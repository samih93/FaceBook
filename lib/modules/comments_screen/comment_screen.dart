import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/modules/comments_screen/comment_controller.dart';
import 'package:social_app/shared/components/componets.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class CommentsScreen extends StatelessWidget {
  String? postId;
  String? senderName;
  String? senderimage;
  int nbOfLikes;
  var commentsQuery;
  CommentsScreen(
      this.postId, this.senderName, this.senderimage, this.nbOfLikes) {
    commentsQuery = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('commentDate', descending: true)
        .withConverter<CommentModel>(
          fromFirestore: (snapshot, _) =>
              CommentModel.fromJson(snapshot.data()!),
          toFirestore: (comment, _) => comment.toJson(),
        );
  }
  var comment_textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsController>(
        init: CommentsController(),
        builder: (commentController) {
          return Scaffold(
              body: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            height: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nbOfLikes == 0
                          ? Text(
                              "Be the first to like this",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Row(
                              children: [
                                CircleAvatar(
                                    radius: 10,
                                    backgroundColor: defaultColor,
                                    child: FaIcon(
                                      FontAwesomeIcons.solidThumbsUp,
                                      color: Colors.white,
                                      size: 12,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  nbOfLikes.toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 20, color: Colors.black54),
                              ],
                            ),
                      FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.grey)
                    ],
                  ),
                ),
                Expanded(
                  child: FirestoreListView<CommentModel>(
                      shrinkWrap: true,
                      pageSize: 10,
                      query: commentsQuery,
                      loadingBuilder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                      errorBuilder: (context, error, stackTrace) => Text(
                          'Something went wrong! ${error} - ${stackTrace}'),
                      itemBuilder: (context, snapshot) {
                        late CommentModel model;
                        // NOTE check if snapshot is not empty
                        if (snapshot.hashCode == true) {
                          print("snapshot empty");
                        } else {
                          print("snapshot has data");
                          model = snapshot.data();
                        }

                        return Column(
                          children: [
                            _buildCommentItem(model, context),
                          ],
                        );
                      }),
                ),
                Divider(),
                _buildMessageRow(commentController),
              ],
            ),
          ));
        });
  }

  _buildCommentItem(CommentModel model, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(model.senderimage.toString()),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.senderName.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.text.toString(),
                    maxLines: 50,
                  ),
                ],
              ),
            ),
            Text(
              "${convertToAgo(DateTime.parse(model.commentDate!.toDate().toString()))}",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(height: 1.4, color: Colors.grey.shade700),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildemptyCommentView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottie/comments.json', width: 150, height: 150),
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
    );
  }

  _buildMessageRow(CommentsController commentController) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade100,
              ),
              padding: EdgeInsetsDirectional.only(start: 17),
              child: TextFormField(
                minLines: 1,
                maxLines: 4,
                scrollPhysics: ScrollPhysics(),
                onChanged: (value) {
                  setState(() {});
                },
                controller: comment_textcontroller,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "write a comment ... "),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                //setState(() {});
                if (comment_textcontroller.text.trim() != "") {
                  CommentModel model = CommentModel(
                      senderId: uId,
                      senderName: senderName,
                      senderimage: senderimage,
                      text: comment_textcontroller.text.toString(),
                      commentDate: Timestamp.fromDate(DateTime.now()));
                  commentController.AddCommentToPost(postId.toString(), model)
                      .then((value) {
                    comment_textcontroller.clear();
                  });
                } else {
                  showToast(
                      message: "Comment field must be not empty",
                      status: ToastStatus.Error);
                }
              },
              icon: Icon(Icons.send,
                  color: comment_textcontroller.text.trim() != ""
                      ? defaultColor
                      : Colors.grey)),
        ],
      );
    });
  }
}
