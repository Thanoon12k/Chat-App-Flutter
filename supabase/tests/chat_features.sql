-- Runs inside a transaction, creates synthetic identities, and leaves no data.
begin;
create temp table fixture(name text primary key,id uuid default gen_random_uuid());
insert into fixture(name) values('alice'),('bob'),('unverified'),('foreign');
grant select on fixture to authenticated;
insert into auth.users(id,phone,phone_confirmed_at)
select id,case when name='foreign' then '1555' else '964770' end || substring(replace(id::text,'-',''),1,7),case when name='unverified' then null else now() end from fixture;
-- Use numeric random phone fixtures instead of UUID letters.
update auth.users set phone=case when f.name='foreign' then '1555' else '964770' end || lpad((floor(random()*10000000)::int)::text,7,'0') from fixture f where auth.users.id=f.id;
insert into public.chat_profiles(id,name) select id,'test_'||substring(id::text,1,12) from fixture;
update chat_private.settings set require_phone=true,room_limits_enabled=true,push_enabled=true;
select set_config('request.jwt.claim.sub',(select id::text from fixture where name='alice'),true);
set local role authenticated;
do $$ declare r uuid; begin
 if not (public.chat_capabilities()->>'phone_verified')::boolean then raise exception 'Verified Iraqi phone rejected'; end if;
 r:=public.chat_create_room('test room');
 begin
  perform public.chat_create_room('second free room');
  raise exception 'Free limit bypassed';
 exception when raise_exception then
  if sqlerrm <> 'ROOM_LIMIT_REACHED' then raise; end if;
 end;
 begin
  insert into public.chat_entitlements(user_id,expires_at) values(auth.uid(),now()+interval '1 year');
  raise exception 'Client can grant VIP';
 exception when insufficient_privilege then null;
 end;
 perform public.chat_register_device('test_alice_device_token_123456789','android');
end $$;
reset role;
insert into public.chat_entitlements(user_id,expires_at) select id,now()+interval '1 day' from fixture where name='alice';
set local role authenticated;
select public.chat_create_room('second VIP room');
reset role;
select set_config('request.jwt.claim.sub',(select id::text from fixture where name='unverified'),true);
set local role authenticated;
do $$ begin
 if exists(select 1 from public.chat_profiles) then raise exception 'Phone RLS bypassed'; end if;
 begin
  perform public.chat_create_room('blocked room');
  raise exception 'Unverified RPC bypassed';
 exception when raise_exception then if sqlerrm<>'PHONE_REQUIRED' then raise; end if; end;
end $$;
reset role;
select set_config('request.jwt.claim.sub',(select id::text from fixture where name='foreign'),true);
set local role authenticated;
do $$ begin
 if (public.chat_capabilities()->>'phone_verified')::boolean then raise exception 'Foreign phone accepted'; end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub',(select id::text from fixture where name='bob'),true);
set local role authenticated;
select public.chat_register_device('test_bob_device_token_123456789','ios');
reset role;
insert into public.chat_members(conversation_id,user_id)
select c.id,f.id from public.chat_conversations c join fixture f on f.name='bob' where c.created_by=(select id from fixture where name='alice');
select set_config('request.jwt.claim.sub',(select id::text from fixture where name='alice'),true);
set local role authenticated;
insert into public.chat_messages(conversation_id,sender_id,body)
select id,auth.uid(),'test question' from public.chat_conversations where created_by=auth.uid() order by created_at limit 1;
reset role;
do $$ begin
 if (select count(*) from public.chat_push_jobs where user_id=(select id from fixture where name='bob'))<>1 then raise exception 'Fanout did not enqueue recipient'; end if;
 if exists(select 1 from public.chat_push_jobs where user_id=(select id from fixture where name='alice')) then raise exception 'Sender received push'; end if;
end $$;
select 'PASS: phone RLS, Iraqi restriction, free/VIP room quotas, entitlement protection, token registration and recipient fanout' as result;
rollback;
