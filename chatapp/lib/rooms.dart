import 'package:flutter/material.dart';

import 'appbar.dart';

class Rooms extends StatelessWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Column(
          children: [
            TextField(
                decoration: InputDecoration(
              labelText: "ROOM!", //babel text
              hintText: "اكتب اسمك هنا", //hint text
              prefixIcon: Icon(Icons.person), //prefix iocn

              hintStyle: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w100), //hint text style
              labelStyle: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
            )),
            TextField(
              decoration: InputDecoration(
                labelText: "ROOM2", //babel text
                hintText: "الوصف (اختياري )", //hint text
                prefixIcon: Icon(Icons.person), //prefix iocn

                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100), //hint text style
                labelStyle: TextStyle(
                    fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
              ),
            ),
            Text('data'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: null,
            ),
          ],
        ),
      ),
    );
  }
}
