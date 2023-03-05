import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const String url = 'https://iraqchatapp.pythonanywhere.com/';

var client = http.Client();

Future<dynamic> PostUserRegister(Map data, String endpoint) async {
  final dio = Dio();
  final fullUrl = url + endpoint;
  final imageFile = data['image'] as XFile;
  final imageName = imageFile.path.split('/').last;
  final formData = FormData.fromMap({
    'name': data['name'],
    'notification': data['notification'],
    'status': data['status'],
    'image': await MultipartFile.fromFile(imageFile.path, filename: imageName),
  });
  print('request sending sir ...');
  try {
    final response = await dio.post(fullUrl, data: formData);
    return response.data;
  } on DioError catch (e) {
    if (e.response != null) {
      if (e.response!.statusCode == 400) {
        return 'user_exist';
      }
    } else {
      return 'server_error';
    }
  }
  return 'respp';
}

Future PostMessage(data, String endpoint) async {
  var full_url = url + endpoint;

  final response = await http.post(
    Uri.parse(full_url),
    body: jsonEncode(data),
    headers: {'Content-Type': 'application/json'},
  );

  print('mesesage sent ${response.body}');

  return response;
}
