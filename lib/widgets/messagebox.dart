import 'package:chatapp/screens/user_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';

MessageRow(
    {required BuildContext context,
    required int? sender_id,
    required String? text,
    required String? sender_name,
    required String? sender_image,
    required String? message_image,
    required String? sendtime,
    required Color msgcolor}) {
  return GestureDetector(
    onLongPress: () {
      print('row : $sender_name ,$sender_image $sendtime ');
    },
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => UserView(userviewid: sender_id));
                  },
                  child: sender_image != null
                      ? Image(
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          image: NetworkImage(sender_image),
                        )
                      : Image(
                          height: 50,
                          width: 50,
                          image: AssetImage('assets/avatar.png'),
                        )),
            ),
            SizedBox(
              height: 10,
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(sender_name.toString()),
                            ),
                            Expanded(child: Text('')),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(sendtime.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.not_interested_rounded,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(text!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(0, 8, 40, 10),
          child: Visibility(
            visible: message_image != null,
            child: Image(
              width: 300,
              height: 300,
              image: NetworkImage(
                message_image.toString(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
