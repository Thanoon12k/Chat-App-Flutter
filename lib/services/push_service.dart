import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// No Firebase account is required until PUSH_ENABLED is set at build time.
class PushService {
  PushService._();
  static final i = PushService._();
  static const enabled = bool.fromEnvironment('PUSH_ENABLED');
  final opened = StreamController<String>.broadcast();
  final foreground = StreamController<RemoteMessage>.broadcast();
  RemoteMessage? _pending;
  String? activeConversation;
  String? _token;
  bool _ready = false;
  SupabaseClient get _db => Supabase.instance.client;

  Future<void> initialize() async {
    if (!enabled || kIsWeb) return;
    try {
      await Firebase.initializeApp();
      // Foreground notifications use an in-app banner to avoid duplicates.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: false,
            badge: false,
            sound: false,
          );
      FirebaseMessaging.onMessageOpenedApp.listen(_open);
      FirebaseMessaging.onMessage.listen((message) {
        if (_forMe(message) &&
            message.data['conversation_id'] != activeConversation)
          foreground.add(message);
      });
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          if (_token != null && _token != token)
            await _db.rpc(
              'chat_unregister_device',
              params: {'p_token': _token},
            );
          _token = token;
          await _register();
        } catch (_) {
          /* Retried on next resume. */
        }
      });
      _pending = await FirebaseMessaging.instance.getInitialMessage();
      _ready = true;
    } catch (_) {
      debugPrint('Push setup unavailable; chat remains usable.');
    }
  }

  bool _forMe(RemoteMessage message) =>
      _db.auth.currentUser?.id == message.data['recipient_id'];
  void _open(RemoteMessage message) {
    if (!_forMe(message)) return;
    final id = message.data['conversation_id'];
    if (id is String) opened.add(id);
  }

  void consumePending() {
    final message = _pending;
    _pending = null;
    if (message != null) _open(message);
  }

  Future<void> activate() async {
    if (!_ready) return;
    final permission = await FirebaseMessaging.instance.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) return;
    // APNs token may arrive after initial startup. Retry on app resume.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await FirebaseMessaging.instance.getAPNSToken() == null)
      return;
    _token = await FirebaseMessaging.instance.getToken();
    await _register();
  }

  Future<void> _register() async {
    if (_token == null || _db.auth.currentUser == null) return;
    await _db.rpc(
      'chat_register_device',
      params: {
        'p_token': _token,
        'p_platform': defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'android',
      },
    );
  }

  Future<void> detach() async {
    if (!_ready) return;
    // If unregister fails, do not silently leave a token associated to the account.
    if (_token != null)
      await _db.rpc('chat_unregister_device', params: {'p_token': _token});
    await FirebaseMessaging.instance.deleteToken();
    _token = null;
    _pending = null;
    activeConversation = null;
  }
}
