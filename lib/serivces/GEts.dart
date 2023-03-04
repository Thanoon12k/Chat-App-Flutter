import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'https://iraqchatapp.pythonanywhere.com/';
var dio = Dio();

Future GetRooms(String endpoint) async {
  var full_url = Uri.parse(url + endpoint);
  var response = await dio.getUri(
    full_url,
  );
  if (response.statusCode == 200) {
    return json.encode(response.data);
  } else {
    return null;
  }
}
