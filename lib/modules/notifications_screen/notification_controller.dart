import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/constants.dart';

class NotificationController extends GetxController {
  @override
  void onInit() async {
    getListOfReceivedRequests().then((value) {
      print("getting requests");
    });
    super.onInit();
  }

  //NOTE get list of receivrd requests
  List<FriendRequest> _listofreceivedfriendrequests = [];
  List<FriendRequest> get listofreceivedfriendrequests =>
      _listofreceivedfriendrequests;
  List<FriendRequest> get listofreceivedRequestTodisplay =>
      _listofreceivedfriendrequests.take(2).toList();
  Future<void> getListOfReceivedRequests() async {
    _listofreceivedfriendrequests = [];
    //List<String> _listofreceivedRequestIds = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('receivedfriendrequest')
        .orderBy('requestDate', descending: true)
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        value.docs.forEach((element) {
          _listofreceivedfriendrequests
              .add(FriendRequest.fromJson(element.data()));
        });
        update();

        _listofreceivedfriendrequests.forEach((element) {
          print(element.toJson());
        });

        // _listofreceivedfriendrequests.forEach((element) {
        //   print(element.toJson());
        // });

        //update();
      }
    });
  }

//NOTE delete request
  Future<void> deleteRequest(
      {required String myId, required String user_requestId}) async {
    // delete received request in current logged in user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('receivedfriendrequest')
        .doc(user_requestId)
        .delete()
        .then((value) {
      print("deleted from current Logged in user");
    });

    // delete request from other user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_requestId)
        .collection('sentfriendrequests')
        .doc(myId)
        .delete()
        .then((value) {
      print("deleted from other user ");
      _listofreceivedfriendrequests
          .removeWhere((element) => element.requestId == user_requestId);
      update();
    });
  }

  // NOTE confirm Request
  Future<void> confirmRequest(
      {required String myId, required String user_requestId}) async {
    //TODO:
    // add him as my friend in my collection user

    // add me as his friend in his collection user

    // delete request
    deleteRequest(myId: myId, user_requestId: user_requestId);
  }
}
