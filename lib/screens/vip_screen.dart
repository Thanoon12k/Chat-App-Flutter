import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/vip_service.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});
  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  Map<String, dynamic>? _status;
  List<Package> _packages = [];
  bool _busy = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final status = Map<String, dynamic>.from(
        await Supabase.instance.client.rpc('chat_capabilities'),
      );
      if (mounted) setState(() => _status = status);
      if (VipService.enabled) {
        final packages = await VipService.packages();
        if (mounted) setState(() => _packages = packages);
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر تحميل الاشتراك. حاول مجدداً.');
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      await _load();
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) !=
              PurchasesErrorCode.purchaseCancelledError &&
          mounted) {
        setState(
          () => _error =
              'لم تكتمل العملية. إذا تم الدفع، استخدم استعادة المشتريات.',
        );
      }
    } catch (_) {
      if (mounted)
        setState(
          () => _error =
              'تعذر تأكيد الاشتراك الآن. جرّب استعادة المشتريات لاحقاً.',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _link(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      ))
        throw StateError('Unavailable');
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر فتح الرابط');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('اشتراك VIP')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.workspace_premium, size: 72, color: Colors.amber),
        const SizedBox(height: 16),
        Text(
          _status?['vip'] == true ? 'أنت مشترك VIP' : 'غرف أكثر مع VIP',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (_status != null)
          Text(
            'الخطة المجانية: ${_status!['free_rooms']} غرفة • VIP: ${_status!['vip_rooms']} غرف\nغرفك الحالية: ${_status!['rooms_created']}',
          ),
        if (_status?['vip_expires_at'] != null)
          Text(
            'صالح حتى: ${_status!['vip_expires_at'].toString().split('T').first}',
          ),
        const SizedBox(height: 16),
        if (!VipService.enabled)
          const Text(
            'الاشتراكات ستكون متاحة قريباً. المحادثات الحالية مستمرة.',
          ),
        if (VipService.enabled) ...[
          const Text(
            'اشتراك يتجدد تلقائياً حسب فترة الخطة المعروضة. تتم إدارة التجديد والإلغاء من حساب المتجر. إلغاء التجديد لا يحذف غرفك الحالية.',
          ),
          for (final package in _packages)
            Card(
              child: ListTile(
                title: Text(package.storeProduct.title),
                subtitle: Text(package.storeProduct.description),
                trailing: FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() => VipService.purchase(package)),
                  child: Text(package.storeProduct.priceString),
                ),
              ),
            ),
          if (_packages.isEmpty) const Text('لا توجد خطط متاحة للشراء حالياً.'),
          TextButton(
            onPressed: _busy ? null : () => _run(VipService.restore),
            child: const Text('استعادة المشتريات'),
          ),
          TextButton(
            onPressed: _busy
                ? null
                : () async {
                    await _run(() async {
                      await VipService.prepare();
                      final info = await Purchases.getCustomerInfo();
                      if (info.managementURL != null)
                        await _link(info.managementURL!);
                    });
                  },
            child: const Text('إدارة الاشتراك'),
          ),
          TextButton(
            onPressed: () => _link(VipService.termsUrl),
            child: const Text('شروط الاستخدام'),
          ),
          TextButton(
            onPressed: () => _link(VipService.privacyUrl),
            child: const Text('سياسة الخصوصية'),
          ),
        ],
        if (_busy) const LinearProgressIndicator(),
        if (_error != null) ...[
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          TextButton(onPressed: _load, child: const Text('إعادة المحاولة')),
        ],
      ],
    ),
  );
}
