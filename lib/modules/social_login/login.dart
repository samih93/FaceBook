import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/social_login/login_controller.dart';
import 'package:social_app/modules/social_register/register.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cashhelper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (socialLoginController) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOGIN",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Login To comunicate with friends",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      controller: emailController,
                      text: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                      inputtype: TextInputType.emailAddress,
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your email address';
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    defaultTextFormField(
                      controller: passwordController,
                      text: "Password",
                      prefixIcon: Icon(Icons.lock),
                      inputtype: TextInputType.emailAddress,
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter password';
                        }
                      },
                      obscure: socialLoginController.showpassword,
                      suffixIcon: IconButton(
                        icon: socialLoginController.showpassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          socialLoginController.onObscurePassword();
                          print(socialLoginController.showpassword);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    socialLoginController.isloadingLogin
                        ? Center(child: CircularProgressIndicator())
                        : defaultButton(
                            text: "Login",
                            isUppercase: true,
                            onpress: () async {
                              if (_formkey.currentState!.validate()) {
                                await socialLoginController.userlogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }

                              if (socialLoginController.statusLoginMessage ==
                                  ToastStatus.Success) {
                                //NOTE: uId saved in login method
                                CashHelper.saveData(key: "uId", value: uId);
                                Get.off(SocialLayout());
                              }

                              showToast(
                                  message: socialLoginController.statusMessage,
                                  status: socialLoginController
                                      .statusLoginMessage!);
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                        ),
                        defaultTextButton(
                            onpress: () {
                              Get.to(RegisterScreen());
                            },
                            text: "Register".toUpperCase()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
