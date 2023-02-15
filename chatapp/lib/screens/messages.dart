import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:chatapp/screens/profile_view.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../models/Message.dart';
import '../serivces/GEts.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Directionality(
            textDirection: TextDirection.rtl, child: MsgListBuilder()),
      ),
    );
  }
}

class MsgListBuilder extends StatelessWidget {
  const MsgListBuilder({Key? key}) : super(key: key);

  Future<List<MessgesModel>> getJson() async {
    print('sending request');
    final jsonmsgs = await Get_messages_list('rooms/1/messages');
    print(' reques t ok ');
    final List<dynamic> jsonList = jsonDecode(jsonmsgs);
    final List<MessgesModel> msgslist = jsonList
        .map((dynamic item) =>
            MessgesModel.fromJson(item as Map<String, dynamic>))
        .toList();
    // print(' msgs >> $msgslist');
    return msgslist;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MessgesModel>>(
      future: getJson(),
      builder:
          (BuildContext context, AsyncSnapshot<List<MessgesModel>> snapshot) {
        if (snapshot.hasData) {
          final List<MessgesModel> msgslist = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: msgslist.length,
                  itemBuilder: ((context, index) {
                    Color msgcolor;
                    List<Color> colorsarray = [
                      Color.fromARGB(255, 233, 232, 186),
                      Color.fromARGB(255, 186, 233, 221),
                      Color.fromARGB(255, 225, 186, 233),
                      Color.fromARGB(255, 190, 233, 186),
                    ];

                    return MessageRow(
                      context,
                      msgslist[index].sender,
                      msgslist[index].text,
                      msgslist[index].addtime,
                      colorsarray[Random().nextInt(colorsarray.length)],
                    );
                  }),
                ),
              ),
              MyTextInput(),
            ],
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        }
      },
    );
  }
}

MessageRow(context, sender, text, addtime, msgcolor) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
          child: Image(
            height: 50,
            image: AssetImage('assets/girl.png'),
          ),
        ),
      ),
      Card(
        color: msgcolor,
        child: Wrap(
          alignment: WrapAlignment.end,
          children: <Widget>[
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text(sender.toString()),
                      ),
                      Expanded(child: Text('')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text(addtime),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 10, 0, 5),
                        child: Icon(Icons.not_interested_rounded),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  Icons.attach_file_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
