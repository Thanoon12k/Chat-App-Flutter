import 'package:chatapp/screens/get2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';

class GETX1 extends StatefulWidget {
  const GETX1({Key? key}) : super(key: key);

  @override
  State<GETX1> createState() => _GETX1State();
}

class _GETX1State extends State<GETX1> {
  TextEditingController txtcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Center(
          child: Column(
            children: [
              Text('page  1  '),
              ElevatedButton(
                onPressed: () {
                  Get.to(GETX2());
                  // Get.off(GETX2());
                  // Get.toNamed('/GETX2');
                  // on flutter if we write init route we must remove home from meterial app
                },
                child: Text('go page 2 '),
              ),
              TextField(
                controller: txtcon,
              )
            ],
          ),
        ),
      ),
    );
  }
}
