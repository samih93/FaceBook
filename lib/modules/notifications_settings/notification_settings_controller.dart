import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/network/local/cashhelper.dart';

class NotificationSettingsController extends GetxController {
  var isGetLikesNotification = false.obs;
  var isGetFriendRequestNotification = false.obs;
  var isGetCommentsNotification = false.obs;
  var isGetSMSNotification = false.obs;
  var isGetFriendPostNotification = false.obs;

  NotificationSettingsController() {
    isGetLikesNotification.value =
        CashHelper.getData(key: 'isGetLikesNotification') ?? false;
    isGetFriendRequestNotification.value =
        CashHelper.getData(key: 'isGetFriendRequestNotification') ?? false;
    isGetCommentsNotification.value =
        CashHelper.getData(key: 'isGetCommentsNotification') ?? false;
    isGetSMSNotification.value =
        CashHelper.getData(key: 'isGetSMSNotification') ?? false;
    isGetFriendPostNotification.value =
        CashHelper.getData(key: 'isGetFriendPostNotification') ?? false;
  }

// NOTE Likes -----------------
  onchangeLikesNotification(bool value) {
    isGetLikesNotification.value = value;
    CashHelper.saveData(key: "isGetLikesNotification", value: value);
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic("LikesPost");
      showToast(message: "Subscribed", status: ToastStatus.Success);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("LikesPost");
      showToast(message: "Unsubscribed", status: ToastStatus.Success);
    }
    update();
  }

// NOTE Comments ----------------------
  onchangeCommentNotification(bool value) {
    isGetCommentsNotification.value = value;
    CashHelper.saveData(key: "isGetCommentsNotification", value: value);
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic("comments");
      showToast(message: "Subscribed", status: ToastStatus.Success);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("comments");
      showToast(message: "Unsubscribed", status: ToastStatus.Success);
    }
    update();
  }

  // NOTE Friend Request
  onchangeFriendRequestNotification(bool value) {
    isGetFriendRequestNotification.value = value;
    CashHelper.saveData(key: "isGetFriendRequestNotification", value: value);
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic("friendsrequest");
      showToast(message: "Subscribed", status: ToastStatus.Success);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("friendsrequest");
      showToast(message: "Unsubscribed", status: ToastStatus.Success);
    }
    update();
  }

  //NOTE SMS
  onchangeSMSNotification(bool value) {
    isGetSMSNotification.value = value;
    CashHelper.saveData(key: "isGetSMSNotification", value: value);
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic("sms");
      showToast(message: "Subscribed", status: ToastStatus.Success);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("sms");
      showToast(message: "Unsubscribed", status: ToastStatus.Success);
    }
    update();
  }

  onchangeFriendPostNotification(bool value) {
    isGetFriendPostNotification.value = value;
    CashHelper.saveData(key: "isGetFriendPostNotification", value: value);
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic("FriendsPost");
      showToast(message: "Subscribed", status: ToastStatus.Success);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("FriendsPost");
      showToast(message: "Unsubscribed", status: ToastStatus.Success);
    }
    update();
  }
}
