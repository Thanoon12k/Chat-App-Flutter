import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/firebase.dart';

class FireMessages extends StatelessWidget {
  FireMessages({Key? key}) : super(key: key);
  final GetMessages controller = Get.put(GetMessages());
  @override
  Widget build(BuildContext context) {
    controller.getData();

    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Obx(() => ListView.builder(
          itemCount: controller.messagesList.length,
          itemBuilder: (context, index) {
            final item = controller.messagesList[index];
            return ListTile(title: Text(item['sender_name']));
          })),
    );
  }
}
