import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/shared/constants.dart';

class ChatDetailsController extends GetxController {
  var socialLayoutController = Get.find<SocialLayoutController>();

  // NOTE on type in text field to check if empty or not
  var messageText = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

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
    MessageModel model = MessageModel(
        senderId: uId,
        receiverId: receiverId,
        text: text,
        messageDate: messageDate,
        image: _imageMessageUrl ?? '');

    // NOTE write message in user sender
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .set({'latestTimeMessage': DateTime.now()}).then((value) {});

      // NOTE write message in user received
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(model.toJson())
          .then((value) {
        // NOTE add lastest time message in receiver message
        isSendMessageSuccess.value = true;
        update();
      }).catchError((error) {
        print(error.toString());
      });
      if (socialLayoutController.myFriends
          .where((element) => element.uId == receiverId)
          .isEmpty) {
        socialLayoutController.getMyFriend();
      } else {
        socialLayoutController.getMyFriend();
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
}
