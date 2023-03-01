
import 'package:chatapp/models/Rooms.dart';
import 'package:get/get.dart';
import '../serivces/GEts.dart';

class RoomsController extends GetxController {
  RxList<RoomsModel> roomslist = RxList<RoomsModel>([]);

  @override
  void onInit() {
    super.onInit();
    fetchrooms();
  }

  Future fetchrooms() async {
    var resp = await GetRooms('rooms');
    roomslist.value = roomsModelFromJson(resp.body);
  }
}
