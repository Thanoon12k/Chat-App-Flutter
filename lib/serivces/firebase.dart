import 'package:chatapp/serivces/GEts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class MessageGetter extends GetxController {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('messages');
  final messagesList = [].obs;

  void getData() async {
    print('getting messages');
    ref.onValue.listen((event) {
      messagesList.clear(); // clear the existing list before adding new values
      event.snapshot.children.forEach((element) {
        messagesList.add(element.value!);
      });
    });
  }
}
