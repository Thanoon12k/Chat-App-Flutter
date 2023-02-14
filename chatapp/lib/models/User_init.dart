// import 'dart:convert';

// List<User> roomfromjson(String str) =>
//     List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// String roomtojson(List<User> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class User {
//   int? id;
//   String name;
//   String status;
//   dynamic gender;
//   String notify;
//   dynamic? image;
//   User({
//     this.id,
//     required this.name,
//     required this.status,
//     required this.gender,
//     required this.notify,
//     this.image,
     
//   });
//   get myuser {
//     return User(
//         id: id,
//         name: name,
//         gender: gender,
//         status: status,
//         notify: notify,
//         image: image
        
//         );
//   }


//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"],
//         status: json["status"],
//         gender: json["gender"],
//         notify: json["notify"],
//         image: json["image"],
       
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "status": status,
//         "gender": gender,
//         "image": image,
//         "notify": notify
//       };
// }
