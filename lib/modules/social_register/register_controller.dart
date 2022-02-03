import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_app/model/social_usermodel.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/constants.dart';

class RegisterController extends GetxController {
  //NOTE : ---------------------Show Hide password--------------------
  bool _showpassword = true;
  bool get showpassword => _showpassword;

  onObscurePassword() {
    _showpassword = !showpassword;
    update();
  }

  // NOTE: --------------------- Resgister New User --------------

  ToastStatus? _statusLoginMessage;
  ToastStatus? get statusLoginMessage => _statusLoginMessage;

  String? _statusMessage = "";
  String? get statusMessage => _statusMessage;

  bool? _isloadingRegister = false;
  bool? get isloadingRegister => _isloadingRegister;

  Future<void> registerUser(
      {required String name,
      required String email,
      required String password,
      required String phone}) async {
    _statusLoginMessage = ToastStatus.Success;
    _statusMessage = "User Created Successfully";
    // _isloadingRegister = true;
    // update();
    // FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(email: email, password: password)
    //     .then((value) {
    //   _isloadingRegister = false;

    //   print(value.user!.email);
    //   print(value.user!.uid);
    //   update();
    // }).catchError((error) {
    //   print(error.toString());
    // });
    _isloadingRegister = true;
    update();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print(value.user!.email);
        print(value.user!.uid);
        uId = value.user!.uid;
        await registerUserToFireStore(
            name: name, email: email, phone: phone, uid: value.user!.uid);
        _isloadingRegister = false;
        update();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _statusMessage = "The password provided is too weak.";
        _statusLoginMessage = ToastStatus.Error;

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _statusMessage = "The account already exists for that email.";
        _statusLoginMessage = ToastStatus.Error;

        print('The account already exists for that email.');
      }
      _isloadingRegister = false;
      update();
    }
  }

  // NOTE: --------------------- Resgister User To FireStore --------------

  bool _isSuccessRegisterToFireStore = false;
  bool get isSuccessRegisterToFireStore => _isSuccessRegisterToFireStore;

  Future<void> registerUserToFireStore(
      {required String name,
      required String email,
      required String phone,
      required String uid}) async {
    UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        image: '',
        coverimage: '',
        bio: 'write your bio ...',
        uId: uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toJson())
        .then((value) {
      _isSuccessRegisterToFireStore = true;
      update();
    }).catchError((error) {
      print(error.toString());
    });
    print("register status function $_isSuccessRegisterToFireStore");
  }
}
