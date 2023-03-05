import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/screens/user_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/preference.dart';
import '../widgets/dialogs.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    next_screen(context);

    return Container(
      child: Image(
        image: AssetImage('assets/sky2.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

Future next_screen(context) async {
  await Future.delayed(Duration(seconds: 1));
  // await remove_all_userdata();
  if (await retiriveBool('is_user_registered')) {
    Get.to(() => RoomsList());
  } else {
    Get.to(() => UserRegister());
  }
}
