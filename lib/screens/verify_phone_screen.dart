import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/config.dart';
import '../data/repo.dart';
import '../widgets/common.dart';

/// Free phone verification: the user sends a code to our WhatsApp number,
/// the server confirms it and this screen notices.
class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  String? _phone;
  String? _code;
  bool _loading = true;
  bool _busy = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final phone = await Repo.i.myPhone();
      if (!mounted) return;
      final justVerified = _code != null && phone != null && phone != _phone;
      setState(() {
        _phone = phone;
        _loading = false;
        if (justVerified) _code = null;
      });
      if (justVerified) {
        _poll?.cancel();
        toast(context, 'تم تأكيد رقمك ✅');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        toast(context, errorText(e));
      }
    }
  }

  Future<void> _start() async {
    setState(() => _busy = true);
    try {
      final code = await Repo.i.newPhoneCode();
      if (!mounted) return;
      setState(() => _code = code);
      _poll?.cancel();
      var ticks = 0;
      _poll = Timer.periodic(const Duration(seconds: 3), (t) {
        if (++ticks > 200) t.cancel(); // codes expire after 10 minutes
        _refresh();
      });
      await _openWhatsApp();
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openWhatsApp() async {
    final text = Uri.encodeComponent('رمز التحقق $_code');
    final uri =
        Uri.parse('https://wa.me/${AppConfig.whatsappNumber}?text=$text');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) toast(context, 'تعذر فتح واتساب');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد رقم الهاتف')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Icon(
                    _phone != null
                        ? Icons.verified_rounded
                        : Icons.phonelink_lock_rounded,
                    size: 72,
                    color: scheme.primary),
                const SizedBox(height: 16),
                if (_phone != null) ...[
                  Text('رقمك المؤكد',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(_phone!,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 24),
                ],
                Text(
                  _phone == null
                      ? 'أكّد رقمك مجاناً عبر واتساب: سنفتح لك محادثة فيها رمز، فقط اضغط إرسال.'
                      : 'لتغيير الرقم، أرسل رمزاً جديداً من الرقم الجديد.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_code == null)
                  FilledButton.icon(
                    onPressed: _busy ? null : _start,
                    icon: const Icon(Icons.chat_rounded),
                    label: Text(_phone == null
                        ? 'تأكيد عبر واتساب'
                        : 'تغيير الرقم عبر واتساب'),
                  )
                else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        const Text('أرسل هذا الرمز في واتساب'),
                        const SizedBox(height: 8),
                        SelectableText(_code!,
                            style: const TextStyle(
                                fontSize: 32,
                                letterSpacing: 6,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                              SizedBox(width: 8),
                              Text('بانتظار التأكيد…'),
                            ]),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _openWhatsApp,
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('فتح واتساب مرة أخرى'),
                  ),
                ],
              ],
            ),
    );
  }
}
