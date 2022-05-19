import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? senderId;
  String? senderName;
  String? senderimage;
  String? text;
  Timestamp? commentDate;

  CommentModel({
    this.senderId,
    this.senderName,
    this.senderimage,
    this.text,
    this.commentDate,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    senderName = json['senderName'];
    senderimage = json['senderimage'];
    text = json['text'];
    commentDate = json['commentDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderimage': senderimage,
      'text': text,
      'commentDate': commentDate,
    };
  }
}
