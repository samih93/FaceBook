import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/model/storymodel.dart';
import "package:story_view/story_view.dart";

class StoryViewScreen extends StatelessWidget {
  final storyController = StoryController();

  List<StoryModel> stories = [
    StoryModel(
        storyId: "1",
        image:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
        caption: "Hello ",
        storyDate: "1m ago"),
    StoryModel(
        storyId: "2",
        image: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
        caption: "Good Morning ",
        storyDate: "15m ago"),
    StoryModel(
        storyId: "3",
        image: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        caption: "Good Night ",
        storyDate: "1h ago"),
  ];
//! toDo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _DisplayStories(stories),
    );
  }

  _DisplayStories(List<StoryModel> stories) => StoryView(
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
      );
}
