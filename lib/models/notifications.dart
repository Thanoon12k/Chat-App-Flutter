

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class MyNotificaion {
  int? id;
  int? sender;
  int? reception_id;
  int? room_id;
  String? device_id;
  String? title;
  String? body;
  bool? isRead;
  String? addtime;

  MyNotificaion(
      {this.id,
      this.sender,
      this.reception_id,
      this.room_id,
      this.device_id,
      this.title,
      this.body,
      this.isRead,
      this.addtime});

  MyNotificaion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    reception_id = json['reception_id'];
    room_id = json['room_id'];
    device_id = json['device_id'];
    title = json['title'];
    body = json['body'];
    isRead = json['is_read'];
    addtime = json['addtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender;
    data['reception_id'] = this.reception_id;
    data['room_id'] = this.room_id;
    data['device_id'] = this.device_id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['is_read'] = this.isRead;
    data['addtime'] = this.addtime;
    return data;
  }
}
