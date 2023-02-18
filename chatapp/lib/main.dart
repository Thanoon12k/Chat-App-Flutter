import 'package:chatapp/screens/friends_list.dart';
import 'package:chatapp/screens/friends_requests.dart';
import 'package:chatapp/screens/get1.dart';
import 'package:chatapp/screens/get2.dart';
import 'package:chatapp/screens/messages.dart';
import 'package:chatapp/screens/notification.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/screens/user_register.dart';
import 'package:chatapp/screens/user_setting.dart';
import 'package:chatapp/screens/user_view.dart';
import 'package:chatapp/widgets/utils.dart';

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
        initialRoute: '/',
        getPages: [
          GetPage(name: '/userinit', page: () => UserRegister()),
          GetPage(name: '/splash', page: () => SplashScreen()),
          GetPage(name: '/usersetting', page: () => UserSetting()),
          GetPage(name: '/userview', page: () => UserView()),
          GetPage(name: '/rooms', page: () => RoomsList()),
          GetPage(name: '/notification', page: () => NotifyList()),
          GetPage(name: '/frindlist', page: () => FriendsList()),
          GetPage(name: '/friendrequests', page: () => FriendsRequests()),
          GetPage(name: '/', page: () => UserRegister()),
          GetPage(name: '/get1', page: () => GETX1()),
          GetPage(name: '/get2', page: () => GETX2()),
        ]);
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
