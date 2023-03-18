import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/Users.dart';
import 'package:chatapp/serivces/GEts.dart';
import 'package:chatapp/serivces/PUTs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/preference.dart';

class UserSettingController extends GetxController {
  final userupdateformkey = GlobalKey<FormState>();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  RxString selected_image_path = ''.obs;
  RxString selected_gender = ''.obs;
  RxString selected_birthdate = ''.obs;
  RxString selected_private = ''.obs;
  RxString selected_comments = ''.obs;
  RxString selected_notification = ''.obs;
  RxInt uesr_stars = 0.obs;
  Rx<XFile?> realimage = Rx<XFile?>(null);
  Rx<bool> waiting_response = true.obs;
  Rx<bool> user_null = true.obs;
  Rx<bool> name_exist = false.obs;

  @override
  void onInit() async {
    UserModel user1;
    user1 = await fetchuser();
    if (user1.id != null) {
      namecontroller.text = user1.name!;
      statuscontroller.text = user1.status!;
      selected_image_path.value = user1.image.toString();
      selected_gender.value = user1.gender!;
      selected_birthdate.value = user1.birthdate!;
      selected_private.value = user1.private.toString();
      selected_comments.value = user1.comments.toString();
      selected_notification.value = user1.notification!;
      user_null.value = false;
      super.onInit();
    } else {}
  }

  TextValidator(String? v) {
    if (v == '' || v == ' ') {
      return 'please enter some text';
    } else {
      return null;
    }
  }

  Future<UserModel> fetchuser() async {
    var _userid = await rereint('id');
    var user = await GetUserData('users/$_userid/user_ret_update');

    print('image ${user.image}');
    return user;
  }

  Future SendNow() async {
    var _userid = await rereint('id');
    var data = {
      'name': namecontroller.text,
      'status': statuscontroller.text,
      'gender': selected_gender.value,
      'birthdate': selected_birthdate.value,
      'private': selected_private.value,
      'comments': selected_comments.value,
      'notification': selected_notification.value,
      'image': File(selected_image_path.value)
    };
    waiting_response.value = true;
    dynamic resp = await PutUpdateUser(data, 'users/$_userid/user_ret_update');
    waiting_response.value = false;
    if (userupdateformkey.currentState!.validate()) {
      if (resp == 'server_error' || resp == null) {
      } else if (resp == 'name_exist') {
        name_exist.value = true;
        update(['name_exist_widget']);
      } else {
        UserModel _user;
        name_exist.value = false;
        update(['name_exist_widget']);
        _user = UserModel.fromJson(resp);
        storeKey('name', _user.name);
        storeKey('imagelink', _user.image);
      }
    } else {
      print('not valid form');
    }
  }

  @override
  void onClose() {
    namecontroller.dispose();
    statuscontroller.dispose();
    super.onClose();
  }
}
