import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/storymodel.dart';
import 'package:social_app/shared/constants.dart';

class StoriesController extends GetxController {
  String? tag;
  StoriesController({this.tag});

  SocialLayoutController socialLayoutController =
      Get.find<SocialLayoutController>();
  void onInit() async {
    super.onInit();

    print("tag " + tag.toString());
    if (tag.toString() == 'AddStoryScreen') pickStoryImage();
  }

  // NOTE Pick Story image
  File? _storyimage;
  File? get storyimage => _storyimage;
  var picker = ImagePicker();

  Future<void> pickStoryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _storyimage = File(pickedFile.path);
      //NOTE :upload Story image to firebase storage
      //uploadStoryImage();
      update();
    } else {
      print('no image selected');
    }
  }

// NOTE on click close to remove image from Story
  void removeStoryImage() {
    _storyimage = null;
    // _imagePostUrl = null;
    update();
  }

// NOTE :  upload post image
  bool? _isloadingurlStory = false;
  bool? get isloadingurlStory => _isloadingurlStory;

  String? _imageStoryUrl = null;
  String? get imageStoryUrl => _imageStoryUrl;

  Future<void> uploadStoryImage() async {
    _isloadingurlStory = true;
    update();
    await FirebaseStorage.instance
        .ref('')
        .child('Stories/$uId/${Uri.file(_storyimage!.path).pathSegments.last}')
        .putFile(_storyimage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        _imageStoryUrl = value;
        _isloadingurlStory = false;
        update();
      }).catchError((error) {
        {
          print(error.toString());
        }
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  // NOTE ------------------- Add Story ------------------------
  var isLoadingAddStory = false.obs;

  Future<void> AddStoryToFireStore({String? caption = ''}) async {
    isLoadingAddStory.value = true;
    if (_storyimage != null)
      await uploadStoryImage().then((value) async {
        print("image" + _storyimage.toString());
        // Future.delayed(Duration(seconds: 2));
        StoryModel storyModel = StoryModel(
            storyId: '',
            storyUserId: uId,
            storyName: socialLayoutController.socialUserModel!.name,
            image: _imageStoryUrl,
            caption: caption,
            storyUserImage: socialLayoutController.socialUserModel!.image,
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
            isLoadingAddStory.value = false;
          });
        });
      });
  }

  // Note For Time of Story

  var storytime = ''.obs;

  onchangeStorytime(val) {
    storytime.value = val;
  }
}
