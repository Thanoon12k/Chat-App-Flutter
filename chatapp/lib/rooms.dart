// import 'package:chatapp/screens/profile_view.dart';
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Rooms()));
                        },
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.42,
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Image(
                                    image: AssetImage('assets/sq2.png'),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 8,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/girl.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.notifications,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 40,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 15,
                                    child: Container(
                                      width: 140,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  66, 118, 78, 212),
                                              offset: Offset(0, 0),
                                              blurRadius: 40,
                                              blurStyle: BlurStyle.solid),
                                        ],
                                        border: Border.all(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 1,
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: Text(
                                        'الكروب العام',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(66, 23, 9, 219),
                                    offset: Offset(0, 0),
                                    blurRadius: 40,
                                    blurStyle: BlurStyle.solid),
                              ],
                              border: Border.all(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 1,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
