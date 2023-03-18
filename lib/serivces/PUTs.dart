import 'package:chatapp/screens/splashscreen.dart';
import 'package:chatapp/serivces/preference.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as gg;
import 'package:http/http.dart' as http;

const String root_url = 'http://38.242.140.198/';
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
    final fullUrl = root_url + endpoint;
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

Future<dynamic> LogoutUser(String endpoint) async {
  try {
    final fullUrl = root_url + endpoint;
    var _data = {'is_active': false};
    print('logout sending to  $fullUrl');
    final response = await dio.put(fullUrl,
        data: _data, options: Options(headers: jsonheaders));
    print('responsecode ${response.statusCode}');

    removeKey('is_user_registered');
    gg.Get.offAll(() => SplashScreen());
    return response;
  } on DioError catch (e) {
    print(
        'eroor :    ${e.response!.statusCode} ${e.response!.statusMessage} ${e.response!}');

    if (e.response != null) {
      if (e.response!.statusCode == 400) {
        return 'name_exist';
      }
    } else {
      return 'server_error';
    }
  } catch (e) {
    print('error in logout $e');
  }
}

Future<dynamic> PUTStar(int stars, String endpoint) async {
  final fullUrl = root_url + endpoint;
  var _data = {'stars': stars.toString()};
  try {
    print('sending stars $stars to $fullUrl');
    var response = await http.put(Uri.parse(fullUrl), body: _data);
    return true;
  } catch (e) {
    print('error in sending stars : ${e}');
  }
}
