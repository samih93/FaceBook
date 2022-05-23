import 'package:get/get.dart';
import 'package:social_app/layout/layout_controller.dart';
import 'package:social_app/modules/notifications_screen/notification_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    //NOTE:  implement dependencies

    Get.lazyPut<SocialLayoutController>(() => SocialLayoutController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
