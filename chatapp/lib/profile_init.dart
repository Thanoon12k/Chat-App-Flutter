import 'dart:io';

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
  XFile? image;
  final name_controller = TextEditingController();
  final status_controller = TextEditingController();
// final gender_controller = controlle();

  final ImagePicker picker = ImagePicker();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name_controller.dispose();
    status_controller.dispose();
    super.dispose();
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    uploadimage() {
      setState(() {
        image = img;
      });
    }
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
          MyImageInput(),
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
                    debugPrint('image: ${image}');
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

class MyImageInput extends StatefulWidget {
  @override
  _MyImageInputState createState() => _MyImageInputState();
}

class _MyImageInputState extends State<MyImageInput> {
  File? _image;

  void _getImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image as File;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: _image == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 40,
                  ),
                  onPressed: () {
                    _getImage(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 2, 0),
                  child: Text('اضافة صورة'),
                ),
              ],
            )
          : Image.file(
              _image!,
              fit: BoxFit.cover,
              width: double.infinity,
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
