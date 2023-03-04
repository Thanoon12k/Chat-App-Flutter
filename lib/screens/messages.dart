import 'dart:math';
import 'package:chatapp/serivces/firebase.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/firebase.dart';
import '../widgets/messagebox.dart';
import '../widgets/messageinput.dart';

bool postmessagecomplete = false;

// ignore: must_be_immutable
class MessagesScreen extends StatelessWidget {
  final int roomid;
  MessagesScreen({Key? key, required this.roomid}) : super(key: key);

  TextEditingController msgcontroller = TextEditingController();
  final MessageGetter controller = Get.put(MessageGetter());

  @override
  Widget build(BuildContext context) {
    controller.getData();
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

                      List<Color> colorsarray = [
                        Color.fromARGB(255, 233, 232, 186),
                        Color.fromARGB(255, 186, 233, 221),
                        Color.fromARGB(255, 225, 186, 233),
                        Color.fromARGB(255, 190, 233, 186),
                      ];

                      if (item['text'] != null) {
                        return MessageRow(
                          context,
                          item['sender_name'],
                          item['text'],
                          item['addtime'],
                          colorsarray[Random().nextInt(colorsarray.length)],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ),
            messsageinput1(roomid, msgcontroller, context),
          ],
        ),
      ),
    );
  }
}
