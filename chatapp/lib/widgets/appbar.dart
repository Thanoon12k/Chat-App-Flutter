import 'package:chatapp/screens/notification.dart';
import 'package:chatapp/screens/profile_setting.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/widgets/utils.dart';
import 'package:flutter/material.dart';

class myappbar extends StatelessWidget implements PreferredSizeWidget {
  const myappbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        leading: Padding(
          padding: EdgeInsets.all(0),
          child: Image(
            image: AssetImage('assets/icons/girl.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileSettings()),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/icons/girl.jpg'),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()),
                  );
                },
                child: Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class mydrawer extends StatelessWidget {
  const mydrawer({Key? key}) : super(key: key);

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
                  image: AssetImage('assets/icons/girl.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: const Text('❤ الدردشات ❤'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Rooms()),
                );
              },
            ),
            ListTile(
              title: const Text('سياسة الخصوصية'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => privacypolicydialog()),
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