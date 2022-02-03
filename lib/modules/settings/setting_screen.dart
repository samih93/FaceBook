import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/modules/notifications/notification_screen.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/constants.dart';

class SettingScreen extends StatelessWidget {
  final double coverheight = 250;
  double profileheight = 60;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          var socialUserModel = socialLayoutController.socialUserModel!;
          // var profileimage = socialLayoutController.profileimage;
          // var coverimage = socialLayoutController.coverimage;
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //NOTE Cover And Profile ---------------------
                    Container(
                      height: 220,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          //NOTE : Cover Image
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                    image: socialUserModel.coverimage == null ||
                                            socialUserModel.coverimage == ""
                                        ? AssetImage(
                                                'assets/default profile.png')
                                            as ImageProvider
                                        : NetworkImage(
                                            socialUserModel.coverimage!),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                          //NOTE profileImage
                          CircleAvatar(
                            radius: profileheight + 3,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: profileheight,
                              backgroundImage: socialUserModel.image == null ||
                                      socialUserModel.image == ""
                                  ? AssetImage('assets/default profile.png')
                                      as ImageProvider
                                  : NetworkImage(socialUserModel.image!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //NOTE Name
                    Text(
                      socialUserModel.name.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    // NOTE bio
                    Text(
                      socialUserModel.bio.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    // NOTE posts and follower ,following
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    "100",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Posts",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    "390",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Photos",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    "2K",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Followers",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    "700",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Following",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // NOTE : Edit Profile Button
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text("Edit Profile"),
                          ),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Get.to(EditProfile());
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                Get.to(NotificationScreen());
                              },
                              child: Text('Notifications Settings')),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                //NOTE : FriendsRequest this is announcement title for notification can be anything
                                FirebaseMessaging.instance
                                    .subscribeToTopic("FriendsPost");
                                showToast(
                                    message: "Subscribed",
                                    status: ToastStatus.Success);
                              },
                              child: Text("Subscribe")),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                // NOTE
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("FriendsPost");
                                showToast(
                                    message: "Unsubscribed",
                                    status: ToastStatus.Success);
                              },
                              child: Text("Unsubscribe")),
                        ),
                      ],
                    ),
                    defaultButton(
                        text: "Sign Out",
                        onpress: () {
                          signOut();
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}
