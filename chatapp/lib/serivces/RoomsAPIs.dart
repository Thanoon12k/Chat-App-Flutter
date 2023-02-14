import 'dart:convert';
import 'package:chatapp/models/quick_rooms.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

const String url = 'https://iraqchatapp.pythonanywhere.com/api/';

var client = http.Client();
var _headers = {
  'Content-Type': 'multipart/form-data',
};
var headers = {
  'Content-Type': 'multipart/form-data',
};

Future upload_user_data(data, String endpoint) async {
  var full_url = url + endpoint;
  final dio = Dio();

  String filename = data['image'].path.split('/').last;
  String filepath = data['image'].path;
  debugPrint(
      'data sending sir .. : ${data['name']},${data['status']},${data['notification']} ');

  final formData = FormData.fromMap({
    'name': data['name'],
    'notification': data['notification'],
    'status': data['status'],
    'image': await MultipartFile.fromFile(filepath, filename: filename),
  });
  final response = await dio.post(full_url,
      data: formData,
      options: Options(
          validateStatus: (status) {
            return true;
          }));

  debugPrint('status code : ${response} body ${response.data}');
  return response;
}
