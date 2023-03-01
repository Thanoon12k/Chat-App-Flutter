import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chatapp/controllers/register_controller.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/POSTs.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final RegisterController controller =
      Get.put<RegisterController>(RegisterController());
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 228, 211, 211),
      appBar: AppBar_init(),
      body: Form(
        key: controller.registerformkey,
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: controller.namecontroller,
                validator: (v) => controller.TextValidator(v),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اكتب اسمك هنا ',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: controller.statuscontroller,
                validator: (v) => controller.TextValidator(v),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اكتب الحالة هنا ',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.selected_notification.value,
                    items: controller.list_notification,
                    onChanged: (String? newvalue) {
                      controller.selected_notification.value = newvalue!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    '  استلام الاشعارات',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color.fromARGB(255, 12, 12, 12),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.show_dialoge.value,
                child: AlertDialog(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Get.back();
                          controller.show_dialoge.value = false;
                          controller.getImage(ImageSource.gallery);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            Text('From Gallery'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        //if user click this button. user can upload image from camera
                        onPressed: () {
                          // Get.back();
                          controller.show_dialoge.value = false;
                          controller.getImage(ImageSource.camera);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera),
                            Text('From Camera'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: IconButton(
                  onPressed: () => {
                        controller.show_dialoge.value =
                            !controller.show_dialoge.value,
                        print(controller.show_dialoge.isTrue)
                      },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: 40),
            ),
            Obx(() => Center(
                  child: controller.image.value != null
                      ? Image.file(
                          File(controller.image.value!.path),
                          width: 150,
                          height: 150,
                        )
                      : Text(
                          "No image selected.",
                          style: TextStyle(color: Colors.red),
                        ),
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    onPrimary: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () => controller.DoRegister(),
                  child: const Text(
                    'حفظ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Obx(
              () => Center(
                child: controller.user_exist.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          'الاسم مستخدم الرجاء ادخال اسم اخر',
                          style: TextStyle(color: Colors.red),
                        ))
                    : Text(''),
              ),
            ),
            Obx(
              () => Center(
                child: controller.waiting_response.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ))
                    : Text(''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
