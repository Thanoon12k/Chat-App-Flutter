// chat-push: sends FCM notifications for new chat messages and broadcasts.
// Called by the chat_push_notify() trigger (pg_net) with {type, id}.
// Secret: FCM_SERVICE_ACCOUNT (Firebase service-account JSON).
// Deployed with verify_jwt = false. It is safe to be public: it re-reads the row
// itself, only sends for rows under a minute old, and each row only once.
import { createClient } from "npm:@supabase/supabase-js@2.45.4";

const db = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

type Push = { title: string; body: string; data: Record<string, string> };

Deno.serve(async (req) => {
  const sa = Deno.env.get("FCM_SERVICE_ACCOUNT");
  if (!sa) return Response.json({ skipped: "FCM_SERVICE_ACCOUNT not set" });

  const { type, id } = await req.json().catch(() => ({}));
  if (type === "check") { // health check: can we get a Google token? Sends nothing.
    try {
      await googleAccessToken(JSON.parse(sa));
      return Response.json({ ok: true, project: JSON.parse(sa).project_id });
    } catch (e) {
      return Response.json({ ok: false, error: String(e).slice(0, 300) }, { status: 500 });
    }
  }
  if (type === "test") return sendTest(req, sa);
  if (!["chat_messages", "chat_broadcasts"].includes(type) || !Number.isInteger(id)) {
    return new Response("bad request", { status: 400 });
  }
  const { data: record } = await db.from(type).select("*").eq("id", id).maybeSingle();
  if (!record || Date.now() - Date.parse(record.created_at) > 60_000) {
    return Response.json({ skipped: "missing or old" });
  }
  const { error: dup } = await db.from("chat_push_sent").insert({ kind: type, id });
  if (dup) return Response.json({ skipped: "already sent" });

  let userIds: string[] | null = null; // null = everyone
  let push: Push;

  if (type === "chat_messages") {
    const [{ data: conv }, { data: sender }, { data: members }] = await Promise.all([
      db.from("chat_conversations").select("kind,name").eq("id", record.conversation_id).single(),
      db.from("chat_profiles").select("name").eq("id", record.sender_id).single(),
      db.from("chat_members").select("user_id").eq("conversation_id", record.conversation_id),
    ]);
    userIds = (members ?? []).map((m) => m.user_id).filter((id) => id !== record.sender_id);
    const text = (record.body ?? "").trim() || "📷 صورة";
    const who = sender?.name ?? "";
    push = conv?.kind === "room"
      ? { title: conv.name, body: `${who}: ${text}`, data: { conversation_id: record.conversation_id } }
      : { title: who, body: text, data: { conversation_id: record.conversation_id } };
  } else if (type === "chat_broadcasts") {
    if (record.room_id) {
      const { data: members } = await db.from("chat_members").select("user_id").eq("conversation_id", record.room_id);
      userIds = (members ?? []).map((m) => m.user_id);
    }
    push = { title: `📣 ${record.title}`, body: record.body, data: { broadcast_id: String(record.id) } };
  } else {
    return new Response("bad request", { status: 400 });
  }

  if (userIds && userIds.length === 0) return Response.json({ sent: 0 });
  let q = db.from("chat_push_tokens").select("token");
  if (userIds) q = q.in("user_id", userIds);
  const { data: tokens } = await q;
  if (!tokens?.length) {
    console.log("push", type, id, "no registered phones for", userIds ? userIds.length + " recipient(s)" : "everyone");
    return Response.json({ sent: 0 });
  }

  const tag = push.data.conversation_id ?? `b${push.data.broadcast_id}`;
  const sent = await sendAll(sa, tokens.map((t) => t.token), push, tag);
  console.log("push", type, id, "sent", sent, "of", tokens.length);
  return Response.json({ sent, of: tokens.length });
});

// "Send me a test notification" from the app: to the caller's own phones only,
// at most once per 20 seconds.
async function sendTest(req: Request, sa: string) {
  const jwt = (req.headers.get("authorization") ?? "").replace(/^Bearer\s+/i, "");
  const { data: { user } } = await db.auth.getUser(jwt);
  if (!user) return Response.json({ error: "sign in first" }, { status: 401 });
  const { error: dup } = await db.from("chat_push_sent")
    .insert({ kind: `test:${user.id}`, id: Math.floor(Date.now() / 20_000) });
  if (dup) return Response.json({ error: "wait" }, { status: 429 });
  const { data: tokens } = await db.from("chat_push_tokens").select("token").eq("user_id", user.id);
  if (!tokens?.length) return Response.json({ sent: 0, of: 0 });
  const sent = await sendAll(sa, tokens.map((t) => t.token), {
    title: "🔔 إشعار تجريبي",
    body: "الإشعارات تعمل على هذا الجهاز ✅",
    data: { test: "1" },
  }, "test");
  console.log("push test", user.id, "sent", sent, "of", tokens.length);
  return Response.json({ sent, of: tokens.length });
}

// Sends one notification to each token; drops tokens Google says are dead.
async function sendAll(sa: string, tokens: string[], push: Push, tag: string) {
  const account = JSON.parse(sa);
  const access = await googleAccessToken(account);
  let sent = 0;
  await Promise.all(tokens.map(async (token) => {
    const res = await fetch(`https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`, {
      method: "POST",
      headers: { authorization: `Bearer ${access}`, "content-type": "application/json" },
      body: JSON.stringify({
        message: {
          token,
          notification: { title: push.title, body: push.body },
          data: push.data,
          android: {
            priority: "HIGH",
            notification: { channel_id: "chat_messages", sound: "default", tag, default_vibrate_timings: true },
          },
        },
      }),
    });
    if (res.ok) sent++;
    else {
      const err = await res.text();
      console.log("push failed", res.status, err.slice(0, 200));
      if (err.includes("UNREGISTERED") || err.includes("INVALID_ARGUMENT")) {
        await db.from("chat_push_tokens").delete().eq("token", token);
      }
    }
  }));
  return sent;
}

// OAuth access token for FCM from a service account (JWT bearer grant).
let cached: { token: string; exp: number } | null = null;
async function googleAccessToken(sa: { client_email: string; private_key: string }) {
  const now = Math.floor(Date.now() / 1000);
  if (cached && cached.exp > now + 60) return cached.token;
  const b64 = (s: string | Uint8Array) =>
    btoa(typeof s === "string" ? s : String.fromCharCode(...s)).replace(/=+$/, "").replace(/\+/g, "-").replace(/\//g, "_");
  const header = b64(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claims = b64(JSON.stringify({
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  }));
  const pem = sa.private_key.replace(/-----[^-]+-----/g, "").replace(/\s/g, "");
  const key = await crypto.subtle.importKey(
    "pkcs8", Uint8Array.from(atob(pem), (c) => c.charCodeAt(0)),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" }, false, ["sign"],
  );
  const sig = new Uint8Array(await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(`${header}.${claims}`)));
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${header}.${claims}.${b64(sig)}`,
    }),
  });
  const json = await res.json();
  if (!json.access_token) throw new Error("google token: " + JSON.stringify(json));
  cached = { token: json.access_token, exp: now + (json.expires_in ?? 3600) };
  return cached.token;
}
