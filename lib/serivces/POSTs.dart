import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Map<String, dynamic> jsonheaders = {
  'Content-Type': 'application/json',
};
Map<String, dynamic> formheaders = {
  'Content-Type': 'application/json',
};

const String root_url = 'http://38.242.140.198/';
var client = http.Client();
final dio = Dio();

Future<dynamic> PostUserRegister(
    Map<String, dynamic> data, String endpoint) async {
  try {
    final fullUrl = root_url + endpoint;
    final imageFile = data['image'] as XFile;
    final imageName = imageFile.path.split('/').last;
    data['image'] =
        await MultipartFile.fromFile(imageFile.path, filename: imageName);
    final formData = FormData.fromMap(data);
    print('userdata sending sir ...$fullUrl');
    try {
      final response = await dio.post(fullUrl, data: formData);
      print('reqquest send done()$response');
      return response.data;
    } on DioError catch (e) {
      print('eroor :  ${e.response}  ${e.response!.statusCode}');

      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return 'user_exist';
        }
      } else {
        return 'server_error';
      }
    }
    return 'respp';
  } catch (e) {
    print('post user error:$e');
  }
}

Future PostMessage(Map<String, dynamic> data, String endpoint) async {
  final formData;
  final response;
  final fullUrl = root_url + endpoint;
  bool have_image = data['image'] != null;
  if (have_image) {
    final imageFile = data['image'] as XFile;
    final imageName = imageFile.path.split('/').last;
    data['image'] =
        await MultipartFile.fromFile(imageFile.path, filename: imageName);
    formData = FormData.fromMap(data);
  } else {
    data.remove('image');
    formData = '';
  }
  try {
    print('request sending sir');
    if (have_image) {
      response = await dio.post(fullUrl, data: formData);
    } else {
      response = await dio.post(fullUrl,
          data: data, options: Options(headers: jsonheaders));
    }

    return response.statusCode;
  } on DioError catch (e) {
    print('eroor :  ${e.response}  ${e.response!.statusCode}');
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

Future POSTcomment(Map<String, dynamic> data, String endpoint) async {
  final formData;
  final response;
  final fullUrl = root_url + endpoint;
  bool have_image = data['image'] != null;
  if (have_image) {
    final imageFile = data['image'] as XFile;
    final imageName = imageFile.path.split('/').last;
    data['image'] =
        await MultipartFile.fromFile(imageFile.path, filename: imageName);
    formData = FormData.fromMap(data);
  } else {
    data.remove('image');
    formData = '';
  }
  try {
    print('request sending sir');
    if (have_image) {
      response = await dio.post(fullUrl, data: formData);
    } else {
      response = await dio.post(fullUrl,
          data: data, options: Options(headers: jsonheaders));
    }

    return response.statusCode;
  } on DioError catch (e) {
    print('eroor :  ${e.response}  ${e.response!.statusCode}');
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
