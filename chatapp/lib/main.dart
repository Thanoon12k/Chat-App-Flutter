import 'package:chatapp/rooms.dart';
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
      home: Home(),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showDialogAfter5Seconds(context);
    // _open_roomsafter5seconds(context);
  }

  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: AssetImage('assets/sky2.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

Future<void> _open_roomsafter5seconds(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Rooms()),
  );
}

Future<void> _showDialogAfter5Seconds(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  MyPrivacyDialog(context);
}
