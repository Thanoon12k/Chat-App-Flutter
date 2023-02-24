import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextInputs extends GetxController {
  String? hint;
  TextEditingController controller;
  TextInputs({
    required this.hint,
   required this.controller,
  });
  TextInput1() {
   
    if (hint == 'name_hint') {
      hint = ' اكتب اسمك هنا ';
    } else if (hint == 'status_hint') {
      hint = 'اكتب الحالة هنا (اختياري *)';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextFormField(
        controller: controller,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint, //hint text
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
