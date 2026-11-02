// otpiq-sms-hook: Supabase Auth "Send SMS" hook. Delivers sign-in codes through
// OTPIQ (WhatsApp first, then Telegram, then SMS) for "المتابعة عبر واتساب".
// Secrets: SEND_SMS_HOOK_SECRET (from Auth → Hooks, "v1,whsec_..."),
//          OTPIQ_API_KEY (sk_live_...). Optional: OTPIQ_PROVIDER, OTP_DAILY_CAP.
// Guards: Iraqi mobile numbers only, 3 codes per number per 15 min, 10 per day,
// and a daily cap for the whole app, so a bot can't run up the bill.
// Deployed with verify_jwt = false; the hook signature is the auth.
import { Webhook } from "https://esm.sh/standardwebhooks@1.0.0";
import { createClient } from "npm:@supabase/supabase-js@2.45.4";

const db = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

const fail = (http_code: number, message: string) =>
  Response.json({ error: { http_code, message } }, { status: http_code });

async function count(filter: { phone?: string; minutes: number }) {
  let q = db.from("chat_otp_sends").select("id", { count: "exact", head: true })
    .gte("created_at", new Date(Date.now() - filter.minutes * 60_000).toISOString());
  if (filter.phone) q = q.eq("phone", filter.phone);
  const { count } = await q;
  return count ?? 0;
}

Deno.serve(async (req) => {
  const secret = Deno.env.get("SEND_SMS_HOOK_SECRET");
  const apiKey = Deno.env.get("OTPIQ_API_KEY");
  if (!secret || !apiKey) return fail(500, "Phone sign-in is not configured yet");

  const payload = await req.text();
  let data: { user?: { phone?: string }; sms?: { otp?: string } };
  try {
    data = new Webhook(secret.replace("v1,whsec_", "")).verify(payload, Object.fromEntries(req.headers)) as typeof data;
  } catch {
    return fail(401, "Invalid hook signature");
  }

  const phone = String(data.user?.phone ?? "").replace(/\D/g, "");
  const otp = String(data.sms?.otp ?? "");
  if (!/^9647\d{9}$/.test(phone)) return fail(400, "Only Iraqi mobile numbers (+964 7…) are supported");
  if (!otp) return fail(400, "Missing code");

  const dailyCap = Number(Deno.env.get("OTP_DAILY_CAP") ?? "300");
  if (await count({ phone, minutes: 15 }) >= 3 || await count({ phone, minutes: 1440 }) >= 10) {
    return fail(429, "Too many codes for this number, try again later");
  }
  if (await count({ minutes: 1440 }) >= dailyCap) return fail(429, "Daily limit reached, try again tomorrow");

  const { data: row } = await db.from("chat_otp_sends").insert({ phone }).select("id").single();
  const res = await fetch("https://api.otpiq.com/api/sms", {
    method: "POST",
    headers: { authorization: `Bearer ${apiKey}`, "content-type": "application/json", accept: "application/json" },
    body: JSON.stringify({
      phoneNumber: phone,
      smsType: "verification",
      verificationCode: otp,
      provider: Deno.env.get("OTPIQ_PROVIDER") ?? "whatsapp-telegram-sms",
    }),
  }).catch((e) => { console.log("otpiq network error", String(e)); return null; });

  if (!res?.ok) {
    console.log("otpiq failed", res?.status, res ? (await res.text()).slice(0, 300) : "");
    return fail(502, "Could not send the code, try again");
  }
  if (row) await db.from("chat_otp_sends").update({ ok: true }).eq("id", row.id);
  return Response.json({});
});
