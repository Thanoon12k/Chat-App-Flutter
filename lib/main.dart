import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config.dart';
import 'core/theme.dart';
import 'data/models.dart';
import 'data/repo.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseKey,
  );
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
        return _ProfileGate(key: ValueKey(user.id));
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
  late Future<Profile?> _profile = _check();

  Future<Profile?> _check() => Repo.i.myProfile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: _profile,
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: FilledButton.tonal(
                onPressed: () => setState(() => _profile = _check()),
                child: const Text('تعذر الاتصال — إعادة المحاولة'),
              ),
            ),
          );
        }
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final me = snap.data;
        if (me == null) {
          return ProfileSetupScreen(
            onDone: () => setState(() => _profile = _check()),
          );
        }
        if (me.banned) return const _BannedScreen();
        return const HomeScreen();
      },
    );
  }
}

class _BannedScreen extends StatelessWidget {
  const _BannedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyState(
        icon: Icons.block_rounded,
        title: 'تم إيقاف حسابك',
        subtitle: 'تواصل مع إدارة التطبيق لمزيد من المعلومات.',
        action: FilledButton.tonal(
            onPressed: Repo.i.signOut, child: const Text('تسجيل الخروج')),
      ),
    );
  }
}
