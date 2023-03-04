import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeKey(String? key, String? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key!, value!);
}

Future<void> storelist(String? key, List<String> strings) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key!, strings);
}

Future<void> storeInt(String? key, int? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key!, value!);
}

Future<void> storeBoolen(String Key, bool is_user_registered) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(Key, is_user_registered);
}

Future<int?> rereint(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('id');
}

Future<String?> retiriveString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? null;
}

Future<List<String>?> retiriveList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key) ?? null;
}

Future<bool> retiriveBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<void> removeKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<void> remove_all_userdata() async {
  await removeKey('id');
  await removeKey('is_user_registered');
  await removeKey('name');
  await removeKey('token');
}
