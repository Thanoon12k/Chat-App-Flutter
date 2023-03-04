import 'package:chatapp/models/Users.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/POSTs.dart';
import '../serivces/preference.dart';

class RegisterController extends GetxController {
  final registerformkey = GlobalKey<FormState>();
  late TextEditingController namecontroller = TextEditingController();
  late TextEditingController statuscontroller = TextEditingController();
  final Rx<XFile?> image = Rx<XFile?>(null);
  final ImagePicker picker = ImagePicker();

  var selected_notification = 'icon_image'.obs;
  var image_path = ''.obs;

  Rx<bool> show_dialoge = false.obs;
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

  DoRegister() async {
    // await write_data();
    // await read_data(UserID: '5');
    user_exist.value = false;
    if (registerformkey.currentState!.validate() && image.value != null) {
      var data = {
        'name': namecontroller.text,
        'status': statuscontroller.text,
        'notification': selected_notification,
        'image': image.value
      };
      waiting_response.value = true;
      dynamic resp = await PostUserRegister(data, 'users/user_register');
      waiting_response.value = false;

      if (resp.statusCode == 422) {
        user_exist.value = true;
      } else {
        var user = UserModel.fromJson(resp.data);
        storeKey('token', user.token);
        storeKey('name', user.name);
        storeInt('id', user.id);
        storeBoolen('is_user_registered', true);
        print('usertoken ${user.token}');
        Get.offAll(RoomsList());
      }
    } else
      print('not valid or no image');
  }

  Future getImage(ImageSource media) async {
    image.value = await picker.pickImage(source: media);
    image_path.value = image.value!.path;
  }
}
