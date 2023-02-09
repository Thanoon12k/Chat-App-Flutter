
import 'dart:convert';

List<QRoom> roomfromjson(String str) => List<QRoom>.from(json.decode(str).map((x) => QRoom.fromJson(x)));

String roomtojson(List<QRoom> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QRoom {
  
    int id;
    String name;
    int owner;
    int usersCount;
    dynamic image;
    DateTime addtime;

    QRoom({
        required this.id,
        required this.name,
        required this.owner,
        required this.usersCount,
        this.image,
        required this.addtime,
    });
  get instance {
    return QRoom(id: id, name: name, owner: owner, usersCount: usersCount, addtime: addtime);
  }
 get room {
    return QRoom(id: id, name: name, owner: owner, usersCount: usersCount, addtime: addtime);
  }
    factory QRoom.fromJson(Map<String, dynamic> json) => QRoom(
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
        "addtime": addtime.toIso8601String(),
    };
}
