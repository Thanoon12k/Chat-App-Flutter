import 'dart:io';

import 'package:chatapp/screens/user_view.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:chatapp/widgets/lists.dart';
import 'package:chatapp/widgets/textformfield.dart';
import 'package:chatapp/widgets/textformlabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/usersetting_con.dart';
import '../serivces/media_manager.dart';
import '../widgets/dialogs.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final UserSettingController controller =
      Get.put<UserSettingController>(UserSettingController());
  @override
  Widget build(BuildContext context) {
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
          GetBuilder<UserSettingController>(
            id: 'name_exist_widget',
            builder: (UserSettingController controller) {
              return controller.name_exist.value
                  ? Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'الاسم مستخدم الرجاء ادخال اسم اخر',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox(width: 0);
            },
          ),
          MyTextFormField(
            controller: controller.statuscontroller,
            validator: (v) => controller.TextValidator(v),
            field_label: ' الحالة',
          ),
          GetBuilder<UserSettingController>(
              id: 'birthdate_widget',
              builder: (UserSettingController controller) {
                return birthdate_row(context, controller);
              }),
          GetBuilder<UserSettingController>(
              id: 'image_widget',
              builder: (UserSettingController controller) {
                return image_rows(context, controller);
              }),
          GetBuilder<UserSettingController>(
              id: 'gender_menu',
              builder: (context) {
                return MenuRow(
                  controller,
                  ' : الجنس ',
                  'gender_list',
                );
              }),
          GetBuilder<UserSettingController>(
              id: 'private_menu',
              builder: (context) {
                return MenuRow(
                  controller,
                  ' : الخاص ',
                  'private_list',
                );
              }),
          GetBuilder<UserSettingController>(
              id: 'comments_menu',
              builder: (context) {
                return MenuRow(
                  controller,
                  ' : التعليقات ',
                  'comments_list',
                );
              }),
          GetBuilder<UserSettingController>(
            id: 'notification_menu',
            builder: (context) {
              return MenuRow(
                controller,
                ' : الاشعارات ',
                'notification_list',
              );
            },
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
                      controller.SendNow();
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
                    onPressed: () => Get.off(() => UserView()),
                    child: const Text(
                      'الملف الشخصي / الصور',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                    child: Text('تسجيل الخروج'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => MyRatingDialog(
                              context, ' 💔💔   هل تريد حقا تسجيل الخروج'));
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: GestureDetector(
                  child: Text('سياسة الخصوصية'),
                  onTap: () {
                    Dialog(
                      child: MyPrivacyDialog(context, 'user_setting'),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

MenuRow(
  controller,
  row_label,
  list_name,
) {
  var _items;
  var _sel_value;
  var _controller_item;
  String _widget_id = '';
  if (list_name == 'gender_list') {
    _items = ListsManager().list_gender;
    _sel_value = controller.selected_gender.value;
    _widget_id = 'gender_menu';
  } else if (list_name == 'private_list') {
    _items = ListsManager().list_private;
    _sel_value = controller.selected_private.value;
    _widget_id = 'private_menu';
  } else if (list_name == 'comments_list') {
    _items = ListsManager().list_comments;
    _sel_value = controller.selected_comments.value;
    _widget_id = 'comments_menu';
  } else if (list_name == 'notification_list') {
    _items = ListsManager().list_notification;
    _sel_value = controller.selected_notification.value;
    _widget_id = 'notification_menu';
  }

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: _sel_value,
          items: _items,
          onChanged: (String? val) {
            if (_widget_id == 'gender_menu')
              controller.selected_gender.value = val;
            else if (_widget_id == 'private_menu')
              controller.selected_private.value = val;
            else if (_widget_id == 'comments_menu')
              controller.selected_comments.value = val;
            else if (_widget_id == 'notification_menu')
              controller.selected_notification.value = val;

            controller.update([_widget_id]);
          },
        ),
        SizedBox(
          width: 10,
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

birthdate_row(context, controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      MyTextFormLabel(label_text: controller.selected_birthdate.value),
      IconButton(
        onPressed: () async {
          final DateTime? _val = await showDatePicker(
              context: context,
              initialDate: DateTime(1999),
              firstDate: DateTime(1960),
              lastDate: DateTime(2025),
              locale: Locale('ar'));
          controller.selected_birthdate.value =
              _val.toString().substring(0, 10);
          controller.update(['birthdate_widget']);
        },
        icon: Icon(
          Icons.date_range,
          color: Color.fromARGB(255, 77, 75, 75),
        ),
      ),
      MyTextFormLabel(label_text: ':تاريخ الميلاد'),
    ],
  );
}

image_rows(context, controller) {
  String _path = controller.selected_image_path.value;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
          onPressed: () async {
            var _picked = await GetLocalImage(context);
            _path = _picked!.path;
            controller.realimage.value = _picked;
            controller.selected_image_path.value = _path;

            controller.update(['image_widget']);
          },
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 35),
      _path != null && _path != '' && _path.contains('http://')
          ? Image.network(
              _path,
              width: 150,
              height: 150,
            )
          : _path != null && _path != '' && !_path.contains('https://')
              ? Image.file(
                  File(_path),
                  width: 150,
                  height: 150,
                )
              : SizedBox(
                  width: 1,
                ),
    ],
  );
}
