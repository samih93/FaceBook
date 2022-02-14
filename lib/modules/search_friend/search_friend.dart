import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/search_friend/search_controller.dart';
import 'package:social_app/shared/components/componets.dart';

class SearchFriendScreen extends StatelessWidget {
  var queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (socialLayoutController) => Scaffold(
        appBar: AppBar(
          title: defaultTextFormField(
              controller: queryController,
              onchange: (query) {
                print(query);
                socialLayoutController.searchForUser(query!);
              },
              inputtype: TextInputType.name,
              border: InputBorder.none,
              hinttext: "Search for a friend ... "),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 30),
          child: socialLayoutController.userfiltered.length > 0
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return buildChatItem(
                        context, socialLayoutController.userfiltered[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: socialLayoutController.userfiltered.length)
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return buildChatItem(
                        context, socialLayoutController.users[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: socialLayoutController.users.length),
        ),
      ),
    );
  }
}
