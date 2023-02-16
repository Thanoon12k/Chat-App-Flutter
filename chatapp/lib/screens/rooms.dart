// import 'package:chatapp/screens/profile_view.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:chatapp/models/Rooms.dart';
import 'package:chatapp/screens/messages.dart';

import 'package:flutter/material.dart';

import '../serivces/GEts.dart';
import '../widgets/appbar.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: listbuilser(),
      ),
    );
  }
}

//
class listbuilser extends StatelessWidget {
  listbuilser({Key? key}) : super(key: key);

  Future<dynamic> getjson() async {
    var jsonrooms = await Get_rooms_list('rooms');
    return jsonrooms;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getjson(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<RoomModel> roomslist =
              (jsonDecode(snapshot.data) as List<dynamic>)
                  .map((dynamic item) =>
                      RoomModel.fromJson(item as Map<String, dynamic>))
                  .toList();

          return ListView.builder(
              itemCount: roomslist.length,
              itemBuilder: ((context, index) {
                if (index.isEven && index != (roomslist.length) - 1) {
                  return Row(children: [
                    RoomCard(context, roomslist, index),
                    RoomCard(context, roomslist, index + 1)
                  ]);
                } else if ((roomslist.length).isOdd &&
                    index == (roomslist.length) - 1) {
                  return Row(children: [
                    RoomCard(context, roomslist, index),
                    Container()
                  ]);
                } else {
                  return Container();
                }
              }));
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        }
      },
    );
  }
}

RoomCard(context, roomslist, index) {
  //}, myicondata, changeicon) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
    child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Messages(roomid: roomslist![index].id);
        }));
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
                          roomslist![index].users_count.toString(),
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
                      roomslist[index].name,
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
