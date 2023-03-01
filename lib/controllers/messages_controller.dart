
import 'package:chatapp/models/Messages.dart';
import 'package:get/get.dart';
import '../serivces/GEts.dart';


import '../models/Messages.dart';

class RoomsController extends GetxController {
  RxList<MessagesModel> mesgslist = RxList<MessagesModel>([]);

  @override
  void onInit() {
    super.onInit();
    fetchrooms();
  }

  Future fetchrooms() async {
    var resp = await Get_messages_list('rooms');
    mesgslist.value = messagesmodelFromJson(resp.body);
  }
}