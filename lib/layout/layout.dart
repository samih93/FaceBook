import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';

class SocialLayout extends StatelessWidget {
  get defaultColor => null;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: SocialLayoutController(),
      builder: (socialLayoutController) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(socialLayoutController
              .appbar_title[socialLayoutController.currentIndex]),
          actions: [
            IconButton(
                onPressed: () {
                  //socialLayoutController.pushNotification();
                },
                icon: Icon(Icons.notifications))
          ],
        ),
        body:
            socialLayoutController.screens[socialLayoutController.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: defaultColor,
          onTap: (index) {
            //NOTE : if index equal 2 open NewPostScreen without change index
            if (index == 2)
              Get.to(NewPostScreen());
            else
              socialLayoutController.onchangeIndex(index);
          },
          currentIndex: socialLayoutController.currentIndex,
          items: socialLayoutController.bottomItems,
        ),
      ),
    );
  }
}
