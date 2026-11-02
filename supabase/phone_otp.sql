-- "Continue with WhatsApp": Supabase phone sign-in whose codes are delivered by
-- OTPIQ (WhatsApp, then Telegram, then SMS) through the Send SMS hook
-- (`otpiq-sms-hook` Edge Function). Applied as migration `chat_phone_otp`.
-- One row per code sent, used for rate limits and the daily spending cap.

create table public.chat_otp_sends (
  id bigint generated always as identity primary key,
  phone text not null,
  ok boolean not null default false,
  created_at timestamptz not null default now()
);
create index chat_otp_sends_phone_idx on public.chat_otp_sends (phone, created_at desc);
create index chat_otp_sends_created_idx on public.chat_otp_sends (created_at);
alter table public.chat_otp_sends enable row level security;
-- No policies: only the Edge Function (service role) reads and writes it.
