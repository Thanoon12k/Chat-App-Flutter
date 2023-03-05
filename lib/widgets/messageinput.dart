import 'package:chatapp/serivces/media_manager.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/POSTs.dart';

messsageinput1(int roomid, msgcontroller, context) {
  Rx<XFile?> _image = Rx<XFile?>(null);

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
                onPressed: () async {
                  _image.value = await GetLocalImage(context);
                  print('image :  $_image');
                },
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
                onPressed: () async {
                  int? userid = await rereint('id');
                  String? username = await retiriveString('name');

                  print('user id :::: $userid  username : $username');
                  var data = {
                    'text': msgcontroller.text,
                    'room_id': roomid,
                    'sender': userid,
                    'sender_name': username,
                    'image': _image.value,
                    'sendtime': DateTime.now().toString(),

                    // 'sendtime':
                  };
                  if (msgcontroller.text != '') {
                    PostMessage(data, 'rooms/$roomid/messages/new');
                    _image.value = null;
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
