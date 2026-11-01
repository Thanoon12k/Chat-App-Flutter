-- Staged rollout: phone requirement, push and room limits default OFF.
create schema if not exists chat_private;
revoke all on schema chat_private from public, anon, authenticated;
grant usage on schema chat_private to authenticated;
create table chat_private.settings (
 id boolean primary key default true check(id),
 require_phone boolean not null default false,
 phone_login_enabled boolean not null default false,
 push_enabled boolean not null default false,
 room_limits_enabled boolean not null default false,
 free_rooms int not null default 1 check(free_rooms >= 0),
 vip_rooms int not null default 5 check(vip_rooms > 0)
);
insert into chat_private.settings(id) values(true);
create table public.chat_entitlements (
 user_id uuid primary key references auth.users(id) on delete cascade,
 expires_at timestamptz, updated_at timestamptz not null default now()
);
alter table public.chat_entitlements enable row level security;
grant select on public.chat_entitlements to authenticated;
revoke insert,update,delete on public.chat_entitlements from anon,authenticated;
create policy "own VIP status" on public.chat_entitlements for select to authenticated using(user_id=auth.uid());

create function chat_private.phone_verified() returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from auth.users where id=auth.uid()
 and phone_confirmed_at is not null and phone ~ '^[+]?9647[0-9]{9}$');
$$;
create function chat_private.access_allowed() returns boolean
language sql stable security definer set search_path='' as $$
 select auth.uid() is not null and
 (not (select require_phone from chat_private.settings where id) or chat_private.phone_verified());
$$;
revoke all on function chat_private.phone_verified(),chat_private.access_allowed() from public,anon;
grant execute on function chat_private.phone_verified(),chat_private.access_allowed() to authenticated;

create function public.chat_capabilities() returns jsonb
language sql stable security definer set search_path='' as $$
 select jsonb_build_object('require_phone', s.require_phone,
 'phone_login_enabled', s.phone_login_enabled,'push_enabled',s.push_enabled,
 'phone_verified',chat_private.phone_verified(),
 'vip',coalesce(e.expires_at > now(),false),'vip_expires_at',e.expires_at,
 'room_limits_enabled',s.room_limits_enabled,
 'free_rooms',s.free_rooms,'vip_rooms',s.vip_rooms,
 'rooms_created',(select count(*) from public.chat_conversations where kind='room' and created_by=auth.uid()))
 from chat_private.settings s left join public.chat_entitlements e on e.user_id=auth.uid() where s.id;
$$;
revoke all on function public.chat_capabilities() from public;
grant execute on function public.chat_capabilities() to anon,authenticated;

-- Restrictive policies also protect clients that bypass Flutter's phone gate.
do $$ declare t text; begin
 foreach t in array array['chat_profiles','chat_conversations','chat_members','chat_messages','chat_profile_comments','chat_profile_stars'] loop
 execute format('create policy "verified phone gate" on public.%I as restrictive for all to authenticated using ((select chat_private.access_allowed())) with check ((select chat_private.access_allowed()))',t);
 end loop;
end $$;
create policy "chat upload phone gate" on storage.objects as restrictive for insert to authenticated
 with check(bucket_id <> 'chat-media' or (select chat_private.access_allowed()));

-- Device tokens are private; only RPCs can register/unregister this user's device.
create table public.chat_devices (
 token text primary key check(length(token) between 20 and 4096),
 user_id uuid not null references auth.users(id) on delete cascade,
 platform text not null check(platform in ('android','ios')),
 updated_at timestamptz not null default now()
);
create index on public.chat_devices(user_id);
alter table public.chat_devices enable row level security;
revoke all on public.chat_devices from anon,authenticated;
grant all on public.chat_devices to service_role;
create table public.chat_notification_preferences (
 user_id uuid not null references auth.users(id) on delete cascade,
 conversation_id uuid not null references public.chat_conversations(id) on delete cascade,
 muted boolean not null default false,
 primary key(user_id,conversation_id)
);
alter table public.chat_notification_preferences enable row level security;
grant select,insert,update,delete on public.chat_notification_preferences to authenticated;
create policy "own notification preferences" on public.chat_notification_preferences for all to authenticated
 using(user_id=auth.uid() and public.chat_is_member(conversation_id))
 with check(user_id=auth.uid() and public.chat_is_member(conversation_id));

create function public.chat_register_device(p_token text,p_platform text) returns void
language plpgsql security definer set search_path='' as $$ begin
 if not chat_private.access_allowed() then raise exception 'PHONE_REQUIRED'; end if;
 insert into public.chat_devices(token,user_id,platform) values(p_token,auth.uid(),p_platform)
 on conflict(token) do update set user_id=excluded.user_id,platform=excluded.platform,updated_at=now();
end $$;
create function public.chat_unregister_device(p_token text) returns void
language sql security definer set search_path='' as $$
 delete from public.chat_devices where token=p_token and user_id=auth.uid();
