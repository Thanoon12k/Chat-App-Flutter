import 'dart:io';

class UserModel {
  String? name;
  File? image;
  int? id;
  bool? newUser;
  String? token;

  UserModel({this.name, this.image, this.id, this.newUser, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    id = json['id'];
    newUser = json['new_user'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['id'] = this.id;
    data['new_user'] = this.newUser;
    data['token'] = this.token;
    return data;
  }
}
