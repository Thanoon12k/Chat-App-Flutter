import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config.dart';
import 'models.dart';

/// Every call to Supabase lives here, so screens only deal with models.
class Repo {
  Repo._();
  static final Repo i = Repo._();

  SupabaseClient get _db => Supabase.instance.client;
  String get myId => _db.auth.currentUser!.id;

  // ---------- auth ----------
  Future<void> signIn(String email, String password) =>
      _db.auth.signInWithPassword(email: email.trim(), password: password);

  /// Returns true when the user is signed in right away, false when the
  /// project requires email confirmation first.
  Future<bool> signUp(String email, String password) async {
    final res = await _db.auth.signUp(email: email.trim(), password: password);
    return res.session != null;
  }

  /// "Continue with WhatsApp": Supabase sends a 6-digit code through OTPIQ
  /// (WhatsApp, then Telegram, then SMS). [phone] is +9647XXXXXXXXX.
  Future<void> sendPhoneCode(String phone) =>
      _db.auth.signInWithOtp(phone: phone);

  Future<void> verifyPhoneCode(String phone, String code) =>
      _db.auth.verifyOTP(phone: phone, token: code.trim(), type: OtpType.sms);

  /// Opens Google in the browser; the session arrives through the deep link
  /// and AuthGate reacts to it.
  Future<void> signInWithGoogle() async {
    await _db.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : AppConfig.authRedirect,
      queryParams: {'prompt': 'select_account'},
    );
  }

  /// Name and photo from the Google account, used to prefill profile setup.
  String? get providerName {
    final m = _db.auth.currentUser?.userMetadata;
    return (m?['full_name'] ?? m?['name']) as String?;
  }

  String? get providerAvatar {
    final m = _db.auth.currentUser?.userMetadata;
    return (m?['avatar_url'] ?? m?['picture']) as String?;
  }

  Future<void> signOut() async {
    final t = pushToken;
    if (t != null) {
      try {
        await _db.from('chat_push_tokens').delete().eq('token', t);
      } catch (_) {}
    }
    await _db.auth.signOut();
  }

  // ---------- phone (WhatsApp verification) ----------
  /// My verified phone number, or null.
  Future<String?> myPhone() async {
    final row = await _db
        .from('chat_phones')
        .select('phone')
        .eq('user_id', myId)
        .maybeSingle();
    return row?['phone'] as String?;
  }

  /// A fresh 6-digit code to send to our WhatsApp number.
  Future<String> newPhoneCode() async =>
      await _db.rpc('chat_new_phone_code') as String;

  // ---------- push ----------
  /// This device's FCM token, once push is set up.
  String? pushToken;

  /// Asks the server to send a test notification to my registered phones.
  Future<({int sent, int of})> sendTestPush() async {
    final res = await _db.functions.invoke('chat-push', body: {'type': 'test'});
    final data = (res.data as Map?) ?? {};
    return (sent: (data['sent'] ?? 0) as int, of: (data['of'] ?? 0) as int);
  }

  Future<void> savePushToken(String token) async {
    pushToken = token;
    await _db.rpc('chat_save_push_token', params: {'p_token': token});
  }

  // ---------- profiles ----------
  final Map<String, Profile> _cache = {};

  Future<Profile?> myProfile() => profile(myId, fresh: true);

  Future<Profile?> profile(String id, {bool fresh = false}) async {
    if (!fresh && _cache.containsKey(id)) return _cache[id];
    final row =
        await _db.from('chat_profiles').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    return _cache[id] = Profile.fromJson(row);
  }

  Future<Map<String, Profile>> profiles(Iterable<String> ids) async {
    final missing = ids.where((id) => !_cache.containsKey(id)).toSet();
    if (missing.isNotEmpty) {
      final rows = await _db
          .from('chat_profiles')
          .select()
          .inFilter('id', missing.toList());
      for (final r in rows) {
        final p = Profile.fromJson(r);
        _cache[p.id] = p;
      }
    }
    return {
      for (final id in ids)
        if (_cache[id] != null) id: _cache[id]!
    };
  }

  Future<List<Profile>> searchPeople(String q) async {
    var query = _db.from('chat_profiles').select().neq('id', myId);
    if (q.trim().isNotEmpty) query = query.ilike('name', '%${q.trim()}%');
    final rows = await query.order('name').limit(50);
    return rows.map(Profile.fromJson).toList();
  }

  /// Creates or updates my profile. Throws [NameTakenException] on duplicates.
  Future<void> saveProfile(
      {required String name,
      String bio = '',
      XFile? avatar,
      String? avatarUrl}) async {
    if (avatar != null) avatarUrl = await uploadImage(avatar, 'avatar');
    try {
      await _db.from('chat_profiles').upsert({
        'id': myId,
        'name': name.trim(),
        'bio': bio.trim(),
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw NameTakenException();
      rethrow;
    }
    _cache.remove(myId);
  }

  // ---------- stars & comments ----------
  Future<bool> didStar(String profileId) async {
    final row = await _db
        .from('chat_profile_stars')
        .select('profile_id')
        .eq('profile_id', profileId)
        .eq('giver_id', myId)
        .maybeSingle();
    return row != null;
  }

  Future<void> setStar(String profileId, bool on) async {
    if (on) {
      await _db
          .from('chat_profile_stars')
          .upsert({'profile_id': profileId, 'giver_id': myId});
    } else {
      await _db
          .from('chat_profile_stars')
          .delete()
          .eq('profile_id', profileId)
          .eq('giver_id', myId);
    }
    _cache.remove(profileId);
  }

  Future<List<ProfileComment>> comments(String profileId) async {
    final rows = await _db
        .from('chat_profile_comments')
        .select(
            'id, body, created_at, author:chat_profiles!chat_profile_comments_author_id_fkey(*)')
        .eq('profile_id', profileId)
        .order('created_at', ascending: false)
        .limit(100);
    return rows.map(ProfileComment.fromJson).toList();
  }

  Future<void> addComment(String profileId, String body) =>
      _db.from('chat_profile_comments').insert(
          {'profile_id': profileId, 'author_id': myId, 'body': body.trim()});

  Future<void> deleteComment(int id) =>
      _db.from('chat_profile_comments').delete().eq('id', id);

  // ---------- conversations ----------
  Future<List<ChatSummary>> myChats() async {
    final rows = await _db.rpc('chat_my_conversations') as List;
    return rows.cast<Map<String, dynamic>>().map(ChatSummary.fromJson).toList();
  }

  Future<List<Room>> rooms() async {
    final rows = await _db.rpc('chat_rooms_directory') as List;
    return rows.cast<Map<String, dynamic>>().map(Room.fromJson).toList();
  }

  Future<String> createRoom(
          String name, String description, String password) async =>
      await _db.rpc('chat_create_room', params: {
        'p_name': name.trim(),
        'p_description': description.trim(),
        'p_password': password.isEmpty ? null : password,
      }) as String;

  /// False when the password is wrong.
  Future<bool> joinRoom(String roomId, [String? password]) async =>
      await _db.rpc('chat_join_room',
          params: {'p_room': roomId, 'p_password': password}) as bool;

  Future<void> leave(String conversationId) => _db
      .from('chat_members')
      .delete()
      .eq('conversation_id', conversationId)
      .eq('user_id', myId);

  Future<String> startDirect(String otherUserId) async =>
      await _db.rpc('chat_start_direct', params: {'p_other': otherUserId})
          as String;

  Future<void> markRead(String conversationId) =>
      _db.rpc('chat_mark_read', params: {'p_conv': conversationId});

  Future<List<String>> memberIds(String conversationId) async {
    final rows = await _db
        .from('chat_members')
        .select('user_id')
        .eq('conversation_id', conversationId);
    return rows.map((r) => r['user_id'] as String).toList();
  }

  // ---------- messages ----------
  Stream<List<Message>> messages(String conversationId) => _db
      .from('chat_messages')
      .stream(primaryKey: ['id'])
      .eq('conversation_id', conversationId)
      .order('created_at', ascending: false)
      .limit(200)
      .map((rows) => rows.map(Message.fromJson).toList());

  Future<void> send(String conversationId, {String? text, XFile? image}) async {
    String? imageUrl;
    if (image != null) imageUrl = await uploadImage(image, 'msg');
    await _db.from('chat_messages').insert({
      'conversation_id': conversationId,
      'sender_id': myId,
      'body': (text?.trim().isEmpty ?? true) ? null : text!.trim(),
      'image_url': imageUrl,
    });
  }

  Future<void> deleteMessage(int id) =>
      _db.from('chat_messages').delete().eq('id', id);

  /// The chat currently on screen, so new-message alerts skip it.
  String? openChatId;

  /// Fires whenever a message lands in any chat I belong to (RLS filters
  /// realtime to members, so every member of a room gets every message).
  RealtimeChannel onAnyMessage(void Function(Message m) cb) => _db
      .channel('home-${DateTime.now().microsecondsSinceEpoch}')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'chat_messages',
        callback: (p) => cb(Message.fromJson(p.newRecord)),
      )
      .subscribe();

  // ---------- broadcasts ----------
  Future<List<Broadcast>> broadcasts() async {
    final rows = await _db
        .from('chat_broadcasts')
        .select(
            'id, title, body, room_id, created_at, room:chat_conversations(name)')
        .order('created_at', ascending: false)
        .limit(100);
    return rows.map(Broadcast.fromJson).toList();
  }

  /// Fires when a manager broadcasts to everyone or to a room I'm in.
  RealtimeChannel onBroadcast(void Function(Broadcast b) cb) => _db
      .channel('broadcasts-${DateTime.now().microsecondsSinceEpoch}')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'chat_broadcasts',
        callback: (p) => cb(Broadcast.fromJson(p.newRecord)),
      )
      .subscribe();

  Future<void> unsubscribe(RealtimeChannel c) => _db.removeChannel(c);

  // ---------- storage ----------
  Future<String> uploadImage(XFile file, String prefix) async {
    final bytes = await file.readAsBytes();
    final ext = _ext(file);
    final path = '$myId/$prefix-${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _db.storage.from(AppConfig.mediaBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: _mime(ext), upsert: true),
        );
    return _db.storage.from(AppConfig.mediaBucket).getPublicUrl(path);
  }

  String _ext(XFile f) {
    final n = f.name.toLowerCase();
    for (final e in ['png', 'webp', 'gif']) {
      if (n.endsWith('.$e')) return e;
    }
    return 'jpg';
  }

  String _mime(String ext) => ext == 'jpg' ? 'image/jpeg' : 'image/$ext';
}

class NameTakenException implements Exception {}
