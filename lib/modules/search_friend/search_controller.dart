import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("searching...");
    search("samih");
  }

  void search(String query) {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: query)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
    });
  }
}
