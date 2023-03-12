
import 'dart:ffi';

class UserModel {
  String? name;
String? status;
String? gender;
String? birthdate;
String? notification;
bool? private;
bool? comments;
 String? image;
 int? id;
String? token;

  UserModel({this.name, this.image, this.id,  this.token});

  UserModel.fromJson(Map<String, dynamic> json) {


     id = json['id'];
    token = json['token'];
   name = json['name'];
   status = json['status'];
    image = json['image'];
   
    birthdate = json['birthdate'];
    gender = json['gender'];
    comments = json['comments'];
    private = json['private'];
    notification = json['notification'];



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['name'] = this.name;
    data['status'] = this.status;
    data['image'] = this.image;
    
   data['birthdate'] = this.birthdate;
    data['gender'] = this.gender;
    data['comments'] = this.comments;
    data['private'] = this.private;
    data['notification'] = this.notification;
    return data;
  }
}
