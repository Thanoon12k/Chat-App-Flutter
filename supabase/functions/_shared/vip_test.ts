import {expiryFor} from './vip.ts';
function expect(actual:unknown,expected:unknown) {if(actual!==expected) throw new Error(`${actual} != ${expected}`);}
const now=Date.parse('2026-01-01');
const subscriber=(end:string,store='app_store',sandbox=false)=>({entitlements:{vip:{expires_date:end,product_identifier:'vip_monthly'}},subscriptions:{vip_monthly:{store,is_sandbox:sandbox}}});
Deno.test('VIP denies expired, missing, promotional and sandbox entitlements',()=>{
 Deno.env.delete('ALLOW_SANDBOX_VIP');
 expect(expiryFor({},now),null);
 expect(expiryFor(subscriber('2025-01-01'),now),null);
 expect(expiryFor(subscriber('2027-01-01','promotional'),now),null);
 expect(expiryFor(subscriber('2027-01-01','app_store',true),now),null);
 expect(expiryFor(subscriber('invalid'),now),null);
});
Deno.test('VIP accepts active store subscriptions',()=>{
 expect(expiryFor(subscriber('2027-01-01'),now),'2027-01-01T00:00:00.000Z');
 expect(expiryFor(subscriber('2027-01-01','play_store'),now),'2027-01-01T00:00:00.000Z');
});
