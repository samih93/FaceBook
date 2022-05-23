import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/model/friend_request.dart';
import 'package:social_app/modules/notifications_screen/notification_controller.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<FriendRequest> _listofReceivedFriendRequest = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListOfreceivedFriendRequest().then((value) {
      setState(() {
        _listofReceivedFriendRequest = value;
        print("lenght of request :" +
            _listofReceivedFriendRequest.length.toString());
      });
    });
  }

  Future<List<FriendRequest>> _getListOfreceivedFriendRequest() async {
    NotificationController notificationController =
        Get.put(NotificationController());
    await notificationController
        .getListOfReceivedRequests()
        .then((value) async {});
    return notificationController.listofreceivedfriendrequests;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        init: NotificationController(),
        builder: (notificationController) {
          return Scaffold(
            body: _listofReceivedFriendRequest.length == 0
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
                          height: MediaQuery.of(context).size.height * 0.25,
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
                                    _listofReceivedFriendRequest.length
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
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
                              ..._listofReceivedFriendRequest
                                  .map((e) => _buildRequestItem(e)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  _buildRequestItem(FriendRequest model) {
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
          Column(
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
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: defaultColor.shade800,
                    onPressed: () {},
                    child: Text(
                      "confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.grey.shade300,
                    onPressed: () {},
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
