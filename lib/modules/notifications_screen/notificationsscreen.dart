import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/modules/notifications_screen/notification_controller.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class NotificationsScreen extends StatelessWidget {
  var controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        init: Get.find<NotificationController>(),
        builder: (notificationController) {
          return Scaffold(
            body: notificationController
                        .listofreceivedRequestTodisplay.length ==
                    0
                ? Container(
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/notifications.json',
                              width: 150, height: 150),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Your Notifications",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          Text("No Notifications to show at the moment",
                              style: TextStyle(color: Colors.grey)),
                          Text("Check back Later",
                              style: TextStyle(color: Colors.grey)),
                        ]),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Friend requests",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    notificationController
                                        .listofreceivedRequestTodisplay.length
                                        .toString(),
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
                              SizedBox(
                                height: 10,
                              ),
                              ...notificationController
                                  .listofreceivedRequestTodisplay
                                  .map((e) => _buildRequestItem(e, context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  _buildRequestItem(FriendRequest model, BuildContext context) {
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
                          controller.confirmRequest(myId: uId.toString(),
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
