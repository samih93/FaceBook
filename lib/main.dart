import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/helper/binding.dart';
import 'package:social_app/shared/network/local/cashhelper.dart';

import 'modules/social_login/login.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(" message data background " + message.data.toString());
  showToast(message: "on background message", status: ToastStatus.Success);
}

void main() async {
  // NOTE : to run all thing befor runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: INITIALIZE FIREBASE
  await Firebase.initializeApp();

// NOTE : Unique token for device
  var messagingToken = await FirebaseMessaging.instance.getToken();
  print("token messaging -- " + messagingToken.toString());

// NOTE : catch notification  with parameter while app is opened  : ForeGroundMessage
  FirebaseMessaging.onMessage.listen((message) {
    print("message data " + message.data.toString());
    showToast(message: "on message", status: ToastStatus.Success);
  });

// NOTE : catch notification  with parameter while app is closed and when on press notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("message data opened " + message.data.toString());
    showToast(message: "on message opened", status: ToastStatus.Success);
  });

// NOTE : catch notification  with parameter while app is in background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await CashHelper.Init();

  Widget widget;

  uId = CashHelper.getData(key: "uId") ?? null;
  print("UId :" + uId.toString());

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  //NOTE ----------------------------------

  //NOTE : ADD dependencies

  Get.put(SocialLayoutController());
  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  Widget widget;
  MyApp(this.widget);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLayoutController>(
      init: Get.find<SocialLayoutController>(),
      builder: (newsLayoutController) => GetMaterialApp(
        // bind the dependency

        initialBinding: Binding(),
        debugShowCheckedModeBanner: false,
        home: widget,
      ),
    );
  }
}
