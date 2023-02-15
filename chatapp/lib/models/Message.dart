class MessgesModel {
  int? id;
  int? sender;
  int? room_id;
  String? text;
  String? addtime;

  MessgesModel({this.id, this.sender, this.room_id, this.text, this.addtime});

  factory MessgesModel.fromJson(Map<String, dynamic> json) {
    return MessgesModel(
      id: json['id'],
      sender: json['sender'],
      room_id: json['room_id'],
      text: json['text'],
      addtime: json['addtime'],
    );
  }
}
