import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/shared/constants.dart';

class CommentsController extends GetxController {
  //NOTE Add Comment On Post
  Future<void> AddCommentToPost(String postId, CommentModel model) async {
    print("befor insert");
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .where('postId', isEqualTo: postId)
          .get()
          .then((doc_of_post) {
        FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'nbOfComments': doc_of_post.docs.first.data()['nbOfComments'] + 1,
        }).then((value) {});
      });
      print('inserted');
      print(value.id);
    });
  }
}
