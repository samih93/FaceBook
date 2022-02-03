import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/styles/colors.dart';

class EditProfile extends StatelessWidget {
  final double coverheight = 250;
  double profileheight = 60;

  var namecontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var biocontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
        init: Get.find<SocialLayoutController>(),
        builder: (socialLayoutController) {
          var socialUserModel = socialLayoutController.socialUserModel!;
          var profileimage = socialLayoutController.profileimage;
          var coverimage = socialLayoutController.coverimage;
          print(profileimage.toString());
          print(coverimage.toString());

          namecontroller.text = socialUserModel.name.toString();
          biocontroller.text = socialUserModel.bio.toString();
          phonecontroller.text = socialUserModel.phone.toString();
          return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: "Edit Profile",
                actions: [
                  defaultTextButton(
                      onpress:
                          //NOTE : check if an image still uploading  to firebase disable click
                          socialLayoutController.isloadingUrlcover! ||
                                  socialLayoutController.isloadingUrlProfile!
                              ? null
                              : () async {
                                  print("befor : " +
                                      socialLayoutController
                                          .isloadingupdateUser!
                                          .toString());
                                  socialLayoutController
                                      .updateUser(
                                          name: namecontroller.text,
                                          phone: phonecontroller.text,
                                          bio: biocontroller.text)
                                      .then((value) {
                                    if (!socialLayoutController
                                        .isloadingupdateUser!)
                                      Navigator.pop(context);
                                  });

                                  print("after : " +
                                      socialLayoutController
                                          .isloadingupdateUser!
                                          .toString());
                                },
                      text: "Update",
                      //NOTE : check if an image still uploading  to firebase change color of button to grey
                      color: socialLayoutController.isloadingUrlcover! ||
                              socialLayoutController.isloadingUrlProfile!
                          ? Colors.grey
                          : defaultColor),
                  SizedBox(
                    width: 15,
                  )
                ]),
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (socialLayoutController.isloadingupdateUser!)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 220,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          //NOTE:---------------- Cover Image ------------
                          //NOTE : check if cover still  uploading return progress bar else display image
                          socialLayoutController.isloadingUrlcover!
                              ? Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: CircularProgressIndicator())
                              : Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Container(
                                          height: 180,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                            ),
                                            image: DecorationImage(
                                              image: (coverimage == null ||
                                                      coverimage == "")
                                                  ? socialUserModel
                                                              .coverimage! !=
                                                          ""
                                                      ? NetworkImage(
                                                          socialUserModel
                                                              .coverimage
                                                              .toString())
                                                      : AssetImage(
                                                              'assets/default profile.png')
                                                          as ImageProvider
                                                  : FileImage(coverimage),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            //NOTE : for Cover
                                            socialLayoutController
                                                .pickImage(false)
                                                .then((value) {});
                                          },
                                          icon: CircleAvatar(
                                              radius: 20,
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 17,
                                              ))),
                                    ],
                                  ),
                                ),
                          //NOTE --------------- profile Image------------------------
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: profileheight + 3,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child:
                                    socialLayoutController.isloadingUrlProfile!
                                        ? CircularProgressIndicator()
                                        : CircleAvatar(
                                            radius: profileheight,
                                            backgroundImage: (profileimage ==
                                                        null ||
                                                    profileimage == "")
                                                ? socialUserModel.image! != ""
                                                    ? NetworkImage(
                                                        socialUserModel.image
                                                            .toString())
                                                    : AssetImage(
                                                            'assets/default profile.png')
                                                        as ImageProvider
                                                : FileImage(profileimage),
                                          ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    // NOTE : For Profile
                                    await socialLayoutController
                                        .pickImage(true)
                                        .then((value) {});
                                  },
                                  icon: CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 17,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        controller: namecontroller,
                        inputtype: TextInputType.name,
                        prefixIcon: Icon(Icons.person),
                        text: "Name",
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "name must not be empty";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        controller: biocontroller,
                        inputtype: TextInputType.text,
                        prefixIcon: Icon(Icons.info_outline),
                        text: "Bio",
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "bio must not be empty";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        controller: phonecontroller,
                        inputtype: TextInputType.phone,
                        prefixIcon: Icon(Icons.phone),
                        text: "Phone",
                        onvalidate: (value) {
                          if (value!.isEmpty) {
                            return "Phone must not be empty";
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
