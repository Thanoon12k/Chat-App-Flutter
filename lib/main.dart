import 'package:chatapp/bindings/routes.dart';

import 'package:chatapp/widgets/dialogs.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:get_initial_route(),
        getPages: app_routes());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    _show_privacy_dialog_3s(context);

    return Container(
      child: Image(
        image: AssetImage('assets/sky2.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

Future<void> _show_privacy_dialog_3s(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  MyPrivacyDialog(context);
}