$$;
revoke all on function public.chat_register_device(text,text),public.chat_unregister_device(text) from public,anon;
grant execute on function public.chat_register_device(text,text),public.chat_unregister_device(text) to authenticated;

-- Durable per-device delivery. No public FCM topics for private rooms.
create table public.chat_push_jobs (
 id bigint generated always as identity primary key,
 message_id bigint not null references public.chat_messages(id) on delete cascade,
 token text not null references public.chat_devices(token) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 attempts int not null default 0,
 available_at timestamptz not null default now(),
 lease_id uuid,
 status text not null default 'pending' check(status in ('pending','sent','dead')),
 created_at timestamptz not null default now(),
 unique(message_id,token)
);
create index on public.chat_push_jobs(available_at) where status='pending';
alter table public.chat_push_jobs enable row level security;
revoke all on public.chat_push_jobs from anon,authenticated;
grant all on public.chat_push_jobs to service_role;
grant usage,select on sequence public.chat_push_jobs_id_seq to service_role;
create function chat_private.queue_push() returns trigger
language plpgsql security definer set search_path='' as $$ begin
 if not (select push_enabled from chat_private.settings where id) then return new; end if;
 insert into public.chat_push_jobs(message_id,token,user_id)
 select new.id,d.token,m.user_id from public.chat_members m
 join public.chat_devices d on d.user_id=m.user_id
 left join public.chat_notification_preferences p on p.user_id=m.user_id and p.conversation_id=m.conversation_id
 where m.conversation_id=new.conversation_id and m.user_id<>new.sender_id
 and not coalesce(p.muted,false) and d.updated_at>now()-interval '60 days';
 return new;
end $$;
revoke all on function chat_private.queue_push() from public,anon,authenticated;
create trigger chat_queue_push after insert on public.chat_messages for each row execute function chat_private.queue_push();

create function public.chat_claim_push_jobs(p_limit int default 100) returns setof public.chat_push_jobs
language plpgsql security definer set search_path='' as $$ begin
 update public.chat_push_jobs set status='dead' where status='pending' and (attempts>=6 or created_at<now()-interval '1 day');
 return query with picked as (
 select j.id from public.chat_push_jobs j where j.status='pending' and j.available_at<=now()
 order by j.id for update skip locked limit least(greatest(p_limit,1),100)
 ) update public.chat_push_jobs j set available_at=now()+interval '5 minutes',attempts=attempts+1,lease_id=gen_random_uuid()
 from picked where picked.id=j.id returning j.*;
end $$;
revoke all on function public.chat_claim_push_jobs(int) from public,anon,authenticated;
grant execute on function public.chat_claim_push_jobs(int) to service_role;

-- Bound fan-out abuse at the database, including direct REST inserts.
create table chat_private.send_limits(user_id uuid primary key references auth.users(id) on delete cascade,last_sent timestamptz not null);
create function chat_private.message_rate_limit() returns trigger
language plpgsql security definer set search_path='' as $$
declare v_time timestamptz; begin
 if auth.uid() is null then return new; end if;
 insert into chat_private.send_limits(user_id,last_sent) values(auth.uid(),now()-interval '2 seconds') on conflict do nothing;
 select last_sent into v_time from chat_private.send_limits where user_id=auth.uid() for update;
 if v_time>clock_timestamp()-interval '2 seconds' then raise exception 'MESSAGE_RATE_LIMIT'; end if;
 update chat_private.send_limits set last_sent=clock_timestamp() where user_id=auth.uid();
 return new;
end $$;
revoke all on function chat_private.message_rate_limit() from public,anon,authenticated;
create trigger chat_message_rate_limit before insert on public.chat_messages for each row execute function chat_private.message_rate_limit();

