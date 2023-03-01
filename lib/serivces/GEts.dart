import 'dart:convert';

import 'package:chatapp/models/Messages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

const String url = 'https://iraqchatapp.pythonanywhere.com/';

Future GetRooms(String endpoint) async {
  var full_url = Uri.parse(url + endpoint);
  var client = http.Client();
  var response = await client.get(full_url);
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future Get_messages_list(String text) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('messages');
  DataSnapshot snapshot = await ref.get();
  List messagesList = [];
  snapshot.children.forEach((element) {
    messagesList.add(element.value!);
  });
  var last_msg = messagesList.last;
  print('>> : ${last_msg}');
  return messagesList;
}
