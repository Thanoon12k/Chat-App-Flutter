import 'package:chatapp/models/Comments.dart';
import 'package:chatapp/serivces/PUTs.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Users.dart';
import '../serivces/GEts.dart';
import '../serivces/POSTs.dart';

class UserViewController extends GetxController {
  UserViewController({this.userviewid});
  final int? userviewid;

  TextEditingController textcontroller = TextEditingController();
  Rx<Color> starcolor = Colors.white.obs;
  RxString user_name = ''.obs;
  RxString user_status = ''.obs;
  RxString user_image = ''.obs;
  RxInt stars_number = 0.obs;
  RxInt user_id = 0.obs;
  RxList<CommentsModel> commentslist = RxList<CommentsModel>([]);

  Rx<UserModel> user = Rx<UserModel>(UserModel());

  Future updateStars() async {
    var _userid = user_id.value;
    if (starcolor.value == Colors.white) {
      stars_number.value++;
      starcolor.value = Color.fromARGB(255, 255, 226, 59);
      await storeKey('starcolor_$_userid', 'yellow');
    } else {
      stars_number.value--;
      starcolor.value = Colors.white;
      await removeKey('starcolor_$_userid');
    }
    await PUTStar(stars_number.value, 'users/$_userid/stars_update');
  }

  Future SendComment(sender_data) async {
    await POSTcomment(sender_data, 'users/add_comment');
  }

  Future<void> fetchuser([id]) async {
    var _user;
    print('beforid: $id');

    if (id == null) {
      id = await rereint('id');
    }
    print('afterid: $id');
    _user = await GetUserData('users/$id/view');
    if (_user != null) {
      user_id.value = _user.id;
      user_name.value = _user.name;
      user_status.value = _user.status;
      user_image.value = _user.image;
      stars_number.value = _user.stars;

      if (_user.userComments != null) {
        commentslist.value = _user.userComments;
      }
    }
  }
}
