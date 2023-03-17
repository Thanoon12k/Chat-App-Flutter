import 'package:chatapp/controllers/user_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/appbar.dart';

class UserView extends StatelessWidget {
  UserView({Key? key}) : super(key: key);
  final UserViewController controller =
      Get.put<UserViewController>(UserViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Column(
        children: [
          Visibility(
            visible: controller.user.value.image != '',
            replacement: CircularProgressIndicator(),
            child: Stack(children: [
              Obx(
                () => Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  image: NetworkImage(controller.user.value.image!),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => controller.updateStars(),
                  child: Obx(
                    () => Icon(
                      Icons.star,
                      color: controller.starcolor.value,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                bottom: 0,
                child: Obx(
                  () => Text(
                    controller.starnumber.value.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // MessageRow(context),
                  // MessageRow(context),
                ],
              ),
            ),
          ),
          MyTextInput1()
        ],
      ),
    );
  }
}

MyTextInput1() {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: " اكتب رسالة....",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Color.fromARGB(255, 3, 244, 144),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
