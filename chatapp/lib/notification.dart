import 'package:flutter/material.dart';

import 'appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              title: Text('الاشعار $index'),
              subtitle: Text('تم قبول طلب الصداقة'),
            );
          },
        ),
      ),
    );
  }
}
