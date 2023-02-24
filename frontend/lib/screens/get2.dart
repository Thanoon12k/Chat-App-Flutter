import 'package:chatapp/screens/get1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/appbar.dart';

class GETX2 extends StatefulWidget {
  const GETX2({Key? key}) : super(key: key);

  @override
  State<GETX2> createState() => _GETX2State();
}

class _GETX2State extends State<GETX2> {
  var text = 'here i iam  ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Center(
        child: Column(
          children: [
            Text('page  2  '),
            Text(text),
            ElevatedButton(
              onPressed: () {
                // Get.back();
              },
              child: Text('go page 1'),
            ),
            TextField(
            ),
          ],
        ),
      ),
    );
  }
}
