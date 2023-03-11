import 'dart:io';

import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/serivces/media_manager.dart';
import 'package:chatapp/widgets/textformfield.dart';
import 'package:chatapp/widgets/textformlabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/user_setting_controller.dart';
import '../widgets/dialogs.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final UserSettingController controller =
      Get.put<UserSettingController>(UserSettingController());
  Rx<XFile?> _image = Rx<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 228, 211, 211),
      appBar: myappbar(),
      body: Form(
        key: controller.usersettingform,
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            MyTextFormField(
              controller: controller.namecontroller,
              validator: (v) => controller.TextValidator(v),
              field_hint: 'الاسم',
            ),
            MyTextFormField(
              controller: controller.statuscontroller,
              validator: (v) => controller.TextValidator(v),
              field_hint: 'الحالة',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return MyTextFormLabel(
                      label_text: controller.birthdaytext.value);
                }),
                IconButton(
                  onPressed: () => controller.selectDate(context),
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.blue,
                  ),
                ),
                MyTextFormLabel(label_text: ':تاريخ الميلاد'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.selected_gender.value,
                    items: controller.list_gender,
                    onChanged: (String? newvalue) {
                      controller.selected_gender.value = newvalue!;
                    },
                  ),
                ),
                MyTextFormLabel(label_text: ':الجنس')
              ],
            ),
            Column(
              children: [
                Obx(() => Center(
                      child: _image.value != null
                          ? Image.file(
                              File(_image.value!.path),
                              width: 150,
                              height: 150,
                            )
                          : SizedBox(
                              width: 1,
                            ),
                    )),
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _image.value != null
                            ? IconButton(
                                onPressed: () {
                                  _image.value = null;
                                },
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  color: Color.fromARGB(255, 236, 98, 98),
                                ),
                                iconSize: 30,
                              )
                            : IconButton(
                                onPressed: () async {
                                  _image.value = await GetLocalImage(context);
                                },
                                icon: Icon(Icons.camera_alt_outlined),
                                iconSize: 40)
                      ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.selected_comment.value,
                    items: controller.list_comments,
                    onChanged: (String? newvalue) {
                      controller.selected_comment.value = newvalue!;
                    },
                  ),
                ),
                MyTextFormLabel(label_text: ':التعليقات')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.selected_private.value,
                    items: controller.list_private,
                    onChanged: (String? newvalue) {
                      controller.selected_private.value = newvalue!;
                    },
                  ),
                ),
                MyTextFormLabel(label_text: ':محادثة خاصة')
              ],
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
                MyTextFormLabel(label_text: ':استلام الاشعارات')
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      key: Key('updatedata'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255),
                        onPrimary: Color.fromARGB(255, 0, 0, 0),
                      ),
                      onPressed: () {
                        controller.UpdateUserData(_image);
                        if (retiriveBool('is_user_register') == true) {
                          Get.to(() => RoomsList());
                        }
                      },
                      child: const Text(
                        'حفظ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      key: Key('userimages'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255),
                        onPrimary: Color.fromARGB(255, 0, 0, 0),
                      ),
                      onPressed: () {
                     
                      },
                      child: const Text(
                        'الملف الشخصي / الصور',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
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
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 50),
              child: GestureDetector(
                child: Text('سياسة الخصوصية'),
                onTap: () {
                  Dialog(
                    child: MyPrivacyDialog(context, 'user_setting'),
                  );
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.only(right: 50),
              child: GestureDetector(
                child: Text(' تسجيل الخروج'),
                onTap: () {
                  Dialog(
                    child: MyPrivacyDialog(context, 'user_setting'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
