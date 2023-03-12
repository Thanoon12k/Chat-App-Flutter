import 'dart:convert';

import 'package:chatapp/models/Users.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/GEts.dart';
import 'package:chatapp/serivces/PUTs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../serivces/POSTs.dart';
import '../serivces/preference.dart';

class UserSettingController extends GetxController {
  final userupdateformkey = GlobalKey<FormState>();
  Rx<UserModel?> user = Rx<UserModel?>(null);

  TextEditingController namecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  RxString selected_image_path = ''.obs;
  RxString selected_gender = ''.obs;
  RxString selected_birthdate = ''.obs;
  RxString selected_private = ''.obs;
  RxString selected_comments = ''.obs;
  RxString selected_notification = ''.obs;

  Rx<bool> waiting_response = true.obs;
  Rx<bool> user_null = true.obs;
  Rx<bool> name_exist = false.obs;
  void update_menus(String menu_id, new_val) {
    if (menu_id == 'gender_menu') {
      selected_gender.value = new_val;
    } else if (menu_id == 'private_menu') {
      selected_private.value = new_val;
    } else if (menu_id == 'comments_menu') {
      selected_comments.value = new_val;
    } else if (menu_id == 'notification_menu') {
      selected_notification.value = new_val;
    }
    print(' update now $menu_id with $new_val');
    update([menu_id]);
  }

  @override
  void onInit() async {
    UserModel user1;
    user1 = await fetchuser();
    print('user1 : ${user1.id}');
    if (user1.id != null) {
      namecontroller.text = user1.name!;
      statuscontroller.text = user1.status!;
      selected_image_path.value = user1.image.toString();
      selected_gender.value = user1.gender!;
      selected_birthdate.value = user1.birthdate!;
      selected_private.value = 'false';
      selected_comments.value = 'false';
      selected_notification.value = user1.notification!;
      user_null.value = false;
      super.onInit();

      print('user 1 updated not  null');
    } else {
      print('user 1 is null not updated');
    }
  }

  @override
  void onClose() {
    //Get called when controller is removed from memory
    super.onClose();
  }

  TextValidator(String? v) {
    if (v == '' || v == ' ') {
      return 'please enter some text';
    } else {
      return null;
    }
  }

  Future<UserModel> fetchuser() async {
    String resp = await GetUserData('users/32/user_ret_update');
    return UserModel.fromJson(jsonDecode(resp));
  }

  Future UpdateNow(_image) async {
    var userid = 32;
    var data = {
      'name': namecontroller.text,
      'status': statuscontroller.text,
      'gender': user.value!.gender,
      'birthdate': user.value!.birthdate,
      'private': user.value!.private,
      'comments': user.value!.comments,
      'notification': user.value!.notification,
      'image': _image.value
    };
    waiting_response.value = true;
    dynamic resp = await PutUpdateUser(data, 'users/$userid/user_ret_update');
    waiting_response.value = false;
    if (userupdateformkey.currentState!.validate() && _image.value != null) {
      if (resp == 'server_error' || resp == null) {
      } else if (resp == 'name_exist') {
        name_exist.value = true;
      } else {
        user.value = UserModel.fromJson(resp);
        storeKey('name', user.value!.name);
        storeKey('imagelink', user.value!.image);
      }
    } else {
      print('not valid or no image');
    }
  }
}
