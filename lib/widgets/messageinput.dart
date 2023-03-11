import 'package:chatapp/serivces/media_manager.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/POSTs.dart';

messsageinput1(int roomid, controller, context) {
  return WillPopScope(
    child: Column(
      children: [
        Stack(
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
                        controller: controller.textEditingController,
                        focusNode: controller.focusNode,
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
                        controller.msg_image.value =
                            await GetLocalImage(context);
                        print('image :  $controller.msg_image');
                      },
                      child: Icon(
                        Icons.attach_file_rounded,
                        color: Colors.white,
                      ),
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    ),
                    FloatingActionButton(
                      heroTag: 'btn2',
                      onPressed: () {
                        controller.isEmojiVisible.value =
                            !controller.isEmojiVisible.value;
                        controller.focusNode.unfocus();
                        controller.focusNode.canRequestFocus = true;
                      },
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
                          'text': controller.textEditingController.text,
                          'room_id': roomid,
                          'sender': userid,
                          'sender_name': username,
                          'image': controller.msg_image.value,
                          'sendtime': DateTime.now().toString(),

                          // 'sendtime':
                        };
                        if (controller.textEditingController.text != '') {
                          PostMessage(data, 'rooms/$roomid/messages/new');
                          controller.msg_image.value = null;
                          controller.textEditingController.text = '';
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
        ),
        Obx(() => Offstage(
              offstage: !controller.isEmojiVisible.value,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    controller.textEditingController.text =
                        controller.textEditingController.text + emoji.emoji;
                  },
                  onBackspacePressed: () {},
                  config: Config(
                      columns: 7,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.SMILEYS,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      noRecents: Text('No Recents',
                          style:
                              TextStyle(fontSize: 20, color: Colors.black26)),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL),
                ),
              ),
            ))
      ],
    ),
    onWillPop: () {
      if (controller.isEmojiVisible.value) {
        controller.isEmojiVisible.value = false;
      } else {
        Navigator.pop(context);
      }
      return Future.value(false);
    },
  );
}
