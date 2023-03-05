import 'dart:io';

import 'package:chatapp/screens/friends_requests.dart';

import 'package:chatapp/screens/user_setting.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:chatapp/widgets/dialogs.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/friends_list.dart';

class myappbar extends StatelessWidget implements PreferredSizeWidget {
  myappbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        leading: Padding(
          padding: EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => RoomsList());
            },
            child: Image(
              image: AssetImage('assets/girl.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => UserSetting());
              },
              child: CircleAvatar(
                backgroundImage: FileImage(File(
                    '/data/user/0/com.example.chatapp/app_flutter/user_image.png')),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              width: 40,
              height: 40,
              child: Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return MyRatingDialog(context);
                    });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                  child: Text(
                    'تقييم الجات',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 66, 66),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBar_init extends StatelessWidget implements PreferredSizeWidget {
  const AppBar_init({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => RoomsList());
              },
              child: Image(
                image: AssetImage('assets/girl.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class mydrawer extends StatefulWidget {
  const mydrawer({Key? key}) : super(key: key);

  @override
  State<mydrawer> createState() => _mydrawerState();
}

class _mydrawerState extends State<mydrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ClipRect(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Image(
                  image: AssetImage('assets/girl.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: const Text('❤ الدردشات ❤'),
              onTap: () {
                Get.to(() => FriendsList());
              },
            ),
            ListTile(
              title: const Text(' 😍 طلبات الصداقة  😍'),
              onTap: () {
                Get.to(() => FriendsRequests());
              },
            ),
            ListTile(
              title: const Text('سياسة الخصوصية'),
              onTap: () {
                Dialog(
                  child: MyPrivacyDialog(context),
                );
              },
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
