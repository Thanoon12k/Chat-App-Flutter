import 'dart:io';

class UserModel {
  int? id;
  File? image;
  int? sender;
  
  int? room_id;
  String? text;
  String? addtime;

  UserModel({this.id, this.sender,this.image, this.room_id, this.text, this.addtime});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      sender: json['sender'],
      room_id: json['room_id'],
      text: json['text'],
      addtime: json['addtime'],
    );
  }
}
