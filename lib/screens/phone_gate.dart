import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'phone_screen.dart';

class PhoneGate extends StatefulWidget {
  final Widget child;
  const PhoneGate({super.key, required this.child});
  @override
  State<PhoneGate> createState() => _PhoneGateState();
}

class _PhoneGateState extends State<PhoneGate> {
  late Future<dynamic> _check = _load();
  Future<dynamic> _load() => Supabase.instance.client.rpc('chat_capabilities');
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _check,
    builder: (context, snapshot) {
      if (snapshot.hasError)
        return Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => setState(() => _check = _load()),
              child: const Text('تعذر الاتصال — إعادة المحاولة'),
            ),
          ),
        );
      if (!snapshot.hasData)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final status = snapshot.data as Map;
      if (status['require_phone'] == true && status['phone_verified'] != true) {
        return PhoneScreen(
          linkExisting: true,
          onVerified: () => setState(() => _check = _load()),
        );
      }
      return widget.child;
    },
  );
}
