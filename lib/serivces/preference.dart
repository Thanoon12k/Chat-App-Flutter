// somewhere in your code
import 'package:shared_preferences/shared_preferences.dart';

storeKey(String? key, String? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key!, value!);
}

retrieveKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? null;
}
