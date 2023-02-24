import 'package:flutter/material.dart';

class form1 extends StatefulWidget {
  form1({Key? key,this.minlines=1,required this.text,this.maxlines=1,
    required this.font_size, required this.width, this.height=70,
     this.str="", required this.mycontroller}) : super(key: key);
  final double font_size,width,height;
  final int maxlines,minlines;
  final String text,str;
  final TextEditingController mycontroller;

  @override
  State<form1> createState() => _form1State();
}
class _form1State extends State<form1> {

  @override
  Widget build(BuildContext context) {

    return Container(
        height: widget.height,
        width: widget.width,
      child:    Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: widget.font_size,
            ),
          ),
        ),
        child: TextFormField(

          maxLines: widget.maxlines,
          minLines: widget.minlines,

          controller: widget.mycontroller,

          decoration: InputDecoration(
            labelText: widget.text,

            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Color.fromRGBO(42, 18, 233, 1),width: 3),
            )

          ),
        ),
      )
    );
  }
}