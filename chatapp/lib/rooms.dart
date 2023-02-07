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
          body: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Container(
                        child:  ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16),),
                          child: Image(
                            image: AssetImage('assets/girl.png'),
                          ),
                        ),
                         decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(66, 23, 9, 219),
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                blurStyle: BlurStyle.solid),
                          ],
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Container(
                        child: Image(
                          image: AssetImage('assets/girl.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
