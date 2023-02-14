import 'package:chatapp/screens/profile_init.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/widgets/utils.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Profile_Inite(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
