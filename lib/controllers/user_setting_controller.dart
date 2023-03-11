import 'package:chatapp/models/Users.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/PUTs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../serivces/POSTs.dart';
import '../serivces/preference.dart';

class UserSettingController extends GetxController {
  final usersettingform = GlobalKey<FormState>();
  late TextEditingController namecontroller = TextEditingController();
  late TextEditingController statuscontroller = TextEditingController();
  var selected_notification = 'icon_image'.obs;
  var selected_gender = 'male'.obs;
  var selected_comment = 'allow'.obs;
  var selected_private = 'allow'.obs;

  RxString birthdaytext = ''.obs;
  Rx<bool> waiting_response = false.obs;

  List<DropdownMenuItem<String>> list_notification = [
    DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
    DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
    DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
  ];

  List<DropdownMenuItem<String>> list_gender = [
    DropdownMenuItem(child: Text("ذكر"), value: "male"),
    DropdownMenuItem(child: Text("انثى"), value: "famle"),
  ];
  List<DropdownMenuItem<String>> list_comments = [
    DropdownMenuItem(child: Text("السماح للجميع بالتعليق"), value: "allow"),
    DropdownMenuItem(child: Text("لا تسمح"), value: "disallow"),
  ];
  List<DropdownMenuItem<String>> list_private = [
    DropdownMenuItem(child: Text("السماح  بالخاص"), value: "allow"),
    DropdownMenuItem(child: Text("لا تسمح"), value: "disallow"),
  ];

  TextValidator(String? v) {
    if (v == '' || v == ' ') {
      return 'please enter some text';
    } else {
      return null;
    }
  }

  UpdateUserData(_image) async {
    if (usersettingform.currentState!.validate() && _image.value != null) {
      var selected_notification = 'icon_image'.obs;
   
      var data = {
        'name': namecontroller.text,
        'status': statuscontroller.text,
        'gender': selected_gender,
        'comments': selected_comment,
        'private': selected_private,
        'notification': selected_notification,
        'image': _image.value
      };
      waiting_response.value = true;
      dynamic resp = await PutUpdateUser(data, 'users/user_register');
      waiting_response.value = false;

      if (resp == 'server_error' || resp == null) {
      } else {
        var user = UserModel.fromJson(resp);
      }
    } else
      print('not valid or no image');
  }

  void selectDate(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1999),
      firstDate: DateTime(1960),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      birthdaytext.value = DateFormat('dd-MM- yyyy').format(pickedDate);
    }
  }
}
