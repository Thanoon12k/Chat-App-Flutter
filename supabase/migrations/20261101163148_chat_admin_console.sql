create table chat_private.admins(user_id uuid primary key references auth.users(id) on delete cascade);
create table chat_private.admin_invites(email text primary key);
create table chat_private.bans(user_id uuid primary key references public.chat_profiles(id) on delete cascade);
create table chat_private.room_bans(conversation_id uuid references public.chat_conversations(id) on delete cascade,user_id uuid references public.chat_profiles(id) on delete cascade,primary key(conversation_id,user_id));
create table chat_private.audit(id bigint generated always as identity primary key,actor uuid,action text,target uuid,payload jsonb,created_at timestamptz default now());
alter table public.chat_conversations add column closed boolean not null default false;

create function chat_private.admin_status() returns boolean
language plpgsql security definer set search_path='' as $$
declare v_email text; begin
 if auth.uid() is null then return false; end if;
 -- One-time, verified-email bootstrap. Never trust user_metadata for roles.
 select lower(u.email) into v_email from auth.users u join public.chat_profiles p on p.id=u.id
 where u.id=auth.uid() and u.email_confirmed_at is not null;
 delete from chat_private.admin_invites where email=v_email returning email into v_email;
 if found then
   insert into chat_private.admins(user_id) values(auth.uid()) on conflict do nothing;
   insert into chat_private.audit(actor,action,target) values(auth.uid(),'claim_admin',auth.uid());
 end if;
 return exists(select 1 from chat_private.admins where user_id=auth.uid());
end $$;
revoke all on function chat_private.admin_status() from public,anon;
grant execute on function chat_private.admin_status() to authenticated;
create function public.chat_admin_status() returns boolean language sql security invoker set search_path='' as $$ select chat_private.admin_status(); $$;
revoke all on function public.chat_admin_status() from public,anon;
grant execute on function public.chat_admin_status() to authenticated;

create or replace function chat_private.access_allowed() returns boolean
language sql stable security definer set search_path='' as $$
 select auth.uid() is not null and
 not exists(select 1 from chat_private.bans where user_id=auth.uid()) and
 (not (select require_phone from chat_private.settings where id) or chat_private.phone_verified());
$$;

