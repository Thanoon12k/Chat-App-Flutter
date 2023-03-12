import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/lists.dart';
import 'package:chatapp/widgets/textformfield.dart';
import 'package:chatapp/widgets/textformlabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/user_setting_controller.dart';

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
    if (controller.user_null == true) {
      print('iam in null ${controller.selected_notification}');
    } else {
      print('iam not null ${controller.selected_notification}');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 228, 211, 211),
      appBar: myappbar(),
      body: Obx(
        () => Visibility(
            visible: controller.user_null.value == false,
            replacement: process_circle(),
            child: MyUserSettingForm(
              controller: controller,
            )),
      ),
    );
  }
}

class MyUserSettingForm extends StatelessWidget {
  UserSettingController controller;
  MyUserSettingForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.userupdateformkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MyTextFormField(
            controller: controller.namecontroller,
            validator: (v) => controller.TextValidator(v),
            field_label: ' الاسم',
          ),
          MyTextFormField(
            controller: controller.statuscontroller,
            validator: (v) => controller.TextValidator(v),
            field_label: ' الحالة',
          ),
          GetBuilder<UserSettingController>(
            id: 'gendermenu',
            builder: (context) {
              return MenuRow(
                  context, ' : الجنس ', ListsManager().list_gender, 'm');
            },
          ),
          MenuRow(context, ' : الخاص ', ListsManager().list_private, 'false'),
          MenuRow(
              context, ' : التعليقات ', ListsManager().list_comments, 'false'),
          MenuRow(context, ' : الاشعارات ', ListsManager().list_notification,
              'icon_image'),
        ],
      ),
    );
  }
}

MenuRow(context, row_label, menu_name, menu_value) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 0, 12, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: menu_value,
          items: menu_name,
          onChanged: (String? val) {
            // controller.selected_notification.value = val!;
          },
        ),
        SizedBox(
          width: 40,
        ),
        MyTextFormLabel(label_text: row_label),
      ],
    ),
  );
}

process_circle() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
    child: CircularProgressIndicator(
      color: Colors.red,
    ),
  );
}

image_frame() {}
