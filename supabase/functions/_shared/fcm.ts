const enc=new TextEncoder();
const b64=(bytes:Uint8Array)=>btoa(String.fromCharCode(...bytes)).replaceAll('+','-').replaceAll('/','_').replaceAll('=','');
export async function fcmCredentials() {
 const raw=Deno.env.get('FCM_SERVICE_ACCOUNT');
 if(!raw) throw new Error('FCM not configured');
 const sa=JSON.parse(raw);
 const now=Math.floor(Date.now()/1000);
 const head=b64(enc.encode(JSON.stringify({alg:'RS256',typ:'JWT'})));
 const claims=b64(enc.encode(JSON.stringify({iss:sa.client_email,scope:'https://www.googleapis.com/auth/firebase.messaging',aud:'https://oauth2.googleapis.com/token',iat:now,exp:now+3600})));
 const keyData=Uint8Array.from(atob(sa.private_key.replace(/-----[^-]+-----|\s/g,'')),c=>c.charCodeAt(0));
 const key=await crypto.subtle.importKey('pkcs8',keyData,{name:'RSASSA-PKCS1-v1_5',hash:'SHA-256'},false,['sign']);
 const signature=await crypto.subtle.sign('RSASSA-PKCS1-v1_5',key,enc.encode(`${head}.${claims}`));
 const res=await fetch('https://oauth2.googleapis.com/token',{method:'POST',body:new URLSearchParams({grant_type:'urn:ietf:params:oauth:grant-type:jwt-bearer',assertion:`${head}.${claims}.${b64(new Uint8Array(signature))}`}),signal:AbortSignal.timeout(15000)});
 if(!res.ok) throw new Error('FCM authorization failed');
 const body=await res.json();
 return {project:sa.project_id,accessToken:body.access_token};
}