create function chat_private.admin_action(p_action text,p_target uuid default null,p_data jsonb default '{}'::jsonb) returns jsonb
language plpgsql security definer set search_path='' as $$
declare result jsonb; v_offset int:=greatest(0,least(coalesce((p_data->>'offset')::int,0),100000));
begin
 if not chat_private.admin_status() then raise exception 'ADMIN_REQUIRED' using errcode='42501'; end if;
 if p_action='rooms' then
   select coalesce(jsonb_agg(to_jsonb(r)),'[]'::jsonb) into result from (
    select c.id,c.name,c.description,c.closed,c.password_hash is not null as locked,
    (select count(*) from public.chat_members where conversation_id=c.id) as members
    from public.chat_conversations c where c.kind='room' and c.name ilike '%'||coalesce(p_data->>'query','')||'%'
    order by c.created_at desc,c.id limit 30 offset v_offset) r;
   return result;
 elsif p_action='users' then
   select coalesce(jsonb_agg(to_jsonb(r)),'[]'::jsonb) into result from (
    select p.id,p.name,exists(select 1 from chat_private.bans where user_id=p.id) as banned,
    exists(select 1 from chat_private.admins where user_id=p.id) as admin
    from public.chat_profiles p where p.name ilike '%'||coalesce(p_data->>'query','')||'%'
    order by p.created_at desc,p.id limit 30 offset v_offset) r;
   return result;
 elsif p_action='members' then
   select coalesce(jsonb_agg(to_jsonb(r)),'[]'::jsonb) into result from (
    select p.id,p.name,exists(select 1 from chat_private.room_bans where user_id=p.id and conversation_id=p_target) as banned
    from public.chat_profiles p where p.id in (select user_id from public.chat_members where conversation_id=p_target union select user_id from chat_private.room_bans where conversation_id=p_target)
    order by p.name,p.id limit 30 offset v_offset) r;
   return result;
 elsif p_action='settings' then
   select to_jsonb(s)-'id' into result from chat_private.settings s where id;
   return result;
 elsif p_action='room_update' then
   update public.chat_conversations set name=trim(p_data->>'name'),description=coalesce(p_data->>'description',''),closed=coalesce((p_data->>'closed')::boolean,false)
    where id=p_target and kind='room';
   if not found then raise exception 'ROOM_NOT_FOUND'; end if;
 elsif p_action='room_password' then
   update public.chat_conversations set password_hash=case when coalesce(p_data->>'password','')='' then null else extensions.crypt(p_data->>'password',extensions.gen_salt('bf')) end
   where id=p_target and kind='room';
   if not found then raise exception 'ROOM_NOT_FOUND'; end if;
 elsif p_action in ('ban','unban') then
   if exists(select 1 from chat_private.admins where user_id=p_target) then raise exception 'CANNOT_BAN_ADMIN'; end if;
   if p_action='ban' then
     insert into chat_private.bans(user_id) values(p_target) on conflict do nothing;
     delete from public.chat_devices where user_id=p_target;
   else delete from chat_private.bans where user_id=p_target; end if;
 elsif p_action in ('kick','allow_member') then
   if p_action='kick' then
     if exists(select 1 from chat_private.admins where user_id=(p_data->>'user_id')::uuid) then raise exception 'CANNOT_BAN_ADMIN'; end if;
     insert into chat_private.room_bans(conversation_id,user_id) values(p_target,(p_data->>'user_id')::uuid) on conflict do nothing;
     delete from public.chat_members where conversation_id=p_target and user_id=(p_data->>'user_id')::uuid;
   else delete from chat_private.room_bans where conversation_id=p_target and user_id=(p_data->>'user_id')::uuid; end if;
 elsif p_action='set_limits' then
   if (p_data->>'free_rooms')::int<0 or (p_data->>'vip_rooms')::int<1 or (p_data->>'vip_rooms')::int<(p_data->>'free_rooms')::int or (p_data->>'vip_rooms')::int>100 then raise exception 'INVALID_LIMITS'; end if;
   update chat_private.settings set free_rooms=(p_data->>'free_rooms')::int,vip_rooms=(p_data->>'vip_rooms')::int,room_limits_enabled=(p_data->>'enabled')::boolean where id;
 else raise exception 'UNKNOWN_ADMIN_ACTION'; end if;
 insert into chat_private.audit(actor,action,target,payload) values(auth.uid(),p_action,p_target,p_data-'password');
 return jsonb_build_object('ok',true);
end $$;
revoke all on function chat_private.admin_action(text,uuid,jsonb) from public,anon;
grant execute on function chat_private.admin_action(text,uuid,jsonb) to authenticated;
create function public.chat_admin_action(p_action text,p_target uuid default null,p_data jsonb default '{}'::jsonb) returns jsonb
language sql security invoker set search_path='' as $$ select chat_private.admin_action(p_action,p_target,p_data); $$;
revoke all on function public.chat_admin_action(text,uuid,jsonb) from public,anon;
grant execute on function public.chat_admin_action(text,uuid,jsonb) to authenticated;

create function chat_private.closed_room_guard() returns trigger language plpgsql security definer set search_path='' as $$ begin
 if exists(select 1 from public.chat_conversations where id=new.conversation_id and closed) then raise exception 'ROOM_CLOSED'; end if;
 return new;
end $$;
revoke all on function chat_private.closed_room_guard() from public,anon,authenticated;
create trigger chat_closed_room_guard before insert on public.chat_messages for each row execute function chat_private.closed_room_guard();
revoke all on all tables in schema chat_private from public,anon,authenticated;

