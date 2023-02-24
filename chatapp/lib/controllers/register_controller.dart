import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final registerformkey = GlobalKey<FormState>();
  late TextEditingController namecontroller = TextEditingController();
  late TextEditingController statuscontroller = TextEditingController();
  File? image;
  var default_notification = 'icon_image'.obs;

  List<DropdownMenuItem<String>> list_notification = [
    DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
    DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
    DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
  ];

  TextValidator(String? v) {
    if (v == 'null') {
      return 'please enter some text';
    } else {
      return null;
    }
  }

  DoRegister() {
    print(
        ' ${namecontroller.text}  ${statuscontroller.text}  ${default_notification}');
    return 'ok registered';
  }
}
