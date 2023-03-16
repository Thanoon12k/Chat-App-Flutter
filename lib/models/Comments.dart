
class CommentsModel {
  int? id;
  int? sender;
  int? reception;
  String? text;
  String? image;
  String? senderImage;
  String? token;
  String? sendtime;

  CommentsModel(
      {this.id,
      this.sender,
      this.reception,
      this.text,
      this.image,
      this.senderImage,
      this.token,
      this.sendtime});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
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
    data['reception'] = this.reception;
    data['text'] = this.text;
    data['image'] = this.image;
    data['sender_image'] = this.senderImage;
    data['token'] = this.token;
    data['sendtime'] = this.sendtime;
    return data;
  }
}