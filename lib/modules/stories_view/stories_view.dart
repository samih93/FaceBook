import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/storymodel.dart';
import "package:story_view/story_view.dart";

class StoryViewScreen extends StatelessWidget {
  final storyController = StoryController();

//! toDo
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (socialLayoutController) => Scaffold(
        body: _DisplayStories(socialLayoutController.stories),
      ),
    );
  }

  _DisplayStories(List<StoryModel?> stories) => StoryView(
        controller: storyController,
        storyItems: <StoryItem>[
          ...List.generate(
              stories.length,
              (index) => StoryItem.inlineImage(
                    imageFit: BoxFit.contain,
                    url: stories[index]!.image.toString(),
                    controller: storyController,
                    caption: Text(
                      stories[index]!.caption.toString(),
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
      );
}
