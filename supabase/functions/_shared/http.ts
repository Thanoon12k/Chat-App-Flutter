import { createClient } from 'npm:@supabase/supabase-js@2.106.1';
export const cors = {'Access-Control-Allow-Origin':'*','Access-Control-Allow-Headers':'authorization, apikey, content-type, x-client-info'};
export const json = (body: unknown, status=200) => new Response(JSON.stringify(body), {status,headers:{...cors,'Content-Type':'application/json'}});
export function admin() {
 return createClient(Deno.env.get('SUPABASE_URL')!,Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,{auth:{persistSession:false,autoRefreshToken:false}});
}
export async function userFor(req:Request) {
 const header=req.headers.get('authorization') || '';
 if(!header.startsWith('Bearer ')) throw new Error('Unauthorized');
 const {data,error}=await admin().auth.getUser(header.slice(7));
 if(error || !data.user) throw new Error('Unauthorized');
 return data.user;
}
export function validSecret(req:Request,name:string) {
 const expected=Deno.env.get(name);
 return !!expected && expected.length>=32 && req.headers.get('authorization')===`Bearer ${expected}`;
}
