import 'package:chatapp/messages.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Private extends StatefulWidget {
  const Private({Key? key}) : super(key: key);

  @override
  State<Private> createState() => _PrivateState();
}

class _PrivateState extends State<Private> {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyRow(context),
                      MyRow(context),
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

MyTextInput() {
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
