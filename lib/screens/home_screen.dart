import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';
import 'chat_screen.dart';
import 'people_screen.dart';
import 'profile_screen.dart';
import 'rooms_screen.dart';
import 'vip_screen.dart';
import '../services/push_service.dart';

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
  RealtimeChannel? _channel;
  Timer? _debounce;
  StreamSubscription<String>? _pushOpen;
  StreamSubscription? _pushForeground;
  bool _openingPush = false;
  Future<void> _activatePush() async {
    try {
      await PushService.i.activate();
    } catch (_) {
      /* Retry on resume. */
    }
  }

  Future<void> _openPush(String id) async {
    if (_openingPush || !mounted) return;
    _openingPush = true;
    try {
      final chats = await Repo.i.myChats();
      final matches = chats.where((c) => c.id == id);
      if (!mounted || matches.isEmpty) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      await _open(matches.first);
    } catch (_) {
      if (mounted) toast(context, 'تعذر فتح المحادثة');
    } finally {
      _openingPush = false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _pushOpen = PushService.i.opened.stream.listen(_openPush);
    _pushForeground = PushService.i.foreground.stream.listen((message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('رسالة جديدة في إحدى محادثاتك'),
          action: SnackBarAction(
            label: 'فتح',
            onPressed: () =>
                _openPush(message.data['conversation_id'] as String),
          ),
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      PushService.i.consumePending();
      _activatePush();
    });
    Repo.i.myProfile().then((p) => mounted ? setState(() => _me = p) : null);
    _channel = Repo.i.onAnyMessage(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), _load);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _pushOpen?.cancel();
    _pushForeground?.cancel();
    if (_channel != null) Repo.i.unsubscribe(_channel!);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
      _activatePush();
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(userId: _me!.id)),
    );
    final p = await Repo.i.myProfile();
    if (mounted) setState(() => _me = p);
  }

  Future<void> _newChat() async {
    final choice = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;

    ChatSummary? opened;
    if (choice == 0) {
      opened = await Navigator.push<ChatSummary>(
        context,
        MaterialPageRoute(builder: (_) => const PeopleScreen()),
      );
    } else if (choice == 1) {
      opened = await Navigator.push<ChatSummary>(
        context,
        MaterialPageRoute(builder: (_) => const RoomsScreen()),
      );
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
            backgroundImage: AssetImage('assets/images/girl.jpg'),
          ),
        ),
        leadingWidth: 60,
        title: const Text('المحادثات'),
        actions: [
          IconButton(
            tooltip: 'اشتراك VIP',
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VipScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _openMe,
              child: Avatar(
                name: _me?.name ?? '',
                url: _me?.avatarUrl,
                size: 38,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'محادثة جديدة',
        onPressed: _newChat,
        child: const Icon(Icons.add_comment_rounded),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_chats == null) {
      return _failed
          ? EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'لا يوجد اتصال',
              action: FilledButton.tonal(
                onPressed: _load,
                child: const Text('إعادة المحاولة'),
              ),
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
        icon: chat.isRoom && chat.imageUrl == null
            ? Icons.groups_rounded
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            shortTime(chat.lastMessageAt),
            style: TextStyle(
              fontSize: 12,
              color: unread ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage ?? (chat.isRoom ? 'غرفة جديدة' : 'قل مرحباً 👋'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unread ? scheme.onSurface : scheme.onSurfaceVariant,
                fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (unread)
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chat.unread > 99 ? '99+' : '${chat.unread}',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

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
