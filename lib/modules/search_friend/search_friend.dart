import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/search_friend/search_controller.dart';
import 'package:social_app/shared/components/componets.dart';

import '../../shared/constants.dart';

class SearchFriendScreen extends StatelessWidget {
  var queryController = TextEditingController();
  //final usersQuery = FirebaseFirestore.instance.collection('users').orderBy('name');

  final usersQuery = FirebaseFirestore.instance
      .collection('users')
      .where('uId', isNotEqualTo: uId)
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

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
                        context: context,
                        userModel: socialLayoutController.userfiltered[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: socialLayoutController.userfiltered.length)
              : FirestoreListView<UserModel>(
                  query: usersQuery,
                  itemBuilder: (context, snapshot) {
                    UserModel userModel = snapshot.data();

                    return buildChatItem(
                        context: context, userModel: userModel);
                  },
                ),
        ),
      ),
    );
  }
}
