class MessageModel {
  String? senderId;
  String? receiverId;
  String? messageDate;
  String? text;
  String? image;
  bool? isReadByfriend;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.messageDate,
    this.text,
    this.image,
    this.isReadByfriend,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageDate = json['messageDate'];
    text = json['text'];
    image = json['image'];
    isReadByfriend = json['isReadByfriend'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageDate': messageDate,
      'text': text,
      'image': image,
      'isReadByfriend': isReadByfriend,
    };
  }
}
