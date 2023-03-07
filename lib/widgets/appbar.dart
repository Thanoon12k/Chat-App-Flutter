import 'package:chatapp/screens/friends_requests.dart';
import 'package:chatapp/screens/user_setting.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:chatapp/widgets/dialogs.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/friends_list.dart';
import '../screens/notification.dart';

class myappbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        leading: Container(
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
          GestureDetector(
            onTap: () {
              Get.to(() => UserSetting());
            },
            child: FutureBuilder<String?>(
                future: retiriveString('imagelink'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                        backgroundImage: AssetImage('assets/wall.jpg'));
                  } else {
                    return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!));
                  }
                }),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Get.to(() => NotifyList());
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(Icons.notifications, color: Colors.white, size: 30),
            ),
          ),
          SizedBox(width: 3),
          GestureDetector(
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
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Text(
                  'تقييم الجات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color.fromARGB(255, 255, 255, 255),
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
