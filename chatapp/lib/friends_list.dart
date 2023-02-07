import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
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
            height: 70,
            image: AssetImage('assets/girl.png'),
          ),
        ),
      ),
      Row(
        children: [
          Card(
            child: Text(
              " احمد ",
              style: TextStyle(fontSize: 28),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.chat_rounded,
              size: 30,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    ],
  );
}
