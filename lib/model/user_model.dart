import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/model/message_model.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? coverimage;
  String? bio;
  String? uId;
  bool? isemailverified;
  String? deviceToken;
  bool? isUnread;
  Timestamp? latestTimeMessage; // TO order chats descending by time
  MessageModel? messageModel;
  List<String>? friends = [];

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.image,
      this.coverimage,
      this.bio,
      this.uId,
      this.isemailverified});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    coverimage = json['coverimage'];
    bio = json['bio'];
    uId = json['uId'];
    deviceToken = json['deviceToken'] ?? '';
    isemailverified = json['isemailverified'];
    if (json['friends'] != null)
      json['friends'].forEach((element) {
        friends!.add(element);
      });
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'coverimage': coverimage,
      'bio': bio,
      'uId': uId,
      'deviceToken': deviceToken,
      'isemailverified': isemailverified,
      'friends': friends ?? [],
    };
  }
}
