import {json,userFor} from '../_shared/http.ts';
import {syncVip} from '../_shared/vip.ts';
Deno.serve(async req=>{
 if(req.method==='OPTIONS') return json({});
 if(req.method!=='POST') return json({error:'Method not allowed'},405);
 let user;
 try {user=await userFor(req);} catch {return json({error:'Unauthorized'},401);}
 try {return json(await syncVip(user.id));}
 catch {return json({error:'Subscription verification unavailable. Please retry.'},503);}
});
