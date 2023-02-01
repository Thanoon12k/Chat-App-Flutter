// import 'dart:html';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'package:chatapp/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        // add this
        textDirection: TextDirection.rtl,
        child: Profile(),
      ),
    );
  }
}
