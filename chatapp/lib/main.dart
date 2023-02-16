import 'package:chatapp/screens/friends_list.dart';
import 'package:chatapp/screens/friends_requests.dart';
import 'package:chatapp/screens/get1.dart';
import 'package:chatapp/screens/get2.dart';
import 'package:chatapp/screens/messages.dart';
import 'package:chatapp/screens/notification.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/screens/user_init.dart';
import 'package:chatapp/screens/user_setting.dart';
import 'package:chatapp/screens/user_view.dart';
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
      initialRoute: '/',
      routes: {
        '/userinit': (context) => UserInit(),
        '/splash': (context) => SplashScreen(),
        '/usersetting': (context) => UserSetting(),
        '/userview': (context) => UserView(),
        '/rooms': (context) => RoomsList(),
        // '/messages': (context) => MessagesList(roomid: 1,),
        '/notification': (context) => NotifyList(),
        '/': (context) => GETX1(),
        '/frindlist': (context) => FriendsList(),
        '/friendrequests': (context) => FriendsRequests(),
        '/get1': (context) => GETX1(),
        '/get2': (context) => GETX2(),
      },
    );
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
