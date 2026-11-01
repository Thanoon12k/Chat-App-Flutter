# دردشة — Chat App

A simple Arabic (RTL) chat app built with Flutter and Supabase.

The home screen shows only what matters: your conversations, newest first, with unread badges.
Everything else is one tap away:

- **＋ button** → private chat · browse rooms · create room
- **Your avatar** (top corner) → your profile, edit, sign out
- **Chat title** → the other person's profile, or the room's members / leave

## Features

- Google sign-in and email + password (Supabase Auth)
- Public rooms, optionally locked with a password (hashed on the server)
- Private 1:1 chats
- Image messages (Supabase Storage, bucket `chat-media`)
- Realtime messages and unread counts
- Profiles with stars and comments
- Live room delivery: every message in a room reaches all its members in realtime, with an
  in-app alert (who, which room, "open") when you're on another screen
- Manager announcements: broadcast to everyone or to one room's members; shown as a pop-up
  and kept under the 📣 button on the home screen
- Banned accounts see a "suspended" screen and can't send messages
- The original look: pink background, red accents, pastel bubbles, girl-photo logo and icon, night-sky login, Cairo font

## Backend

Supabase project `axncazensmjdqpczvzwf`. All tables use the `chat_` prefix and have row-level security:

| Table | Purpose |
|---|---|
| `chat_profiles` | name, bio, avatar, stars count |
| `chat_conversations` | rooms and direct chats, last message preview |
| `chat_members` | who is in which chat, last read time |
| `chat_messages` | text and/or image messages |
| `chat_profile_stars` / `chat_profile_comments` | profile reactions |

| `chat_admins` | who can use the admin dashboard |
| `chat_broadcasts` | manager announcements (`room_id` null = everyone) |

RPCs: `chat_my_conversations`, `chat_rooms_directory`, `chat_create_room`, `chat_join_room`,
`chat_start_direct`, `chat_mark_read`. The full schema is in `supabase/schema.sql`; the admin/broadcast additions
(including `chat_is_admin`, `chat_admin_stats` and the `banned` flag) are in `supabase/admin.sql`.

## Admin dashboard

`admin/index.html` is a single-file web dashboard (no build step):

- **Overview**: user / room / message counts and the latest messages
- **Users**: search, suspend / unsuspend, delete a profile (with its messages)
- **Rooms**: create, rename, edit description, remove a password, delete, add / remove members
- **Messages**: browse by conversation, search text, delete
- **Broadcasts**: send an announcement to everyone or to one room, delete old ones

**Live:** https://iraqchatapp.pythonanywhere.com/ — publish or update it with
`scripts/deploy_admin.sh` (needs the PythonAnywhere API token in `$iraqchatapp_api_token`).

Or run it locally:

```bash
cd admin && python3 -m http.server 8080
```

Only accounts listed in `chat_admins` see data; everyone else is signed out. Add an admin with SQL:

```sql
insert into public.chat_admins (user_id) select id from auth.users where email = 'someone@example.com';
```

For Google sign-in on the dashboard, add its URL (`https://iraqchatapp.pythonanywhere.com/` and/or `http://localhost:8080/`) to
Supabase Auth → URL Configuration → Redirect URLs.

## Run

```bash
flutter pub get
flutter run
```

To point at a different project:
`flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_KEY=sb_publishable_...`

## Code layout

```
lib/
  core/      config + theme
  data/      models + Repo (every Supabase call)
  screens/   auth, profile setup, home, chat, people, rooms, profile
  widgets/   Avatar, EmptyState, helpers
```
