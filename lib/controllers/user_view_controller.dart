import 'dart:convert';

import 'package:chatapp/serivces/PUTs.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Users.dart';
import '../serivces/GEts.dart';
import '../serivces/POSTs.dart';

class UserViewController extends GetxController {
  TextEditingController textcontroller = TextEditingController();
  Rx<Color> starcolor = Colors.white.obs;
  final RxInt starnumber = 0.obs;
  Rx<UserModel> user = Rx<UserModel>(UserModel());
  @override
  void onInit() async {
    super.onInit();

    user.value = await getUser();
    starnumber.value = user.value.stars ?? 0;
    var sharedcolor = await retiriveString('starcolor_${user.value.id}');
    if (sharedcolor != null) {
      starcolor.value = Colors.yellow;
    }
  }

  Future<UserModel> getUser() async {
    var _userid = await rereint('id');
    var resp = await GetUserData('users/$_userid/user_ret_update');
    return UserModel.fromJson(jsonDecode(resp));
  }

  Future updateStars() async {
    var _userid = user.value.id;
    if (starcolor.value == Colors.white) {
      starcolor.value = Color.fromARGB(255, 255, 226, 59);
      starnumber.value++;
      await PUTStar(starnumber.value++, 'users/$_userid/stars_update');
      await storeKey('starcolor_$_userid', 'yellow');
      print('added ${starnumber.value++}');
    } else {
      starcolor.value = Colors.white;
      starnumber.value--;
      await PUTStar(starnumber.value--, 'users/$_userid/stars_update');
      await removeKey('starcolor_$_userid');
      print('removed ${starnumber.value--}');
    }

    // await PUTStar(user_stars + 1, 'users/$sender_id/stars_update');
  }

  Future SendComment(sender_data) async {
    await POSTcomment(sender_data, 'users/add_comment');
  }
}
