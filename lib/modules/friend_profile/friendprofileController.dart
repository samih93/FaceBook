import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/constants.dart';

class FriendProfileController extends GetxController {
  //NOTE get user by id
  UserModel? _profileUser;
  UserModel? get profileUser => _profileUser;
  Future<void> getUserById(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      print(value.data());
      _profileUser = UserModel.fromJson(value.data()!);
      update();
    });
  }

// NOTE add request to friend

  bool isrequested = false;

  Future<void> addFriendRequest(String userId,
      {String? name, String? image}) async {
    FriendRequest model =
        FriendRequest(name, image, userId, Timestamp.now(), false);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('sentfriendrequests')
        .doc(userId)
        .set(model.toJson())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("receivedfriendrequest")
          .doc(uId)
          .set(model.toJson())
          .then((value) {
        isrequested = true;
        getListOfsentRequests();
      });
    });
  }

//NOTE get list of sent requests
  List<FriendRequest> _listofsentfriendrequests = [];
  List<FriendRequest> get listofsentfriendrequests => _listofsentfriendrequests;
  Future<void> getListOfsentRequests() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('sentfriendrequests')
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        value.docs.forEach((element) {
          _listofsentfriendrequests.add(FriendRequest.fromJson(element.data()));
        });
        update();
      }
    });
  }
}
