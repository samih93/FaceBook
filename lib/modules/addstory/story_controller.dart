import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/storymodel.dart';

class StoryController extends GetxController {
  SocialLayoutController socialLayoutController =
      Get.find<SocialLayoutController>();
  void onInit() async {
    super.onInit();
    pickStoryImage();
  }

  // NOTE Pick Story image
  File? _storyimage;
  File? get storyimage => _storyimage;
  var picker = ImagePicker();

  Future<void> pickStoryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _storyimage = File(pickedFile.path);
      //NOTE :upload post image to firebase storage
      //uploadPostImage();
      update();
    } else {
      print('no image selected');
    }
  }

// NOTE on click close to remove image from post
  void removeStoryImage() {
    _storyimage = null;
    // _imagePostUrl = null;
    update();
  }

  // NOTE ------------------- Add Story ------------------------

  Future<void> AddStory(String uId) async {
    StoryModel storyModel = StoryModel(
        storyId: '',
        storyUserId: uId,
        storyName: socialLayoutController.socialUserModel!.name,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJiDUsiX6YaPIQ1cWEEehfjPYQjHyjJkMU3Q&usqp=CAU',
        caption: "instagram",
        storyDate: DateTime.now().toString());

    await FirebaseFirestore.instance
        .collection('stories')
        .add(storyModel.toJson())
        .then((value) async {
      print("story inserted in stories collection");
      storyModel.storyId = value.id;
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(value.id)
          .update({'storyId': value.id}).then((value) {
        print("story updated in stories collection");
      });
    });
  }

// // NOTE :  upload post image
//   bool? _isloadingurlPost = false;
//   bool? get isloadingurlPost => _isloadingurlPost;

//   String? _imagePostUrl = null;
//   String? get imagePostUrl => _imagePostUrl;

//   Future<void> uploadPostImage() async {
//     _isloadingurlPost = true;
//     update();
//     FirebaseStorage.instance
//         .ref('')
//         .child('posts/${Uri.file(_postimage!.path).pathSegments.last}')
//         .putFile(_postimage!)
//         .then((value) {
//       value.ref.getDownloadURL().then((value) {
//         _imagePostUrl = value;
//         _isloadingurlPost = false;
//         update();
//       }).catchError((error) {
//         {
//           print(error.toString());
//         }
//       });
//     }).catchError((error) {
//       print(error.toString());
//     });
//   }
}
