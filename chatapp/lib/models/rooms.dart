import 'dart:convert';

import 'dart:ffi';

import 'package:flutter/foundation.dart';

List<ModelRoom> roomfromjson(String str) {
  debugPrint(' not done');
  List<ModelRoom>.from(json.decode(str).map((x) => ModelRoom.fromJson(x)));

  debugPrint('done');
  return List<ModelRoom>.from(
      json.decode(str).map((x) => ModelRoom.fromJson(x)));
}

String userToJson(List<ModelRoom> data) {
  return json.encode(List<String>.from(data.map((x) => x.toJson())));
}

class ModelRoom {
 
  int? id;
  String? name;
  String? image;
  
 ModelRoom({
    this.id,
    this.name,
    this.image,
    this.users_count,
  });

  List<ModelMembers>? users_count;

  factory ModelRoom.fromJson(Map<String, dynamic> json) => ModelRoom(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        users_count: json["users_count"] != null
            ? List<ModelMembers>.from(
                json["users_count"].map((x) => ModelMembers.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "users_count": users_count != null
            ? List<dynamic>.from(users_count!.map((x) => x.toJson()))
            : [],
      };
}

class ModelMembers {
  ModelMembers({
    this.id,
    this.name,
    this.gender,
  });

  String? id;
  String? name;
  Bool? gender;
  factory ModelMembers.fromJson(Map<String, dynamic> json) => ModelMembers(
        gender: json["gender"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gender": gender,
        "name": name,
      };
}
