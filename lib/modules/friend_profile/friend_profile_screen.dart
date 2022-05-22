import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/modules/notifications_settings/notification_settings.dart';
import 'package:social_app/shared/styles/colors.dart';

class FriendProfileScreen extends StatelessWidget {
  final double coverAndProfileheight = 220;
  final double coverimageheight = 180;
  double profileheight = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
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
                                    image: AssetImage(
                                      'assets/default profile.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),

                          //NOTE profileImage
                          CircleAvatar(
                            radius: profileheight + 3,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                                radius: profileheight,
                                backgroundImage:
                                    AssetImage('assets/profile_test.jpg')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //NOTE Name
                    Text(
                      "Samih damaj",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 25),
                    ),
                    // NOTE bio
                    Text(
                      "developer",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 15),
                    ),

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
                                // Get.to(AddStoryScreen());
                              },
                              child: Container(
                                // color: defaultColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Add Friend",
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
                                //  Get.to(ChatDetailsScreen(socialUserModel: socialUserModel))
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.facebookMessenger,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Message"),
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
                              Get.to(NotificationSettingsScreen());
                            },
                            child: Text("..."),
                          ),
                          // OutlinedButton(
                          //     onPressed: () {}, child: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
