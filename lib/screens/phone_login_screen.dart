import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/repo.dart';
import '../widgets/common.dart';

/// "المتابعة عبر واتساب": type an Iraqi number, get a 6-digit code on
/// WhatsApp (or Telegram / SMS), type it, signed in.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  String? _sentTo; // +9647XXXXXXXXX once a code is on its way
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  /// 07701234567, 7701234567, 9647701234567, +964 770 123 4567 → +9647701234567
  String? _normalize(String input) {
    var d = input.replaceAll(RegExp(r'\D'), '');
    if (d.startsWith('00')) d = d.substring(2);
    if (d.startsWith('964')) d = d.substring(3);
    if (d.startsWith('0')) d = d.substring(1);
    return RegExp(r'^7\d{9}$').hasMatch(d) ? '+964$d' : null;
  }

  Future<void> _send() async {
    final phone = _normalize(_phone.text);
    if (phone == null) {
      toast(context, 'أدخل رقماً عراقياً صحيحاً مثل 07701234567');
      return;
    }
    setState(() => _busy = true);
    try {
      await Repo.i.sendPhoneCode(phone);
      if (mounted) setState(() => _sentTo = phone);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_code.text.trim().length < 6) return;
    setState(() => _busy = true);
    try {
      await Repo.i.verifyPhoneCode(_sentTo!, _code.text);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sent = _sentTo != null;
    return Scaffold(
      appBar: AppBar(title: const Text('المتابعة عبر واتساب')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.chat_rounded, size: 72, color: Color(0xFF25D366)),
          const SizedBox(height: 16),
          Text(
            sent
                ? 'أرسلنا رمزاً من 6 أرقام إلى واتساب الرقم'
                : 'أدخل رقم هاتفك وسنرسل لك رمز الدخول عبر واتساب',
            textAlign: TextAlign.center,
          ),
          if (sent) ...[
            const SizedBox(height: 4),
            Text(_sentTo!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('إن لم يصلك خلال دقيقة سيصلك عبر تيليجرام أو رسالة نصية',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
          const SizedBox(height: 24),
          if (!sent) ...[
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                hintText: '07701234567',
                prefixIcon: Icon(Icons.phone_iphone_rounded),
              ),
              onSubmitted: (_) => _send(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _send,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('إرسال الرمز'),
            ),
          ] else ...[
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              autofocus: true,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 28, letterSpacing: 8),
              decoration: const InputDecoration(counterText: ''),
              onChanged: (v) {
                if (v.length == 6) _verify();
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _verify,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('دخول'),
            ),
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                        _sentTo = null;
                        _code.clear();
                      }),
              child: const Text('تغيير الرقم أو إعادة الإرسال'),
            ),
          ],
        ],
      ),
    );
  }
}
