

import 'package:chatapp/models/Comments.dart';

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
int? stars;
String? token;
 List<CommentsModel>? userComments;

  UserModel({this.name, this.image, this.id,  this.token, this.userComments});

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
stars = json['stars'];
  if (json['user_comments'] != null) {
      userComments = <CommentsModel>[];
      json['user_comments'].forEach((v) {
        userComments!.add(new CommentsModel.fromJson(v));
      });
    }



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
    data['stars'] = this.stars;
     if (this.userComments != null) {
      data['user_comments'] =
          this.userComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

