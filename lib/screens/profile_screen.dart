import 'package:flutter/material.dart';

import '../core/config.dart';
import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';
import 'chat_screen.dart';
import 'profile_setup_screen.dart';
import 'verify_phone_screen.dart';

/// Anyone's profile: photo, bio, stars and comments.
/// On my own profile the actions become "edit" and "sign out".
class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _p;
  bool _starred = false;
  bool _starBusy = false;
  List<ProfileComment>? _comments;
  final _comment = TextEditingController();
  bool _posting = false;

  bool get _isMe => widget.userId == Repo.i.myId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        Repo.i.profile(widget.userId, fresh: true),
        Repo.i.comments(widget.userId),
        if (!_isMe) Repo.i.didStar(widget.userId),
      ]);
      if (!mounted) return;
      setState(() {
        _p = results[0] as Profile?;
        _comments = results[1] as List<ProfileComment>;
        if (!_isMe) _starred = results[2] as bool;
      });
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  Future<void> _toggleStar() async {
    if (_isMe || _starBusy || _p == null) return;
    final on = !_starred;
    setState(() {
      _starBusy = true;
      _starred = on;
      _p = Profile(
          id: _p!.id,
          name: _p!.name,
          bio: _p!.bio,
          avatarUrl: _p!.avatarUrl,
          stars: _p!.stars + (on ? 1 : -1));
    });
    try {
      await Repo.i.setStar(widget.userId, on);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
      await _load();
    } finally {
      if (mounted) setState(() => _starBusy = false);
    }
  }

  Future<void> _postComment() async {
    final text = _comment.text.trim();
    if (text.isEmpty) return;
    setState(() => _posting = true);
    try {
      await Repo.i.addComment(widget.userId, text);
      _comment.clear();
      if (mounted) FocusScope.of(context).unfocus();
      final c = await Repo.i.comments(widget.userId);
      if (mounted) setState(() => _comments = c);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _deleteComment(ProfileComment c) async {
    try {
      await Repo.i.deleteComment(c.id);
      setState(() => _comments!.removeWhere((x) => x.id == c.id));
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  Future<void> _message() async {
    try {
      final id = await Repo.i.startDirect(widget.userId);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chat: ChatSummary(
              id: id,
              isRoom: false,
              title: _p!.name,
              imageUrl: _p!.avatarUrl,
              otherUserId: _p!.id,
              lastMessageAt: DateTime.now(),
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProfileSetupScreen(existing: _p)),
    );
    if (saved == true) _load();
  }

  Future<void> _signOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('تسجيل الخروج؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(d, true),
              child: const Text('خروج')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
    await Repo.i.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = _p;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_isMe)
            PopupMenuButton<int>(
              onSelected: (v) => v == 0
                  ? _edit()
                  : v == 2
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VerifyPhoneScreen()))
                      : _signOut(),
              itemBuilder: (_) => [
                if (AppConfig.whatsappNumber.isNotEmpty)
                  const PopupMenuItem(
                      value: 2,
                      child: ListTile(
                          leading: Icon(Icons.verified_user_outlined),
                          title: Text('تأكيد رقم الهاتف'))),
                const PopupMenuItem(
                    value: 0,
                    child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('تعديل'))),
                const PopupMenuItem(
                    value: 1,
                    child: ListTile(
                        leading: Icon(Icons.logout_rounded),
                        title: Text('تسجيل الخروج'))),
              ],
            ),
        ],
      ),
      body: p == null
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      Center(
                          child: Avatar(
                              name: p.name, url: p.avatarUrl, size: 112)),
                      const SizedBox(height: 14),
                      Text(p.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      if (p.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 4, 32, 0),
                          child: Text(p.bio,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.onSurfaceVariant)),
                        ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(children: [
                          Expanded(
                            child: _StarButton(
                              count: p.stars,
                              active: _starred,
                              enabled: !_isMe,
                              onTap: _toggleStar,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _isMe
                                ? FilledButton.tonalIcon(
                                    onPressed: _edit,
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('تعديل'))
                                : FilledButton.icon(
                                    onPressed: _message,
                                    icon: const Icon(Icons.chat_rounded),
                                    label: const Text('مراسلة')),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                        child: Text('التعليقات',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurfaceVariant)),
                      ),
                      if (_comments == null)
                        const Center(child: CircularProgressIndicator())
                      else if (_comments!.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                              _isMe
                                  ? 'لم يعلّق أحد على ملفك بعد'
                                  : 'كن أول من يترك تعليقاً لطيفاً',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.onSurfaceVariant)),
                        )
                      else
                        for (final c in _comments!)
                          ListTile(
                            leading: Avatar(
                                name: c.author.name,
                                url: c.author.avatarUrl,
                                size: 40),
                            title: Row(children: [
                              Expanded(
                                child: Text(c.author.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                              Text(shortTime(c.createdAt),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.onSurfaceVariant)),
                            ]),
                            subtitle: Text(c.body),
                            onLongPress: (_isMe || c.author.id == Repo.i.myId)
                                ? () => _deleteComment(c)
                                : null,
                          ),
                    ],
                  ),
                ),
              ),
              if (!_isMe)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _comment,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: 'اكتب تعليقاً…',
                            counterText: '',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none),
                          ),
                          onSubmitted: (_) => _postComment(),
                        ),
                      ),
                      IconButton(
                        onPressed: _posting ? null : _postComment,
                        icon: const Icon(Icons.send_rounded,
                            textDirection: TextDirection.rtl),
                      ),
                    ]),
                  ),
                ),
            ]),
    );
  }
}

class _StarButton extends StatelessWidget {
  final int count;
  final bool active;
  final bool enabled;
  final VoidCallback onTap;

  const _StarButton(
      {required this.count,
      required this.active,
      required this.enabled,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFF59E0B);
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: active ? gold : scheme.outlineVariant),
        foregroundColor: active ? gold : scheme.onSurface,
        disabledForegroundColor: scheme.onSurface,
      ),
      icon: Icon(active ? Icons.star_rounded : Icons.star_outline_rounded,
          color: gold),
      label: Text('$count',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}
