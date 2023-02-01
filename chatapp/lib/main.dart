import 'package:chatapp/profile.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showDialogAfter5Seconds(context);
  }

  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/app_images/appbaricon.jpg'),
      fit: BoxFit.cover,
    );
  }
}

Future<void> _showDialogAfter5Seconds(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  String text =
      """Clients on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.
nts on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business information you share and/or store with us. This Privacy Policy applies to transactions and activities and data gathered through the Clients on Demand Website and interaction you may have with its related Social Media accounts. Please review this Privacy Policy periodically as we may revise it without notice.

Generally, we may collect and use personal information for many purposes, including, but not limited to: billing, product and service fulfillment, understanding customer needs, providing a better website, improving products and services, and communicating with customers and potential customers regarding our products and services with third-party products and services.""";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  wordSpacing: 3,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
                child: ElevatedButton(
                  onPressed: () => _show_rate_us_dialog(context),
                  child: Text('اوافق'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void _show_rate_us_dialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('هل اعجبك التطبيق قيمنا الان 😍😍😍؟'),
        actionsAlignment: MainAxisAlignment.start,
        actions: <Widget>[
          ElevatedButton(
            child: Text('نعم'),
            onPressed: () {
              // final uri =
              //     Uri.parse('https://www.youtube.com/watch?v=1tGBCpx4gEU');
              // launchUrl(uri);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
          ),
          ElevatedButton(
            child: Text('لا'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
          ),
        ],
      );
    },
  );
}
