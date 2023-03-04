import 'package:chatapp/screens/user_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';

MessageRow(context, sender_name, text, sendtime, msgcolor) {
  return GestureDetector(
    onLongPress: () {
      print('row : $sender_name , $text $sendtime ');
    },
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
          child: GestureDetector(
            onTap: () {
              Get.to(() => UserView());
            },
            child: Image(
              height: 50,
              image: AssetImage('assets/girl.png'),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Bubble(
          nipOffset: 25,
          nipHeight: 10,
          nipWidth: 12,
          margin: BubbleEdges.only(top: 10),
          nip: BubbleNip.rightTop,
          color: msgcolor,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: <Widget>[
              Container(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                          child: Text(sender_name.toString()),
                        ),
                        Expanded(child: Text('')),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                          child: Text(sendtime.toString()),
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
    ),
  );
}
