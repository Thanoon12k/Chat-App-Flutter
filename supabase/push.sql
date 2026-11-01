-- Push notifications (FCM). Applied as migration `chat_push`.
-- New messages and broadcasts call the `chat-push` Edge Function, which sends
-- FCM notifications to the recipients' devices. The function needs the
-- FCM_SERVICE_ACCOUNT secret (Firebase service-account JSON).

create table public.chat_push_tokens (
  token text primary key,
  user_id uuid not null references public.chat_profiles(id) on delete cascade,
  platform text not null default 'android',
  updated_at timestamptz not null default now()
);
create index chat_push_tokens_user_idx on public.chat_push_tokens (user_id);
alter table public.chat_push_tokens enable row level security;

create policy "chat push tokens own read" on public.chat_push_tokens for select to authenticated
  using (user_id = (select auth.uid()));
create policy "chat push tokens own insert" on public.chat_push_tokens for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy "chat push tokens own update" on public.chat_push_tokens for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "chat push tokens own delete" on public.chat_push_tokens for delete to authenticated
  using (user_id = (select auth.uid()));

-- A device token moves to whoever signs in on that phone.
create or replace function public.chat_save_push_token(p_token text, p_platform text default 'android')
returns void language sql security definer set search_path = '' as $$
  insert into public.chat_push_tokens (token, user_id, platform, updated_at)
  values (p_token, (select auth.uid()), coalesce(p_platform, 'android'), now())
  on conflict (token) do update set user_id = excluded.user_id, platform = excluded.platform, updated_at = now();
$$;
revoke all on function public.chat_save_push_token(text, text) from public, anon;
grant execute on function public.chat_save_push_token(text, text) to authenticated;

-- One row per message/broadcast already pushed, so each is sent at most once
-- (the function is public; it only ever sends for fresh, real rows).
create table public.chat_push_sent (
  kind text not null,
  id bigint not null,
  sent_at timestamptz not null default now(),
  primary key (kind, id)
);
alter table public.chat_push_sent enable row level security;

create or replace function public.chat_push_notify()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  perform net.http_post(
    url := 'https://axncazensmjdqpczvzwf.supabase.co/functions/v1/chat-push',
    body := jsonb_build_object('type', tg_table_name, 'id', new.id),
    headers := jsonb_build_object('content-type', 'application/json'));
  return null;
end $$;
revoke all on function public.chat_push_notify() from public, anon, authenticated;

create trigger chat_messages_push after insert on public.chat_messages
  for each row execute function public.chat_push_notify();
create trigger chat_broadcasts_push after insert on public.chat_broadcasts
  for each row execute function public.chat_push_notify();
