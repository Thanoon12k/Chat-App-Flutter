import 'package:chatapp/models/Users.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../serivces/POSTs.dart';
import '../serivces/media_manager.dart';
import '../serivces/preference.dart';

class RegisterController extends GetxController {
  final registerformkey = GlobalKey<FormState>();
  late TextEditingController namecontroller = TextEditingController();
  late TextEditingController statuscontroller = TextEditingController();

  var selected_notification = 'icon_image'.obs;

  Rx<bool> user_exist = false.obs;
  Rx<bool> waiting_response = false.obs;

  List<DropdownMenuItem<String>> list_notification = [
    DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
    DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
    DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
  ];

  TextValidator(String? v) {
    if (v == '' || v == ' ') {
      return 'please enter some text';
    } else {
      return null;
    }
  }

  DoRegister(_image) async {
    user_exist.value = false;
    if (registerformkey.currentState!.validate() && _image.value != null) {
      var data = {
        'name': namecontroller.text,
        'status': statuscontroller.text,
        'notification': selected_notification,
        'image': _image.value
      };
      waiting_response.value = true;
      dynamic resp = await PostUserRegister(data, 'users/user_register');
      waiting_response.value = false;

      if (resp == 'server_error' || resp == null) {
        print(' response : $resp');
      } else if (resp == 'user_exist') {
        print(' response : $resp');

        user_exist.value = true;
      } else {
        print('data ok : ${resp}');
        var user = UserModel.fromJson(resp);
        await SaveLocalImage(_image.value, 'user_image.jpg');

        storeKey('token', user.token);
        storeKey('name', user.name);
        storeKey('imagelink', user.image);
        storeInt('id', user.id);
        storeBoolen('is_user_registered', true);
        print('usertoken ${user.token}');

        Get.offAll(RoomsList());
      }
    } else
      print('not valid or no image');
  }
}
