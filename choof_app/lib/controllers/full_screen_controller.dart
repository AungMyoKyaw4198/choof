import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../models/youtubeVideoResponse.dart';
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
  final videoDetail = YoutubeVideoResponse().obs;
  final isLoading = false.obs;
  final textFieldExpanded = false.obs;
  final editingTextFieldExpanded = false.obs;
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

  setTextFieldExpanded(bool value) {
    textFieldExpanded(value);
  }

  setEditingTextFieldExpanded(bool value) {
    editingTextFieldExpanded(value);
  }

  setVideoDetail(YoutubeVideoResponse value) {
    videoDetail(value);
  }

  setIsLoading(bool value) {
    isLoading(value);
  }

  setPost(Post newPost) {
    post(newPost);
  }

  setEditingMode(bool value, Comment cmt) {
    isInEditingMode(value);
    editingComment(cmt);
    editingController.text = cmt.commentText;
    if (cmt.commentText.length > 30) {
      editingTextFieldExpanded(true);
    }
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
    textFieldExpanded(false);
    editingTextFieldExpanded(false);
  }

  editComment(
      TextEditingController commentController, BuildContext context) async {
    try {
      loadingDialog();

      // Edit Comment
      Comment metaComment = editingComment.value;
      // If document id is empty
      if (metaComment.docId == null) {
        QuerySnapshot<Object?> querySnapshot = await _allComments
            .where('postName', isEqualTo: post.value.name)
            .where('postLink', isEqualTo: post.value.youtubeLink)
            .where('postCreator', isEqualTo: post.value.creator)
            .where('postGroup', isEqualTo: post.value.groupName)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          metaComment.docId = querySnapshot.docs.first.id;
        }
      }
      metaComment.commentText = editingController.text;
      metaComment.addedTime = DateTime.now();
      await _allComments
          .doc(metaComment.docId)
          .update(metaComment.toJson())
          .then((value) {
        // Modify Post Comments
        Post currentPost = post.value;
        currentPost.comments!.forEach((element) {
          if (element.commentText == editingComment.value.commentText &&
              element.commenter == editingComment.value.commenter) {
            element = metaComment;
          }
        });
        post(currentPost);
        clearEditingMode();
        FocusScope.of(context).unfocus();
        commentController.clear();
        Get.back();
      });
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

  deleteComment(
      TextEditingController commentController, BuildContext context) async {
    try {
      loadingDialog();
      // Edit Comment
      Comment metaComment = editingComment.value;
      // If document id is empty
      if (metaComment.docId == null) {
        QuerySnapshot<Object?> querySnapshot = await _allComments
            .where('postName', isEqualTo: post.value.name)
            .where('postLink', isEqualTo: post.value.youtubeLink)
            .where('postCreator', isEqualTo: post.value.creator)
            .where('postGroup', isEqualTo: post.value.groupName)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          metaComment.docId = querySnapshot.docs.first.id;
        }
      }
      metaComment.commentText = editingController.text;
      metaComment.commentText = editingController.text;
      // Modify Post Comments
      Post currentPost = post.value;
      List<Comment> currentComments = post.value.comments!;

      for (int i = 0; i < currentPost.comments!.length; i++) {
        if (currentPost.comments![i].commentText == metaComment.commentText &&
            currentPost.comments![i].commenter == metaComment.commenter) {
          currentComments.removeAt(i);
        }
        if (i == currentPost.comments!.length - 1) {
          currentPost.comments = currentComments;
          post(currentPost);
          await _allComments.doc(metaComment.docId).delete().then((value) {
            clearEditingMode();
            FocusScope.of(context).unfocus();
            commentController.clear();
            Get.back();
          });
        }
      }
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
        content: '''"${post.name}" will be deleted.''',
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
      post.value.comments!.sort((a, b) => b.addedTime.compareTo(a.addedTime));
      sortByRecent(true);
    } else {
      post.value.comments!
          .sort((a, b) => a.commentText.compareTo(b.commentText));
      sortByRecent(false);
    }
  }
}
