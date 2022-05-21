import 'package:flutter/material.dart';

class FriendProfileScreen extends StatelessWidget {
  final double coverAndProfileheight = 220;
  final double coverimageheight = 180;
  double profileheight = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
                child: Column(
                  children: [
                    //NOTE Cover And Profile ---------------------
                    Container(
                      height: coverAndProfileheight,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          //NOTE : Cover Image
                          Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: coverimageheight,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/default profile.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),

                          //NOTE profileImage
                          CircleAvatar(
                            radius: profileheight + 3,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                                radius: profileheight,
                                backgroundImage:
                                    AssetImage('assets/profile_test.jpg')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //NOTE Name
                    Text(
                      "Samih damaj",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 25),
                    ),
                    // NOTE bio
                    Text(
                      "developer",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
