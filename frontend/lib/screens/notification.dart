import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

class NotifyList extends StatelessWidget {
  const NotifyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: 15,
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
