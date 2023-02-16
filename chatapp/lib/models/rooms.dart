class RoomModel {
  int? id;
  String? name;
  int? owner;
  int? users_count;
  Null? image;
  String? addtime;

  RoomModel(
      {this.id,
      this.name,
      this.owner,
      this.users_count,
      this.image,
      this.addtime});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      users_count: json['users_count'],
      image: json['image'],
      addtime: json['addtime'],
    );
  }
}

