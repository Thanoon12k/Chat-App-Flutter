import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme.dart';
import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';
import 'profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatSummary chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _text = TextEditingController();
  late final Stream<List<Message>> _stream = Repo.i.messages(widget.chat.id);
  Map<String, Profile> _people = {};
  bool _sending = false;
  int _lastSeenId = 0;

  String get _me => Repo.i.myId;

  @override
  void initState() {
    super.initState();
    Repo.i.markRead(widget.chat.id);
    Repo.i.memberIds(widget.chat.id).then(_loadPeople);
  }

  Future<void> _loadPeople(Iterable<String> ids) async {
    final found = await Repo.i.profiles(ids);
    if (mounted) setState(() => _people = {..._people, ...found});
  }

  void _onMessages(List<Message> msgs) {
    if (msgs.isEmpty || msgs.first.id == _lastSeenId) return;
    _lastSeenId = msgs.first.id;
    Repo.i.markRead(widget.chat.id);
    final unknown =
        msgs.map((m) => m.senderId).where((id) => !_people.containsKey(id));
    if (unknown.isNotEmpty) _loadPeople(unknown.toSet());
  }

  Future<void> _send({XFile? image}) async {
    final text = _text.text;
    if (text.trim().isEmpty && image == null) return;
    setState(() => _sending = true);
    _text.clear();
    try {
      await Repo.i.send(widget.chat.id, text: text, image: image);
    } catch (e) {
      if (image == null) _text.text = text;
      if (mounted) toast(context, 'لم يتم الإرسال، حاول مجدداً');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendImage() async {
    final img = await pickImage(context);
    if (img != null) _send(image: img);
  }

  void _openProfile(String id) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: id)));

  Future<void> _messageMenu(Message m) async {
    if (m.senderId != _me) return;
    final del = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: ListTile(
          leading: Icon(Icons.delete_outline_rounded,
              color: Theme.of(c).colorScheme.error),
          title: const Text('حذف الرسالة'),
          onTap: () => Navigator.pop(c, true),
        ),
      ),
    );
    if (del == true) {
      try {
        await Repo.i.deleteMessage(m.id);
      } catch (e) {
        if (mounted) toast(context, errorText(e));
      }
    }
  }

  Future<void> _info() async {
    if (!widget.chat.isRoom) {
      if (widget.chat.otherUserId != null) {
        _openProfile(widget.chat.otherUserId!);
      }
      return;
    }
    final leave = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (c) => _RoomInfoSheet(
        chat: widget.chat,
        members: _people.values.toList(),
        onOpenProfile: (id) {
          Navigator.pop(c);
          _openProfile(id);
        },
      ),
    );
    if (leave == true) {
      await Repo.i.leave(widget.chat.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: _info,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(children: [
              Avatar(
                name: chat.title,
                url: chat.imageUrl,
                size: 38,
                icon: chat.isRoom && chat.imageUrl == null
                    ? Icons.groups_rounded
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                    Text(
                      chat.isRoom
                          ? '${_people.length} أعضاء'
                          : 'اضغط لعرض الملف الشخصي',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: _stream,
            builder: (context, snap) {
              if (snap.hasError) {
                return const EmptyState(
                    icon: Icons.wifi_off_rounded, title: 'تعذر تحميل الرسائل');
              }
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final msgs = snap.data!;
              _onMessages(msgs);
              if (msgs.isEmpty) {
                return const EmptyState(
                  icon: Icons.waving_hand_rounded,
                  title: 'لا توجد رسائل',
                  subtitle: 'ابدأ المحادثة بكلمة لطيفة',
                );
              }
              return ListView.builder(
                reverse: true, // newest at the bottom, no manual scrolling
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final m = msgs[i];
                  final older = i + 1 < msgs.length ? msgs[i + 1] : null;
                  final firstOfGroup = older == null ||
                      older.senderId != m.senderId ||
                      m.createdAt.difference(older.createdAt).inMinutes > 5;
                  return _Bubble(
                    message: m,
                    mine: m.senderId == _me,
                    sender: _people[m.senderId],
                    showSender: chat.isRoom && firstOfGroup,
                    isRoom: chat.isRoom,
                    onAvatarTap: () => _openProfile(m.senderId),
                    onLongPress: () => _messageMenu(m),
                  );
                },
              );
            },
          ),
        ),
        _Composer(
          controller: _text,
          sending: _sending,
          onSend: () => _send(),
          onImage: _sendImage,
        ),
      ]),
    );
  }
}

