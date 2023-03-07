import 'package:dio/dio.dart';
import 'dart:convert';

const String url = 'https://iraqchatapp.pythonanywhere.com/';
var dio = Dio();

Future GetRooms(String endpoint) async {
  var full_url = Uri.parse(url + endpoint);
  try {
    var response = await dio.getUri(
      full_url,
    );
    if (response.statusCode == 200) {
      return json.encode(response.data);
    } else {
      return null;
    }
  } on DioError catch (e) {
    print('error getiing rooms !! $e');
  }
}
