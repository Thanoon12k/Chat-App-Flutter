import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config.dart';
import 'core/theme.dart';
import 'data/repo.dart';
import 'screens/auth_screen.dart';
import 'screens/phone_gate.dart';
import 'services/push_service.dart';
import 'screens/home_screen.dart';
import 'screens/profile_setup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseKey,
  );
  await PushService.i.initialize();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const AuthGate(),
    );
  }
}

/// Signed out → login. Signed in without profile → setup. Otherwise → chats.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, _) {
        final user = auth.currentUser;
        if (user == null) return const AuthScreen();
        return PhoneGate(key: ValueKey(user.id), child: const _ProfileGate());
      },
    );
  }
}

class _ProfileGate extends StatefulWidget {
  const _ProfileGate({super.key});

  @override
  State<_ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<_ProfileGate> {
  late Future<bool> _hasProfile = _check();

  Future<bool> _check() async => (await Repo.i.myProfile()) != null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasProfile,
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: FilledButton.tonal(
                onPressed: () => setState(() => _hasProfile = _check()),
                child: const Text('تعذر الاتصال — إعادة المحاولة'),
              ),
            ),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data!) return const HomeScreen();
        return ProfileSetupScreen(
          onDone: () => setState(() => _hasProfile = Future.value(true)),
        );
      },
    );
  }
}
