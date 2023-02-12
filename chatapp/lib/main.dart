import 'package:chatapp/friends_list.dart';
import 'package:chatapp/friends_requests.dart';
import 'package:chatapp/messages.dart';
import 'package:chatapp/notification.dart';
import 'package:chatapp/private.dart';
import 'package:chatapp/profile_init.dart';
import 'package:chatapp/profile_setting.dart';
import 'package:chatapp/profile_view.dart';
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
       initialRoute: '/',  
      routes:  {
    '/profile_init': (context) => SplashScreen(),
    '/friends_requests': (context) => FriendsRequests(),
    '/friends_list': (context) => FriendsList(),
    '/messages': (context) => Messages(),
    '/rooms': (context) => Rooms(),
    '/notifications': (context) => MyNotification(),
    '/private': (context) => Private(),
    '/': (context) => Profile_Inite(),
    '/profile_setting': (context) => ProfileSettings(),
    '/profile_view': (context) => ProfileView(),
      },
      debugShowCheckedModeBanner: false,
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
