import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/shared/styles/colors.dart';

class CommentsScreen extends StatelessWidget {
  var comment_textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Be the first to like this",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.grey)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/comments.json',
                        width: 150, height: 150),
                    Text("No Comments yet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.grey,
                        )),
                    Text("Be the first to Comment",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.shade100,
                      ),
                      padding: EdgeInsetsDirectional.only(start: 17),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: comment_textcontroller,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "write a comment ... "),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        //setState(() {});
                      },
                      icon: Icon(Icons.send,
                          color: comment_textcontroller.text.trim() != ""
                              ? defaultColor
                              : Colors.grey)),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
