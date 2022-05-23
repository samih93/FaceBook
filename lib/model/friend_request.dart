import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/model/user_model.dart';

class FriendRequest {
  String? name;
  String? image;
  String? requestId;
  Timestamp? requestDate;
  bool? isconfirmed;

  FriendRequest(this.name, this.image, this.requestId, this.requestDate,
      this.isconfirmed);

  FriendRequest.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    requestDate = json['requestDate'];
    isconfirmed = json['isconfirmed'];
    name = json['name'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'requestDate': requestDate,
      'isconfirmed': isconfirmed ?? 0,
      'name': name ?? '',
      'image': image ?? '',
    };
  }
}
