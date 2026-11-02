import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/repo.dart';
import 'config.dart';

/// Phone notifications for new messages and broadcasts (FCM).
///
/// When the app is closed or in the background, Android shows the server's
/// notification itself on the loud [channel] (pops from the top with sound).
/// When the app is open, we show the same kind of notification ourselves,
/// except for the chat that's already on screen.
class Push {
  Push._();

  static bool get enabled => !kIsWeb && AppConfig.firebaseApiKey.isNotEmpty;

  /// True once Firebase started, i.e. phone notifications are live.
  static bool get ready => _ready;

  static const channel = AndroidNotificationChannel(
    'chat_messages',
    'الرسائل',
    description: 'إشعارات الرسائل والإعلانات الجديدة',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static final _local = FlutterLocalNotificationsPlugin();
  static bool _ready = false;
  static StreamSubscription<String>? _refresh;

  /// Called with a conversation id, or null for the announcements list.
  static void Function(String? conversationId)? _onOpen;
  static String? _pending;
  static bool _hasPending = false;

  /// Once at startup.
  static Future<void> init() async {
    if (!enabled || _ready) return;
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: AppConfig.firebaseApiKey,
          appId: AppConfig.firebaseAppId,
          messagingSenderId: AppConfig.firebaseSenderId,
          projectId: AppConfig.firebaseProjectId,
        ),
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await _local.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher')),
        onDidReceiveNotificationResponse: (r) =>
            _open(r.payload == 'broadcasts' ? null : r.payload),
      );
      FirebaseMessaging.onMessage.listen(_showForeground);
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _openData(m.data));
      _ready = true;
    } catch (e) {
      debugPrint('push init failed: $e');
    }
  }

  /// After sign-in, from the home screen: asks permission, saves this
  /// device's token and opens the chat if the app was launched from a
  /// notification.
  static Future<void> register(
      void Function(String? conversationId) onOpen) async {
    _onOpen = onOpen;
    if (_hasPending) {
      _hasPending = false;
      onOpen(_pending);
    }
    if (!_ready) return;
    try {
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      final token = await fm.getToken();
      if (token != null) await Repo.i.savePushToken(token);
      _refresh ??= fm.onTokenRefresh.listen(Repo.i.savePushToken);
      final initial = await fm.getInitialMessage();
      if (initial != null) _openData(initial.data);
    } catch (e) {
      debugPrint('push register failed: $e');
    }
  }

  static void _openData(Map<String, dynamic> data) {
    if (data['test'] != null) return; // test notification: nothing to open
    _open(data['conversation_id'] as String?);
  }

  /// False when the user has turned notifications off for this app (or for
  /// the chat channel), so nothing would show even though we send it.
  static Future<bool> allowed() async {
    if (!_ready) return true; // push not set up: nothing to warn about
    try {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      if (s.authorizationStatus == AuthorizationStatus.denied) return false;
      final android = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        if (await android.areNotificationsEnabled() == false) return false;
        final channels = await android.getNotificationChannels() ?? [];
        for (final c in channels) {
          if (c.id == channel.id && c.importance == Importance.none) {
            return false;
          }
        }
      }
    } catch (_) {}
    return true;
  }

  /// Asks again; if Android won't show the prompt any more, opens the app's
  /// notification settings.
  static Future<void> fix() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (_) {}
    if (!await allowed()) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  /// Makes sure this phone is registered, then asks the server to send a test
  /// notification to it. Returns how many of my phones it reached.
  static Future<({int sent, int of})> sendTest() async {
    if (!_ready) return (sent: 0, of: 0);
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await Repo.i.savePushToken(token);
    return Repo.i.sendTestPush();
  }

  static void _open(String? conversationId) {
    final cb = _onOpen;
    if (cb == null) {
      _pending = conversationId;
      _hasPending = true;
    } else {
      cb(conversationId);
    }
  }

  static void _showForeground(RemoteMessage m) {
    final n = m.notification;
    if (n == null) return;
    if (m.data['test'] != null) {
      _local.show(
        0,
        n.title,
        n.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high),
        ),
      );
      return;
    }
    final conv = m.data['conversation_id'] as String?;
    if (conv == null) return; // broadcasts already pop up as a dialog in-app
    if (conv == Repo.i.openChatId) return;
    _local.show(
      conv.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          tag: conv,
        ),
      ),
      payload: conv,
    );
  }
}
