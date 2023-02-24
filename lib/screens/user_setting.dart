import 'package:chatapp/screens/rooms.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/datepicker.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  List<DropdownMenuItem<String>> get genderitems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ذكر"), value: "male"),
      DropdownMenuItem(child: Text("انثى"), value: "famle"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get commentsitems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("السماح للجميع بالتعليق"), value: "allow_comments"),
      DropdownMenuItem(child: Text("لا تسمح"), value: "deny_comments"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get privateitems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("السماح بالخاص"), value: "allow_private"),
      DropdownMenuItem(child: Text("لا تسمح"), value: "deny_private"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get notificationitems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
      DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
      DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
    ];
    return menuItems;
  }

  String gender_default = "male";
  String commnets_default = "allow_comments";
  String private_default = "allow_private";
  String notification_default = "icon_image";
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        appBar: myappbar(),
        endDrawer: mydrawer(),
        body: Column(textDirection: TextDirection.rtl, children: [
          ////name input
          TextField(
            decoration: InputDecoration(
              labelText: "الاسم :", //babel text
              hintText: "اكتب اسمك هنا", //hint text
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),

              hintStyle: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w100), //hint text style
              labelStyle: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
            ),
          ),
          //////////status input
          TextField(
            decoration: InputDecoration(
              labelText: "الحالة :", //babel text
              hintText: " الحالة (اختياري )", //hint text
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),

              hintStyle: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w100), //hint text style
              labelStyle: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
            ),
          ),
          ////////////////birthday input
          DatePicker(),
          //////////////image input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Image(
                  width: 70,
                  image: AssetImage('assets/girl.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                '  : صورة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color.fromARGB(255, 12, 12, 12),
                ),
              ),
            ],
          ),
          ///////////////////////notification input
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                  value: notification_default,
                  onChanged: (String? newValue) {
                    setState(() {
                      notification_default = newValue!;
                    });
                  },
                  items: notificationitems),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
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
          ////////////////////////////////gender input
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                  value: gender_default,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender_default = newValue!;
                    });
                  },
                  items: genderitems),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  '  :  الجنس ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color.fromARGB(255, 12, 12, 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Get.to(() => RoomsList());
              },
              child: Text('حفظ'),
            ),
          ),
          Text(
            'سياسة الخصوصية',
            style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 12,
              color: Color.fromARGB(255, 12, 12, 12),
            ),
          ),
        ]),
      ),
    );
  }
}