create or replace function public.chat_join_room(p_room uuid, p_password text default null)
returns boolean language plpgsql security definer set search_path = '' as $$
declare v_hash text; v_uid uuid := auth.uid();
begin
  if not chat_private.access_allowed() then raise exception 'PHONE_REQUIRED'; end if;
  if exists(select 1 from public.chat_conversations where id=p_room and closed) then raise exception 'ROOM_CLOSED'; end if;
  if exists(select 1 from chat_private.room_bans where conversation_id=p_room and user_id=v_uid) then raise exception 'ROOM_BANNED'; end if;
  select password_hash into v_hash from public.chat_conversations
   where id = p_room and kind = 'room';
  if not found then raise exception 'room not found'; end if;
  if v_hash is not null and not exists (select 1 from public.chat_members where conversation_id = p_room and user_id = v_uid)
     and (p_password is null or extensions.crypt(p_password, v_hash) <> v_hash) then
    return false;
  end if;
  insert into public.chat_members (conversation_id, user_id) values (p_room, v_uid)
  on conflict do nothing;
  return true;
end $$;


create or replace function public.chat_capabilities() returns jsonb
language sql stable security definer set search_path='' as $$
 select jsonb_build_object('require_phone', s.require_phone, 'banned',exists(select 1 from chat_private.bans where user_id=auth.uid()),
 'phone_login_enabled', s.phone_login_enabled,'push_enabled',s.push_enabled,
 'phone_verified',chat_private.phone_verified(),
 'vip',coalesce(e.expires_at > now(),false),'vip_expires_at',e.expires_at,
 'room_limits_enabled',s.room_limits_enabled,
 'free_rooms',s.free_rooms,'vip_rooms',s.vip_rooms,
 'rooms_created',(select count(*) from public.chat_conversations where kind='room' and created_by=auth.uid()))
 from chat_private.settings s left join public.chat_entitlements e on e.user_id=auth.uid() where s.id;
$$;

alter function public.chat_capabilities() set schema chat_private;
create function public.chat_capabilities() returns jsonb language sql security invoker set search_path='' as $$ select chat_private.chat_capabilities(); $$;
revoke all on function public.chat_capabilities() from public,anon,authenticated;
grant execute on function public.chat_capabilities() to anon,authenticated;

alter function public.chat_register_device(text,text) set schema chat_private;
create function public.chat_register_device(p_token text,p_platform text) returns void language sql security invoker set search_path='' as $$ select chat_private.chat_register_device(p_token,p_platform); $$;
revoke all on function public.chat_register_device(text,text) from public,anon,authenticated;
grant execute on function public.chat_register_device(text,text) to authenticated;

alter function public.chat_unregister_device(text) set schema chat_private;
create function public.chat_unregister_device(p_token text) returns void language sql security invoker set search_path='' as $$ select chat_private.chat_unregister_device(p_token); $$;
revoke all on function public.chat_unregister_device(text) from public,anon,authenticated;
grant execute on function public.chat_unregister_device(text) to authenticated;

alter function public.chat_claim_push_jobs(int) set schema chat_private;
create function public.chat_claim_push_jobs(p_limit int default 100) returns setof public.chat_push_jobs language sql security invoker set search_path='' as $$ select * from chat_private.chat_claim_push_jobs(p_limit); $$;
revoke all on function public.chat_claim_push_jobs(int) from public,anon,authenticated;
grant execute on function public.chat_claim_push_jobs(int) to service_role;

alter function public.chat_set_entitlement(uuid,timestamptz,timestamptz) set schema chat_private;
create function public.chat_set_entitlement(p_user uuid,p_expires timestamptz,p_checked timestamptz) returns void language sql security invoker set search_path='' as $$ select chat_private.chat_set_entitlement(p_user,p_expires,p_checked); $$;
revoke all on function public.chat_set_entitlement(uuid,timestamptz,timestamptz) from public,anon,authenticated;
grant execute on function public.chat_set_entitlement(uuid,timestamptz,timestamptz) to service_role;

grant usage on schema chat_private to anon,service_role;
create policy "server-only device access" on public.chat_devices for all to service_role using(true) with check(true);
create policy "server-only push jobs" on public.chat_push_jobs for all to service_role using(true) with check(true);
