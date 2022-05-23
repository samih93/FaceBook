import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/model/user_model.dart';

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
}
