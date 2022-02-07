import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          return socialLayoutController.isloadingGetPosts!
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  body: socialLayoutController.listOfPost.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              buildStoryItem(context),
                              // Card(
                              //   elevation: 20,
                              //   clipBehavior: Clip.antiAliasWithSaveLayer,
                              //   margin: EdgeInsets.all(8),
                              //   child: Stack(
                              //     alignment: AlignmentDirectional.bottomEnd,
                              //     children: [
                              //       Image(
                              //         width: double.infinity,
                              //         image: NetworkImage(
                              //             'https://th.bing.com/th/id/R.53afc35fea65364b957bda77adee36c6?rik=5vbij2dxjsHRPQ&pid=ImgRaw&r=0'),
                              //         fit: BoxFit.cover,
                              //         height: 200,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Text(
                              //           "Communicate with friends",
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .subtitle1!
                              //               .copyWith(color: Colors.white),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  return buildPostItem(
                                      socialLayoutController.listOfPost[index],
                                      context,
                                      index);
                                },
                                itemCount:
                                    socialLayoutController.listOfPost.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, int index) =>
                                    SizedBox(
                                  height: 10,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                );
        });
  }

  Widget buildStoryItem(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (socialLayoutController) => Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
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
                            image: socialLayoutController
                                            .socialUserModel!.image ==
                                        null ||
                                    socialLayoutController
                                            .socialUserModel!.image ==
                                        ""
                                ? AssetImage('assets/default profile.png')
                                    as ImageProvider
                                : NetworkImage(
                                    '${socialLayoutController.socialUserModel!.image}'),
                            // : NetworkImage(socialUserModel.coverimage!),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),

                  //NOTE profileImage

                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 15,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              'Create story',
              style: TextStyle(color: Colors.grey.shade800),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostItem(
    PostModel model,
    BuildContext context,
    int index,
  ) =>
      GetBuilder<SocialLayoutController>(
          init: Get.find<SocialLayoutController>(),
          builder: (socialLayoutController) {
            // SocialUserModel? userOfPost;

            // socialLayoutController
            //     .getUserDataById(
            //         socialLayoutController.listOfPost[index].uId.toString())
            //     .then((value) {
            //   userOfPost = value;
            //   // print(userOfPost!.isemailverified);
            // });
            return Card(
                elevation: 5,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //NOTE : header of post (circle avatar and name and date of post)
                      Row(
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
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_horiz,
                              )),
                        ],
                      ),
                      //NOTE: Divider()
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      //NOTE: post body()
                      Text('${model.text}'),
                      //NOTE : Tags
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 7.0),
                                child: Container(
                                  height: 25,
                                  child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      minWidth: 1,
                                      onPressed: () {},
                                      child: Text(
                                        "#software_Engineer",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: defaultColor,
                                            ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //NOTE : Image Of post
                      if (model.postImage != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: Container(
                              width: double.infinity,
                              height: 180,
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite_border,
                                        color: Colors.red),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      model.nbOfLikes.toString(),
                                      style:
                                          Theme.of(context).textTheme.caption,
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
                                    Icon(Icons.comment_rounded,
                                        color: Colors.amber),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "0 comments",
                                      style:
                                          Theme.of(context).textTheme.caption,
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                          ? AssetImage(
                                                  'assets/default profile.png')
                                              as ImageProvider
                                          : NetworkImage(
                                              '${socialLayoutController.socialUserModel!.image}'),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Write a Comment",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                      model.isLiked
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
                                if (model.isLiked == true) {
                                  socialLayoutController.likePost(
                                      model.postId.toString(), index,
                                      isForremove: true);
                                } else {
                                  socialLayoutController.likePost(
                                      model.postId.toString(), index);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });

  // Future _refreshData() async {
  //   Get.delete<SocialLayoutController>();
  //   await Future.delayed(Duration(seconds: 3));
  //   Get.put(SocialLayoutController());
  //   SocialLayoutController.onload();
  // }
}
