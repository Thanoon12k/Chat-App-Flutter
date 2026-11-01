import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';

/// Announcements from the app managers: to everyone, or to rooms I'm in.
class BroadcastsScreen extends StatefulWidget {
  const BroadcastsScreen({super.key});

  @override
  State<BroadcastsScreen> createState() => _BroadcastsScreenState();
}

class _BroadcastsScreenState extends State<BroadcastsScreen> {
  late Future<List<Broadcast>> _items = Repo.i.broadcasts();

  Future<void> _reload() async {
    final f = Repo.i.broadcasts();
    setState(() => _items = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('الإعلانات')),
      body: FutureBuilder<List<Broadcast>>(
        future: _items,
        builder: (context, snap) {
          if (snap.hasError) {
            return EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'لا يوجد اتصال',
              action: FilledButton.tonal(
                  onPressed: _reload, child: const Text('إعادة المحاولة')),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const EmptyState(
                icon: Icons.campaign_outlined, title: 'لا توجد إعلانات بعد');
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final b = items[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.campaign_rounded, color: scheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(b.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ),
                          Text(shortTime(b.createdAt),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant)),
                        ]),
                        const SizedBox(height: 8),
                        Text(b.body),
                        if (b.roomName != null) ...[
                          const SizedBox(height: 8),
                          Text('إلى أعضاء ${b.roomName}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
