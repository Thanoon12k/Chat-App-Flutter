import {admin} from './http.ts';
export function expiryFor(subscriber: any, now=Date.now()): string|null {
 const ent=subscriber?.entitlements?.vip;
 const sub=subscriber?.subscriptions?.[ent?.product_identifier];
 if(!ent || !sub || !['app_store','play_store'].includes(sub.store)) return null;
 if(sub.is_sandbox && Deno.env.get('ALLOW_SANDBOX_VIP')!=='true') return null;
 const end=Date.parse(ent.expires_date);
 return Number.isFinite(end) && end>now ? new Date(end).toISOString():null;
}
export async function syncVip(uid:string) {
 if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(uid)) return;
 const key=Deno.env.get('REVENUECAT_SECRET_KEY');
 if(!key) throw new Error('RevenueCat not configured');
 const started=new Date().toISOString();
 const res=await fetch(`https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`,{headers:{Authorization:`Bearer ${key}`},signal:AbortSignal.timeout(15000)});
 if(!res.ok) throw new Error(`RevenueCat ${res.status}`);
 const {subscriber}=await res.json();
 const expires_at=expiryFor(subscriber);
 // Serialized server RPC prevents an older response overwriting a newer sync.
 const {error}=await admin().rpc('chat_set_entitlement',{p_user:uid,p_expires:expires_at,p_checked:started});
 if(error) throw error;
 return {vip:expires_at!==null,expires_at};
}
