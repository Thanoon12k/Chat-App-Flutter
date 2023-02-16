import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chatapp/serivces/POSTs.dart';
import 'package:chatapp/screens/profile_view.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Messages.dart';
import '../serivces/GEts.dart';

bool postmessagecomplete = false;

class Messages extends StatefulWidget {
  final int roomid;
  Messages({Key? key, required this.roomid}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  File? _image;

  final ImagePicker picker = ImagePicker();

  TextEditingController msgcontroller = TextEditingController();
  Future<List<MessgesModel>> getJson() async {
    var jsonmsgs = await Get_messages_list('rooms/${widget.roomid}/messages');
    final List<dynamic> jsonList = jsonDecode(jsonmsgs);

    final List<MessgesModel> msgslist = jsonList
        .map((dynamic item) =>
            MessgesModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return msgslist;
  }

  void refresh() {
    setState(() {});
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _image = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: FutureBuilder<List<MessgesModel>>(
            future: getJson(),
            builder: (BuildContext context,
                AsyncSnapshot<List<MessgesModel>> snapshot) {
              if (snapshot.hasData) {
                final List<MessgesModel> msgslist = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: msgslist.length,
                        itemBuilder: ((context, index) {
                          Color msgcolor;
                          List<Color> colorsarray = [
                            Color.fromARGB(255, 233, 232, 186),
                            Color.fromARGB(255, 186, 233, 221),
                            Color.fromARGB(255, 225, 186, 233),
                            Color.fromARGB(255, 190, 233, 186),
                          ];

                          return MessageRow(
                            context,
                            msgslist[index].sender_name,
                            msgslist[index].text,
                            msgslist[index].addtime,
                            colorsarray[Random().nextInt(colorsarray.length)],
                          );
                        }),
                      ),
                    ),
                    MyTextInput(widget.roomid, msgcontroller, context, refresh,
                        getImage, _image),
                  ],
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}

MessageRow(context, sender, text, addtime, msgcolor) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
          child: Image(
            height: 50,
            image: AssetImage('assets/girl.png'),
          ),
        ),
      ),
      Card(
        color: msgcolor,
        child: Wrap(
          alignment: WrapAlignment.end,
          children: <Widget>[
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text(sender.toString()),
                      ),
                      Expanded(child: Text('')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                        child: Text(addtime),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 10, 0, 5),
                        child: Icon(Icons.not_interested_rounded),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

MyTextInput(int roomid, msgcontroller, context, refresh, getimage, _image) {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: msgcontroller,
                  decoration: InputDecoration(
                      hintText: " اكتب رسالة....",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {
                  return MyImageInput(context, getimage, _image);
                },
                child: Icon(
                  Icons.attach_file_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
              FloatingActionButton(
                onPressed: () {
                  var data = {
                    'text': msgcontroller.text,
                    'room_id': roomid,
                    // 'addtime':
                  };
                  refresh();
                  if (msgcontroller.text != '') {
                    PostMessage(data, 'rooms/$roomid/messages/new');
                    msgcontroller.text = '';
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

MyImageInput(context, getImage, _image) {
  return Column(children: [
    Center(
      //image
      child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          //if user click this button, user can upload image from gallery
                          onPressed: () {
                            Navigator.pop(context);
                            getImage(ImageSource.gallery);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              Text('From Gallery'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          //if user click this button. user can upload image from camera
                          onPressed: () {
                            Navigator.pop(context);
                            getImage(ImageSource.camera);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.camera),
                              Text('From Camera'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          icon: Icon(Icons.camera_alt_outlined),
          iconSize: 40),
    ),
  ]);
}
