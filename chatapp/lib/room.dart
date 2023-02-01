import 'package:flutter/material.dart';

class Rooms extends StatelessWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 25,
          backgroundColor: Color.fromARGB(255, 211, 143, 65),
          title: Text('دردشة شباب وبنات العراق'),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        body: Column(children: [
          
          TextField(
              decoration: InputDecoration(
            labelText: "ROOM!", //babel text
            hintText: "اكتب اسمك هنا", //hint text
            prefixIcon: Icon(Icons.person), //prefix iocn

            hintStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w100), //hint text style
            labelStyle:
                TextStyle(fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
          )),
          TextField(
              decoration: InputDecoration(
            labelText: "ROOM2", //babel text
            hintText: "الوصف (اختياري )", //hint text
            prefixIcon: Icon(Icons.person), //prefix iocn

            hintStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w100), //hint text style
            labelStyle:
                TextStyle(fontSize: 13, color: Color.fromARGB(255, 12, 12, 12)),
          )),
          Text('data'),
            
         ElevatedButton(
          onPressed: () {
           Navigator.pop(context);
          }, child: null,
        ),
        
        ]),
        
      ),
    );
  }
}
