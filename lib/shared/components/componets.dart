import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/styles/colors.dart';

//NOTE  ---------default APP bar -------------------------
AppBar defaultAppBar(
        {required BuildContext context,
        String? title,
        List<Widget>? actions}) =>
    AppBar(
      titleSpacing: 5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title.toString()),
      actions: actions,
    );

//NOTE ----------default Button -----------------------------
Widget defaultButton(
        {double width = double.infinity,
        Color background = Colors.blue,
        VoidCallback? onpress,
        required String text,
        double radius = 0,
        double height = 40,
        bool? isUppercase}) =>
    Container(
      width: width,
      child: MaterialButton(
        height: height,
        onPressed: onpress,
        child: Text(
          (isUppercase != null && isUppercase) ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

//NOTE ----------default Text  Button -----------------------------
Widget defaultTextButton(
        {@required VoidCallback? onpress,
        @required String? text,
        Color? color}) =>
    TextButton(
      onPressed: onpress,
      child: Text(
        text!,
        style: TextStyle(color: color ?? defaultColor),
      ),
    );

//NOTE ----------default TextFormField -----------------------------
Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType inputtype,
        Function(String?)? onfieldsubmit,
        VoidCallback? ontap,
        String? Function(String?)? onvalidate,
        Function(String?)? onchange,
        String? text,
        Widget? prefixIcon,
        Widget? suffixIcon,
        bool obscure = false,
        InputBorder? border,
        String? hinttext,
        int? maxligne}) =>
    TextFormField(
        controller: controller,
        keyboardType: inputtype,
        onFieldSubmitted: onfieldsubmit,
        onTap: ontap,
        maxLines: maxligne ?? 1,
        obscureText: obscure,
        onChanged: onchange,
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          labelText: text,
          hintText: hinttext ?? null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: border ?? OutlineInputBorder(),
        ),
        validator: onvalidate);

//NOTE ----------My Divider -----------------------------
Widget myDivider() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 1,
    );

//NOTE ----------Toast message -----------------------------

void showToast({required message, required ToastStatus status}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(status),
        textColor: Colors.white,
        fontSize: 16.0);

//NOTE ----------Toast Types -----------------------------

enum ToastStatus { Success, Error, Warning }

//NOTE ----------choose Toast Color -----------------------------
Color chooseToastColor(ToastStatus status) {
  Color color;
  switch (status) {
    case ToastStatus.Success:
      color = defaultColor;
      break;
    case ToastStatus.Error:
      color = Colors.red;
      break;
    case ToastStatus.Warning:
      color = Colors.amber;
      break;
  }
  return color;
}

// NOTE buildChatItem
Widget buildChatItem(
        {required BuildContext context,
        required UserModel userModel,
        bool isForChatScreen = false}) =>
    InkWell(
      onTap: () {
        // TODO: get Messages
        // socialLayoutController.getMessages(
        //     receiverId: userModel.uId.toString());
        Get.to(ChatDetailsScreen(
          socialUserModel: userModel,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: userModel.image == null || userModel.image == ""
                  ? AssetImage('assets/default profile.png') as ImageProvider
                  : NetworkImage(userModel.image!),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userModel.name.toString(),
                        style: TextStyle(
                            height: 1.4,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    isForChatScreen && userModel.messageModel != null
                        ? Text(
                            "${DateFormat("h:mm a").format(DateTime.parse(userModel.messageModel!.messageDate.toString()))}",
                            style: TextStyle(color: Colors.grey),
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                isForChatScreen && userModel.messageModel != null
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          userModel.messageModel!.text.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ],
            )),
          ],
        ),
      ),
    );
