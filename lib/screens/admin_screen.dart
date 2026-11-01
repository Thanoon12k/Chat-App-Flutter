import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminScreen extends StatefulWidget {
  final String? room;
  const AdminScreen({super.key, this.room});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String tab = 'rooms';
  final search = TextEditingController();
  int offset = 0;
  late Future<dynamic> page = load();
  String get section => widget.room == null ? tab : 'members';
  Future<dynamic> call(
    String action, {
    String? id,
    Map<String, dynamic> data = const {},
  }) => Supabase.instance.client.rpc(
    'chat_admin_action',
    params: {'p_action': action, 'p_target': id, 'p_data': data},
  );
  Future<dynamic> load() => call(
    section,
    id: widget.room,
    data: {'offset': offset, 'query': search.text.trim()},
  );
  void refresh() => setState(() => page = load());
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<bool> confirm(String label) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(label),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('رجوع'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> change(
    String action, {
    String? id,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      await call(action, id: id, data: data);
      if (mounted) refresh();
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر حفظ التغيير. تحقق من الصلاحية والقيم.'),
          ),
        );
    }
  }

  Future<String?> input(
    String label,
    String initial, {
    bool secret = false,
  }) async {
    var value = initial;
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(label),
        content: TextFormField(
          initialValue: initial,
          onChanged: (v) => value = v,
          obscureText: secret,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, value.trim()),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> roomAction(String action, Map room) async {
    final id = room['id'] as String;
    if (action == 'members') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AdminScreen(room: id)),
      );
      return;
    }
    if (action == 'password') {
      final value = await input(
        'كلمة مرور الغرفة (فارغة لإزالة القفل)',
        '',
        secret: true,
      );
      if (value != null)
        await change('room_password', id: id, data: {'password': value});
      return;
    }
    final data = <String, dynamic>{
      'name': room['name'],
      'description': room['description'],
      'closed': room['closed'],
    };
    if (action == 'closed') {
      if (!await confirm(
        room['closed'] ? 'فتح الغرفة؟' : 'إيقاف الانضمام والإرسال في الغرفة؟',
      ))
        return;
      data[action] = !room[action];
    } else {
      final value = await input(
        action == 'name' ? 'اسم الغرفة' : 'وصف الغرفة',
        room[action] ?? '',
      );
      if (value == null) return;
      data[action] = value;
    }
    await change('room_update', id: id, data: data);
  }

  Widget item(Map row) {
    if (section == 'rooms')
      return ListTile(
        title: Text(row['name']),
        subtitle: Text(
          '${row['members']} أعضاء • ${row['closed'] ? 'مغلقة' : 'مفتوحة'}',
        ),
        onTap: () => roomAction('members', row),
        trailing: PopupMenuButton<String>(
          onSelected: (v) => roomAction(v, row),
          itemBuilder: (_) => [
            for (final e in {
              'members': 'الأعضاء',
              'name': 'تعديل الاسم',
              'description': 'تعديل الوصف',
              'password': 'كلمة المرور',
              'closed': row['closed'] ? 'فتح الغرفة' : 'إغلاق الغرفة',
            }.entries)
              PopupMenuItem(value: e.key, child: Text(e.value)),
          ],
        ),
      );
    final banned = row['banned'] == true;
    final label = section == 'members'
        ? (banned ? 'السماح بالعودة' : 'إزالة ومنع العودة')
        : (banned ? 'رفع الحظر' : 'حظر');
    return ListTile(
      title: Text(row['name']),
      subtitle: Text(
        row['admin'] == true
            ? 'أدمن التطبيق'
            : banned
            ? 'محظور'
            : 'عضو',
      ),
      trailing: row['admin'] == true
          ? null
          : TextButton(
              child: Text(label),
              onPressed: () async {
                if (!await confirm('$label • ${row['name']}؟')) return;
                if (section == 'members') {
                  await change(
                    banned ? 'allow_member' : 'kick',
                    id: widget.room,
                    data: {'user_id': row['id']},
                  );
                } else {
                  await change(banned ? 'unban' : 'ban', id: row['id']);
                }
              },
            ),
    );
  }

  Widget settings(Map s) {
    Future<void> save(String key) async {
      final data = <String, dynamic>{
        'free_rooms': s['free_rooms'],
        'vip_rooms': s['vip_rooms'],
        'enabled': s['room_limits_enabled'],
      };
      if (key == 'enabled') {
        if (!await confirm('تغيير تطبيق حدود الغرف؟')) return;
        data[key] = !data[key];
      } else {
        final v = await input('عدد الغرف', data[key].toString());
        if (v == null) return;
        final n = int.tryParse(v);
        if (n == null) return;
        data[key] = n;
      }
      await change('set_limits', data: data);
    }

    return ListView(
      children: [
        ListTile(
          title: const Text('حد الغرف المجانية'),
          trailing: Text('${s['free_rooms']}'),
          onTap: () => save('free_rooms'),
        ),
        ListTile(
          title: const Text('حد غرف VIP'),
          trailing: Text('${s['vip_rooms']}'),
          onTap: () => save('vip_rooms'),
        ),
        SwitchListTile(
          title: const Text('تطبيق حدود إنشاء الغرف'),
          value: s['room_limits_enabled'] == true,
          onChanged: (_) => save('enabled'),
        ),
        ListTile(
          title: const Text('التحقق الإلزامي من الهاتف'),
          trailing: Text(s['require_phone'] ? 'مفعّل' : 'بانتظار التفعيل'),
        ),
        ListTile(
          title: const Text('إشعارات الهاتف'),
          trailing: Text(s['push_enabled'] ? 'مفعّلة' : 'بانتظار التفعيل'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.room == null ? 'إدارة التطبيق' : 'أعضاء الغرفة'),
    ),
    body: Column(
      children: [
        if (widget.room == null)
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'rooms', label: Text('الغرف')),
              ButtonSegment(value: 'users', label: Text('الأعضاء')),
              ButtonSegment(value: 'settings', label: Text('الإعدادات')),
            ],
            selected: {tab},
            onSelectionChanged: (s) {
              tab = s.first;
              offset = 0;
              search.clear();
              refresh();
            },
          ),
        if (widget.room == null && tab != 'settings')
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: search,
              onSubmitted: (_) {
                offset = 0;
                refresh();
              },
              decoration: InputDecoration(
                hintText: 'بحث بالاسم',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    offset = 0;
                    refresh();
                  },
                ),
              ),
            ),
          ),
        Expanded(
          child: FutureBuilder<dynamic>(
            future: page,
            builder: (c, s) {
              if (s.connectionState != ConnectionState.done)
                return const Center(child: CircularProgressIndicator());
              if (s.hasError)
                return Center(
                  child: TextButton(
                    onPressed: refresh,
                    child: const Text('تعذر عرض البيانات • إعادة المحاولة'),
                  ),
                );
              if (section == 'settings') return settings(s.data as Map);
              final rows = s.data as List;
              return Column(
                children: [
                  Expanded(
                    child: rows.isEmpty
                        ? const Center(child: Text('لا توجد نتائج'))
                        : ListView.builder(
                            itemCount: rows.length,
                            itemBuilder: (_, i) => item(rows[i] as Map),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: offset == 0
                            ? null
                            : () {
                                offset -= 30;
                                refresh();
                              },
                        child: const Text('السابق'),
                      ),
                      Text('${offset ~/ 30 + 1}'),
                      TextButton(
                        onPressed: rows.length < 30
                            ? null
                            : () {
                                offset += 30;
                                refresh();
                              },
                        child: const Text('التالي'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
