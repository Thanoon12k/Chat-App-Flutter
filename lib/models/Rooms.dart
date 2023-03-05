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
    this.users_count,
    this.image,
    this.addtime,
    this.password,
    this.admins_password,
  });

  int? id;
  String? name;
  String? password;
  String? admins_password;
  int? owner;
  int? users_count;
  dynamic image;
  DateTime? addtime;

  factory RoomsModel.fromJson(Map<String, dynamic> json) => RoomsModel(
        id: json["id"],
        name: json["name"],
        password: json["password"],
        admins_password: json["admins_password"],
        owner: json["owner"],
        users_count: json["users_count"],
        image: json["image"],
        addtime: DateTime.parse(json["addtime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "admins_password": admins_password,
        "owner": owner,
        "users_count": users_count,
        "image": image,
        "addtime": addtime.toString(),
      };
}
