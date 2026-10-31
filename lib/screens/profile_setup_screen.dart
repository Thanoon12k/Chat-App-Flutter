import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models.dart';
import '../data/repo.dart';
import '../widgets/common.dart';

/// Used both for first-time setup and for editing my profile later.
class ProfileSetupScreen extends StatefulWidget {
  final Profile? existing;
  final VoidCallback? onDone;

  const ProfileSetupScreen({super.key, this.existing, this.onDone});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _form = GlobalKey<FormState>();
  late final _name =
      TextEditingController(text: widget.existing?.name ?? Repo.i.providerName);
  late final _bio = TextEditingController(text: widget.existing?.bio);
  XFile? _avatar;
  Uint8List? _avatarBytes;
  bool _busy = false;

  bool get _editing => widget.existing != null;

  Future<void> _pick() async {
    final f = await pickImage(context);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() {
      _avatar = f;
      _avatarBytes = bytes;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await Repo.i.saveProfile(
          name: _name.text,
          bio: _bio.text,
          avatar: _avatar,
          avatarUrl: widget.existing == null ? Repo.i.providerAvatar : null);
      if (!mounted) return;
      if (_editing) Navigator.pop(context, true);
      widget.onDone?.call();
    } on NameTakenException {
      if (mounted) toast(context, 'هذا الاسم مستخدم، اختر اسماً آخر');
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'تعديل الملف الشخصي' : 'ملفك الشخصي'),
        actions: [
          if (!_editing)
            IconButton(
              tooltip: 'تسجيل الخروج',
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => Repo.i.signOut(),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_editing) ...[
                      Text('كيف يراك الآخرون؟',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 24),
                    ],
                    Center(
                      child: GestureDetector(
                        onTap: _pick,
                        child: Stack(children: [
                          _avatarBytes != null
                              ? CircleAvatar(
                                  radius: 56,
                                  backgroundImage: MemoryImage(_avatarBytes!))
                              : Avatar(
                                  name: _name.text,
                                  url: widget.existing?.avatarUrl ??
                                      Repo.i.providerAvatar,
                                  size: 112,
                                  icon: widget.existing == null
                                      ? Icons.person_rounded
                                      : null),
                          PositionedDirectional(
                            bottom: 0,
                            end: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: scheme.primary,
                              child: Icon(Icons.camera_alt_rounded,
                                  size: 18, color: scheme.onPrimary),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _name,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        hintText: 'الاسم',
                        prefixIcon: Icon(Icons.badge_outlined),
                        counterText: '',
                      ),
                      validator: (v) => (v == null || v.trim().length < 2)
                          ? 'حرفان على الأقل'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bio,
                      maxLength: 140,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'نبذة قصيرة (اختياري)',
                        prefixIcon: Icon(Icons.short_text_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _busy ? null : _save,
                      child: _busy
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5))
                          : Text(_editing ? 'حفظ' : 'ابدأ'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
