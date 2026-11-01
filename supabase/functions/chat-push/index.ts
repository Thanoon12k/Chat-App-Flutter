import {admin,json,validSecret} from '../_shared/http.ts';
import {fcmCredentials} from '../_shared/fcm.ts';
Deno.serve(async req=>{
 if(req.method!=='POST' || !validSecret(req,'CHAT_PUSH_WORKER_SECRET')) return json({error:'Unauthorized'},401);
 try {
 const credentials=await fcmCredentials(); // No jobs claimed until credentials work.
 const db=admin();
 const {data:jobs,error}=await db.rpc('chat_claim_push_jobs',{p_limit:100});
 if(error) throw error;
 async function deliver(job:any) {
  const finish=async(status:string)=>{const {error}=await db.from('chat_push_jobs').update({status}).eq('id',job.id).eq('lease_id',job.lease_id);if(error) throw error;};
  try {
   // Recheck membership, mute and token ownership at send time.
   const {data:msg,error:me}=await db.from('chat_messages').select('conversation_id,sender_id').eq('id',job.message_id).maybeSingle();
   if(me) throw me;
   if(!msg) return await finish('dead');
   const results=await Promise.all([
    db.from('chat_members').select('user_id').eq('conversation_id',msg.conversation_id).eq('user_id',job.user_id).maybeSingle(),
    db.from('chat_devices').select('user_id').eq('token',job.token).eq('user_id',job.user_id).maybeSingle(),
    db.from('chat_notification_preferences').select('muted').eq('conversation_id',msg.conversation_id).eq('user_id',job.user_id).maybeSingle()
   ]);
   if(results.some(r=>r.error)) throw new Error('Recipient lookup failed');
   if(!results[0].data || !results[1].data || results[2].data?.muted || msg.sender_id===job.user_id) return await finish('dead');
   // Generic lock-screen copy avoids exposing private conversation text.
   const response=await fetch(`https://fcm.googleapis.com/v1/projects/${credentials.project}/messages:send`,{
    method:'POST',headers:{Authorization:`Bearer ${credentials.accessToken}`,'Content-Type':'application/json'},
    body:JSON.stringify({message:{token:job.token,notification:{title:'دردشة',body:'رسالة جديدة في إحدى محادثاتك'},data:{conversation_id:msg.conversation_id,message_id:String(job.message_id),recipient_id:job.user_id},android:{priority:'HIGH',ttl:'86400s',notification:{tag:`chat-${job.message_id}`,sound:'default',channel_id:'chat_messages'}},apns:{headers:{'apns-priority':'10','apns-collapse-id':`chat-${job.message_id}`},payload:{aps:{sound:'default','thread-id':msg.conversation_id}}}}}),signal:AbortSignal.timeout(15000)
   });
   if(response.ok) return await finish('sent');
   const body=await response.json();
   const invalid=body?.error?.details?.some((d:any)=>d.errorCode==='UNREGISTERED');
   if(invalid) {await db.from('chat_devices').delete().eq('token',job.token).eq('user_id',job.user_id);return;}
   // Configuration/transient failures retry; malformed targets terminate.
   if(response.status===400) return await finish('dead');
   throw new Error('FCM temporary error');
  } catch {
   const {error}=await db.from('chat_push_jobs').update({available_at:new Date(Date.now()+Math.min(3600,30*2**job.attempts)*1000).toISOString(),status:job.attempts>=6?'dead':'pending'}).eq('id',job.id).eq('lease_id',job.lease_id);
   if(error) console.error('Push retry update failed');
  }
 }
 // Ten concurrent sends, at most 100 jobs per invocation.
 for(let i=0;i<jobs.length;i+=10) await Promise.all(jobs.slice(i,i+10).map(deliver));
 return json({processed:jobs.length});
 } catch {return json({error:'Push worker unavailable'},503);}
});
