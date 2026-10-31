# دردشة — Chat App

A simple Arabic (RTL) chat app built with Flutter and Supabase.

The home screen shows only what matters: your conversations, newest first, with unread badges.
Everything else is one tap away:

- **＋ button** → private chat · browse rooms · create room
- **Your avatar** (top corner) → your profile, edit, sign out
- **Chat title** → the other person's profile, or the room's members / leave

## Features

- Email + password sign-in (Supabase Auth)
- Public rooms, optionally locked with a password (hashed on the server)
- Private 1:1 chats
- Image messages (Supabase Storage, bucket `chat-media`)
- Realtime messages and unread counts
- Profiles with stars and comments
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

RPCs: `chat_my_conversations`, `chat_rooms_directory`, `chat_create_room`, `chat_join_room`,
`chat_start_direct`, `chat_mark_read`. The full schema is in `supabase/schema.sql`.

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
