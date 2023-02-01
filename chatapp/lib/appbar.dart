import 'package:flutter/material.dart';

class myappbar extends StatelessWidget implements PreferredSizeWidget {
  const myappbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        leadingWidth: 200,
        leading: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    'تقييم الجات',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 66, 66),
                    ),
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
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/app_images/appbaricon.jpg'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Image(
              image: AssetImage('assets/app_images/appbaricon.jpg'),
              fit: BoxFit.cover,
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

class mydrawer extends StatelessWidget {
  const mydrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                image: AssetImage('assets/app_images/appbaricon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: const Text('❤ الدردشات ❤'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('سياسة الخصوصية'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
