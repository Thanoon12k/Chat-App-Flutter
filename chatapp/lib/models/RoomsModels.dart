class modelroom {
  int? id;
  String? name;
  int? owner;
  int? users_count;
  Null? image;
  String? addtime;

  modelroom(
      {this.id,
      this.name,
      this.owner,
      this.users_count,
      this.image,
      this.addtime});

 
  factory modelroom.fromJson(Map<String, dynamic> json) {
    return modelroom(
      id: json['id'],
      name: json['name'],
    owner: json['owner'],
    users_count: json['users_count'],
    image: json['image'],
    addtime: json['addtime'],
    );
  }
}