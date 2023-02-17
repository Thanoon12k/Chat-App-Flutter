import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Column(
            children: [
              MyRow(),
              MyRow(),
              MyRow(),
            ],
          ),
        ),
      ),
    );
  }
}

MyRow() {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: GestureDetector(
          onTap: () {},
          child: Image(
            height: 60,
            image: AssetImage('assets/girl.png'),
          ),
        ),
      ),
      Row(
        children: [
          Text(
            " احمد ",
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.edit_note_rounded,
              size: 24,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    ],
  );
}
