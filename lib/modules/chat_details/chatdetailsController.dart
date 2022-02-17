import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/remote/diohelper.dart';

class ChatDetailsController extends GetxController {
  var socialLayoutController = Get.find<SocialLayoutController>();

  // NOTE on type in text field to check if empty or not
  var messageText = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete => super.onDelete;

  void ontypingmessage(value) {
    messageText.value = value;
    update();
  }

  // NOTE :------------------ send Message ---------------------------------------

  var isSendMessageSuccess = false.obs;

  void sendMessage(
      {required String receiverId,
      required String messageDate,
      required String text}) {
    isSendMessageSuccess.value = false;
    MessageModel messageModel = MessageModel(
        senderId: uId,
        receiverId: receiverId,
        text: text,
        messageDate: messageDate,
        image: _imageMessageUrl ?? '',
        isReadByfriend: false);

    // NOTE write message in user sender
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      // NOTE set latest time in doc of sender
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .set({'latestTimeMessage': DateTime.now()}).then((value) {});

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(messageModel.toJson())
          .then((value) {
        // NOTE set latest time in doc of receiver
        FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .collection('chats')
            .doc(uId)
            .set({'latestTimeMessage': DateTime.now()}).then((value) {});
        // NOTE add lastest time message in receiver message
        isSendMessageSuccess.value = true;
        update();

        FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .get()
            .then((value) {
          UserModel usermodel = UserModel.fromJson(value.data()!);
          print(usermodel.toJson());
          pushNotificationOnsendMessage(messageModel, usermodel);
        });
      }).catchError((error) {
        print(error.toString());
      });
      if (socialLayoutController.myFriends
          .where((element) => element.uId == receiverId)
          .isEmpty) {
        socialLayoutController.getMyFriend();
      } else {
        socialLayoutController.getMyFriend(
            isAlreadyFriend: true, receiverId: receiverId);
      }

      update();
    }).catchError((error) {
      print(error.toString());
    });
  }

  // NOTE : -------------- get Messages-----------------

  List<MessageModel> _listOfMessages = [];
  List<MessageModel> get listOfMessages => _listOfMessages;

  var isGetMessageSuccess = false.obs;

  void getMessages({required String receiverId}) {
    isGetMessageSuccess.value = false;
    update();

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('messageDate')
        .limitToLast(10)
        .snapshots()
        // ! Stream => of type Stream<QureySnapshot>  get data and still open to receive new updates
        // ! get => of type Future<QuerySnapshot> get data one time
        .listen((event) {
      _listOfMessages = []; // ! cz listen get old and new data
      // update();
      event.docs.forEach((element) {
        _listOfMessages.add(MessageModel.fromJson(element.data()));
        update();
      });
    });
    isGetMessageSuccess.value = true;
    update();
  }

// NOTE Picke Image
  File? _messageImage = null;
  File? get messageImage => _messageImage;

  var picker = ImagePicker();
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _messageImage = File(pickedFile.path);
      //NOTE :upload profile image to firebase storage
      //uploadMessageImage();
      update();
    } else {
      print('no image selected');
    }
  }

//NOTE upload message image to database
  bool? _isloadingUrlMessage = false;
  bool? get isloadingUrlMessage => _isloadingUrlMessage;

  String? _imageMessageUrl = null;
  String? get imageMessageUrl => _imageMessageUrl;

  Future<void> uploadMessageImage(String receiverId) async {
    _isloadingUrlMessage = true;
    update();
    await FirebaseStorage.instance
        .ref('')
        .child(
            'users/chats/$uId/${Uri.file(_messageImage!.path).pathSegments.last}')
        .putFile(_messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        _imageMessageUrl = value;
        _isloadingUrlMessage = false;
        sendMessage(
            receiverId: receiverId,
            messageDate: DateTime.now().toString(),
            text: '');
        _imageMessageUrl = null;
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

  // NOTE on click close to remove image from chat
  void removeMessageImage() {
    _messageImage = null;
    _imageMessageUrl = null;
    update();
  }

  //NOTE push notification to my friend when i send a message
  void pushNotificationOnsendMessage(
      MessageModel messageModel, UserModel userModel) {
    print("device token :" + userModel.deviceToken.toString());
    DioHelper.postData(url: 'https://fcm.googleapis.com/fcm/send', data: {
      "to": userModel.deviceToken,
      "notification": {
        "body": messageModel.text,
        "title": userModel.name,
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
      "data": {"messageModel": messageModel.toJson()}
    }).then((value) {
      print("notification pushed");
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> updatestatusMessage(List<MessageModel> messagesModel) async {
    var first = FirebaseFirestore.instance
        .collection('users')
        .doc(messagesModel.first.senderId)
        .collection('chats')
        .doc(messagesModel.first.receiverId)
        .collection('messages')
        .orderBy('messageDate')
        .limit(messagesModel.length);

    first.get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['isReadByfriend'] == false)
          FirebaseFirestore.instance
              .collection('users')
              .doc(messagesModel.first.senderId)
              .collection('chats')
              .doc(messagesModel.first.receiverId)
              .collection('messages')
              .doc(element.id)
              .update({'isReadByfriend': true}).then((value) {
            print('messages updates');
          });
      });
    });
  }
}
