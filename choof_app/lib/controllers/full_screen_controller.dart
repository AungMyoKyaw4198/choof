import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../screens/widgets/shared_widgets.dart';

class FullScreenController extends GetxController {
  static FullScreenController get to => Get.find();

  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  final tabValue = 0.obs;

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
}
