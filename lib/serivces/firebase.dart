import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageGetter extends GetxController {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('messages');
  final messagesList = [].obs;
  ScrollController scorlcon = new ScrollController();

  void getData(int room_id) async {
    ref.onValue.listen((event) {
      messagesList.clear(); // clear the existing list before adding new values
      event.snapshot.children.forEach((element) {
        if (element.child('room_id').value == room_id) {
          messagesList.add(element.value!);
        }
      });
      scorlltodown();
    });
  }

  scorlltodown() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scorlcon.animateTo(
        scorlcon.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }
}

Future<String?> get_fcm_token() async {
  final fcmtoken = await FirebaseMessaging.instance.getToken();
  print('fcmtoken: $fcmtoken');
  return fcmtoken;
}
