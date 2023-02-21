import 'dart:io';
import 'dart:typed_data';

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
  State<UserRegister> createState() => _UserInitState();
}

class _UserInitState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();
  final ImageInputs _imageInputs = Get.put(ImageInputs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 228, 211, 211),
        appBar: AppBar_init(),
        body: Form(
          key: _formKey,
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputs(hint: ' اكتب اسمك هنا ', controller: namecontroller)
                  .TextInput1(),
              TextInputs(
                      hint: 'اكتب الحالة هنا (اختياري *)',
                      controller: statuscontroller)
                  .TextInput1(),
              // DropDownLists().droplist(),
              GetBuilder<ImageInputs>(
                init: _imageInputs,
                builder: (_) {
                  return _imageInputs.imagewidget(context);
                },
              ),
              // savebutton(sendform(namecontroller.text, statuscontroller.text, _imageInputs.image.path)),
            ],
          ),
        ));
  }
}

sendform(namecon,statuscon,image) {
 Map data = {
    'name':namecon,
    'status':statuscon,
    'image':image,
  };

  return data;
}
