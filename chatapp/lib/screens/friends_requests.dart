import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

class FriendsRequests extends StatefulWidget {
  const FriendsRequests({Key? key}) : super(key: key);

  @override
  State<FriendsRequests> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequests> {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyRow(),
                MyRow(),
                MyRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

MyRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: Image(
              height: 60,
              image: AssetImage('assets/girl.png'),
            ),
          ),
          Column(
            children: [
              Text(
                " احمد العراقي",
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "   sun 8:15 pm               ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
      Row(
        children: [
          Card(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Text(
                " قبول ",
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          Card(
            child: Container(
              color: Color.fromARGB(255, 0, 0, 0),
              child: Text(
                " رفض ",
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
        ],
      ),
    ],
  );
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
