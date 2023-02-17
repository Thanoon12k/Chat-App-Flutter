import 'dart:math';

import 'package:chatapp/models/foods.dart';
import 'package:chatapp/screens/get2.dart';
import 'package:chatapp/screens/rooms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/appbar.dart';

class GETX1 extends StatefulWidget {
  const GETX1({Key? key}) : super(key: key);

  @override
  State<GETX1> createState() => _GETX1State();
}

class _GETX1State extends State<GETX1> {
  TextEditingController txtcon = TextEditingController();
  FoodsList ff = Get.put(FoodsList());
  var text = 'here i am '.obs;
  RxInt i = 0.obs;
  List foods = ['f1', 'f2'].obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 211, 211),
      endDrawer: mydrawer(),
      appBar: myappbar(),
      body: Center(
        child: Column(
          children: [
            Text('page  1  '),
            Obx(() => Text(text.value)),
            ElevatedButton(
              onPressed: () {
                foods.add('help ${Random().nextInt(50)}');
                text.value = 'your welcome ${Random().nextInt(50)}';

                // Get.to(RoomsList());
                // Get.off(GETX2()); go to it  with no return never
                // Get.toNamed('/GETX2');
              },
              child: Text('Tester '),
            ),
            Expanded(
              child: Obx(
                (() => ListView.builder(
                      itemCount: ff.drinks.length,
                      itemBuilder: (context, index) => ListTile(
                        trailing: Text(ff.drinks[index]),
                        onTap: () {
                          ff.drinks.add('help ${i.value++}');
                        },
                      ),
                    )),
              ),
            ),
            TextField(
              controller: txtcon,
            )
          ],
        ),
      ),
    );
  }
}
