// TODO Implement this library.import 'package:chatapp/rooms.dart';
import 'package:chatapp/screens/user_register.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/screens/rooms.dart';
import 'package:get/get.dart';

String privacy_text =
    """Clients on Demand, LLC, (“Clients on Demand,” “we,” “us,” “our”) is committed to protecting both the personal as well as business  information you share and/or store with us. This Privacy Policy   applies to transactions and activities and data gathered through the  Clients on Demand Website and interaction you may have with its  related Social Media accounts. Please review this Privacy Policy   periodically as we may revise it without notice.""";

MyRatingDialog(context) {
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
          Get.to(() => RoomsList());
        },
      ),
      ElevatedButton(
        child: Text('لا'),
        onPressed: () {
          Get.to(() => RoomsList());
        },
      ),
    ],
  );
}

MyPrivacyDialog(context) {
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
                    privacy_text,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
                  child: ElevatedButton(
                    onPressed: () {
                      print(' to userinit');
                      Get.to(() => UserRegister());
                    },
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

