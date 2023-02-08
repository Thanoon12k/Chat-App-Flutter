import 'package:chatapp/private.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyRow(context),
                      MyRow(context),
                      MyRow(context),
                      MyRow(context),
                      MyRow(context),
                    ],
                  ),
                ),
              ),
              MyTextInput()
            ],
          ),
        ),
      ),
    );
  }
}

MyRow(context) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Private()),
            );
          },
          child: Image(
            height: 50,
            image: AssetImage('assets/girl.png'),
          ),
        ),
      ),
      Card(
        color: Color.fromARGB(255, 233, 232, 186),
        child: Wrap(
          alignment: WrapAlignment.end,
          children: <Widget>[
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text(" احمد العراقي  "),
                      ),
                      Expanded(child: Text('')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text("  10:10  "),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 10, 0, 5),
                        child: Icon(Icons.not_interested_rounded),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" مرحبا بكم"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

MyTextInput() {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: " اكتب رسالة....",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.attach_file_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
