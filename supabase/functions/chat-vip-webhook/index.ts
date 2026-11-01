import {json,validSecret} from '../_shared/http.ts';
import {syncVip} from '../_shared/vip.ts';
Deno.serve(async req=>{
 if(req.method!=='POST' || !validSecret(req,'REVENUECAT_WEBHOOK_SECRET')) return json({error:'Unauthorized'},401);
 try {
 const {event}=await req.json();
 if(!event) return json({error:'Missing event'},400);
 // Re-fetch authoritative state: never grant VIP directly from webhook fields.
 const ids=new Set<string>([event.app_user_id,event.original_app_user_id,...(event.aliases||[]),...(event.transferred_from||[]),...(event.transferred_to||[])].filter(Boolean));
 for(const id of ids) await syncVip(id);
 return json({ok:true});
 } catch {return json({error:'Retry webhook'},503);}
});
