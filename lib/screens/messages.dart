import 'dart:convert';
import 'dart:math';
import 'package:chatapp/serivces/POSTs.dart';
import 'package:chatapp/screens/user_view.dart';
import 'package:chatapp/serivces/firebase.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Messages.dart';
import '../serivces/GEts.dart';

bool postmessagecomplete = false;

class MessagesScreen extends StatelessWidget {
  final int roomid;
  MessagesScreen({Key? key, required this.roomid}) : super(key: key);

  TextEditingController msgcontroller = TextEditingController();
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                    itemCount: controller.messagesList.length,
                    itemBuilder: (context, index) {
                      final item = controller.messagesList[index];
                      Color msgcolor;
                      List<Color> colorsarray = [
                        Color.fromARGB(255, 233, 232, 186),
                        Color.fromARGB(255, 186, 233, 221),
                        Color.fromARGB(255, 225, 186, 233),
                        Color.fromARGB(255, 190, 233, 186),
                      ];

                      return MessageRow(
                        context,
                        item['sender_name'],
                        item['text'],
                        item['addtime'],
                        colorsarray[Random().nextInt(colorsarray.length)],
                      );
                    }),
              ),
            ),
            MyTextInput(roomid, msgcontroller, context),
          ],
        ),
      ),
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
            Get.to(() => UserView());
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
                        child: Text(addtime.toString()),
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

MyTextInput(int roomid, msgcontroller, context) {
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
                  controller: msgcontroller,
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
                onPressed: () {
                  var data = {
                    'text': msgcontroller.text,
                    'room_id': roomid,
                    'sender': 1,
                    'sender_name': 'thanoon1',
                    'atachment': 'null',
                    'addtime': '1/3/2023',

                    // 'addtime':
                  };
                  if (msgcontroller.text != '') {
                    PostMessage(data, 'rooms/$roomid/messages/new');
                    msgcontroller.text = '';
                  }
                },
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
