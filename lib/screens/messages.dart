import 'dart:math';
import 'package:chatapp/controllers/keyboard_con.dart';
import 'package:chatapp/controllers/messages_con.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/messages_con.dart';
import '../widgets/messagebox.dart';
import '../widgets/messageinput.dart';

// ignore: must_be_immutable
class MessagesScreen extends StatelessWidget {
  final int room_id;
  MessagesScreen({Key? key, required this.room_id}) : super(key: key);

  final MessageController controller = Get.put(MessageController());
  final KeyboardController keyboardcon = Get.put(KeyboardController());

  @override
  Widget build(BuildContext context) {
    controller.scorlltodown();
    controller.getData(room_id);
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
                    controller: controller.scorlcon,
                    itemBuilder: (context, index) {
                      var item = controller.messagesList[index];

                      List<Color> colorsarray = [
                        Color.fromARGB(255, 233, 232, 186),
                        Color.fromARGB(255, 186, 233, 221),
                        Color.fromARGB(255, 225, 186, 233),
                        Color.fromARGB(255, 190, 233, 186),
                      ];

                      if (item['text'] != null) {
                        return MessageRow(
                          context: context,
                          sender_id: item['sender'],
                          text: item['text'],
                          sender_name: item['sender_name'],
                          sender_image: item['sender_image'],
                          message_image: item['image'],
                          sendtime: item['sendtime'],
                          msgcolor: colorsarray[item['sender'] % 4],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ),
            messsageinput1(room_id, keyboardcon, context),
          ],
        ),
      ),
    );
  }
}
