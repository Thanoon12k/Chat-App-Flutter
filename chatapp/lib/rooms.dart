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
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                //     color: Color.fromARGB(255, 87, 0, 0),

                image: DecorationImage(
                    image: AssetImage('assets/app_images/tech.png'),
                    fit: BoxFit.cover),
              ),
            ),
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
