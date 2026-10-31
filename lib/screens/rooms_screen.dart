import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';

/// Public room directory. Pops with the joined room as a [ChatSummary].
class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room>? _rooms;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await Repo.i.rooms();
      if (mounted) setState(() => _rooms = r);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  ChatSummary _summary(Room r) => ChatSummary(
      id: r.id, isRoom: true, title: r.name, lastMessageAt: DateTime.now());

  Future<void> _join(Room r) async {
    if (r.isMember) return Navigator.pop(context, _summary(r));
    String? password;
    if (r.hasPassword) {
      password = await _askPassword(r.name);
      if (password == null) return;
    }
    try {
      final ok = await Repo.i.joinRoom(r.id, password);
      if (!mounted) return;
      if (!ok) return toast(context, 'كلمة المرور غير صحيحة');
      Navigator.pop(context, _summary(r));
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  Future<String?> _askPassword(String room) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        icon: const Icon(Icons.lock_rounded),
        title: Text(room),
        content: TextField(
          controller: c,
          autofocus: true,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'كلمة مرور الغرفة'),
          onSubmitted: (v) => Navigator.pop(d, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(d), child: const Text('إلغاء')),
          FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
              onPressed: () => Navigator.pop(d, c.text),
              child: const Text('دخول')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rooms = _rooms
        ?.where((r) => r.name.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الغرف'),
        actions: [
          IconButton(
            tooltip: 'إنشاء غرفة',
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              final created = await showCreateRoom(context);
              if (created != null && context.mounted) {
                Navigator.pop(context, created);
              }
            },
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'ابحث عن غرفة',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (q) => setState(() => _filter = q.trim()),
          ),
        ),
        Expanded(
          child: rooms == null
              ? const Center(child: CircularProgressIndicator())
              : rooms.isEmpty
                  ? EmptyState(
                      icon: Icons.meeting_room_outlined,
                      title: 'لا توجد غرف',
                      subtitle: 'كن أول من ينشئ غرفة',
                      action: FilledButton.tonal(
                        onPressed: () async {
                          final created = await showCreateRoom(context);
                          if (created != null && context.mounted) {
                            Navigator.pop(context, created);
                          }
                        },
                        child: const Text('إنشاء غرفة'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (_, i) {
                          final r = rooms[i];
                          return ListTile(
                            onTap: () => _join(r),
                            leading: Avatar(
                                name: r.name, icon: Icons.groups_rounded),
                            title: Row(children: [
                              Flexible(
                                child: Text(r.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                              if (r.hasPassword) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.lock_rounded,
                                    size: 16, color: scheme.onSurfaceVariant),
                              ],
                            ]),
                            subtitle: Text(
                              [
                                '${r.members} عضو',
                                if (r.description.isNotEmpty) r.description,
                              ].join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: r.isMember
                                ? Icon(Icons.check_circle_rounded,
                                    color: scheme.primary)
                                : const Text('انضمام'),
                          );
                        },
                      ),
                    ),
        ),
      ]),
    );
  }
}

/// Bottom sheet to create a room. Returns the new room or null.
Future<ChatSummary?> showCreateRoom(BuildContext context) {
  return showModalBottomSheet<ChatSummary>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _CreateRoomSheet(),
  );
}

class _CreateRoomSheet extends StatefulWidget {
  const _CreateRoomSheet();

  @override
  State<_CreateRoomSheet> createState() => _CreateRoomSheetState();
}

class _CreateRoomSheetState extends State<_CreateRoomSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _password = TextEditingController();
  bool _locked = false;
  bool _busy = false;

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final id = await Repo.i.createRoom(
          _name.text, _desc.text, _locked ? _password.text : '');
      if (!mounted) return;
      Navigator.pop(
        context,
        ChatSummary(
            id: id,
            isRoom: true,
            title: _name.text.trim(),
            lastMessageAt: DateTime.now()),
      );
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('غرفة جديدة',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              autofocus: true,
              maxLength: 40,
              decoration: const InputDecoration(
                  hintText: 'اسم الغرفة',
                  prefixIcon: Icon(Icons.tag_rounded),
                  counterText: ''),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'حرفان على الأقل' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              maxLength: 120,
              decoration: const InputDecoration(
                  hintText: 'وصف (اختياري)',
                  prefixIcon: Icon(Icons.notes_rounded),
                  counterText: ''),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _locked,
              onChanged: (v) => setState(() => _locked = v),
              title: const Text('غرفة خاصة بكلمة مرور'),
              secondary: const Icon(Icons.lock_outline_rounded),
            ),
            if (_locked) ...[
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.key_rounded)),
                validator: (v) =>
                    (_locked && (v == null || v.length < 3)) ? '3 أحرف على الأقل' : null,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _busy ? null : _create,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }
}
