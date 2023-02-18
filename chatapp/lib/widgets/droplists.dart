import 'package:flutter/material.dart';

class DropDownLists {
  String defaul_value = 'icon_image';
  String lablel = 'icon_image';

    List<DropdownMenuItem<String>>? listnotificationitems = [
      DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
      DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
      DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
    ];

  

  droplist() {
    return DropdownButton(
      value: defaul_value,
      items: listnotificationitems,
      onChanged: (value) {
        defaul_value = value.toString();
      },
    );
  }

  
}
