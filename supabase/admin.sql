-- Admin dashboard + broadcasts. Applied as migration `chat_admin_dashboard`
-- on top of schema.sql.

-- ===== admins =====
-- Keyed on auth.users so an admin does not need a chat profile.
create table public.chat_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.chat_admins enable row level security;

create or replace function public.chat_is_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.chat_admins a where a.user_id = (select auth.uid()));
$$;

-- An admin can see who the admins are; nobody writes this table from the API
-- (add admins with SQL: insert into chat_admins select id from auth.users where email = '...').
create policy "chat admins visible to admins" on public.chat_admins for select to authenticated
  using ((select public.chat_is_admin()));

-- ===== banning =====
alter table public.chat_profiles add column banned boolean not null default false;

create or replace function public.chat_is_banned()
returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce((select p.banned from public.chat_profiles p where p.id = (select auth.uid())), false);
$$;

-- Users may not flip their own `banned` flag.
create or replace function public.chat_guard_profile()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.banned is distinct from old.banned and not public.chat_is_admin() then
    raise exception 'only admins can change banned';
  end if;
  return new;
end $$;
create trigger chat_profiles_guard before update on public.chat_profiles
  for each row execute function public.chat_guard_profile();

-- Banned users can no longer send messages.
drop policy "chat messages send by members" on public.chat_messages;
create policy "chat messages send by members" on public.chat_messages for insert to authenticated
  with check (sender_id = (select auth.uid()) and (select public.chat_is_member(conversation_id))
              and not (select public.chat_is_banned()));

-- ===== admin access to everything =====
create policy "chat admin profiles update" on public.chat_profiles for update to authenticated
  using ((select public.chat_is_admin())) with check ((select public.chat_is_admin()));
create policy "chat admin profiles delete" on public.chat_profiles for delete to authenticated
  using ((select public.chat_is_admin()));

create policy "chat admin conversations read" on public.chat_conversations for select to authenticated
  using ((select public.chat_is_admin()));
create policy "chat admin conversations insert" on public.chat_conversations for insert to authenticated
  with check ((select public.chat_is_admin()));
create policy "chat admin conversations update" on public.chat_conversations for update to authenticated
  using ((select public.chat_is_admin())) with check ((select public.chat_is_admin()));
create policy "chat admin conversations delete" on public.chat_conversations for delete to authenticated
  using ((select public.chat_is_admin()));

create policy "chat admin members read" on public.chat_members for select to authenticated
  using ((select public.chat_is_admin()));
create policy "chat admin members insert" on public.chat_members for insert to authenticated
  with check ((select public.chat_is_admin()));
create policy "chat admin members delete" on public.chat_members for delete to authenticated
  using ((select public.chat_is_admin()));

create policy "chat admin messages read" on public.chat_messages for select to authenticated
  using ((select public.chat_is_admin()));
create policy "chat admin messages delete" on public.chat_messages for delete to authenticated
  using ((select public.chat_is_admin()));

create policy "chat admin comments delete" on public.chat_profile_comments for delete to authenticated
  using ((select public.chat_is_admin()));

-- ===== broadcasts =====
-- room_id null = everyone; otherwise only that room's members see it.
create table public.chat_broadcasts (
  id bigint generated always as identity primary key,
  title text not null check (char_length(trim(title)) between 1 and 100),
  body text not null check (char_length(trim(body)) between 1 and 2000),
  room_id uuid references public.chat_conversations(id) on delete cascade,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);
create index chat_broadcasts_created_idx on public.chat_broadcasts (created_at desc);
create index chat_broadcasts_room_idx on public.chat_broadcasts (room_id);
create index chat_broadcasts_created_by_idx on public.chat_broadcasts (created_by);
alter table public.chat_broadcasts enable row level security;

create policy "chat broadcasts readable" on public.chat_broadcasts for select to authenticated
  using (room_id is null or (select public.chat_is_member(room_id)) or (select public.chat_is_admin()));
create policy "chat broadcasts send by admins" on public.chat_broadcasts for insert to authenticated
  with check ((select public.chat_is_admin()) and created_by = (select auth.uid()));
create policy "chat broadcasts delete by admins" on public.chat_broadcasts for delete to authenticated
  using ((select public.chat_is_admin()));

alter publication supabase_realtime add table public.chat_broadcasts;

-- ===== dashboard stats =====
create or replace function public.chat_admin_stats()
returns json language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.chat_is_admin() then raise exception 'admins only'; end if;
  return json_build_object(
    'users',          (select count(*) from public.chat_profiles),
    'banned',         (select count(*) from public.chat_profiles where banned),
    'rooms',          (select count(*) from public.chat_conversations where kind = 'room'),
    'directs',        (select count(*) from public.chat_conversations where kind = 'direct'),
    'messages',       (select count(*) from public.chat_messages),
    'messages_today', (select count(*) from public.chat_messages where created_at > now() - interval '24 hours'),
    'broadcasts',     (select count(*) from public.chat_broadcasts)
  );
end $$;

revoke all on function public.chat_is_admin(), public.chat_is_banned(), public.chat_admin_stats() from public, anon;
grant execute on function public.chat_is_admin(), public.chat_is_banned(), public.chat_admin_stats() to authenticated;
revoke all on function public.chat_guard_profile() from public, anon, authenticated;