class _Bubble extends StatelessWidget {
  final Message message;
  final bool mine;
  final Profile? sender;
  final bool showSender;
  final bool isRoom;
  final VoidCallback onAvatarTap;
  final VoidCallback onLongPress;

  const _Bubble({
    required this.message,
    required this.mine,
    required this.sender,
    required this.showSender,
    required this.isRoom,
    required this.onAvatarTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = mine
        ? myBubbleColor
        : bubbleColors[message.senderId.hashCode.abs() % bubbleColors.length];
    const fg = Colors.black87;
    final maxW = MediaQuery.sizeOf(context).width * 0.75;

    final bubble = GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxW),
        padding: message.imageUrl != null
            ? const EdgeInsets.all(4)
            : const EdgeInsets.fromLTRB(14, 8, 14, 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(20),
            topEnd: const Radius.circular(20),
            bottomStart: Radius.circular(mine ? 20 : 6),
            bottomEnd: Radius.circular(mine ? 6 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSender && !mine && sender != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                    message.imageUrl != null ? 10 : 0, 2, 0, 2),
                child: Text(sender!.name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary)),
              ),
            if (message.imageUrl != null)
              GestureDetector(
                onTap: () => _viewImage(context, message.imageUrl!),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    message.imageUrl!,
                    width: maxW,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) => p == null
                        ? child
                        : SizedBox(
                            height: 200,
                            width: maxW,
                            child: const Center(
                                child: CircularProgressIndicator())),
                    errorBuilder: (_, __, ___) => const SizedBox(
                        height: 120,
                        child:
                            Center(child: Icon(Icons.broken_image_outlined))),
                  ),
                ),
              ),
            if (message.body != null)
              Padding(
                padding: message.imageUrl != null
                    ? const EdgeInsets.fromLTRB(10, 6, 10, 0)
                    : EdgeInsets.zero,
                child: Text(message.body!,
                    style: TextStyle(color: fg, fontSize: 15, height: 1.4)),
              ),
            Padding(
              padding: message.imageUrl != null
                  ? const EdgeInsets.fromLTRB(10, 2, 10, 4)
                  : EdgeInsets.zero,
              child: Text(clockTime(message.createdAt),
                  style: TextStyle(
                      color: fg.withValues(alpha: 0.65), fontSize: 11)),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(top: showSender ? 10 : 3),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine && isRoom) ...[
            bubble,
            const SizedBox(width: 6),
            SizedBox(
              width: 32,
              child: showSender
                  ? GestureDetector(
                      onTap: onAvatarTap,
                      child: Avatar(
                          name: sender?.name ?? '',
                          url: sender?.avatarUrl,
                          size: 32),
                    )
                  : null,
            ),
          ] else
            bubble,
        ],
      ),
    );
  }

  void _viewImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(child: InteractiveViewer(child: Image.network(url))),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;
  final VoidCallback onImage;

  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
    required this.onImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton.filled(
            tooltip: 'إرسال صورة',
            onPressed: sending ? null : onImage,
            style: IconButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
            icon: const Icon(Icons.image_rounded),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة…',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 6),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, __) {
              final can = value.text.trim().isNotEmpty && !sending;
              return IconButton.filled(
                tooltip: 'إرسال',
                onPressed: can ? onSend : null,
                style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.black38,
                    disabledForegroundColor: Colors.white70),
                icon: sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    // Arrow points "forward" in RTL
                    : const Icon(Icons.send_rounded,
                        textDirection: TextDirection.rtl),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class _RoomInfoSheet extends StatelessWidget {
  final ChatSummary chat;
  final List<Profile> members;
  final void Function(String id) onOpenProfile;

  const _RoomInfoSheet(
      {required this.chat, required this.members, required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scroll) => ListView(
        controller: scroll,
        children: [
          Center(
              child: Avatar(
                  name: chat.title,
                  url: chat.imageUrl,
                  size: 72,
                  icon: Icons.groups_rounded)),
          const SizedBox(height: 12),
          Text(chat.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text('الأعضاء (${members.length})',
                style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600)),
          ),
          for (final p in members)
            ListTile(
              leading: Avatar(name: p.name, url: p.avatarUrl, size: 40),
              title: Text(p.name),
              subtitle: p.bio.isEmpty ? null : Text(p.bio, maxLines: 1),
              onTap: () => onOpenProfile(p.id),
            ),
          const Divider(height: 24),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: scheme.error),
            title: Text('مغادرة الغرفة', style: TextStyle(color: scheme.error)),
            onTap: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
