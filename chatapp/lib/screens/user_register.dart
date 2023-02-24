import 'dart:io';
import 'dart:typed_data';

import 'package:chatapp/controllers/register_controller.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/droplists.dart';
import 'package:chatapp/widgets/imageinputs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/POSTs.dart';
import '../widgets/buttons.dart';
import '../widgets/textinputs.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final RegisterController controler =
      Get.put<RegisterController>(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 228, 211, 211),
      appBar: AppBar_init(),
      body: Form(
        key: controler.registerformkey,
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputs(
                    hint: ' اكتب اسمك هنا ',
                    controller: controler.namecontroller)
                .TextInput1(),
            TextInputs(
                    hint: 'اكتب الحالة هنا (اختياري *)',
                    controller: controler.statuscontroller)
                .TextInput1(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controler.default_notification.value,
                    items: controler.list_notification,
                    onChanged: (String? newvalue) {
                      controler.default_notification.value = newvalue!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
            Center(
              child: IconButton(
                  onPressed: () => (context) {},
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: 40),
            ),
            Center(
              child: controler.image != null
                  ? Image.file(File(controler.image!.path), width: 150)
                  : Text(
                      "No image selected.",
                      style: TextStyle(color: Colors.red),
                    ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    onPrimary: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () => controler.DoRegister(),
                  child: const Text(
                    'حفظ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

sendform(namecon, statuscon, image) {
  Map data = {
    'name': namecon,
    'status': statuscon,
    'image': image,
  };

  return data;
}
