import 'dart:convert';

import 'package:chatapp/models/Users.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/GEts.dart';
import 'package:chatapp/serivces/PUTs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../serivces/POSTs.dart';
import '../serivces/preference.dart';

class UserSettingController extends GetxController {
  final userupdateformkey = GlobalKey<FormState>();

  Rx<UserModel?> user = Rx<UserModel?>(null);

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController statuscontroller = TextEditingController();

  Rx<bool> waiting_response = false.obs;
  Rx<bool> name_exist = false.obs;
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
