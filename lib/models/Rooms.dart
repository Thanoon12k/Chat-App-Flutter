// To parse this JSON data, do
//
//     final roomsModel = roomsModelFromJson(jsonString);

import 'dart:convert';

List<RoomsModel> roomsModelFromJson(String str) =>
    List<RoomsModel>.from(json.decode(str).map((x) => RoomsModel.fromJson(x)));

String roomsModelToJson(List<RoomsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomsModel {
  RoomsModel({
    this.id,
    this.name,
    this.owner,
    this.usersCount,
    this.image,
    this.addtime,
  });

  int? id;
  String? name;
  int? owner;
  int? usersCount;
  dynamic? image;
  DateTime? addtime;

  factory RoomsModel.fromJson(Map<String, dynamic> json) => RoomsModel(
        id: json["id"],
        name: json["name"],
        owner: json["owner"],
        usersCount: json["users_count"],
        image: json["image"],
        addtime: DateTime.parse(json["addtime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "owner": owner,
        "users_count": usersCount,
        "image": image,
        "addtime": addtime.toString(),
      };
}
