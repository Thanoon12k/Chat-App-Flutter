import 'package:flutter/material.dart';

class ListsManager{
  
  List<DropdownMenuItem<String>> list_notification = [
    DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
    DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
    DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
  ];

  List<DropdownMenuItem<String>> list_gender = [
    DropdownMenuItem(child: Text("ذكر"), value: "male"),
    DropdownMenuItem(child: Text("انثى"), value: "famle"),
  ];
  List<DropdownMenuItem<String>> list_comments = [
    DropdownMenuItem(child: Text("السماح للجميع بالتعليق"), value: "allow"),
    DropdownMenuItem(child: Text("لا تسمح"), value: "disallow"),
  ];
  List<DropdownMenuItem<String>> list_private = [
    DropdownMenuItem(child: Text("السماح  بالخاص"), value: "allow"),
    DropdownMenuItem(child: Text("لا تسمح"), value: "disallow"),
  ];

}