import 'dart:io';

import 'package:chatapp/controllers/register_controller.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/serivces/media_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final RegisterController controller =
      Get.put<RegisterController>(RegisterController());
  Rx<XFile?> _image = Rx<XFile?>(null);

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
            Center(
              child: IconButton(
                  onPressed: () async {
                    _image.value = await GetLocalImage(context);               
                  },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: 40),
            ),
            Obx(() => Center(
                  child: _image.value != null
                      ? Image.file(
                          File(_image.value!.path),
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
                  onPressed: () {
                    controller.DoRegister(_image);
                    if (retiriveBool('is_user_register') == true) {
                      Get.to(()=>RoomsList());
                    }
                  },
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