create or replace function public.chat_is_member(conv uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select chat_private.access_allowed() and exists (select 1 from public.chat_members m
                 where m.conversation_id = conv and m.user_id = (select auth.uid()));
$$;

-- ===== RPCs =====
create or replace function public.chat_create_room(p_name text, p_description text default '', p_password text default null)
returns uuid language plpgsql security definer set search_path = '' as $$
declare v_id uuid; v_uid uuid := auth.uid(); v_limit int;
begin
  if not chat_private.access_allowed() then raise exception 'PHONE_REQUIRED'; end if;
  -- Lock creator profile to serialize concurrent room creation.
  perform 1 from public.chat_profiles where id=v_uid for update;
  if (select room_limits_enabled from chat_private.settings where id) then
    select case when exists(select 1 from public.chat_entitlements where user_id=v_uid and expires_at>now())
      then vip_rooms else free_rooms end into v_limit from chat_private.settings where id;
    if (select count(*) from public.chat_conversations where created_by=v_uid and kind='room')>=v_limit then
      raise exception 'ROOM_LIMIT_REACHED';
    end if;
  end if;
  insert into public.chat_conversations (kind, name, description, password_hash, created_by)
  values ('room', trim(p_name), coalesce(p_description,''),
          case when coalesce(p_password,'') = '' then null
               else extensions.crypt(p_password, extensions.gen_salt('bf')) end,
          v_uid)
  returning id into v_id;
  insert into public.chat_members (conversation_id, user_id) values (v_id, v_uid);
  return v_id;
end $$;

create or replace function public.chat_join_room(p_room uuid, p_password text default null)
returns boolean language plpgsql security definer set search_path = '' as $$
declare v_hash text; v_uid uuid := auth.uid();
begin
  if not chat_private.access_allowed() then raise exception 'PHONE_REQUIRED'; end if;
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

create or replace function public.chat_start_direct(p_other uuid)
returns uuid language plpgsql security definer set search_path = '' as $$
declare v_id uuid; v_uid uuid := auth.uid(); v_key text;
begin
  if not chat_private.access_allowed() then raise exception 'PHONE_REQUIRED'; end if;
  if p_other = v_uid then raise exception 'cannot chat with yourself'; end if;
  if not exists (select 1 from public.chat_profiles where id = p_other) then raise exception 'user not found'; end if;
  v_key := least(v_uid::text, p_other::text) || ':' || greatest(v_uid::text, p_other::text);
  select id into v_id from public.chat_conversations where direct_key = v_key;
  if v_id is null then
    insert into public.chat_conversations (kind, direct_key, created_by)
    values ('direct', v_key, v_uid) returning id into v_id;
  end if;
  insert into public.chat_members (conversation_id, user_id) values (v_id, v_uid), (v_id, p_other)
  on conflict do nothing;
  return v_id;
end $$;

create or replace function public.chat_mark_read(p_conv uuid)
returns void language sql security definer set search_path = '' as $$
  update public.chat_members set last_read_at = now()
   where conversation_id = p_conv and user_id = (select auth.uid()) and chat_private.access_allowed();
$$;

create or replace function public.chat_my_conversations()
returns table (id uuid, kind text, title text, image_url text, other_user uuid,
               last_message text, last_message_at timestamptz, unread int)
language sql stable security definer set search_path = '' as $$
  select c.id, c.kind,
         coalesce(case when c.kind = 'direct' then op.name else c.name end, '—') as title,
         case when c.kind = 'direct' then op.avatar_url else c.image_url end as image_url,
         op.id as other_user,
         c.last_message, c.last_message_at,
         (select count(*)::int from public.chat_messages msg
           where msg.conversation_id = c.id and msg.created_at > me.last_read_at
             and msg.sender_id <> me.user_id) as unread
    from public.chat_members me
    join public.chat_conversations c on c.id = me.conversation_id
    left join lateral (
      select p.id, p.name, p.avatar_url from public.chat_members om
        join public.chat_profiles p on p.id = om.user_id
       where c.kind = 'direct' and om.conversation_id = c.id and om.user_id <> me.user_id
       limit 1) op on true
   where me.user_id = (select auth.uid()) and chat_private.access_allowed()
   order by c.last_message_at desc;
$$;

create or replace function public.chat_rooms_directory()
returns table (id uuid, name text, description text, image_url text, has_password boolean,
               members int, is_member boolean, last_message_at timestamptz)
language sql stable security definer set search_path = '' as $$
  select c.id, c.name, c.description, c.image_url, c.password_hash is not null,
         (select count(*)::int from public.chat_members m where m.conversation_id = c.id),
         exists (select 1 from public.chat_members m where m.conversation_id = c.id and m.user_id = (select auth.uid())),
         c.last_message_at
    from public.chat_conversations c
   where c.kind = 'room' and chat_private.access_allowed()
   order by c.last_message_at desc;
$$;

revoke all on function public.chat_create_room(text,text,text), public.chat_join_room(uuid,text),
  public.chat_start_direct(uuid), public.chat_mark_read(uuid), public.chat_my_conversations(),
  public.chat_rooms_directory(), public.chat_is_member(uuid) from public, anon;
grant execute on function public.chat_create_room(text,text,text), public.chat_join_room(uuid,text),
  public.chat_start_direct(uuid), public.chat_mark_read(uuid), public.chat_my_conversations(),
  public.chat_rooms_directory(), public.chat_is_member(uuid) to authenticated;
revoke all on function public.chat_on_message(), public.chat_on_star() from public, anon, authenticated;


revoke all on all tables in schema chat_private from public,anon,authenticated;

create function public.chat_set_entitlement(p_user uuid,p_expires timestamptz,p_checked timestamptz) returns void
language sql security definer set search_path='' as $$
 insert into public.chat_entitlements(user_id,expires_at,updated_at) values(p_user,p_expires,p_checked)
 on conflict(user_id) do update set expires_at=excluded.expires_at,updated_at=excluded.updated_at
 where public.chat_entitlements.updated_at<=excluded.updated_at;
$$;
revoke all on function public.chat_set_entitlement(uuid,timestamptz,timestamptz) from public,anon,authenticated;
grant execute on function public.chat_set_entitlement(uuid,timestamptz,timestamptz) to service_role;
