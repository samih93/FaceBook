import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/social_usermodel.dart';
import 'package:social_app/model/storymodel.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/setting_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/remote/diohelper.dart';

class SocialLayoutController extends GetxController {
  SocialLayoutController() {
    if (uId != null) getLoggedInUserData().then((value) {});
    getStories().then((value) {});
    getPosts().then((value) {});
    getUsers().then((value) {
      print("get user Finished");
    });
  }

// NOTE: -------------------Bottom Navigation------------------------
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
    BottomNavigationBarItem(icon: Icon(Icons.post_add_sharp), label: "Post"),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Users",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [
    FeedsScreen(),
    ChatScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingScreen()
  ];

  final appbar_title = ['Face Book', 'Chat', 'Post', 'Users', 'Settings'];

  //NOTE:  -------------------- Get User Data-------------------------
  UserModel? _socialUserModel;
  UserModel? get socialUserModel => _socialUserModel;

  Future<void> getLoggedInUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      //   print(value.data());
      _socialUserModel = UserModel.fromJson(value.data()!);
      // print("get user email :" + _socialUserModel!.email.toString());
      update();
    });
  }

  Future<bool?> isEmailVerifiedById(String userId) async {
    UserModel? model;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      // print(value.data());
      // print("get user email :" + _socialUserModel!.email.toString());
      model = UserModel.fromJson(value.data()!);
      //print(model!.isemailverified!);
      //update();
    });
    return model!.isemailverified;
  }

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    update();
  }

//NOTE :----------------------- Pick Profile Image and Cover Image-------------------------------
  File? _profileimage;
  File? get profileimage => _profileimage;

  File? _coverimage;
  File? get coverimage => _coverimage;

  var picker = ImagePicker();

  Future<void> pickImage(bool isForProfile) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isForProfile) {
        _profileimage = File(pickedFile.path);
        //NOTE :upload profile image to firebase storage
        uploadProfileImage();
      } else {
        _coverimage = File(pickedFile.path);
        //NOTE :upload cover image to firebase storage
        uploadCoverImage();
      }
      update();
    } else {
      print('no image selected');
    }
  }

