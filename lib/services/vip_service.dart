import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VipService {
  static bool _configured = false;
  static String? _user;
  static const termsUrl = String.fromEnvironment('TERMS_URL');
  static const privacyUrl = String.fromEnvironment('PRIVACY_URL');
  static bool get enabled =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS
          ? const bool.fromEnvironment('IOS_PURCHASES_ENABLED')
          : defaultTargetPlatform == TargetPlatform.android &&
                const bool.fromEnvironment('ANDROID_PURCHASES_ENABLED')) &&
      key.isNotEmpty &&
      termsUrl.startsWith('https://') &&
      privacyUrl.startsWith('https://');
  static String get key => defaultTargetPlatform == TargetPlatform.iOS
      ? const String.fromEnvironment('REVENUECAT_APPLE_KEY')
      : const String.fromEnvironment('REVENUECAT_GOOGLE_KEY');
  static Future<void> prepare() async {
    if (!enabled) throw StateError('Purchases unavailable');
    final uid = Supabase.instance.client.auth.currentUser!.id;
    if (!_configured) {
      await Purchases.configure(PurchasesConfiguration(key)..appUserID = uid);
      _configured = true;
    } else if (_user != uid) {
      await Purchases.logIn(uid);
    }
    _user = uid;
  }

  static Future<List<Package>> packages() async {
    await prepare();
    return (await Purchases.getOfferings()).current?.availablePackages ?? [];
  }

  static Future<void> sync() async {
    final response = await Supabase.instance.client.functions.invoke(
      'chat-vip-sync',
    );
    if (response.status != 200) throw StateError('Subscription sync failed');
  }

  static Future<void> purchase(Package package) async {
    await prepare();
    await Purchases.purchase(PurchaseParams.package(package));
    await sync();
  }

  static Future<void> restore() async {
    await prepare();
    await Purchases.restorePurchases();
    await sync();
  }
}
