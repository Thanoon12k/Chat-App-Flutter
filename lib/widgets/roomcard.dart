import 'package:chatapp/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/messages.dart';

RoomCard(context, room_id, room_name, room_usersCount, room_password) {
  print('index');
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyRoomPasswordDialoge(room_id, room_password);
          },
        );
      },
      child: SizedBox(
        width: (MediaQuery.of(context).size.width) * 0.42,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            child: Stack(
              children: [
                Image(
                  image: AssetImage('assets/sq2.png'),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/girl.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 0, 26, 255)),
                    child: Row(
                      children: [
                        Icon(Icons.group,
                            color: Color.fromARGB(255, 243, 243, 243),
                            size: 25),
                        Text(
                          room_usersCount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 15,
                  child: Container(
                    width: 140,
                    height: 40,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(66, 118, 78, 212),
                            offset: Offset(0, 0),
                            blurRadius: 40,
                            blurStyle: BlurStyle.solid),
                      ],
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 1,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Text(
                      room_name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(66, 23, 9, 219),
                  offset: Offset(0, 0),
                  blurRadius: 40,
                  blurStyle: BlurStyle.solid),
            ],
            border: Border.all(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 1,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
      ),
    ),
  );
}
