// somewhere in your code
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeKey(String? key, String? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key!, value!);
}

Future<void> storeInt(String? key, int? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key!, value!);
}

Future<String?> retrieveKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? null;
}
