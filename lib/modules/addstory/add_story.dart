import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/addstory/story_controller.dart';
import 'package:social_app/shared/components/componets.dart';

class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({Key? key}) : super(key: key);
  var storyBodyController = TextEditingController();

  SocialLayoutController socialLayoutController =
      Get.find<SocialLayoutController>();
  @override
  Widget build(BuildContext context) {
    //NOTE remove status and bottom bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    return GetBuilder<StoryController>(
      init: StoryController(),
      builder: (storyController) => Scaffold(
        backgroundColor: Colors.black,
        body: storyController.storyimage != null
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                image: DecorationImage(
                                  image: FileImage(storyController.storyimage!),
                                  fit: BoxFit.contain,
                                ),
                              )),
                          IconButton(
                              onPressed: () {
                                //NOTE : Remove post image
                                storyController.removeStoryImage();
                                storyController.pickStoryImage();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              )),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                                SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: [SystemUiOverlay.top],
                                );
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 3, right: 3),
                        child: Container(
                            child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: defaultTextFormField(
                                    controller: storyBodyController,
                                    inputtype: TextInputType.name,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.image),
                                    hinttext: "Add a caption..."),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("send button");
                              },
                              child: CircleAvatar(
                                radius: 25,
                                child: Icon(Icons.send),
                              ),
                            )
                          ],
                        )),
                      ),

                      // Row(
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(Icons.close),
                      //       onPressed: () {
                      //         Get.back();
                      //       },
                      //     ),
                      //     Spacer(),
                      //     defaultTextButton(onpress: () {}, text: "Share"),
                      //   ],
                      // ),
                      // Expanded(
                      //   child: defaultTextFormField(
                      //       maxligne: 5,
                      //       onchange: (value) {
                      //         socialLayoutController
                      //             .ontyping_postBody(value.toString());
                      //       },
                      //       controller: storyBodyController,
                      //       inputtype: TextInputType.multiline,
                      //       border: InputBorder.none,
                      //       hinttext: "What is on your mind ..."),
                      // ),
                    ],
                  ),
                  // CircularProgressIndicator()
                ],
              )
            : SizedBox(
                width: 0,
              ),
      ),
    );
  }
}
