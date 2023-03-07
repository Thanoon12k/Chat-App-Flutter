import 'dart:math';
import 'package:chatapp/controllers/message_controller.dart';
import 'package:chatapp/serivces/firebase.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/firebase.dart';
import '../widgets/messagebox.dart';
import '../widgets/messageinput.dart';

// ignore: must_be_immutable
class MessagesScreen extends StatelessWidget {
  final int room_id;
  MessagesScreen({Key? key, required this.room_id}) : super(key: key);

  final MessageGetter controller = Get.put(MessageGetter());
  final MessageController msgcontroller = Get.put(MessageController());

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
                      final item = controller.messagesList[index];

                      List<Color> colorsarray = [
                        Color.fromARGB(255, 233, 232, 186),
                        Color.fromARGB(255, 186, 233, 221),
                        Color.fromARGB(255, 225, 186, 233),
                        Color.fromARGB(255, 190, 233, 186),
                      ];

                      if (item['text'] != null) {
                        return MessageRow(
                          context,
                          item['text'],
                          item['sender_name'],
                          item['sender_image'],
                          item['image'],
                          item['sendtime'],
                          colorsarray[Random().nextInt(colorsarray.length)],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ),
            messsageinput1(room_id, msgcontroller, context),
          ],
        ),
      ),
    );
  }
}
