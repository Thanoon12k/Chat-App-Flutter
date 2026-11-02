import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show RealtimeChannel;

import '../core/push.dart';
import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';
import 'broadcasts_screen.dart';
import 'chat_screen.dart';
import 'people_screen.dart';
import 'profile_screen.dart';
import 'rooms_screen.dart';

/// The one screen that matters: your conversations. Everything else is one
/// tap away behind the "+" button or your avatar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<ChatSummary>? _chats;
  Profile? _me;
  bool _failed = false;
  bool _notifOff = false;
  RealtimeChannel? _channel;
  RealtimeChannel? _broadcasts;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    Repo.i.myProfile().then((p) => mounted ? setState(() => _me = p) : null);
    _channel = Repo.i.onAnyMessage((m) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), _load);
      _alertMessage(m);
    });
    _broadcasts = Repo.i.onBroadcast(_showBroadcast);
    Push.register(_openFromNotification).then((_) => _checkNotifications());
  }

  Future<void> _checkNotifications() async {
    final ok = await Push.allowed();
    if (mounted && ok == _notifOff) setState(() => _notifOff = !ok);
  }

  /// A tapped phone notification: open that chat, or the announcements.
  Future<void> _openFromNotification(String? conversationId) async {
    if (!mounted) return;
    if (conversationId == null) {
      _openBroadcasts();
      return;
    }
    if (conversationId == Repo.i.openChatId) return;
    await _load();
    final chat = _chats?.where((c) => c.id == conversationId).firstOrNull;
    if (chat != null && mounted) _open(chat);
  }

  /// A message reached one of my chats while I'm elsewhere: show who sent it
  /// and where, with a shortcut to open that chat.
  Future<void> _alertMessage(Message m) async {
    // With push on, the phone notification covers this.
    if (Push.ready ||
        m.senderId == Repo.i.myId ||
        m.conversationId == Repo.i.openChatId) {
      return;
    }
    final sender = await Repo.i.profile(m.senderId);
    var chat = _chats?.where((c) => c.id == m.conversationId).firstOrNull;
    if (chat == null) {
      await _load();
      chat = _chats?.where((c) => c.id == m.conversationId).firstOrNull;
    }
    if (!mounted || chat == null || m.conversationId == Repo.i.openChatId) {
      return;
    }
    final who = sender?.name ?? '';
    final where = chat.isRoom ? '$who في ${chat.title}' : who;
    final body = m.body?.trim() ?? '';
    final text = body.isEmpty ? '📷 صورة' : body;
    final target = chat;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('$where: $text',
            maxLines: 2, overflow: TextOverflow.ellipsis),
        action: SnackBarAction(label: 'فتح', onPressed: () => _open(target)),
      ));
  }

  void _showBroadcast(Broadcast b) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        icon: const Icon(Icons.campaign_rounded),
        title: Text(b.title),
        content: SingleChildScrollView(child: Text(b.body)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              _openBroadcasts();
            },
            child: const Text('كل الإعلانات'),
          ),
          FilledButton(
              onPressed: () => Navigator.pop(c), child: const Text('حسناً')),
        ],
      ),
    );
  }

  void _openBroadcasts() => Navigator.push(context,
      MaterialPageRoute(builder: (_) => const BroadcastsScreen()));

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    if (_channel != null) Repo.i.unsubscribe(_channel!);
    if (_broadcasts != null) Repo.i.unsubscribe(_broadcasts!);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
      _checkNotifications(); // back from the settings page?
    }
  }

  Future<void> _load() async {
    try {
      final chats = await Repo.i.myChats();
      if (mounted) {
        setState(() {
          _chats = chats;
          _failed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _open(ChatSummary c) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(chat: c)),
    );
    _load();
  }

  Future<void> _openMe() async {
    if (_me == null) return;
    await Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProfileScreen(userId: _me!.id)));
    final p = await Repo.i.myProfile();
    if (mounted) setState(() => _me = p);
  }

  Future<void> _newChat() async {
    final choice = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _SheetAction(
            icon: Icons.person_add_alt_1_rounded,
            title: 'محادثة خاصة',
            subtitle: 'راسل شخصاً مباشرة',
            onTap: () => Navigator.pop(c, 0),
          ),
          _SheetAction(
            icon: Icons.travel_explore_rounded,
            title: 'تصفح الغرف',
            subtitle: 'انضم إلى غرفة عامة',
            onTap: () => Navigator.pop(c, 1),
          ),
          _SheetAction(
            icon: Icons.group_add_rounded,
            title: 'إنشاء غرفة',
            subtitle: 'غرفة جديدة لأصدقائك',
            onTap: () => Navigator.pop(c, 2),
          ),
          const SizedBox(height: 12),
        ]),
      ),
    );
    if (choice == null || !mounted) return;

    ChatSummary? opened;
    if (choice == 0) {
      opened = await Navigator.push<ChatSummary>(
          context, MaterialPageRoute(builder: (_) => const PeopleScreen()));
    } else if (choice == 1) {
      opened = await Navigator.push<ChatSummary>(
          context, MaterialPageRoute(builder: (_) => const RoomsScreen()));
    } else {
      opened = await showCreateRoom(context);
    }
    await _load();
    if (opened != null && mounted) _open(opened);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsetsDirectional.only(start: 12),
          child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/girl.jpg')),
        ),
        leadingWidth: 60,
        title: const Text('المحادثات'),
        actions: [
          IconButton(
            tooltip: 'الإعلانات',
            onPressed: _openBroadcasts,
            icon: const Icon(Icons.campaign_outlined),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _openMe,
              child:
                  Avatar(name: _me?.name ?? '', url: _me?.avatarUrl, size: 38),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'محادثة جديدة',
        onPressed: _newChat,
        child: const Icon(Icons.add_comment_rounded),
      ),
      body: Column(children: [
        if (_notifOff)
          _NotificationsOffBanner(
              onFix: () => Push.fix().then((_) => _checkNotifications())),
        Expanded(child: _body()),
      ]),
    );
  }

  Widget _body() {
    if (_chats == null) {
      return _failed
          ? EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'لا يوجد اتصال',
              action: FilledButton.tonal(
                  onPressed: _load, child: const Text('إعادة المحاولة')),
            )
          : const Center(child: CircularProgressIndicator());
    }
    if (_chats!.isEmpty) {
      return EmptyState(
        icon: Icons.forum_rounded,
        title: 'لا توجد محادثات بعد',
        subtitle: 'ابدأ محادثة خاصة أو انضم إلى غرفة',
        action: FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(200, 48)),
          onPressed: _newChat,
          icon: const Icon(Icons.add_rounded),
          label: const Text('محادثة جديدة'),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: _chats!.length,
        itemBuilder: (_, i) => _ChatTile(chat: _chats![i], onTap: _open),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatSummary chat;
  final void Function(ChatSummary) onTap;

  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unread = chat.unread > 0;
    return ListTile(
      onTap: () => onTap(chat),
      leading: Avatar(
        name: chat.title,
        url: chat.imageUrl,
        size: 52,
        icon:
            chat.isRoom && chat.imageUrl == null ? Icons.groups_rounded : null,
      ),
      title: Row(children: [
        Expanded(
          child: Text(chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Text(shortTime(chat.lastMessageAt),
            style: TextStyle(
                fontSize: 12,
                color: unread ? scheme.primary : scheme.onSurfaceVariant)),
      ]),
      subtitle: Row(children: [
        Expanded(
          child: Text(
            chat.lastMessage ?? (chat.isRoom ? 'غرفة جديدة' : 'قل مرحباً 👋'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: unread ? scheme.onSurface : scheme.onSurfaceVariant,
                fontWeight: unread ? FontWeight.w600 : FontWeight.normal),
          ),
        ),
        if (unread)
          Container(
            margin: const EdgeInsetsDirectional.only(start: 8),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
                color: scheme.primary, borderRadius: BorderRadius.circular(12)),
            child: Text(chat.unread > 99 ? '99+' : '${chat.unread}',
                style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
      ]),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetAction(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Icon(icon, color: scheme.onPrimaryContainer),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }
}

/// Shown when notifications are turned off for the app on this phone.
class _NotificationsOffBanner extends StatelessWidget {
  final VoidCallback onFix;
  const _NotificationsOffBanner({required this.onFix});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          child: Row(children: [
            Icon(Icons.notifications_off_rounded,
                color: scheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text('الإشعارات متوقفة، لن تصلك الرسائل الجديدة',
                  style: TextStyle(color: scheme.onErrorContainer)),
            ),
            TextButton(onPressed: onFix, child: const Text('تفعيل')),
          ]),
        ),
      ),
    );
  }
}
