import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/comment.dart';
import '../models/group.dart';
import '../models/post.dart';

class ViewGroupController extends GetxController {
  static ViewGroupController get to => Get.find();

  final CollectionReference _allGroups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _postsInsideGroup =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  final groupName = ''.obs;
  final controllerList = <YoutubePlayerController>[].obs;
  final allpost = <Post>[].obs;
  final posts = <Post>[].obs;
  final allTags = <String>[].obs;
  final isFilter = false.obs;
  final filteredTags = <String>[].obs;
  final filteredTagResult = <Post>[].obs;
  final sortByRecent = true.obs;
  final loaded = false.obs;
  final postLimit = 15.obs;
  final isFilterOn = false.obs;

  setFilterOn() {
    bool value = !isFilterOn.value;
    isFilterOn(value);
  }

  setPostLimit(int value) {
    postLimit(value);
  }

  addPostLimit() {
    int value = postLimit.value + 15;
    postLimit(value);
  }

  setGroupName(String name) {
    groupName(name);
  }

  addToControllerList(YoutubePlayerController controller) {
    controllerList.add(controller);
  }

  disposeControllerList() {
    for (var element in controllerList) {
      element.pause();
      element.dispose();
    }
  }

  // Get posts of current group
  getAllPost(Group group) async {
    try {
      loaded(false);
      List<String> metaAllTags = [];
      QuerySnapshot<Object?> allposts = await _postsInsideGroup
          .where('groupName', isEqualTo: group.name)
          .get();
      if (allposts.docs.isNotEmpty) {
        for (var element in allposts.docs) {
          Post currentPost =
              Post.fromJson(element.data() as Map<String, dynamic>);
          currentPost.docId = element.id;

          // Add Comments
          List<Comment> metaCmts = [];
          QuerySnapshot<Object?> postComments = await _allComments
              .where('postName', isEqualTo: currentPost.name)
              .where('postLink', isEqualTo: currentPost.youtubeLink)
              .where('postCreator', isEqualTo: currentPost.creator)
              .where('postGroup', isEqualTo: currentPost.groupName)
              .get();
          if (postComments.docs.isNotEmpty) {
            postComments.docs.forEach((element) {
              Comment currentComment =
                  Comment.fromJson(element.data() as Map<String, dynamic>);
              metaCmts.add(currentComment);
            });
          }
          currentPost.comments = metaCmts;
          //  ----

          posts.add(currentPost);
          allpost.add(currentPost);
          currentPost.tags.forEach((tag) {
            metaAllTags.add(tag);
          });
        }
        // Remove Duplicate From Tags
        var set = Set<String>();
        List<String> uniquelist =
            metaAllTags.where((tag) => set.add(tag.trim())).toList();
        allTags(uniquelist);
        sort(true);
        // ---------------------
      }

      loaded(true);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      loaded(true);
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Refresh all posts
  refreshPosts(Group group) {
    loaded(false);
    allpost([]);
    posts([]);
    allTags([]);
    isFilterOn(false);
    isFilter(false);
    filteredTags([]);
    filteredTagResult([]);
    sortByRecent(true);
    getAllPost(group);
    update();
  }

  // Delete Current Group
  deleteGroup(Group group) async {
    infoDialog(
        title: 'Are you sure you want to delete this group?',
        content: '${group.name} will be deleted.',
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
                  int index = 1;
                  if (allpost.isNotEmpty) {
                    for (var element in allpost) {
                      await _postsInsideGroup.doc(element.docId).delete();
                      if (index == allpost.length) {
                        await _allGroups
                            .doc(group.docId)
                            .delete()
                            .then((value) {
                          Get.back();
                          Get.back();
                        });
                      } else {
                        index++;
                      }
                    }
                  } else {
                    await _allGroups.doc(group.docId).delete().then((value) {
                      Get.back();
                      Get.back();
                    });
                  }
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
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

  // Filtered By tags
  addTags(String newTag) {
    filteredTags.add(newTag);
    filterByTags();
  }

  removeTag(String currentTag) {
    filteredTags.remove(currentTag);
    filterByTags();
  }

  filterByTags() {
    if (filteredTags.isNotEmpty) {
      loaded(false);
      filteredTagResult([]);
      isFilter(true);

      for (var post in posts) {
        // AND Operation
        List<bool> checker = [];
        post.tags.forEach((postTag) {
          if (filteredTags.contains(postTag)) {
            checker.add(true);
          } else {
            checker.add(false);
          }
        });
        final filteredChecker = checker.where((value) => value == true);
        if (filteredChecker.length == filteredTags.length) {
          filteredTagResult.add(post);
        }
      }
      // reloadControllerList();
      loaded(true);
    } else {
      isFilter(false);
      loaded(true);
    }
  }

  // Sort by date
  sort(bool value) {
    loaded(false);
    sortByRecent(value);
    if (value) {
      posts.sort((a, b) => b.addedTime.compareTo(a.addedTime));
      // reloadControllerList();
      loaded(true);
    } else {
      posts
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      // reloadControllerList();
      loaded(true);
    }
  }

  // Add Comment
  addComment(Comment commet) async {
    try {
      loadingDialog();
      await _allComments.add(commet.toJson());
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
}
