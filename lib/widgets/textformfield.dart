import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextDirection? field_textDirection;
  final TextAlign? field_textAlign;
  final String? field_hint;
  final Icon? field_icon;
  final Color? field_color;

  MyTextFormField({
    required this.controller,
    required this.validator,
    this.field_textAlign,
    this.field_textDirection,
    this.field_hint,
    this.field_icon,
    this.field_color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        textDirection: field_textDirection ?? TextDirection.rtl,
        textAlign: field_textAlign ?? TextAlign.right,
        decoration: InputDecoration(
          hintText: field_hint ?? '*',
          prefixIcon: Icon(
            Icons.person,
            color: field_color ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
