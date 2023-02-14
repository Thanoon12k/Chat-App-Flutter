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
  if (data['image'] != null) {
    var full_url = url + endpoint;
    final dio = Dio();

    String filename = data['image'].path.split('/').last;
    String filepath = data['image'].path;
    debugPrint('request is sending sir .. ');
    bool notify = data['notification'];
    debugPrint('data : ${data['name']},${data['status']},${notify} ');
    final formData = FormData.fromMap({
      'name': data['name'],
      'notification': notify,
      'status': data['status'],
      'image': await MultipartFile.fromFile(filepath, filename: filename),
    });
    final response = await dio.post(full_url, data: formData);

    debugPrint('status code : ${response.statusCode} body ${response.data}');
    return response;
  } else {
    debugPrint('image null sir .. ');

    return 'image is null';
  }
}

Future post_user_init(data, String endpoint) async {
  var full_url = url + endpoint;
  debugPrint('url : $full_url');

  var response = await client.post(
    Uri.parse(full_url),
    body: jsonEncode(data),
    headers: _headers,
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    debugPrint('post request  ok');
    var json = response.body;

    return 0;
  } else {
    debugPrint('${response.statusCode}- ${response.body}');

    return null;
  }
}

// class BaseClient {
//   var client = http.Client();
//   var url = Uri.parse(baseUrl + '/rooms/');
//   //GET
//   Future<List<QRoom>?> GET_rooms() async {
//     var response = await client.get(url);
//     if (response.statusCode == 200) {
//       var json = response.body;
//       return roomfromjson(json);
//     } else {
//       return null;
//     }
//   }
// }

// //   //POST
// //   Future<dynamic> post(String api, dynamic object) async {
// //     var url = Uri.parse(baseUrl + api);
// //     var _payload = json.encode(object);
// //     var _headers = {
// //       'Authorization': 'Bearer sfie328370428387=',
// //       'Content-Type': 'application/json',
// //       'api_key': 'ief873fj38uf38uf83u839898989',
// //     };

// //     var response = await client.post(url, body: _payload, headers: _headers);
// //     if (response.statusCode == 201) {
// //       return response.body;
// //     } else {
// //       //throw exception and catch it in UI
// //     }
// //   }

// //   ///PUT Request
// //   Future<dynamic> put(String api, dynamic object) async {
// //     var url = Uri.parse(baseUrl + api);
// //     var _payload = json.encode(object);
// //     var _headers = {
// //       'Authorization': 'Bearer sfie328370428387=',
// //       'Content-Type': 'application/json',
// //       'api_key': 'ief873fj38uf38uf83u839898989',
// //     };

// //     var response = await client.put(url, body: _payload, headers: _headers);
// //     if (response.statusCode == 200) {
// //       return response.body;
// //     } else {
// //       //throw exception and catch it in UI
// //     }
// //   }

// //   //delete
// //   Future<dynamic> delete(String api) async {
// //     var url = Uri.parse(baseUrl + api);
// //     var _headers = {
// //       'Authorization': 'Bearer sfie328370428387=',
// //       'api_key': 'ief873fj38uf38uf83u839898989',
// //     };

// //     var response = await client.delete(url, headers: _headers);
// //     if (response.statusCode == 200) {
// //       return response.body;
// //     } else {
// //       //throw exception and catch it in UI
// //     }
// //   }
// // }
getimagefile(image, name) {
  List<int> imageBytes = image.readAsBytesSync();

  var filetype = 'iamge';
  var filestream = Stream.fromIterable([imageBytes]);
  var filesize = imageBytes.length;
  var filename = name + '.jpg';
  var myfile = new http.MultipartFile(filetype, filestream, filesize,
      filename: filename);
  return myfile;
}
