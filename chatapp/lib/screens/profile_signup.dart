import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
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
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Image(
                image: AssetImage('assets/icons/avatar.jpg'),
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
                  image: AssetImage('assets/icons/girl.jpg'),
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


// Working hard to provide for my family and two children (Salam and Ahmad) to build a better future for them. I'm a recent graduate from computer technical engineering college with a good degree, search a lot for work and couldn't find any kind of works that can help me to develop my future both academically and better life for my family . because all companies I want to enroll with it refused me.
// so I decided to make to work hard to get a job even with my hard-working for the amount of suffering and online learning had no result,
// so lastly i start to learn software developments start from learn  C++ C# python then django then react then flutter lastly now iam learning sotware development but i have no money to paid for this ourse at all w then java but need these courses to join new work that helped me.  \\\


// to be honeset iam aim to do different in the world and that no such dream it is my goal .
// even I know that reality is so difficult now but time is changing .
// and with the change in time I take small steps towards my great goal .
// I believe in myself that I can make the technology and help the companies I work with them to find easier solutions and intelligence to their customer issues.
// I'm thinking of ending my career in development in the background to do something better and new for Internet users all over the world.
// and help them to access information in better ways with less predictable errors that may occur.
// and I think this class is going to help me move forward even if it's a small step.
// but it will make a certain difference in my soul and heart that this is the first valuable certifecate I'm going to have from the largest company in the world .