import 'dart:io';
import "package:collection/collection.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/model/storymodel.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/addstory/add_story.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/setting_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/local/cashhelper.dart';
import 'package:social_app/shared/network/remote/diohelper.dart';

class SocialLayoutController extends GetxController {
  bool? isGetNeededData = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    isGetNeededData = false;
    print(isGetNeededData);
    update();
    isHasTokenInFireStore = CashHelper.getData(key: "deviceToken") ?? null;
    getLoggedInUserData().then((value) {
      print('get logged in user');
      isGetNeededData = true;
      print(isGetNeededData);
      update();
    });
    getStories().then((value) {});
    //getPosts().the;n((value) {});
    getAllUsers().then((value) {});
    getMyFriend().then((value) {});
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    print("on ready");
    token = await FirebaseMessaging.instance.getToken() ?? null;
    print("token messaging -- " + token.toString());

    //  NOTE check if token not set so i set it to used in fcm notification
    if (token != null && isHasTokenInFireStore == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update({"deviceToken": token}).then((value) {
        CashHelper.saveData(key: "deviceToken", value: true);
        print("token Saved");
      });
    } else {
      print("token already saved");
    }
  }

  // SocialLayoutController() {
  //   //Future.delayed(Duration(seconds: 1));
  // }

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
      print(value.data());
      _socialUserModel = UserModel.fromJson(value.data()!);
      print(_socialUserModel!.toJson().toString());
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
      //uploadPostImage();
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
    await FirebaseStorage.instance
        .ref('')
        .child('posts/$uId/${Uri.file(_postimage!.path).pathSegments.last}')
        .putFile(_postimage!)
        .then((value) async {
      // without await if i call uploadpostimage.then(the value return null so i need await to finish get downlaod url)
      await value.ref.getDownloadURL().then((value) {
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
    if (_postimage != null)
      await uploadPostImage().then((value) {
        print("image" + _imagePostUrl.toString());
        // Future.delayed(Duration(seconds: 2));
      });
    PostModel model = PostModel(
        name: _socialUserModel!.name,
        image: _socialUserModel!.image.toString(),
        uId: _socialUserModel!.uId,
        postdate: postdate,
        text: text,
        postImage: _imagePostUrl ?? null);

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
          .update({'postId': value.id})
          .then((value) {})
          .catchError((error) {
            print(error.toString());
            // ! if an error in saving the post id i need to remove it
          });
      //   model.isLiked = false;
      _postimage = null;
      _imagePostUrl = null;
      _isloadingcreatePost = false;
      // NOTE push notification to subscribed to channel FriendsPost
      pushNotification();
      //getPosts();
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

// NOTE -------------------------- Old Get All Posts------------------------

  // bool? _isloadingGetPosts = false;
  // bool? get isloadingGetPosts => _isloadingGetPosts;

  //var postModel = Rxn<PostModel>();
  // List<PostModel> _listOfPost = [];
  // List<PostModel> get listOfPost => _listOfPost;

  // Future<void> getPosts() async {
  //   _listOfPost = [];
  //   _isloadingGetPosts = true;

  //   update();
  //   await FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('postdate', descending: true)
  //       .get()
  //       .then((value) {
  //     // NOTE : reference on posts
  //     int index = 0;
  //     if (value.docs.length > 0) {
  //       value.docs.forEach((docOfpost) async {
  //         // print(docOfpost.data());
  //         // NOTE : add posts in list befor access to its index
  //         _listOfPost.add(PostModel.fromJson(docOfpost.data()));

  //         // NOTE foreach document go to reference likes
  //         await docOfpost.reference
  //             .collection('likes')
  //             .get()
  //             .then((likescollection) async {
  //           //NOTE check  if this user like a post
  //           if (likescollection.docs.isNotEmpty) {
  //             likescollection.docs.forEach((docOflikes) {
  //               // NOTE  check of  the id of doc in likes equal to current user
  //               if (docOflikes.id == uId) {
  //                 _listOfPost[index].isLiked = true;
  //               }
  //             });
  //           }

  //           // NOTE value is the collection likes
  //           // NOTE Add lenght of doc for each likes in post doc
  //           _listOfPost[index].nbOfLikes = likescollection.docs.length;

  //           index++;
  //           update();
  //         }).catchError((error) {
  //           print(error.toString());
  //         });

  //         _listOfPost.forEach((element) async {
  //           isEmailVerifiedById(element.uId.toString()).then((value) {
  //             element.isEmailVerified = value;
  //             update();
  //           });
  //         });

  //         // // NOTE : Sort List desc order by date
  //         // _listOfPost.length != 0
  //         //     ? _listOfPost.sort((a, b) {
  //         //         //NOTE : compareTo : ==> 0 if a==b
  //         //         return b.postdate!.compareTo(a.postdate!);
  //         //       })
  //         //     : [];

  //         _isloadingGetPosts = false;
  //         update();
  //       });
  //     } else {
  //       _isloadingGetPosts = false;
  //       update();
  //     }

  //     // // NOTE if no posts yet
  //     // _isloadingGetPosts = false;
  //     // print("after " + _isloadingGetPosts.toString());
  //   }).catchError((error) {
  //     print(error.toString());
  //   });
  // }

  //NOTE : -----------Like Post --------------------------

  void likePost(String postId, {bool isForremove = false}) {
    print(postId);
    FirebaseFirestore.instance
        .collection('posts')
        .where('postId', isEqualTo: postId)
        .get()
        .then((doc_of_post) {
      if (doc_of_post.docs.length > 0) {
        if (!isForremove) {
          FirebaseFirestore.instance.collection('posts').doc(postId).update({
            'nbOfLikes': doc_of_post.docs.first.data()['nbOfLikes'] + 1,
            'likes': FieldValue.arrayUnion([uId])
          }).then((value) {});
        } else {
          FirebaseFirestore.instance.collection('posts').doc(postId).update({
            'nbOfLikes': doc_of_post.docs.first.data()['nbOfLikes'] - 1,
            'likes': FieldValue.arrayRemove([uId])
          }).then((value) {});
        }
      }
    });
  }

  // NOTE: Get All Users
  List<UserModel> _users = [];
  List<UserModel> get users => _users;
  bool? _isloadingGetUsers = false;
  bool? get isloadingGetUsers => _isloadingGetUsers;

  Future<void> getAllUsers() async {
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

// NOTE get My Chat Ids and Get My Users and get latest message of each one
  List<UserModel> myFriends = [];

  Future<void> getMyFriend(
      {bool isAlreadyFriend = false, String receiverId = ''}) async {
    List<UserModel> myFriendstemp = [];
    List<Timestamp> myfriendMesageTime = [];
    List<String> listOfMyChatIds = [];
    List<MessageModel> myfriendsMesage = [];

    UserModel? userModel;

// NOTE if already friend i need to move him to the first and get latest message and set it
    if (isAlreadyFriend) {
      if (receiverId != '') {
        UserModel model =
            myFriends.singleWhere((element) => element.uId == receiverId);
        myFriends.remove(model);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('chats')
            .doc(receiverId)
            .collection('messages')
            .orderBy('messageDate', descending: true)
            .get()
            .then((value) {
          print(value.docs.first.data()['text']);
          // NOTE Set latest message to user model .message model
          model.messageModel = MessageModel.fromJson(value.docs.first.data());
          myFriends.insert(0, model);
          update();
        });
      }
    } else {
      myFriends = [];

      // NOTE get Ids of my friends
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .orderBy('latestTimeMessage', descending: true)
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          value.docs.forEach((doc_of_chat) async {
            //   print(doc_of_chat.data());
            print("befor: " + doc_of_chat.id);
            listOfMyChatIds.add(doc_of_chat.id);
            // NOTE get latest time for each friend chat
            myfriendMesageTime.add(doc_of_chat.data()['latestTimeMessage']);
          });

          // print(myfriendsMesage.length);

          // NOTE get latest Message for each friend
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .collection('chats')
              .orderBy('latestTimeMessage', descending: true)
              .get()
              .then((value) {
            value.docs.forEach((element) async {
              element.reference
                  .collection('messages')
                  .orderBy('messageDate', descending: true)
                  .get()
                  .then((value) {
                if (value.docs.length > 0) {
                  myfriendsMesage
                      .add(MessageModel.fromJson(value.docs.first.data()));
                }
              });
            });
          }).catchError((error) {
            print(error.toString());
          });

          await Future.delayed(const Duration(milliseconds: 1000), () {});

          var userRef = await FirebaseFirestore.instance.collection('users');
          if (listOfMyChatIds.length > 0) {
            userRef
                .where(FieldPath.documentId,
                    whereIn:
                        listOfMyChatIds) // NOTE Get user where in Friend Ids
                .get()
                .then((value) {
              int indexforMessage = 0;
              if (value.docs.length > 0) {
                value.docs.forEach((doc_of_user) {
                  userModel = UserModel.fromJson(doc_of_user.data());

                  // NOTE set time stamp of latest message for each friend
                  userModel!.latestTimeMessage =
                      myfriendMesageTime[indexforMessage];
                  myFriendstemp.add(userModel!);

                  indexforMessage++;
                });
              }
              int indexforOrdering = 0;
              listOfMyChatIds.forEach((element) {
                print("id :" + element);
              });
              myfriendsMesage.forEach((element) {
                if (element.senderId == uId) {
                  print('friendMessageId :' + element.receiverId.toString());
                } else {
                  print("friendMessageId :" + element.senderId.toString());
                }
              });
              listOfMyChatIds.forEach((element) {
                UserModel model = myFriendstemp.singleWhere((element) =>
                    element.uId == listOfMyChatIds[indexforOrdering]);
                // NOTE set latest message received to each user
                if (myfriendsMesage.length > 0)
                  myfriendsMesage.forEach((element) {
                    // NOTE if the current logged in is the sender
                    if (element.senderId == uId) {
                      model.messageModel = myfriendsMesage.singleWhere(
                          (element) =>
                              element.receiverId ==
                                  listOfMyChatIds[indexforOrdering] ||
                              element.senderId ==
                                  listOfMyChatIds[indexforOrdering]);
                    }
                  });

                myFriends.add(model);
                indexforOrdering++;
              });
              myFriends.forEach((element) {
                print("after :" + element.uId.toString());
                // print(element.messageModel!.toJson().toString());
              });
              update();
            });
          }
        }
      });
    }
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

//

  //NOTE ------------ Get Stories -----------------------------------

  List<Map<String, dynamic>> storiestemp = [];
  Map<dynamic, List<Map<String, dynamic>>> storiesMap = {};
  bool isloadingGetStories = false;
  Future<void> getStories() async {
    isloadingGetStories = true;
    update();
    storiestemp = [];
    await FirebaseFirestore.instance
        .collection('stories')
        .where('storyDate',
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .get()
        .then((querySnap_of_stories) {
      querySnap_of_stories.docs.forEach((doc_of_stories) {
        //if(stories.contains(doc_of_stories.data()['storyUserId']))
        //  print("after-----------------")
        //  print(doc_of_stories.data());
        //  print("befor---------------");
        storiestemp.add(doc_of_stories.data());

        // stories.add(StoryModel.formJson(doc_of_stories.data()));
        isloadingGetStories = false;
        update();
      });
    });
    storiesMap = groupBy(storiestemp, (Map obj) => obj['storyUserId']);
    //var elment = storiesMap![uId.toString()]!.length;
    print(storiesMap.length.toString());
    update();
  }

  List<UserModel>? userfiltered;
  searchForUser(String query) {
    userfiltered = _users
        .where((element) => element.name.toString().contains(query))
        .toList();

    update();
  }
}
