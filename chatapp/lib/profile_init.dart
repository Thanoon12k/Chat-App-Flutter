import 'package:chatapp/rooms.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Profile_Inite extends StatefulWidget {
  const Profile_Inite({Key? key}) : super(key: key);

  @override
  State<Profile_Inite> createState() => _Profile_IniteState();
}

class _Profile_IniteState extends State<Profile_Inite> {
  List<DropdownMenuItem<String>> get dropdownItems {
    const List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("ايقونة وصورة"), value: "icon_image"),
      DropdownMenuItem(child: Text("ايقونة فقط "), value: "just_icon"),
      DropdownMenuItem(child: Text("بدون اشعار"), value: "no_alert"),
    ];
    return menuItems;
  }

  String selectedValue = "icon_image";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 228, 211, 211),
        appBar: AppBar_init(),
        body: Column(textDirection: TextDirection.rtl, children: [
          const TextField(
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
          const TextField(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 255),
                onPrimary: Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Rooms()),
                );
              },
              child: const Text(
                'حفظ',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Text(
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
