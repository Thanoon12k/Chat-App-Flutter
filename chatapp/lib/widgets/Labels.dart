import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Labels extends GetxController{
  bool is_visible = false;
  errorlabel(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Visibility(
        visible: is_visible,
        child: Text(
          text,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  fieldlabel(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color.fromARGB(255, 12, 12, 12),
        ),
      ),
    );
  }
}
