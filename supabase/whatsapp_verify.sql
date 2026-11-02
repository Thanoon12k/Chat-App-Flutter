-- Phone verification by WhatsApp ("reverse OTP"). Applied as migration `chat_whatsapp_verify`.
-- The app asks for a code, opens WhatsApp with it pre-filled, the user sends it
-- to our business number, and the `whatsapp-webhook` Edge Function confirms it.
-- Free: user-initiated messages and the reply to them cost nothing.

-- Verified numbers, private to their owner (profiles are readable by everyone).
create table public.chat_phones (
  user_id uuid primary key references public.chat_profiles(id) on delete cascade,
  phone text not null unique,
  verified_at timestamptz not null default now()
);
alter table public.chat_phones enable row level security;
create policy "chat phones own read" on public.chat_phones for select to authenticated
  using (user_id = (select auth.uid()) or (select public.chat_is_admin()));
create policy "chat phones admin delete" on public.chat_phones for delete to authenticated
  using ((select public.chat_is_admin()));

create table public.chat_phone_codes (
  code text primary key,
  user_id uuid not null references public.chat_profiles(id) on delete cascade,
  expires_at timestamptz not null default now() + interval '10 minutes',
  used_at timestamptz,
  created_at timestamptz not null default now()
);
create index chat_phone_codes_user_idx on public.chat_phone_codes (user_id);
alter table public.chat_phone_codes enable row level security;
-- No policies: only the functions below touch it.

-- New 6-digit code for me; at most 5 per 10 minutes.
create or replace function public.chat_new_phone_code()
returns text language plpgsql security definer set search_path = '' as $$
declare v_uid uuid := auth.uid(); v_code text;
begin
  if v_uid is null then raise exception 'not authenticated'; end if;
  if (select count(*) from public.chat_phone_codes
       where user_id = v_uid and created_at > now() - interval '10 minutes') >= 5 then
    raise exception 'too many codes, try again later';
  end if;
  delete from public.chat_phone_codes where expires_at < now() - interval '1 day';
  loop
    v_code := lpad((floor(random() * 1000000))::int::text, 6, '0');
    begin
      insert into public.chat_phone_codes (code, user_id) values (v_code, v_uid);
      exit;
    exception when unique_violation then
      delete from public.chat_phone_codes where code = v_code and (used_at is not null or expires_at < now());
    end;
  end loop;
  return v_code;
end $$;
revoke all on function public.chat_new_phone_code() from public, anon;
grant execute on function public.chat_new_phone_code() to authenticated;

-- Called by the whatsapp-webhook function (service role only) when a code
-- arrives from a WhatsApp number. Returns 'ok', 'invalid' or 'taken'.
create or replace function public.chat_confirm_phone(p_code text, p_phone text)
returns text language plpgsql security definer set search_path = '' as $$
declare v_uid uuid;
begin
  select user_id into v_uid from public.chat_phone_codes
   where code = p_code and used_at is null and expires_at > now();
  if v_uid is null then return 'invalid'; end if;
  if exists (select 1 from public.chat_phones where phone = p_phone and user_id <> v_uid) then
    return 'taken';
  end if;
  insert into public.chat_phones (user_id, phone) values (v_uid, p_phone)
  on conflict (user_id) do update set phone = excluded.phone, verified_at = now();
  update public.chat_phone_codes set used_at = now() where code = p_code;
  return 'ok';
end $$;
revoke all on function public.chat_confirm_phone(text, text) from public, anon, authenticated;
grant execute on function public.chat_confirm_phone(text, text) to service_role;