//NOTE ------------------ Upload profile image --------------------

  bool? _isloadingUrlProfile = false;
  bool? get isloadingUrlProfile => _isloadingUrlProfile;

  String? _imageProfileUrl = null;
  String? get imageProfileUrl => _imageProfileUrl;

  Future<void> uploadProfileImage() async {
    _isloadingUrlProfile = true;
    update();
    FirebaseStorage.instance
        .ref('')
        .child('users/${Uri.file(_profileimage!.path).pathSegments.last}')
        .putFile(_profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        _imageProfileUrl = value;
        _isloadingUrlProfile = false;
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

//NOTE  ------------- Uplaod cover image ---------------------

  bool? _isloadingUrlcover = false;
  bool? get isloadingUrlcover => _isloadingUrlcover;

  String? _imagecoverUrl = null;
  String? get imageCoverUrl => _imagecoverUrl;

  Future<void> uploadCoverImage() async {
    _isloadingUrlcover = true;
    update();
    FirebaseStorage.instance
        .ref('')
        .child('users/${Uri.file(_coverimage!.path).pathSegments.last}')
        .putFile(_coverimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        _imagecoverUrl = value;
        _isloadingUrlcover = false;
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

//NOTE :---------------------- update user --------------------------
  bool? _isloadingupdateUser = false;
  bool? get isloadingupdateUser => _isloadingupdateUser;

  Future<void> updateUser(
      {required String name,
      required String phone,
      required String bio}) async {
    // print("Profile :" + _imageProfileUrl.toString());
    //  print("cover : " + _imagecoverUrl.toString());
    _isloadingupdateUser = true;
    update();
    UserModel model = UserModel(
        name: name,
        phone: phone,
        bio: bio,
        isemailverified: _socialUserModel!.isemailverified,
        email: _socialUserModel!.email,
        image: _imageProfileUrl ?? _socialUserModel!.image.toString(),
        coverimage: _imagecoverUrl ?? _socialUserModel!.coverimage.toString(),
        uId: _socialUserModel!.uId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toJson())
        .then((value) {
      print("User Updated");

      _profileimage = null;
      _coverimage = null;
      _imageProfileUrl = null;
      _imagecoverUrl = null;
      _isloadingupdateUser = false;
      getLoggedInUserData();
    }).catchError((error) {
      print(error.toString());
    });
  }

  //NOTE :---------------------- Manage New Post  --------------------------

  File? _postimage;
  File? get postimage => _postimage;

  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _postimage = File(pickedFile.path);
      //NOTE :upload post image to firebase storage
      uploadPostImage();
      update();
    } else {
      print('no image selected');
    }
  }

// NOTE :  upload post image
  bool? _isloadingurlPost = false;
  bool? get isloadingurlPost => _isloadingurlPost;

  String? _imagePostUrl = null;
  String? get imagePostUrl => _imagePostUrl;

  Future<void> uploadPostImage() async {
    _isloadingurlPost = true;
    update();
    FirebaseStorage.instance
        .ref('')
        .child('posts/${Uri.file(_postimage!.path).pathSegments.last}')
        .putFile(_postimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        _imagePostUrl = value;
        _isloadingurlPost = false;
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

// NOTE : -----------------create post----------------------------
  bool? _isloadingcreatePost = false;
  bool? get isloadingcreatePost => _isloadingcreatePost;

  Future<void> createNewPost({
    required String postdate,
    required String text,
  }) async {
    _isloadingcreatePost = true;
    update();
    PostModel model = PostModel(
        name: _socialUserModel!.name,
        image: _socialUserModel!.image.toString(),
        uId: _socialUserModel!.uId,
        postdate: postdate,
        text: text,
        postImage: _imagePostUrl ?? '');
    await FirebaseFirestore.instance
        .collection('posts')
        // NOTE .doc('1').set() set data under document Id =1
        // NOTE .add will generate new Id
        .add(model.toJson())
        .then((value) {
      // NOTE update postId to data of document after add the document
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .update({'postId': value.id});
      model.isLiked = false;
      _postimage = null;
      _imagePostUrl = null;
      _isloadingcreatePost = false;
      // NOTE push notification to subscribed to channel FriendsPost
      pushNotification();
      getPosts();
      update();
    }).catchError((error) {
      print(error.toString());
    });
  }

  // NOTE on type in text field body of post  to check if empty or not

  var postBodyText = "".obs;

  void ontyping_postBody(String value) {
    postBodyText.value = value;
    update();
  }

// NOTE on click close to remove image from post
  void removePostImage() {
    _postimage = null;
    _imagePostUrl = null;
    update();
  }

// NOTE --------------------------Get All Posts------------------------

  bool? _isloadingGetPosts = false;
  bool? get isloadingGetPosts => _isloadingGetPosts;

  List<PostModel> _listOfPost = [];
  List<PostModel> get listOfPost => _listOfPost;

  Future<void> getPosts() async {
    _listOfPost = [];
    _isloadingGetPosts = true;
    print("befor " + _isloadingGetPosts.toString());
    update();
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      // NOTE : reference on posts
      int index = 0;
      value.docs.forEach((docOfpost) async {
        // NOTE foreach document go to reference likes
        await docOfpost.reference
            .collection('likes')
            .get()
            .then((likescollection) async {
          // NOTE : add posts in list befor access to its index
          _listOfPost.add(PostModel.fromJson(docOfpost.data()));
          //NOTE check  if this user like a post
          if (likescollection.docs.isNotEmpty) {
            likescollection.docs.forEach((docOflikes) {
              // NOTE  check of  the id of doc in likes equal to current user
              if (docOflikes.id == uId) {
                _listOfPost[index].isLiked = true;
              }
            });
          }

          // NOTE value is the collection likes
          // NOTE Add lenght of doc for each likes in post doc
          _listOfPost[index].nbOfLikes = likescollection.docs.length;

          index++;
          update();
        }).catchError((error) {
          print(error.toString());
        });

        _listOfPost.forEach((element) async {
          isEmailVerifiedById(element.uId.toString()).then((value) {
            element.isEmailVerified = value;
            update();
          });
        });

        // NOTE : Sort List desc order by date
        _listOfPost.length != 0
            ? _listOfPost.sort((a, b) {
                //NOTE : compareTo : ==> 0 if a==b
                return b.postdate!.compareTo(a.postdate!);
              })
            : [];

        _isloadingGetPosts = false;
        print("after " + _isloadingGetPosts.toString());
        update();
      });
      // // NOTE if no posts yet
      // _isloadingGetPosts = false;
      // print("after " + _isloadingGetPosts.toString());
    }).catchError((error) {
      print(error.toString());
    });
  }

  //NOTE : -----------Like Post --------------------------

  void likePost(String postId, int index, {bool isForremove = false}) {
    if (isForremove == true) {
      // NOTE Change  nb and color of likes quickly then update to firestore

      _listOfPost[index].isLiked = false;
      _listOfPost[index].nbOfLikes--;
      update();
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(_socialUserModel!.uId)
          .delete()
          .then((value) {
        print('removed from Likes');
      }).catchError((error) {
        _listOfPost[index].isLiked = true;
        _listOfPost[index].nbOfLikes++;
        print(error.toString());
        update();
      });
    } else {
      // NOTE Change  nb and color of likes quickly then update to firestore
      _listOfPost[index].isLiked = true;
      _listOfPost[index].nbOfLikes++;
      update();
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(_socialUserModel!.uId)
          .set({'like': true}).then((value) {
        print("Added To Likes");
        pushNotificationOnLike();
      }).catchError((error) {
        //NOTE : if an error happen return data to the last updated
        _listOfPost[index].isLiked = false;
        _listOfPost[index].nbOfLikes--;
        update();

        print(error.toString());
      });
    }
  }

  // NOTE: Get All Users
  List<UserModel> _users = [];
  List<UserModel> get users => _users;
  bool? _isloadingGetUsers = false;
  bool? get isloadingGetUsers => _isloadingGetUsers;

  // Future<void> getUsers() async {
  //   _isloadingGetUsers = true;
  //   update();
  //   await FirebaseFirestore.instance.collection('users').get().then((value) {
  //     value.docs.forEach((usermodel) {
  //       if (usermodel.data()['uId'] != uId)
  //         _users.add(UserModel.fromJson(usermodel.data()));
  //       _isloadingGetUsers = false;
  //       update();
  //     });
  //   });
  // }

  Future<void> getUsers() async {
    _isloadingGetUsers = true;
    print("UId : " + uId.toString());
    update();

    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((usermodel) {
        if (usermodel.data()['uId'] != uId)
          _users.add(UserModel.fromJson(usermodel.data()));
        _isloadingGetUsers = false;
        update();
      });
    });

    _isloadingGetUsers = false;
    update();
  }

