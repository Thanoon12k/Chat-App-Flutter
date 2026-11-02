import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Round avatar with a colored initial when there is no photo.
class Avatar extends StatelessWidget {
  final String name;
  final String? url;
  final double size;
  final IconData? icon;

  const Avatar(
      {super.key, required this.name, this.url, this.size = 48, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = [
      scheme.primaryContainer,
      scheme.tertiaryContainer,
      scheme.secondaryContainer,
    ];
    final bg = palette[name.hashCode.abs() % palette.length];
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first;
    // People without a photo get the original app's default avatar picture.
    if (url == null && icon == null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: const Color(0xFF9DBFE0),
        backgroundImage: const AssetImage('assets/images/avatar.png'),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      foregroundImage: url != null ? NetworkImage(url!) : null,
      child: icon != null
          ? Icon(icon, size: size * 0.5, color: scheme.onPrimaryContainer)
          : Text(initial,
              style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimaryContainer)),
    );
  }
}

/// Friendly placeholder for empty lists.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      this.subtitle,
      this.action});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: scheme.primary),
            ),
            const SizedBox(height: 20),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

String shortTime(DateTime t) {
  final now = DateTime.now();
  if (t.year == now.year && t.month == now.month && t.day == now.day) {
    return DateFormat('h:mm a', 'ar').format(t);
  }
  if (now.difference(t).inDays < 7) return DateFormat('EEEE', 'ar').format(t);
  return DateFormat('d/M/yyyy').format(t);
}

String clockTime(DateTime t) => DateFormat('h:mm a', 'ar').format(t);

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

/// Human message for any error thrown by Supabase or the network.
String errorText(Object e) {
  if (e is AuthException) {
    final m = e.message.toLowerCase();
    if (m.contains('iraqi mobile')) return 'يُقبل رقم عراقي فقط (07…)';
    if (m.contains('too many codes') || m.contains('rate limit') ||
        m.contains('for security purposes')) {
      return 'طلبت رموزاً كثيرة، انتظر قليلاً ثم حاول';
    }
    if (m.contains('daily limit')) return 'تم بلوغ الحد اليومي، حاول غداً';
    if (m.contains('could not send') || m.contains('not configured')) {
      return 'تعذر إرسال الرمز الآن، حاول لاحقاً';
    }
    if (m.contains('expired') || (m.contains('invalid') && m.contains('token'))) {
      return 'الرمز غير صحيح أو انتهت صلاحيته';
    }
    if (m.contains('invalid login')) return 'البريد أو كلمة المرور غير صحيحة';
    if (m.contains('already registered')) return 'هذا البريد مسجّل مسبقاً';
    if (m.contains('email not confirmed')) {
      return 'يرجى تأكيد بريدك الإلكتروني أولاً';
    }
    if (m.contains('password')) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return e.message;
  }
  return 'حدث خطأ، تحقق من الاتصال وحاول مجدداً';
}

final _picker = ImagePicker();

/// Bottom sheet: camera or gallery. Returns a compressed image or null.
Future<XFile?> pickImage(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (c) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: const Text('من المعرض'),
          onTap: () => Navigator.pop(c, ImageSource.gallery),
        ),
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: const Text('التقاط صورة'),
          onTap: () => Navigator.pop(c, ImageSource.camera),
        ),
        const SizedBox(height: 8),
      ]),
    ),
  );
  if (source == null) return null;
  return _picker.pickImage(source: source, maxWidth: 1280, imageQuality: 80);
}
