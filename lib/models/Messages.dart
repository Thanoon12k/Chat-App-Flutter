// To parse this JSON data, do
//
//     final MessagesModel = MessagesModelFromJson(jsonString);

import 'dart:convert';

List<MessagesModel> messagesmodelFromJson(String str) =>
    List<MessagesModel>.from(
        json.decode(str).map((x) => MessagesModel.fromJson(x)));

String messagesmodelToJson(List<MessagesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessagesModel {
  MessagesModel({
    this.id,
    this.sender,
    this.sender_name,
    this.room_id,
    this.text,
    this.attachment,
    this.addtime,
  });

  int? id;
  int? sender;
  String? sender_name;
  int? room_id;
  String? text;
  dynamic? attachment;
  DateTime? addtime;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
        id: json["id"],
        sender: json["sender"],
        sender_name: json["sender_name"],
        room_id: json["room_id"],
        text: json["text"],
        attachment: json["attachment"],
        addtime: DateTime.parse(json["addtime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "sender_name": sender_name,
        "room_id": room_id,
        "text": text,
        "attachment": attachment,
        "addtime": addtime.toString(),
      };
}
