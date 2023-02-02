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
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Image.asset('assets/app_images/room.png'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'الكروب العام',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromARGB(255, 59, 73, 6),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Image.asset('assets/app_images/room.png'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'الكروب الاول',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromARGB(255, 59, 73, 6),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Image.asset('assets/app_images/room.png'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/app_images/appbaricon.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'كروب بغداد ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color.fromARGB(255, 59, 73, 6),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
