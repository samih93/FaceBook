import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/modules/notifications/notification_screen.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class SettingScreen extends StatelessWidget {
  final double coverAndProfileheight = 220;
  final double coverimageheight = 180;
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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    //NOTE Cover And Profile ---------------------
                    Container(
                      height: coverAndProfileheight,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          //NOTE : Cover Image
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                                height: coverimageheight,
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 25),
                    ),
                    // NOTE bio
                    Text(
                      socialUserModel.bio.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    // NOTE posts and follower ,following
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 15.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: () {},
                    //           child: Column(
                    //             children: [
                    //               Text(
                    //                 "100",
                    //                 style:
                    //                     Theme.of(context).textTheme.subtitle1,
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 "Posts",
                    //                 style: Theme.of(context).textTheme.caption,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: () {},
                    //           child: Column(
                    //             children: [
                    //               Text(
                    //                 "390",
                    //                 style:
                    //                     Theme.of(context).textTheme.subtitle1,
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 "Photos",
                    //                 style: Theme.of(context).textTheme.caption,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: () {},
                    //           child: Column(
                    //             children: [
                    //               Text(
                    //                 "2K",
                    //                 style:
                    //                     Theme.of(context).textTheme.subtitle1,
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 "Followers",
                    //                 style: Theme.of(context).textTheme.caption,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: InkWell(
                    //           onTap: () {},
                    //           child: Column(
                    //             children: [
                    //               Text(
                    //                 "700",
                    //                 style:
                    //                     Theme.of(context).textTheme.subtitle1,
                    //               ),
                    //               SizedBox(
                    //                 height: 10,
                    //               ),
                    //               Text(
                    //                 "Following",
                    //                 style: Theme.of(context).textTheme.caption,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // NOTE : Edit Profile Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: MaterialButton(
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: defaultColor.shade800,
                              onPressed: () {
                                Get.to(AddStoryScreen());
                              },
                              child: Container(
                                // color: defaultColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add,
                                          size: 16,
                                          color: defaultColor.shade800,
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Add to story",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: MaterialButton(
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.grey.shade300,
                              onPressed: () {
                                Get.to(EditProfile());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Edit Profile"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                            minWidth: 10,
                            height: 40,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.grey.shade300,
                            onPressed: () {
                              Get.to(NotificationScreen());
                            },
                            child: Text("..."),
                          ),
                          // OutlinedButton(
                          //     onPressed: () {}, child: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Divider(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Married",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.more_horiz_outlined,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "See your About info",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
