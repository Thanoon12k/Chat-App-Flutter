import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

const String url = 'https://iraqchatapp.pythonanywhere.com/';

var client = http.Client();
final dio = Dio();
Future<dynamic> PutUpdateUser(
    Map<String, dynamic> data, String endpoint) async {
  final fullUrl = url + endpoint;
  final imageFile = data['image'] as XFile;
  final imageName = imageFile.path.split('/').last;
  data['image'] =
      await MultipartFile.fromFile(imageFile.path, filename: imageName);
  final formData = FormData.fromMap(data);
  print('request sending sir ...');
  try {
    final response = await dio.post(fullUrl, data: formData);
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
}
