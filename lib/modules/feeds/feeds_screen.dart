import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/storymodel.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/stories_view/stories_view.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedsScreen extends StatelessWidget {
  final postsQuery = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('postdate', descending: true)
      .withConverter<PostModel>(
        fromFirestore: (snapshot, _) => PostModel.fromJson(snapshot.data()!),
        toFirestore: (post, _) => post.toJson(),
      );
  // final storiesQuery = FirebaseFirestore.instance
  //     .collection('stories')
  //     .orderBy('storyDate', descending: true)
  //     .withConverter<StoryModel>(
  //       fromFirestore: (snapshot, _) => StoryModel.formJson(snapshot.data()!),
  //       toFirestore: (story, _) => story.toJson(),
  //     );

  late SocialLayoutController controller_NeededInBuildPost;

  @override
  Widget build(BuildContext context) {
    controller_NeededInBuildPost = Get.find<SocialLayoutController>();
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          return Scaffold(
            backgroundColor: Colors.grey.shade400,
            // socialLayoutController.isloadingGetStories
            //     ? Center(child: CircularProgressIndicator())
            //     :
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //NOTE for Story
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildStoryItem(context: context, isForMe: true),
                          SizedBox(
                            width: 10,
                          ),
                          socialLayoutController.storiesMap.length > 0
                              ? Row(
                                  children: [
                                    socialLayoutController.storiesMap[
                                                    uId.toString()] !=
                                                null &&
                                            socialLayoutController
                                                    .storiesMap[uId.toString()]!
                                                    .length >
                                                0
                                        ? buildStoryItem(
                                            context: context,
                                            isForMe: true,
                                            isHasStories: true,
                                            story: StoryModel.formJson(
                                                socialLayoutController
                                                    .storiesMap[uId.toString()]!
                                                    .last))
                                        : SizedBox(
                                            width: 0,
                                          ),
                                    if (socialLayoutController
                                            .storiesMap.length >
                                        0)
                                      for (var e in socialLayoutController
                                          .storiesMap.entries)
                                        if (e.value.last['storyUserId'] != uId)
                                          buildStoryItem(
                                              context: context,
                                              isForMe: false,
                                              isHasStories: true,
                                              story: StoryModel.formJson(
                                                  e.value.last)),
                                  ],
                                )
                              : _noStoriesWidget(context),
                        ],
                      )
                      // : FirestoreListView<StoryModel>(
                      //     scrollDirection: Axis.horizontal,
                      //     pageSize: 8,
                      //     query: storiesQuery,
                      //     loadingBuilder: (context) => Center(
                      //       child: SingleChildScrollView(),
                      //     ),
                      //     errorBuilder: (context, error, stackTrace) => Text(
                      //         'Something went wrong! ${error} - ${stackTrace}'),
                      //     itemBuilder: (context, snapshot) {
                      //       StoryModel model = snapshot.data();

                      //       return buildStoryItem(
                      //         context: context,
                      //         story: model,
                      //       );
                      //     },
                      //   ),
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  //NOTE Old get posts from controller
                  // ListView.separated(
                  //   itemBuilder: (context, index) {
                  //     return buildPostItem(
                  //         socialLayoutController
                  //             .listOfPost[index],
                  //         context,
                  //         index);
                  //   },
                  //   itemCount:
                  //       socialLayoutController.listOfPost.length,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   separatorBuilder: (context, int index) =>
                  //       SizedBox(
                  //     height: 10,
                  //   ),
                  // ),
                  //NOTE For Posts
                  FirestoreListView<PostModel>(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    pageSize: 8,
                    query: postsQuery,
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
                                    'assets/no_posts_yet.svg')),
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

                      return buildPostItem(model,
                          socialLayoutController.socialUserModel!, context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildStoryItem({
    required BuildContext context,
    required bool isForMe,
    isHasStories = false,
    StoryModel? story,
  }) {
    return isForMe
        // if current logged does not have stories
        ? !isHasStories
            ? Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 220,
                child: Column(
                  children: [
                    Container(
                      height: 175,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          //NOTE : Cover Image
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: (controller_NeededInBuildPost
                                                    .socialUserModel !=
                                                null &&
                                            (controller_NeededInBuildPost
                                                        .socialUserModel!
                                                        .image ==
                                                    null ||
                                                controller_NeededInBuildPost
                                                        .socialUserModel!
                                                        .image ==
                                                    ""))
                                        ? AssetImage(
                                                'assets/default profile.png')
                                            as ImageProvider
                                        : NetworkImage(
                                            '${controller_NeededInBuildPost.socialUserModel!.image.toString()}'),
                                    // : NetworkImage(socialUserModel.coverimage!),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                          ),

                          //NOTE profileImage

                          CircleAvatar(
                            radius: 17,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 15,
                              child: InkWell(
                                onTap: () {
                                  // controller_NeededInBuildPost.AddStory(
                                  //     controller_NeededInBuildPost
                                  //         .socialUserModel!.uId
                                  //         .toString());
                                  Get.to(() => AddStoryScreen());
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Create story',
                      style: TextStyle(color: Colors.grey.shade900),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            //NOTE if current user  has stories
            : InkWell(
                onTap: () {
                  Get.to(() => StoryViewScreen(story!.storyUserId.toString()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 220,
                  child: Container(
                    height: 175,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            //NOTE : Cover Image
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(story!.image.toString()),
                                  // : NetworkImage(socialUserModel.coverimage!),
                                  fit: BoxFit.cover,
                                ),
                              )),
                            ),

                            //NOTE profileImage

                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  bottom: 10, end: 15),
                              child: Text(
                                'Your Story',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // NOTE circle avatar inside story
                        ...profileStory(story)
                      ],
                    ),
                  ),
                ),
              )
        : InkWell(
            onTap: () {
              Get.to(() => StoryViewScreen(story!.storyUserId.toString()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 220,
              child: Container(
                height: 175,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        //NOTE : Cover Image
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                              decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(story!.image.toString()),
                              // : NetworkImage(socialUserModel.coverimage!),
                              fit: BoxFit.cover,
                            ),
                          )),
                        ),

                        //NOTE profileImage

                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              bottom: 10, end: 15),
                          child: Text(
                            story.storyName.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // NOTE circle avatar inside story // this is list of circle avatar in a stack
                    ...profileStory(story)
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildPostItem(
    PostModel model,
    UserModel userModel,
    BuildContext context,
  ) =>
      Container(
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
                        backgroundImage:
                            model.image == null || model.image == ""
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text('${model.text}'),
                  ),
                //NOTE : Tags
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Container(
                //     width: double.infinity,
                //     child: Wrap(
                //       alignment: WrapAlignment.start,
                //       children: [
                //         Padding(
                //           padding:
                //               const EdgeInsetsDirectional.only(end: 7.0),
                //           child: Container(
                //             height: 25,
                //             child: MaterialButton(
                //                 padding: EdgeInsets.zero,
                //                 minWidth: 1,
                //                 onPressed: () {},
                //                 child: Text(
                //                   "#software_Engineer",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .caption!
                //                       .copyWith(
                //                         color: defaultColor,
                //                       ),
                //                 )),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                //NOTE : Image Of post
                if (model.postImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Container(
                        width: double.infinity,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage('${model.postImage}'),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                //NOTE : Likes And Comments
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.favorite_border, color: Colors.red),
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
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.comment_rounded, color: Colors.amber),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "0 comments",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                //NOTE: Divider()
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
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
                                backgroundImage: userModel.image == null ||
                                        userModel.image == ""
                                    ? AssetImage('assets/default profile.png')
                                        as ImageProvider
                                    : NetworkImage('${userModel.image}'),
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
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                                model.likes!.length > 0 &&
                                        model.likes!.contains(uId.toString())
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Like",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (model.likes!.any(
                            (element) => element == uId,
                          )) {
                            controller_NeededInBuildPost.likePost(
                                model.postId.toString(),
                                isForremove: true);
                          } else {
                            controller_NeededInBuildPost
                                .likePost(model.postId.toString());
                          }

                          model.likes!.forEach((element) {
                            print(element);
                          });
                          // if (model.likes!.length > 0 &&
                          //     model.likes!.contains(uId)) {
                          //   controller_NeededInBuildPost.likePost(
                          //       model.postId.toString(),
                          //       isForremove: true);
                          // } else {
                          //   controller_NeededInBuildPost
                          //       .likePost(model.postId.toString());
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );

  profileStory(StoryModel story) {
    return [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(radius: 24, backgroundColor: defaultColor.shade800),
      ),
      Padding(
        padding: const EdgeInsets.all(14.0),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade400.withOpacity(0.3),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: CircleAvatar(
          radius: 20,
          backgroundImage:
              story.storyUserImage == null || story.storyUserImage == ""
                  ? AssetImage('assets/default profile.png') as ImageProvider
                  : NetworkImage(story.storyUserImage!),
        ),
      ),
    ];
  }

  _noStoriesWidget(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No stories yet"),
            Text("Add A Story"),
          ],
        ),
      );

  // Future _refreshData() async {
  //   Get.delete<SocialLayoutController>();
  //   await Future.delayed(Duration(seconds: 3));
  //   Get.put(SocialLayoutController());
  //   SocialLayoutController.onload();
  // }

}
