import 'dart:io';
import 'dart:typed_data';

import 'package:chatapp/rooms.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile_Inite extends StatefulWidget {
  const Profile_Inite({Key? key}) : super(key: key);

  @override
  State<Profile_Inite> createState() => _Profile_IniteState();
}

class _Profile_IniteState extends State<Profile_Inite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 228, 211, 211),
        appBar: AppBar_init(),
        body: UserDataForm());
  }
}

class UserDataForm extends StatefulWidget {
  const UserDataForm({Key? key}) : super(key: key);

  @override
  State<UserDataForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  Map<String, String> fieldValues = {};
  String _droplist_value = "icon_image";
  final _formKey = GlobalKey<FormState>();

  final name_controller = TextEditingController();
  final status_controller = TextEditingController();
  @override
  void dispose() {
    name_controller.dispose();
    status_controller.dispose();
    super.dispose();
  }

  File? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextInput(name_controller, 'اكتب اسمك'),
          MyTextInput(status_controller, ' اكتب الحالة ( اختياري* )'),
          Center(
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                //if user click this button, user can upload image from gallery
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.image),
                                    Text('From Gallery'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                //if user click this button. user can upload image from camera
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImage(ImageSource.camera);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.camera),
                                    Text('From Camera'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(Icons.camera_alt_outlined),
                iconSize: 40),
          ),
          Center(
            child: image == null
                ? Text("No image selected.")
                : Image.file(image!, width: 150),
          ),
          Row(
            //notification
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                value: _droplist_value,
                items: NotifyItems(),
                onChanged: (String? newValue) {
                  setState(() {
                    _droplist_value = newValue!;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  '  : استلام الاشعارات ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color.fromARGB(255, 12, 12, 12),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                  onPrimary: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    debugPrint('ok good form ');
                    debugPrint('name: ${name_controller.text}');
                    debugPrint('status: ${status_controller.text}');
                    debugPrint('gender: ${_droplist_value}');
                    debugPrint('image: ${image!}');
                  } else {
                    debugPrint('not valid!!!!');
                  }
                },
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

MyTextInput(mycontroller, hint) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: TextFormField(
      textDirection: TextDirection.rtl,
      controller: mycontroller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint, //hint text
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    ),
  );
}

NotifyItems() {
  List<DropdownMenuItem<String>>? myitems = [
    DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
    DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
    DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
  ];

  return myitems;
}
