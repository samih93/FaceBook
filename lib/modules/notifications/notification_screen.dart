import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/modules/notifications/notification_settings_controller.dart';
import 'package:social_app/shared/constants.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationSettingsController>(
      init: NotificationSettingsController(),
      builder: (notificationSettingsController) => Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.favorite_border),
                      title: Text("Likes"),
                      trailing: Switch(
                        onChanged: (bool value) {
                          notificationSettingsController
                              .onchangeLikesNotification(value);
                          //NOTE : Likes this is announcement for likes event
                          value == true
                              ? FirebaseMessaging.instance
                                  .subscribeToTopic("LikesPost")
                              : FirebaseMessaging.instance
                                  .unsubscribeFromTopic("LikesPost");
                        },
                        value: notificationSettingsController
                            .isGetLikesNotification.value,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.comment),
                      title: Text("Comments"),
                      trailing: Switch(
                        onChanged: (bool value) {
                          notificationSettingsController
                              .onchangeCommentNotification(value);
                          value == true
                              ? FirebaseMessaging.instance
                                  .subscribeToTopic("comments")
                              : FirebaseMessaging.instance
                                  .unsubscribeFromTopic("comments");
                        },
                        value: notificationSettingsController
                            .isGetCommentsNotification.value,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Firend Request"),
                      trailing: Switch(
                        onChanged: (bool value) {
                          notificationSettingsController
                              .onchangeFriendRequestNotification(value);
                          value == true
                              ? FirebaseMessaging.instance
                                  .subscribeToTopic("friendsrequest")
                              : FirebaseMessaging.instance
                                  .unsubscribeFromTopic("friendsrequest");
                        },
                        value: notificationSettingsController
                            .isGetFriendRequestNotification.value,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.sms),
                      title: Text("SMS"),
                      trailing: Switch(
                        onChanged: (bool value) {
                          notificationSettingsController
                              .onchangeSMSNotification(value);
                          value == true
                              ? FirebaseMessaging.instance
                                  .subscribeToTopic("sms")
                              : FirebaseMessaging.instance
                                  .unsubscribeFromTopic("sms");
                        },
                        value: notificationSettingsController
                            .isGetSMSNotification.value,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.post_add),
                      title: Text("Firends Post"),
                      trailing: Switch(
                        onChanged: (bool value) {
                          notificationSettingsController
                              .onchangeFriendPostNotification(value);
                          value == true
                              ? FirebaseMessaging.instance
                                  .subscribeToTopic("FriendsPost")
                              : FirebaseMessaging.instance
                                  .unsubscribeFromTopic("FriendsPost");
                        },
                        value: notificationSettingsController
                            .isGetFriendPostNotification.value,
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minWidth: MediaQuery.of(context).size.width * 0.9,
                onPressed: () async {
                  await signOut();
                },
                color: Colors.grey.shade300,
                child: Text("Log out"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
