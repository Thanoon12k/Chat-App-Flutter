// whatsapp-webhook: Meta WhatsApp Cloud API webhook for free phone verification.
// The user sends "رمز التحقق 123456" to our WhatsApp number; we match the code,
// save the sender's number as verified, and reply (replies to user-started
// chats are free).
// Secrets: WHATSAPP_APP_SECRET (Meta app secret, checks the signature)
//          WHATSAPP_TOKEN (permanent system-user token, for the reply).
// Deployed with verify_jwt = false (Meta calls it directly).
import { createClient } from "npm:@supabase/supabase-js@2.45.4";

const VERIFY_TOKEN = "8043c600fe4d6938ee70365e"; // only used for Meta's subscribe handshake
const db = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

const REPLIES: Record<string, string> = {
  ok: "✅ تم تأكيد رقمك في تطبيق دردشة. يمكنك العودة إلى التطبيق.",
  invalid: "❌ الرمز غير صحيح أو انتهت صلاحيته. اطلب رمزاً جديداً من التطبيق.",
  taken: "⚠️ هذا الرقم مرتبط بحساب آخر في دردشة.",
};

Deno.serve(async (req) => {
  const url = new URL(req.url);
  if (req.method === "GET") {
    if (url.searchParams.get("hub.mode") === "subscribe" &&
        url.searchParams.get("hub.verify_token") === VERIFY_TOKEN) {
      return new Response(url.searchParams.get("hub.challenge") ?? "");
    }
    return new Response("forbidden", { status: 403 });
  }

  const secret = Deno.env.get("WHATSAPP_APP_SECRET");
  const raw = await req.text();
  if (!secret || !(await validSignature(raw, req.headers.get("x-hub-signature-256"), secret))) {
    return new Response("bad signature", { status: 401 });
  }

  const body = JSON.parse(raw);
  for (const entry of body.entry ?? []) {
    for (const change of entry.changes ?? []) {
      const value = change.value ?? {};
      for (const st of value.statuses ?? []) {
        // Delivery reports for messages we sent; failures carry the reason.
        console.log("status", st.status, st.recipient_id, JSON.stringify(st.errors ?? []));
      }
      for (const msg of value.messages ?? []) {
        const text: string = msg.text?.body ?? msg.button?.text ?? "";
        console.log("incoming", msg.from, msg.type);
        const code = text.replace(/[٠-٩]/g, (d) => String("٠١٢٣٤٥٦٧٨٩".indexOf(d))).match(/\b(\d{6})\b/)?.[1];
        if (!code || !msg.from) continue;
        const { data: status } = await db.rpc("chat_confirm_phone", { p_code: code, p_phone: `+${msg.from}` });
        await reply(value.metadata?.phone_number_id, msg.from, REPLIES[status as string] ?? REPLIES.invalid);
      }
    }
  }
  return new Response("ok"); // always 200 so Meta doesn't retry
});

async function reply(phoneNumberId: string | undefined, to: string, text: string) {
  const token = Deno.env.get("WHATSAPP_TOKEN");
  if (!token || !phoneNumberId) return;
  const res = await fetch(`https://graph.facebook.com/v21.0/${phoneNumberId}/messages`, {
    method: "POST",
    headers: { authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: JSON.stringify({ messaging_product: "whatsapp", to, type: "text", text: { body: text } }),
  }).catch((e) => { console.log("reply error", String(e)); return null; });
  if (res && !res.ok) console.log("reply failed", res.status, (await res.text()).slice(0, 300));
}

async function validSignature(raw: string, header: string | null, secret: string) {
  if (!header?.startsWith("sha256=")) return false;
  const key = await crypto.subtle.importKey("raw", new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  const mac = new Uint8Array(await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(raw)));
  const hex = Array.from(mac, (b) => b.toString(16).padStart(2, "0")).join("");
  const given = header.slice(7);
  if (given.length !== hex.length) return false;
  let diff = 0;
  for (let i = 0; i < hex.length; i++) diff |= hex.charCodeAt(i) ^ given.charCodeAt(i);
  return diff === 0;
}
