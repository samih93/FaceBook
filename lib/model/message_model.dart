class MessageModel {
  String? senderId;
  String? receiverId;
  String? messageDate;
  String? text;
  String? image;

  MessageModel(
      {this.senderId,
      this.receiverId,
      this.messageDate,
      this.text,
      this.image});

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageDate = json['messageDate'];
    text = json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageDate': messageDate,
      'text': text,
      'image': image,
    };
  }
}
