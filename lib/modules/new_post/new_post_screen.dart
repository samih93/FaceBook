import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/colors.dart';

class NewPostScreen extends StatelessWidget {
  var postBodyController = TextEditingController();

  bool? isImageClicked = false;
  int _imageWidth = 0;
  int _imageHeight = 0;
  NewPostScreen({this.isImageClicked});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          var socialUserModel = socialLayoutController.socialUserModel!;
          if (isImageClicked == true)
            socialLayoutController.pickPostImage().then((value) async {
              isImageClicked = false;
              var decodedImage = await decodeImageFromList(
                      socialLayoutController.postimage!.readAsBytesSync())
                  .then((value) {
                print("image width : " + value.width.toString());
                print("image height : " + value.height.toString());
                _imageWidth = value.width;
                _imageHeight = value.height;
              });
            });
          return Scaffold(
            appBar:
                defaultAppBar(context: context, title: "Add Post", actions: [
              socialLayoutController.postBodyText != "" ||
                      socialLayoutController.postimage != null
                  ? defaultTextButton(
                      onpress: () {
                        socialLayoutController
                            .createNewPost(
                                postdate: DateTime.now().toString(),
                                text: postBodyController.text,
                                imagewidth:
                                    double.parse(_imageWidth.toString()),
                                imageheight:
                                    double.parse(_imageHeight.toString()))
                            .then((value) {
                          if (!socialLayoutController.isloadingcreatePost!)
                            Navigator.pop(context);
                        });
                      },
                      text: "Post")
                  : defaultTextButton(
                      onpress: () {
                        return null;
                      },
                      text: "Post",
                      color: Colors.grey)
            ]),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (socialLayoutController.isloadingcreatePost!)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: socialUserModel.image == null ||
                                socialUserModel.image == ""
                            ? AssetImage('assets/default profile.png')
                                as ImageProvider
                            : NetworkImage(socialUserModel.image!),
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
                                socialUserModel.name ?? 'No Name',
                                style: TextStyle(height: 1.4),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              if (socialUserModel.isemailverified == true)
                                Icon(
                                  Icons.check_circle,
                                  color: defaultColor,
                                  size: 16,
                                )
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                  Expanded(
                    child: defaultTextFormField(
                        maxligne: 15,
                        onchange: (value) {
                          socialLayoutController
                              .ontyping_postBody(value.toString());
                        },
                        controller: postBodyController,
                        inputtype: TextInputType.multiline,
                        border: InputBorder.none,
                        hinttext: "What is on your mind ..."),
                  ),
                  if (socialLayoutController.postimage != null)
                    Expanded(
                      flex: 2,
                      child: ListView(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                  height:
                                      double.parse(_imageHeight.toString()) -
                                          _imageHeight / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(
                                          socialLayoutController.postimage!),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    //NOTE : Remove post image
                                    socialLayoutController.removePostImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        Icons.close,
                                        size: 17,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (socialLayoutController.postimage == null)
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                socialLayoutController.pickPostImage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Add Photo"),
                                ],
                              )),
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //       onPressed: () {},
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text("# tags"),
                        //         ],
                        //       )),
                        // ),
                      ],
                    ),
                ],
              ),
            ),
          );
        });
  }
}
