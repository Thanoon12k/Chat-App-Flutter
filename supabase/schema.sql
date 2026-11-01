-- Chat app schema (all objects prefixed chat_). Applied as migration `chat_app_schema`.

create table public.chat_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 2 and 30),
  bio text not null default '' check (char_length(bio) <= 140),
  avatar_url text,
  stars int not null default 0,
  created_at timestamptz not null default now()
);
create unique index chat_profiles_name_key on public.chat_profiles (lower(name));

create table public.chat_conversations (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('room','direct')),
  name text check (kind = 'direct' or char_length(trim(name)) between 2 and 40),
  description text not null default '',
  image_url text,
  password_hash text,
  direct_key text unique,
  created_by uuid references public.chat_profiles(id) on delete set null,
  last_message text,
  last_message_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index chat_conversations_kind_idx on public.chat_conversations (kind, last_message_at desc);

create table public.chat_members (
  conversation_id uuid not null references public.chat_conversations(id) on delete cascade,
  user_id uuid not null references public.chat_profiles(id) on delete cascade,
  last_read_at timestamptz not null default now(),
  joined_at timestamptz not null default now(),
  primary key (conversation_id, user_id)
);
create index chat_members_user_idx on public.chat_members (user_id);

create table public.chat_messages (
  id bigint generated always as identity primary key,
  conversation_id uuid not null references public.chat_conversations(id) on delete cascade,
  sender_id uuid not null references public.chat_profiles(id) on delete cascade,
  body text check (char_length(body) <= 4000),
  image_url text,
  created_at timestamptz not null default now(),
  check (coalesce(trim(body),'') <> '' or image_url is not null)
);
create index chat_messages_conv_idx on public.chat_messages (conversation_id, created_at desc);
create index chat_messages_sender_idx on public.chat_messages (sender_id);

create table public.chat_profile_comments (
  id bigint generated always as identity primary key,
  profile_id uuid not null references public.chat_profiles(id) on delete cascade,
  author_id uuid not null references public.chat_profiles(id) on delete cascade,
  body text not null check (char_length(trim(body)) between 1 and 500),
  created_at timestamptz not null default now()
);
create index chat_profile_comments_profile_idx on public.chat_profile_comments (profile_id, created_at desc);
create index chat_profile_comments_author_idx on public.chat_profile_comments (author_id);

create table public.chat_profile_stars (
  profile_id uuid not null references public.chat_profiles(id) on delete cascade,
  giver_id uuid not null references public.chat_profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (profile_id, giver_id),
  check (profile_id <> giver_id)
);
create index chat_profile_stars_giver_idx on public.chat_profile_stars (giver_id);

-- ===== helpers =====
create or replace function public.chat_is_member(conv uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.chat_members m
                 where m.conversation_id = conv and m.user_id = (select auth.uid()));
$$;

create or replace function public.chat_on_message()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  update public.chat_conversations
     set last_message = coalesce(nullif(trim(new.body),''), '📷 صورة'),
         last_message_at = new.created_at
   where id = new.conversation_id;
  update public.chat_members set last_read_at = new.created_at
   where conversation_id = new.conversation_id and user_id = new.sender_id;
  return new;
end $$;
create trigger chat_messages_after_insert after insert on public.chat_messages
  for each row execute function public.chat_on_message();

create or replace function public.chat_on_star()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  update public.chat_profiles
     set stars = (select count(*) from public.chat_profile_stars s
                  where s.profile_id = coalesce(new.profile_id, old.profile_id))
   where id = coalesce(new.profile_id, old.profile_id);
  return null;
end $$;
create trigger chat_stars_changed after insert or delete on public.chat_profile_stars
  for each row execute function public.chat_on_star();

-- ===== RPCs =====
create or replace function public.chat_create_room(p_name text, p_description text default '', p_password text default null)
returns uuid language plpgsql security definer set search_path = '' as $$
declare v_id uuid; v_uid uuid := auth.uid();
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
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
  if v_uid is null then raise exception 'not authenticated'; end if;
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
  if v_uid is null then raise exception 'not authenticated'; end if;
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
   where conversation_id = p_conv and user_id = (select auth.uid());
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
   where me.user_id = (select auth.uid())
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
   where c.kind = 'room' and (select auth.uid()) is not null
   order by c.last_message_at desc;
$$;

revoke all on function public.chat_create_room(text,text,text), public.chat_join_room(uuid,text),
  public.chat_start_direct(uuid), public.chat_mark_read(uuid), public.chat_my_conversations(),
  public.chat_rooms_directory(), public.chat_is_member(uuid) from public, anon;
grant execute on function public.chat_create_room(text,text,text), public.chat_join_room(uuid,text),
  public.chat_start_direct(uuid), public.chat_mark_read(uuid), public.chat_my_conversations(),
  public.chat_rooms_directory(), public.chat_is_member(uuid) to authenticated;
revoke all on function public.chat_on_message(), public.chat_on_star() from public, anon, authenticated;

-- ===== RLS =====
alter table public.chat_profiles enable row level security;
alter table public.chat_conversations enable row level security;
alter table public.chat_members enable row level security;
alter table public.chat_messages enable row level security;
alter table public.chat_profile_comments enable row level security;
alter table public.chat_profile_stars enable row level security;

create policy "chat profiles readable" on public.chat_profiles for select to authenticated using (true);
create policy "chat profile insert own" on public.chat_profiles for insert to authenticated with check (id = (select auth.uid()));
create policy "chat profile update own" on public.chat_profiles for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "chat conversations visible to members" on public.chat_conversations for select to authenticated
  using ((select public.chat_is_member(id)));

create policy "chat members visible to co-members" on public.chat_members for select to authenticated
  using ((select public.chat_is_member(conversation_id)));
create policy "chat members leave" on public.chat_members for delete to authenticated
  using (user_id = (select auth.uid()));

create policy "chat messages read by members" on public.chat_messages for select to authenticated
  using ((select public.chat_is_member(conversation_id)));
create policy "chat messages send by members" on public.chat_messages for insert to authenticated
  with check (sender_id = (select auth.uid()) and (select public.chat_is_member(conversation_id)));
create policy "chat messages delete own" on public.chat_messages for delete to authenticated
  using (sender_id = (select auth.uid()));

create policy "chat comments readable" on public.chat_profile_comments for select to authenticated using (true);
create policy "chat comments write own" on public.chat_profile_comments for insert to authenticated
  with check (author_id = (select auth.uid()));
create policy "chat comments delete by author or owner" on public.chat_profile_comments for delete to authenticated
  using (author_id = (select auth.uid()) or profile_id = (select auth.uid()));

create policy "chat stars readable" on public.chat_profile_stars for select to authenticated using (true);
create policy "chat stars give" on public.chat_profile_stars for insert to authenticated
  with check (giver_id = (select auth.uid()));
create policy "chat stars take back" on public.chat_profile_stars for delete to authenticated
  using (giver_id = (select auth.uid()));

-- ===== Realtime =====
alter publication supabase_realtime add table public.chat_messages;
alter publication supabase_realtime add table public.chat_members;

-- ===== Storage =====
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('chat-media', 'chat-media', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do nothing;

create policy "chat media upload own folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'chat-media' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "chat media update own" on storage.objects for update to authenticated
  using (bucket_id = 'chat-media' and owner_id = (select auth.uid())::text);
create policy "chat media delete own" on storage.objects for delete to authenticated
  using (bucket_id = 'chat-media' and owner_id = (select auth.uid())::text);
