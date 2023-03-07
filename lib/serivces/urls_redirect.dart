
  import 'package:url_launcher/url_launcher.dart';

Future<void> Go_to_url(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}