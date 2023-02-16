import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

class GETX_TEST extends StatefulWidget {
  const GETX_TEST({Key? key}) : super(key: key);

  @override
  State<GETX_TEST> createState() => _GETX_TESTState();
}

class _GETX_TESTState extends State<GETX_TEST> {
  TextEditingController txtcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color.fromARGB(255, 228, 211, 211),
            endDrawer: mydrawer(),
            appBar: myappbar(),
            body: Center(
              child: Column(
                children: [
                  Text('page  2  '),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('go page 1'),
                  ),
                  TextField(
                    controller: txtcon,
                  ),
                ],
              ),
            )));
  }
}

MyTextInput() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: TextFormField(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: 'hint', //hint text
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      validator: (value) {},
    ),
  );
}
