import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/storymodel.dart';
import 'package:social_app/shared/constants.dart';
import "package:story_view/story_view.dart";

class StoryViewScreen extends StatelessWidget {
  String? storyUId;
  StoryViewScreen(this.storyUId);

  final storyController = StoryController();

//! toDo
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          List<StoryModel> stories = [];
          socialLayoutController.storiesMap![storyUId]!.forEach((element) {
            stories.add(StoryModel.formJson(element));
          });
          return Scaffold(
            body: _DisplayStories(stories),
          );
        });
  }

  _DisplayStories(List<StoryModel> stories) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        StoryView(
          controller: storyController,
          storyItems: <StoryItem>[
            ...List.generate(
                stories.length,
                (index) => StoryItem.inlineImage(
                      imageFit: BoxFit.contain,
                      url: stories[index].image.toString(),
                      controller: storyController,
                      caption: Text(
                        stories[index].caption.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.black54,
                          fontSize: 17,
                        ),
                      ),
                    )).toList(),
          ],
          onStoryShow: (s) {
            print("Showing a story");
          },
          onComplete: () {
            print("Completed a cycle");
            Get.back();
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
          //  inline: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 25),
          child: Row(children: [
            CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/default profile.png')),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stories[0].storyName.toString(),
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${convertToAgo(DateTime.parse(stories[0].storyDate.toString()))} ago',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
