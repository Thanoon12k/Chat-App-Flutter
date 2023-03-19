class CommentsModel {
  int? id;
  int? sender;
  String? sender_name;
  int? reception;
  String? text;
  String? image;
  String? senderImage;
  String? token;
  String? sendtime;

  CommentsModel(
      {this.id,
      this.sender,
      this.sender_name,
      this.reception,
      this.text,
      this.image,
      this.senderImage,
      this.token,
      this.sendtime});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    sender_name = json['sender_name'];
    reception = json['reception'];
    text = json['text'];
    image = json['image'];
    senderImage = json['sender_image'];
    token = json['token'];
    sendtime = json['sendtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender;
    data['sender_name'] = this.sender_name;
    data['reception'] = this.reception;
    data['text'] = this.text;
    data['image'] = this.image;
    data['sender_image'] = this.senderImage;
    data['token'] = this.token;
    data['sendtime'] = this.sendtime;
    return data;
  }
}
