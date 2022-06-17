import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../screens/widgets/shared_widgets.dart';

class FullScreenController extends GetxController {
  static FullScreenController get to => Get.find();

  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  final tabValue = 0.obs;
  final sortByRecent = false.obs;
  final isInEditingMode = false.obs;
  final editingComment = Comment(
          postName: '',
          postCreator: '',
          postGroup: '',
          postLink: '',
          commenter: '',
          commentText: '',
          commenterUrl: '',
          addedTime: DateTime.now())
      .obs;

  TextEditingController editingController = TextEditingController();

  final post = Post(
    name: '',
    youtubeLink: '',
    tags: [],
    groupName: '',
    creator: '',
    creatorImageUrl: '',
    addedTime: DateTime.now(),
  ).obs;

  setPost(Post newPost) {
    post(newPost);
  }

  setEditingMode(bool value, Comment cmt) {
    isInEditingMode(value);
    editingComment(cmt);
    editingController.text = cmt.commentText;
  }

  clearEditingMode() {
    isInEditingMode(false);
    editingComment(Comment(
        postName: '',
        postCreator: '',
        postGroup: '',
        postLink: '',
        commenter: '',
        commentText: '',
        commenterUrl: '',
        addedTime: DateTime.now()));
    editingController.clear();
  }

  editComment() async {
    try {
      loadingDialog();
      // Edit Comment
      Comment metaComment = editingComment.value;
      metaComment.commentText = editingController.text;
      metaComment.addedTime = DateTime.now();
      await _allComments.doc(metaComment.docId).update(metaComment.toJson());
      // Modify Post Comments
      Post currentPost = post.value;
      currentPost.comments!.forEach((element) {
        if (element.commentText == editingComment.value.commentText &&
            element.commenter == editingComment.value.commenter) {
          element = metaComment;
        }
      });
      post(currentPost);
      // Edit Finish
      clearEditingMode();
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  deleteComment() async {
    try {
      loadingDialog();
      // Edit Comment
      Comment metaComment = editingComment.value;
      await _allComments.doc(metaComment.docId).delete();
      // Modify Post Comments
      Post currentPost = post.value;
      currentPost.comments!
          .removeWhere((element) => element == editingComment.value);
      post(currentPost);
      // Edit Finish
      clearEditingMode();
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  addCommentToPost(Comment cmt) {
    Post currentPost = post.value;
    currentPost.comments!.add(cmt);
    post(currentPost);
  }

  changeTabValue() {
    if (tabValue.value == 0) {
      tabValue(1);
    } else {
      tabValue(0);
    }
  }

  // Delete Posts
  deletePost(Post post) async {
    infoDialog(
        title: 'Are you sure you want to delete this post?',
        content: '${post.name} will be deleted.',
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                Get.back();
                try {
                  await _allPosts.doc(post.docId).delete();
                  // Delect All Comments
                  QuerySnapshot<Object?> postComments = await _allComments
                      .where('postName', isEqualTo: post.name)
                      .where('postLink', isEqualTo: post.youtubeLink)
                      .where('postCreator', isEqualTo: post.creator)
                      .where('postGroup', isEqualTo: post.groupName)
                      .get();
                  if (postComments.docs.isNotEmpty) {
                    // ignore: avoid_function_literals_in_foreach_calls
                    postComments.docs.forEach((element) async {
                      await _allComments.doc(element.id).delete();
                    });
                  }
                  //  ----
                  Get.back();
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                  Get.back();
                  Get.snackbar(
                    "Something went wrong!",
                    "Please try again later.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                  );
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )),
        ]);
  }

  sortComments(bool value) {
    if (value) {
      post.value.comments!.sort((a, b) => a.addedTime.compareTo(b.addedTime));
      sortByRecent(true);
    } else {
      post.value.comments!.sort((a, b) => b.addedTime.compareTo(a.addedTime));
      sortByRecent(false);
    }
  }
}
