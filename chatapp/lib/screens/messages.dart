import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

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
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(66, 23, 9, 219),
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                blurStyle: BlurStyle.solid),
                          ],
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Image(
                                //backgrounimage
                                image: AssetImage('assets/icons/sky2.jpg'),
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage('assets/icons/girl.jpg'),
                                    ),
                                  ),
                                  Text(
                                    'الكروب العام',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      background: Paint()
                                        ..color =
                                            Color.fromARGB(255, 255, 255, 255)
                                        ..strokeWidth = 20
                                        ..strokeJoin = StrokeJoin.round
                                        ..strokeCap = StrokeCap.round
                                        ..style = PaintingStyle.stroke,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 115,
                                top: 5,
                                child: Icon(
                                  Icons.notifications,
                                  color: Color.fromARGB(255, 149, 215, 235),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(66, 23, 9, 219),
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                blurStyle: BlurStyle.solid),
                          ],
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Image(
                                //backgrounimage
                                image: AssetImage('assets/icons/sky2.jpg'),
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage('assets/icons/girl.jpg'),
                                    ),
                                  ),
                                  Text(
                                    'الكروب العام',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      background: Paint()
                                        ..color =
                                            Color.fromARGB(255, 255, 255, 255)
                                        ..strokeWidth = 20
                                        ..strokeJoin = StrokeJoin.round
                                        ..strokeCap = StrokeCap.round
                                        ..style = PaintingStyle.stroke,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 115,
                                top: 5,
                                child: Icon(
                                  Icons.notifications,
                                  color: Color.fromARGB(255, 149, 215, 235),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
