import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url = 'https://iraqchatapp.pythonanywhere.com/api/';
var client = http.Client();
Future Init_user_data(data, String endpoint) async {
  final dio = Dio();
  var full_url = url + endpoint;

  String filename = data['image'].path.split('/').last;
  String filepath = data['image'].path;

  final formData = FormData.fromMap({
    'name': data['name'],
    'notification': data['notification'],
    'status': data['status'],
    'image': await MultipartFile.fromFile(filepath, filename: filename),
  });
  debugPrint('request is sending sir .. ');

  final response = await dio.post(
    full_url,
    data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return true;
      },
    ),
  );

  return response;
}