// NOTE push notification when a friend add a new post
  void pushNotification() {
    print("test fcm befor");
    DioHelper.postData(url: 'https://fcm.googleapis.com/fcm/send', data: {
      "to": "/topics/FriendsPost",
      "notification": {
        "body": "see details",
        "title": _socialUserModel!.name.toString() + " Add new Post",
        "sound": "default"
      },
      "android": {
        "priortiy": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "87",
        "type": "order"
      }
    }).then((value) {
      print("notification pushed");
    }).catchError((error) {
      print(error.toString());
    });
  }

  // NOTE push notification when a friend like my post a new post
  void pushNotificationOnLike() {
    DioHelper.postData(url: 'https://fcm.googleapis.com/fcm/send', data: {
      "to": "/topics/LikesPost",
      "notification": {
        "body": "see details",
        "title": _socialUserModel!.name.toString() + " Like Your post",
        "sound": "default"
      },
      "android": {
        "priortiy": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "87",
        "type": "order"
      }
    }).then((value) {
      print("notification pushed");
    }).catchError((error) {
      print(error.toString());
    });
  }

  // NOTE ------------------- Add Story ------------------------

  Future<void> AddStory(String uId) async {
    StoryModel storyModel = StoryModel(
        storyId: '',
        storyUserId: uId,
        storyName: "samih damaj",
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJiDUsiX6YaPIQ1cWEEehfjPYQjHyjJkMU3Q&usqp=CAU',
        caption: "instagram",
        storyDate: '2022-02-10 15:30');

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

  //NOTE ------------ Get Stories -----------------------------------

  //Map<String, List<StoryModel?>>  stories  ;
  List<StoryModel?> stories = [];
  Future<void> getStories() async {
    await FirebaseFirestore.instance
        .collection('stories')
        .get()
        .then((querySnap_of_stories) {
      querySnap_of_stories.docs.forEach((doc_of_stories) {
        if(stories.contains(doc_of_stories.data()['storyUserId']))
        print(doc_of_stories.data());
        //stories.add(StoryModel.formJson(doc_of_stories.data()));
      });
    });
  }
}
