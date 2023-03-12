import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

const String url = 'https://iraqchatapp.pythonanywhere.com/';
Map<String, dynamic> jsonheaders = {
  'Content-Type': 'application/json',
};
Map<String, dynamic> formheaders = {
  'Content-Type': 'application/json',
};

var client = http.Client();
final dio = Dio();
Future<dynamic> PutUpdateUser(
    Map<String, dynamic> data, String endpoint) async {
  try {
    var _headers;
    var formData;
    final fullUrl = url + endpoint;
    if (!data['image'].path.toString().contains('https')) {
      _headers = formheaders;
      final imageFile = data['image'];
      final imageName = imageFile.path.split('/').last;
      data['image'] =
          await MultipartFile.fromFile(imageFile.path, filename: imageName);
      formData = FormData.fromMap(data);
    } else {
      _headers = jsonheaders;
      data.remove('image');
      formData = data;
    }
    try {
      print('data sending sir $formData');
      final response = await dio.put(fullUrl,
          data: formData, options: Options(headers: _headers));
      print('responsecode ${response.statusCode}');
      return response.data;
    } on DioError catch (e) {
      print('eroor :  ${e.response}  ${e.response!.statusCode}');

      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return 'name_exist';
        }
      } else {
        return 'server_error';
      }
    }
    return 'respp';
  } catch (e) {
    print('error sending request sir $e');
  }
}
