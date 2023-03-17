// import 'package:chatapp/screens/profile_view.dart';
import 'package:chatapp/controllers/rooms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/appbar.dart';
import '../widgets/roomcard.dart';

class RoomsList extends StatefulWidget {
  @override
  State<RoomsList> createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  
  final RoomsController controller =
      Get.put<RoomsController>(RoomsController());

  @override
  Widget build(BuildContext context) {
    controller.fetchrooms();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Obx(
        () => Container(
          child: controller.roomslist.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.roomslist.length,
                  itemBuilder: ((context, index) {
                    if (index.isEven &&
                        index != (controller.roomslist.length) - 1) {
                      return Row(children: [
                        RoomCard(
                          context,
                          controller.roomslist[index].id,
                          controller.roomslist[index].name,
                          controller.roomslist[index].users_count,
                          controller.roomslist[index].password,
                          controller.roomslist[index].image,
                        ),
                        RoomCard(
                          context,
                          controller.roomslist[index + 1].id,
                          controller.roomslist[index + 1].name,
                          controller.roomslist[index + 1].users_count,
                          controller.roomslist[index + 1].password,
                          controller.roomslist[index + 1].image,
                        ),
                      ]);
                    } else if ((controller.roomslist.length).isOdd &&
                        index == (controller.roomslist.length) - 1) {
                      return Row(children: [
                        RoomCard(
                          context,
                          controller.roomslist[index].id,
                          controller.roomslist[index].name,
                          controller.roomslist[index].users_count,
                          controller.roomslist[index].password,
                          controller.roomslist[index].image,
                        ),
                        Container()
                      ]);
                    } else {
                      return Container();
                    }
                  }))
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
        ),
      ),
    );
  }
}
