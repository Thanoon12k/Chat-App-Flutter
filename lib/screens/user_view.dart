import 'package:chatapp/controllers/userview_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/messagegs_con.dart';
import '../widgets/appbar.dart';
import '../widgets/messagebox.dart';
import '../widgets/messageinput.dart';

class UserView extends StatelessWidget {
  final reception_id;
  UserView({this.reception_id, Key? key}) : super(key: key);
  final UserViewController controller =
      Get.put<UserViewController>(UserViewController());
  final MessageController commentcontroller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Obx(
              () => Visibility(
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
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
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
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                    itemCount: controller.commentslist.length,
                    itemBuilder: ((context, index) {
                      var item = controller.commentslist[index];
                      return MessageRow(
                        context,
                        reception_id,
                        item.text,
                        item.sender,
                        item.senderImage,
                        item.image,
                        'date',
                        Color.fromARGB(255, 233, 232, 186),
                      );
                    })),
              ),
            ),
            messsageinput1(0, commentcontroller, context,
                controller.user_id.value, controller.fetchuser()),
          ],
        ),
      ),
    );
  }
}
