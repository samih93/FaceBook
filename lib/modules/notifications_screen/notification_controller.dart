import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/constants.dart';

class NotificationController extends GetxController {
  NotificationController() {
    getListOfReceivedRequests().then((value) {
      print("getting requests");
    });
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
      print(value.docs.length);
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
}
