import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class GetMessages extends GetxController {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('messages');
  final messagesList = [].obs;
  void getData() {
    ref.onValue.listen((event) {
      messagesList.clear(); // clear the existing list before adding new values
      event.snapshot.children.forEach((element) {
        messagesList.add(element.value!);
      });
    });
  }
}
