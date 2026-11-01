import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/phone.dart';
import '../data/repo.dart';
import '../services/phone_attributes.dart';

class PhoneScreen extends StatefulWidget {
  final bool linkExisting;
  final VoidCallback? onVerified;
  const PhoneScreen({super.key, this.linkExisting = false, this.onVerified});
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  String? _sentPhone;
  String? _error;
  bool _busy = false;
  bool _whatsapp = true;
  int _seconds = 0;
  Timer? _timer;

  Future<void> _send() async {
    final phone = iraqiPhone(_phone.text);
    if (phone == null) {
      setState(() => _error = 'أدخل رقم هاتف عراقي صحيح مثل 07xxxxxxxxx');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final channel = _whatsapp ? OtpChannel.whatsapp : OtpChannel.sms;
      if (widget.linkExisting) {
        await Supabase.instance.client.auth.updateUser(
          PhoneAttributes(phone: phone, channel: channel),
        );
      } else {
        await Supabase.instance.client.auth.signInWithOtp(
          phone: phone,
          channel: channel,
        );
      }
      if (!mounted) return;
      setState(() {
        _sentPhone = phone;
        _seconds = 60;
        _code.clear();
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() => _seconds--);
        if (_seconds <= 0) t.cancel();
      });
    } on AuthException catch (_) {
      if (mounted)
        setState(
          () => _error = 'تعذر إرسال الرمز. تحقق من الرقم، أو جرّب القناة الأخرى بعد قليل.',
        );
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر الاتصال. حاول مجدداً.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_sentPhone == null) return;
    final code = normalizeDigits(_code.text.trim());
    if (!RegExp(r'^[0-9]{6}$').hasMatch(code)) {
      setState(() => _error = 'أدخل رمز التحقق المكوّن من 6 أرقام');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.verifyOTP(
        phone: _sentPhone!,
        token: code,
        type: widget.linkExisting ? OtpType.phoneChange : OtpType.sms,
      );
      if (!mounted) return;
      if (widget.linkExisting) {
        widget.onVerified?.call();
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (_) {
      if (mounted)
        setState(
          () => _error = 'الرمز غير صحيح أو انتهت صلاحيته. حاول مجدداً.',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.linkExisting ? 'تأكيد رقم هاتفك' : 'الدخول برقم الهاتف',
      ),
      actions: [
        if (widget.linkExisting)
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: _busy ? null : () => Repo.i.signOut(),
            icon: const Icon(Icons.logout),
          ),
      ],
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.phone_android, size: 64),
              const SizedBox(height: 16),
              const Text(
                'نحتاج تأكيد ملكيتك لرقم الهاتف العراقي. رقمك لا يظهر لأعضاء الغرف.',
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phone,
                enabled: !_busy && _sentPhone == null,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '07xxxxxxxxx',
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('واتساب')),
                  ButtonSegment(value: false, label: Text('SMS')),
                ],
                selected: {_whatsapp},
                onSelectionChanged: _busy
                    ? null
                    : (v) => setState(() => _whatsapp = v.first),
              ),
              if (_sentPhone != null) ...[
                const SizedBox(height: 16),
                Text(
                  'أرسلنا الرمز إلى $_sentPhone',
                  textDirection: TextDirection.ltr,
                ),
                TextField(
                  controller: _code,
                  enabled: !_busy,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  decoration: const InputDecoration(labelText: 'رمز التحقق'),
                  onSubmitted: (_) => _busy ? null : _verify(),
                ),
                FilledButton(
                  onPressed: _busy ? null : _verify,
                  child: const Text('تأكيد ومتابعة'),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _sentPhone = null),
                  child: const Text('تغيير الرقم'),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _busy || _seconds > 0 ? null : _send,
                child: Text(
                  _seconds > 0
                      ? 'إعادة الإرسال بعد $_seconds ثانية'
                      : _sentPhone == null
                      ? 'إرسال رمز التحقق'
                      : 'إعادة إرسال الرمز',
                ),
              ),
              if (_busy) const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
