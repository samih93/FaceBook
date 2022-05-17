class CommentModel {
  String? senderId;
  String? senderName;
  String? text;
  String? commentDate;

  CommentModel({
    this.senderId,
    this.senderName,
    this.text,
    this.commentDate,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    senderName = json['senderName'];
    text = json['text'];
    commentDate = json['commentDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'commentDate': commentDate,
    };
  }
}
