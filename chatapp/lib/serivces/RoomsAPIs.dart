import 'package:http/http.dart' as http;

const String url = 'https://iraqchatapp.pythonanywhere.com/api/';

Future Get_rooms_list(String endpoint) async {
  var full_url = Uri.parse(url + endpoint);
  var client = http.Client();
 print('sending');
  
  var response = await client.get(full_url);
 
  if (response.statusCode == 200)
   { print('ok');
    var json = response.body;

    return json;
  } else {
    return null;
  }
}
