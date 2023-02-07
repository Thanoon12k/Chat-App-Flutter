import 'package:chatapp/profile_init.dart';
import 'package:chatapp/rooms.dart';
import 'package:chatapp/messages.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Messages());
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
    return Container(
      child: Image(
        image: AssetImage('assets/sky2.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}

Future<void> _showDialogAfter5Seconds(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  String text =
      """Clients on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) 
      is committed to protecting both the personal as well as business 
      information you share and/or store with us. This Privacy Policy 
      applies to transactions and activities and data gathered through the
       Clients on Demand Website and interaction you may have with its
        related Social Media accounts. Please review this Privacy Policy
         periodically as we may revise it without notice.""";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 35),
        child: Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
                  child: ElevatedButton(
                    onPressed: () => _show_rate_us_dialog(context),
                    child: Text(
                      'اوافق',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                    ),
                  ),
                )
              ],
            ),
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
                MaterialPageRoute(
                    builder: (context) => const Profile_StartUp()),
              );
            },
          ),
          ElevatedButton(
            child: Text('لا'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Profile_StartUp()),
              );
            },
          ),
        ],
      );
    },
  );
}
