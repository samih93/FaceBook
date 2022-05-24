import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/modules/notifications_screen/notification_controller.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class NotificationsScreen extends StatelessWidget {
  var friendrequestsQuery = FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .collection('receivedfriendrequest')
      .orderBy('requestDate', descending: true)
      .withConverter<FriendRequest>(
        fromFirestore: (snapshot, _) =>
            FriendRequest.fromJson(snapshot.data()!),
        toFirestore: (request, _) => request.toJson(),
      );

  var controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.4,
              child: FirestoreListView<FriendRequest>(
                  // reverse: true,
                  //    physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  pageSize: 5,
                  query: friendrequestsQuery,
                  // loadingBuilder: (context) => Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Something went wrong! ${error} - ${stackTrace}'),
                  itemBuilder: (context, snapshot) {
                    FriendRequest model;

                    if (snapshot.isBlank!) {
                      print('snapshot blank');

                      print(snapshot.data().name);
                      return Container();
                    } else {
                      model = snapshot.data();
                      print('snapshot data');
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Text(
                                "Friend requests",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${controller.listofreceivedfriendrequests.length}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                "See all",
                                style: TextStyle(color: defaultColor),
                              ),
                            ],
                          ),
                        ),
                        _buildRequestItem(model, context, controller),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildRequestItem(FriendRequest model, BuildContext context,
      NotificationController controller) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: model.image == null || model.image == ""
                  ? AssetImage('assets/default profile.png') as ImageProvider
                  : NetworkImage(model.image!),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.name.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${convertToAgo(model.requestDate!.toDate())}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: defaultColor.shade800,
                        onPressed: () {
                          controller.confirmRequest(
                              myId: uId.toString(),
                              user_requestId: model.requestId.toString());
                        },
                        child: Text(
                          "confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.grey.shade300,
                        onPressed: () {
                          controller.deleteRequest(
                              myId: uId.toString(),
                              user_requestId: model.requestId.toString());
                        },
                        child: Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
