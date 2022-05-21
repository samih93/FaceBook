import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/comments_screen/comment_screen.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/notifications_settings/notification_settings.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class MyAccountScreen extends StatelessWidget {
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

  final mypostsQuery = FirebaseFirestore.instance
      .collection('posts')
      .where('uId', isEqualTo: uId)
      .orderBy('postdate', descending: true)
      .withConverter<PostModel>(
        fromFirestore: (snapshot, _) => PostModel.fromJson(snapshot.data()!),
        toFirestore: (post, _) => post.toJson(),
      );

  //static get uid => null;

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
                                    Get.to(NotificationSettingsScreen());
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

                  //NOTE For Posts
                  FirestoreListView<PostModel>(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    pageSize: 5,
                    query: mypostsQuery,
                    loadingBuilder: (context) => Center(
                      child: SingleChildScrollView(),
                    ),
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Something went wrong! ${error} - ${stackTrace}'),
                    itemBuilder: (context, snapshot) {
                      PostModel model;
                      if (snapshot.isBlank!)
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 200,
                                child: SvgPicture.asset(
                                    'assets/svg/no_posts_yet.svg')),
                            Text(
                              "No Posts Yes",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 30),
                            ),
                          ],
                        );
                      else {
                        model = snapshot.data();
                      }

                      return buildPostItem(
                          model, socialLayoutController, context);
                    },
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
List<IconData> _streamIcons = [Icons.live_tv_sharp, Icons.filter, Icons.flag];
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
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(children: [
            Text(
              "Posts",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Spacer(),
            MaterialButton(
              minWidth: 6,
              height: 30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.grey.shade300,
              onPressed: () {
                Get.to(NotificationSettingsScreen());
              },
              child: Icon(Icons.filter_list, size: 16),
            ),
            SizedBox(
              width: 5,
            ),
            MaterialButton(
              minWidth: 6,
              height: 30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.grey.shade300,
              onPressed: () {
                Get.to(NotificationSettingsScreen());
              },
              child: Icon(Icons.settings, size: 16),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
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
          Divider(),
          _buildStreamsRow(),
        ],
      ),
    ),
  );
}

_buildStreamsRow() {
  return Container(
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

Widget buildPostItem(
  PostModel model,
  SocialLayoutController socialLayoutController,
  BuildContext context,
) {
  model.imageHeight = model.imageHeight != 0
      ? double.parse(model.imageHeight.toString()) - model.imageHeight! / 1.5
      : 0;
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Card(
        margin: EdgeInsets.zero,
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //NOTE : header of post (circle avatar and name and date of post)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: model.image == null || model.image == ""
                        ? AssetImage('assets/default profile.png')
                            as ImageProvider
                        : NetworkImage(model.image!),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(height: 1.4),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if (model.isEmailVerified == true)
                            Icon(
                              Icons.check_circle,
                              color: defaultColor,
                              size: 16,
                            )
                        ],
                      ),
                      Text(
                        "${convertToAgo(DateTime.parse(model.postdate!))}",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.4),
                      ),
                    ],
                  )),
                  IconButton(
                      onPressed: () async {},
                      icon: Icon(
                        Icons.more_horiz,
                      )),
                ],
              ),
            ),
            //NOTE: Divider()
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child: Container(
            //     width: double.infinity,
            //     height: 1,
            //     color: Colors.grey,
            //   ),
            // ),
            //NOTE: post body()
            if (model.text != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Text('${model.text}'),
              ),

            //NOTE : Image Of post
            if (model.postImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //NOTE height - heigt /1.5 ==> about 40% from real height
                  height: model.imageHeight,

                  child: GestureDetector(
                    onDoubleTap: () {
                      // final double scale = 2;
                      // final zoomed = Matrix4.identity()..scale(scale);
                      // final value = zoomed;
                      // print("ok");
                    },
                    child: InteractiveViewer(
                        // transformationController: transformationController,
                        constrained: true,
                        //minScale: 1,
                        maxScale: 2.5,
                        child: Image.network(
                          model.postImage!,
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                ),
              ),
            //NOTE : Likes And Comments
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  if (model.nbOfLikes > 0)
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 10,
                                backgroundColor: defaultColor,
                                child: FaIcon(
                                  FontAwesomeIcons.solidThumbsUp,
                                  color: Colors.white,
                                  size: 12,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              model.nbOfLikes.toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        child: model.nbOfComments != 0
                            ? Text(
                                "${model.nbOfComments} comments",
                                style: Theme.of(context).textTheme.caption,
                              )
                            : Container(),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //NOTE: Divider()
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            // NOTE like share comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    size: 51,
                    onTap: (isLiked) async {
                      if (model.likes!.any(
                        (element) => element == uId,
                      )) {
                        socialLayoutController.likePost(model.postId.toString(),
                            isForremove: true);
                      } else {
                        socialLayoutController
                            .likePost(model.postId.toString());
                      }
                      return !isLiked;
                    },
                    circleColor:
                        CircleColor(start: defaultColor, end: defaultColor),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: defaultColor,
                      dotSecondaryColor: defaultColor,
                      // dotThirdColor: Color.fromARGB(220, 12, 199, 43),
                    ),
                    isLiked: model.likes!.length > 0 &&
                            model.likes!.contains(uId.toString())
                        ? true
                        : false,
                    likeBuilder: (bool isLiked) {
                      return Row(
                        children: [
                          FaIcon(FontAwesomeIcons.solidThumbsUp,
                              size: 18,
                              color: isLiked ? defaultColor : Colors.grey),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Like",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(
                                    color:
                                        isLiked ? defaultColor : Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      print("pressed");
                      Get.to(CommentsScreen(
                          model.postId,
                          socialLayoutController.socialUserModel?.name
                              .toString(),
                          socialLayoutController.socialUserModel?.image,
                          model.nbOfLikes));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.message,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Comments",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.share,
                            color: Colors.grey,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Share",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //NOTE: Divider()
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                height: 0.5,
                color: Colors.grey,
              ),
            ),

            //NOTE : Write a Comment  and like post
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: socialLayoutController
                                            .socialUserModel!.image ==
                                        null ||
                                    socialLayoutController
                                            .socialUserModel!.image ==
                                        ""
                                ? AssetImage('assets/default profile.png')
                                    as ImageProvider
                                : NetworkImage(
                                    '${socialLayoutController.socialUserModel!.image}'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Write a Comment",
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
  );
}
