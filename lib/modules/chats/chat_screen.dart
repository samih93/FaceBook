import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/modules/search_friend/search_friend.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (socialLayoutController) => Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 25),
          child: socialLayoutController.myFriends.length > 0
              ? ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItem(
                      context, socialLayoutController.myFriends[index]),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: socialLayoutController.myFriends.length)
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                        children: [
                          TextSpan(
                              text:
                                  'To Start messaging contact who have social app, tap '),
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 1.0, left: 2, right: 2),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: defaultColor,
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                          TextSpan(text: ' bottom to start chat'),
                        ],
                      ),
                    ),
                    // child: Text(
                    //   'To Start messaging contact who have social app, tap the bottom to start chat',
                    //   style: TextStyle(color: Colors.grey, fontSize: 25),
                    //   textAlign: TextAlign
                    //       .center, // NOTE to center all paragraph in center
                    // ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => SearchFriendScreen());
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}
