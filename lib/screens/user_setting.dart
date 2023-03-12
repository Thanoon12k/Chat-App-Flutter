import 'dart:ffi';
import 'dart:io';

import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/serivces/media_manager.dart';
import 'package:chatapp/widgets/lists.dart';
import 'package:chatapp/widgets/textformfield.dart';
import 'package:chatapp/widgets/textformlabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/user_setting_controller.dart';
import '../models/Users.dart';
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
  @override
  Widget build(BuildContext context) {
    var user = controller.user.value;
    print('user in ui : $user');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 228, 211, 211),
      appBar: myappbar(),
      body: FutureBuilder<UserModel>(
          future: controller.fetchuser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var myuser = snapshot.data;
              user = snapshot.data;

              return Form(
                key: controller.userupdateformkey,
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
                          return MyTextFormLabel(label_text: user!.birthdate);
                        }),
                        // IconButton(
                        //   onPressed: () => controller.get_Date(context),
                        //   icon: Icon(
                        //     Icons.date_range,
                        //     color: Colors.blue,
                        //   ),
                        // ),
                        MyTextFormLabel(label_text: ':تاريخ الميلاد'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: 'user!.gender',
                          items: ListsManager().list_gender,
                          onChanged: (String? val) {
                            user!.gender = val!;
                          },
                        ),
                        MyTextFormLabel(label_text: ':الجنس')
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: _image.value != null
                              ? Image.file(
                                  File(_image.value!.path),
                                  width: 150,
                                  height: 150,
                                )
                              : SizedBox(
                                  width: 1,
                                ),
                        ),
                        Row(
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
                                        _image.value =
                                            await GetLocalImage(context);
                                      },
                                      icon: Icon(Icons.camera_alt_outlined),
                                      iconSize: 40)
                            ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: 'user!.comments',
                          items: ListsManager().list_comments,
                          onChanged: (String? val) {
                            if (val == null || val == 'false') {
                              user!.comments = false;
                            } else if (val == 'true') {
                              user!.comments = true;
                            }
                          },
                        ),
                        MyTextFormLabel(label_text: ':التعليقات')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: 'user!.private.toString()',
                          items: ListsManager().list_private,
                          onChanged: (String? val) {
                            if (val == null || val == 'false') {
                              user!.private = false;
                            } else if (val == 'true') {
                              user!.private = true;
                            }
                          },
                        ),
                        MyTextFormLabel(label_text: ':محادثة خاصة')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: user!.notification,
                          items: ListsManager().list_notification,
                          onChanged: (String? val) {
                            user!.notification = val!;
                          },
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
                              onPressed: () async {
                                await controller.UpdateNow(_image);
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
                              onPressed: () {},
                              child: const Text(
                                'الملف الشخصي / الصور',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
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
              );
            } else {
              return Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
            }
          }),
    );
  }
}
