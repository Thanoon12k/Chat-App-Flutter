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

Rx<UserModel> user = Rx<UserModel>(UserModel()); 
  @override
  void onInit() async {
    super.onInit();  
    var _userid = await rereint('id');
    var resp =  await GetUserData('users/$_userid/user_ret_update');
    user.value=  UserModel.fromJson(jsonDecode(resp));

    if (user.value.stars != null && user.value.image != null) {
      print('userstars${user.value.stars}');
      update(['stars_numbers', 'image_widget']);
    }
  }

}











  Future SendStar(sender_id, user_stars) async {
    await PUTStar(user_stars + 1, 'users/$sender_id/stars_update');
    
  }

Future RemoveStar(sender_id, user_stars) async {
   await PUTStar(user_stars - 1, 'users/$sender_id/stars_update');
        
  }

Future SendComment(sender_data) async {
 await POSTcomment(sender_data, 'users/add_comment');
  }
Future RemoveComment(sender_data) async {
   await POSTcomment(sender_data, 'users/add_comment');
  }