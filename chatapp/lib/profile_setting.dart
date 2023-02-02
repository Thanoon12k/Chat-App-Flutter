import 'package:chatapp/rooms.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  List<DropdownMenuItem<String>> get genderitems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ذكر"), value: "male"),
      DropdownMenuItem(child: Text("انثى"), value: "famle"),
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

  String notificationdefault = "icon_image";
  String genderdefault = "male";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Image(
                image: AssetImage('assets/app_images/appbaricon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ],
          toolbarHeight: 50,
          backgroundColor: Color.fromARGB(255, 228, 211, 211),
        ),
        body: Column(textDirection: TextDirection.rtl, children: [
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
            labelStyle:
                TextStyle(fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
          )),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Image(
                  width: 70,
                  image: AssetImage('assets/app_images/appbaricon.jpg'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                  value: notificationdefault,
                  onChanged: (String? newValue) {
                    setState(() {
                      notificationdefault = newValue!;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                  value: genderdefault,
                  onChanged: (String? newValue) {
                    setState(() {
                      genderdefault = newValue!;
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Rooms()),
                );
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
