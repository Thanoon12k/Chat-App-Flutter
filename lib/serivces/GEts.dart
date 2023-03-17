import 'package:dio/dio.dart';
import 'dart:convert';

const String root_url = 'http://38.242.140.198/';
var dio = Dio();

Future GetRooms(String endpoint) async {
  var full_url = Uri.parse(root_url + endpoint);
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

Future GetUserData(endpoint) async {
  var full_url = Uri.parse(root_url + endpoint);
  print('getting user data  $full_url ...');

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
