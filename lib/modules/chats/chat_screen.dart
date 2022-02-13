import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/modules/search_friend/search_friend.dart';
import 'package:social_app/shared/components/componets.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (socialLayoutController) => Scaffold(
        body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(socialLayoutController.myFriends[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: socialLayoutController.myFriends.length),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => SearchFriendScreen());
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}
