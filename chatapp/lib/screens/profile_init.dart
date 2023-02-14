import 'dart:io';
import 'dart:typed_data';

import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../serivces/UsersAPIs.dart';

String myid = ' -- ';
String myname = ' -- ';
String mystatus = ' -- ';
String mygender = ' -- ';
String mynotify = ' -- ';

class Profile_Inite extends StatefulWidget {
  const Profile_Inite({Key? key}) : super(key: key);

  @override
  State<Profile_Inite> createState() => _Profile_IniteState();
}

class _Profile_IniteState extends State<Profile_Inite> {
  String _notify_value = "icon_image";

  bool _network_errors = false;
  bool _name_exist = false;
  final _formKey = GlobalKey<FormState>();

  File? _image;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _image = File(img!.path);
    });
  }

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
              MyTextInput('_name', 'اكتب اسمك'),
              MyTextInput('_status', ' اكتب الحالة ( اختياري* )'),
              Center(
                //image
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
                //iamge display box
                child: _image == null
                    ? Text(
                        "No image selected.",
                        style: TextStyle(color: Colors.red),
                      )
                    : Image.file(_image!, width: 150),
              ),
              Row(
                //notification
                //notification
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton(
                    value: _notify_value,
                    items: NotifyItems(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _notify_value = newValue!;
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate() == true &&
                          _image != null) {
                        _formKey.currentState!.save();
                        var data = {
                          'name': myname,
                          'status': mystatus,
                          'notification': _notify_value,
                          'image': _image,
                        };

                        var res =
                            await upload_user_data(data, 'users/user_init');

                        if (res.statusCode == 200 || res.statusCode == 201) {
                          print('ok sent  ${res.statusCode}');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Rooms()),
                          );
                        } else if (res.statusCode == 400) {
                          print('name exist ..  ${res.statusCode}');
                          _name_exist = true;
                        } else {
                          _network_errors = true;
                          print('network error .. ${res.statusCode}');
                        }
                      } else {
                        print('image = 0 or fildes empity');
                      }
                    },
                    child: const Text(
                      'حفظ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Visibility(
                  visible: _network_errors,
                  child: Text(
                    '  network connection error !!  ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Visibility(
                  visible: _name_exist,
                  child: Text(
                    'name already exist write another name .',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

MyTextInput(String fieldname, String hint) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: TextFormField(
      textDirection: TextDirection.rtl,
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
        } else {
          switch (fieldname) {
            case '_name':
              myname = value;
              break;
            case '_status':
              mystatus = value;
              break;

            default:
              debugPrint('Other');
          }

          return null;
        }
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
