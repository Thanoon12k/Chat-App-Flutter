import 'package:chatapp/messages.dart';
import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Stack(children: [
                Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  image: AssetImage('assets/avatar.jpg'),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 40,
                  ),
                ),
                Positioned(
                  left: 40,
                  bottom: 10,
                  child: Text(
                    '15',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ]),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyRow(context),
                      MyRow(context),
                    ],
                  ),
                ),
              ),
              MyTextInput()
            ],
          ),
        ),
      ),
    );
  }
}

MyTextInput1() {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: " اكتب رسالة....",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Color.fromARGB(255, 3, 244, 144),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
