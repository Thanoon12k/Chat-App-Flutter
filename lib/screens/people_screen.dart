import 'dart:async';

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';

/// Pick someone to message. Pops with the opened [ChatSummary].
class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<Profile>? _people;
  Timer? _debounce;
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String q) async {
    try {
      final r = await Repo.i.searchPeople(q);
      if (mounted) setState(() => _people = r);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    }
  }

  Future<void> _start(Profile p) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      final id = await Repo.i.startDirect(p.id);
      if (!mounted) return;
      Navigator.pop(
        context,
        ChatSummary(
          id: id,
          isRoom: false,
          title: p.name,
          imageUrl: p.avatarUrl,
          otherUserId: p.id,
          lastMessageAt: DateTime.now(),
        ),
      );
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محادثة خاصة')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'ابحث بالاسم',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (q) {
              _debounce?.cancel();
              _debounce =
                  Timer(const Duration(milliseconds: 300), () => _search(q));
            },
          ),
        ),
        if (_opening) const LinearProgressIndicator(),
        Expanded(
          child: _people == null
              ? const Center(child: CircularProgressIndicator())
              : _people!.isEmpty
                  ? const EmptyState(
                      icon: Icons.person_search_rounded,
                      title: 'لا يوجد أحد بهذا الاسم')
                  : ListView.builder(
                      itemCount: _people!.length,
                      itemBuilder: (_, i) {
                        final p = _people![i];
                        return ListTile(
                          leading: Avatar(name: p.name, url: p.avatarUrl),
                          title: Text(p.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: p.bio.isEmpty
                              ? null
                              : Text(p.bio,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing:
                              const Icon(Icons.chat_bubble_outline_rounded),
                          onTap: () => _start(p),
                        );
                      },
                    ),
        ),
      ]),
    );
  }
}
