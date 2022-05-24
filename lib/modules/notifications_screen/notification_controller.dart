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
    FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: myId)
        .get()
        .then((doc_of_user) {
      if (doc_of_user.docs.length > 0) {
        FirebaseFirestore.instance.collection('users').doc(myId).update({
          'nbOffriends': doc_of_user.docs.first.data()['nbOffriends'] == null
              ? 1
              : doc_of_user.docs.first.data()['nbOffriends'] + 1,
          'friends': FieldValue.arrayUnion([user_requestId])
        }).then((value) {});

        // add me as his friend in his collection user
        FirebaseFirestore.instance
            .collection('users')
            .where('uId', isEqualTo: user_requestId)
            .get()
            .then((doc_of_user) {
          if (doc_of_user.docs.length > 0) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user_requestId)
                .update({
              'nbOffriends':
                  doc_of_user.docs.first.data()['nbOffriends'] == null
                      ? 1
                      : doc_of_user.docs.first.data()['nbOffriends'] + 1,
              'friends': FieldValue.arrayUnion([myId])
            }).then((value) {});

            // delete request
            deleteRequest(myId: myId, user_requestId: user_requestId);
          }
        });
      }
    });
  }
}
