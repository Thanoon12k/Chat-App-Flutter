import 'package:chatapp/controllers/userview_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/keyboard_con.dart';
import '../widgets/appbar.dart';
import '../widgets/messagebox.dart';
import '../widgets/messageinput.dart';

class UserView extends StatelessWidget {
  final userviewid;
  UserView({this.userviewid, Key? key}) : super(key: key);

  KeyboardController commentcontroller = Get.put(KeyboardController());
  UserViewController controller =
      Get.put<UserViewController>(UserViewController());

  @override
  Widget build(BuildContext context) {
    controller.fetchuser(userviewid);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Visibility(
              visible: controller.user_image.value != '',
              replacement: Center(child: CircularProgressIndicator()),
              child: Stack(children: [
                Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  image: NetworkImage(controller.user_image.value),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.updateStars();
                    },
                    child: Icon(
                      Icons.star,
                      color: controller.starcolor.value,
                      size: 25,
                    ),
                  ),
                ),
                Positioned(
                  left: 27,
                  bottom: 0,
                  child: Text(
                    controller.stars_number.value.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.commentslist.length,
                  itemBuilder: ((context, index) {
                    var item = controller.commentslist[index];

                    return MessageRow(
                      context: context,
                      sender_id: item.sender,
                      text: item.text,
                      sender_name: item.sender_name,
                      sender_image: item.senderImage,
                      message_image: item.image,
                      sendtime: item.sendtime,
                      msgcolor: Color.fromARGB(255, 233, 232, 186),
                    );
                  })),
            ),
            messsageinput1(
                0, commentcontroller, context, controller.user_id.value),
          ],
        ),
      ),
    );
  }
}
