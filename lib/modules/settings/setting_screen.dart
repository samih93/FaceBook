import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/notifications/notification_screen.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class SettingScreen extends StatelessWidget {
  final double coverAndProfileheight = 220;
  final double coverimageheight = 180;
  double profileheight = 60;

  List<String> firendsName = [
    "samih damaj",
    "ali chekh",
    "mohammad ismail",
    "dani dani",
    "sergio said",
    "Kassem abou Khechfe",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          var socialUserModel = socialLayoutController.socialUserModel!;
          // var profileimage = socialLayoutController.profileimage;
          // var coverimage = socialLayoutController.coverimage;
          return Scaffold(
            backgroundColor: Colors.grey.shade400,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 12, right: 12),
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
                                          image: socialUserModel.coverimage ==
                                                      null ||
                                                  socialUserModel.coverimage ==
                                                      ""
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
                                    backgroundImage: socialUserModel.image ==
                                                null ||
                                            socialUserModel.image == ""
                                        ? AssetImage(
                                                'assets/default profile.png')
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
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(fontSize: 15),
                          ),

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          SizedBox(height: 10),
                          _buildFirendsHedear(),
                          SizedBox(height: 12),

                          Wrap(
                            spacing: 10,
                            children: [
                              ...firendsName
                                  .map((e) => _buildFriendItem(context, e)),
                            ],
                          ),
                          MaterialButton(
                              onPressed: () {},
                              minWidth: double.infinity,
                              color: Colors.grey.shade300,
                              child: Text("See all friends"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildWhatonYourMind(socialUserModel),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildFirendsHedear() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Friends",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "2233 friends",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ]),
        Text(
          "Find Friends",
          style: TextStyle(color: defaultColor),
        )
      ],
    );
  }

  _buildFriendItem(BuildContext context, String text) {
    return Container(
        width: MediaQuery.of(context).size.width * .28,
        height: 140,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * .28,
                  child: Image.asset(
                    "assets/profile_test.jpg",
                    fit: BoxFit.fitWidth,
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "$text",
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ));
  }
}

List<String> _streamItems = [
  'Live',
  'Photo',
  'Life event',
];
List<IconData> _streamIcons = [
  Icons.live_tv_sharp,
  FontAwesomeIcons.solidImages,
  Icons.flag
];
List<Color> _streamIconColors = [
  Colors.pink.shade400,
  Colors.purple.shade400,
  defaultColor,
];

_buildWhatonYourMind(UserModel? socialUserModel) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Get.to(NewPostScreen());
            },
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: socialUserModel!.image == null ||
                                socialUserModel.image == ""
                            ? AssetImage('assets/default profile.png')
                                as ImageProvider
                            : NetworkImage(socialUserModel.image!),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        "What's on your mind?",
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Divider(),
        _buildStreamsRow(),
      ],
    ),
  );
}

_buildStreamsRow() {
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        ..._streamItems.map(
          (e) => Expanded(
              child: _buildStreamItem(
            e,
            _streamIcons[_streamItems.indexOf(e)],
            _streamIconColors[_streamItems.indexOf(e)],
          )),
        ),
      ],
    ),
  );
}

_buildStreamItem(String text, IconData icon, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        color: color,
        size: 16,
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    ],
  );
}
