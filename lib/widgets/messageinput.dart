import 'package:flutter/material.dart';

import '../serivces/POSTs.dart';

messsageinput1(int roomid, msgcontroller, context) {
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
                heroTag: 'btn1',
                onPressed: () {},
                child: Icon(
                  Icons.attach_file_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {},
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                heroTag: 'btn3',
                onPressed: () {
                  var data = {
                    'text': msgcontroller.text,
                    'room_id': roomid,
                    'sender': 1,
                    'sender_name': 'thanoon1',
                    'atachment': 'null',
                    'addtime': DateTime.now().toString(),

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
