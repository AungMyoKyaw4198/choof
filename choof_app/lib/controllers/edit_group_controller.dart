import 'package:choof_app/controllers/view_group_controller.dart';
import 'package:choof_app/controllers/your_group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../screens/widgets/shared_widgets.dart';
import 'home_page_controller.dart';

class EditGroupContoller extends GetxController {
  static EditGroupContoller get to => Get.find();
  final viewGroupcontroller = Get.find<ViewGroupController>();
  final favController = Get.find<HomePageController>();
  final yourGroupsController = Get.find<YourGroupController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  TextEditingController groupName = TextEditingController();
  TextEditingController tagName = TextEditingController();
  final initialGroupName = ''.obs;
  final tags = <String>[].obs;

  setInitialValue(String currName, List<String> currTags) {
    groupName = TextEditingController(text: currName);
    tags(currTags);
  }

  setInitialGroupName(String name) {
    initialGroupName(name);
  }

  addTags(String newTag) {
    tags.add(newTag);
  }

  removeTag(String currentTag) {
    tags.remove(currentTag);
  }

  editGroup(Group currGroup) async {
    try {
      loadingDialog();

      Group initialGroup = currGroup;
      String finalName = '';
      String realName = initialGroupName.value.contains('#')
          ? initialGroupName.value
              .substring(0, initialGroupName.value.indexOf('#'))
          : initialGroupName.value;
      // ----------------------------------------------------
      /*----------  when name is edited ------------------- */
      if (groupName.text.trim() != realName.trim()) {
        await whenNameisEdited(initialGroup, currGroup, finalName)
            .then((value) {
          if (value) {
            favController.refreshPosts();
            yourGroupsController.refreshGroups();
            Get.back();
            Get.back();
          } else {
            print('error in edited');
            Get.back();
            Get.snackbar(
              "Something went wrong!",
              "Please try again later.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
            );
          }
        });
      }
      /*----------  when name is not edited ------------------- */
      else {
        await whenNameisNotEdited(initialGroup, currGroup, finalName)
            .then((value) {
          if (value) {
            favController.refreshPosts();
            yourGroupsController.refreshGroups();
            Get.back();
            Get.back();
          } else {
            print('error in not edited');
            Get.back();
            Get.snackbar(
              "Something went wrong!",
              "Please try again later.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
            );
          }
        });
      }
      return true;
    } catch (e) {
      print(e);
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  Future<bool> whenNameisEdited(
      Group initialGroup, Group currGroup, String finalName) async {
    try {
      // Check Group Already Exist??
      QuerySnapshot<Object?> querySnapshot =
          await _groups.where('name', isEqualTo: initialGroupName.value).get();
      // Editied Group name exist
      if (querySnapshot.docs.isNotEmpty) {
        finalName =
            groupName.text.trim() + '#ID${querySnapshot.docs.length + 1}';
      }
      // Editied Group not exist
      else {
        finalName = groupName.text.trim();
      }

      // Update GroupName From Posts
      QuerySnapshot<Object?> postSnapshot = await _allPosts
          .where('groupName', isEqualTo: initialGroupName.value)
          .get();
      if (postSnapshot.docs.isNotEmpty) {
        postSnapshot.docs.forEach((element) async {
          Post currentPost =
              Post.fromJson(element.data() as Map<String, dynamic>);

          // Edit Comments
          QuerySnapshot<Object?> postComments = await _allComments
              .where('postName', isEqualTo: currentPost.name)
              .where('postLink', isEqualTo: currentPost.youtubeLink)
              .where('postCreator', isEqualTo: currentPost.creator)
              .where('postGroup', isEqualTo: currentPost.groupName)
              .get();
          if (postComments.docs.isNotEmpty) {
            postComments.docs.forEach((element) async {
              Comment currentComment =
                  Comment.fromJson(element.data() as Map<String, dynamic>);
              currentComment.docId = element.id;
              currentComment.postGroup = finalName;
              _allComments.doc(element.id).update(currentComment.toJson());
            });
          }
          //  ----

          currentPost.docId = element.id;
          currentPost.groupName = finalName;
          _allPosts.doc(currentPost.docId).update(currentPost.toJson());
        });
      }
      //-----------

      if (currGroup.docId!.isNotEmpty) {
        currGroup.name = finalName;
        currGroup.tags = tags;
        currGroup.lastUpdatedTime = DateTime.now();
        _groups.doc(currGroup.docId).update(currGroup.toJson());
      } else {
        QuerySnapshot<Object?> querySnapshot = await _groups
            .where('name', isEqualTo: initialGroupName.value)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          currGroup.docId = querySnapshot.docs.first.id;
          currGroup.name = finalName;
          currGroup.tags = tags;
          currGroup.lastUpdatedTime = DateTime.now();
          _groups.doc(currGroup.docId).update(currGroup.toJson());
        }
      }
      currGroup.name = finalName;

      if (finalName.contains('#')) {
        viewGroupcontroller
            .setGroupName(finalName.substring(0, finalName.indexOf('#')));
      } else {
        viewGroupcontroller.setGroupName(finalName);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> whenNameisNotEdited(
      Group initialGroup, Group currGroup, String finalName) async {
    try {
      // Update GroupName From Posts
      QuerySnapshot<Object?> postSnapshot = await _allPosts
          .where('groupName', isEqualTo: initialGroup.name)
          .get();
      if (postSnapshot.docs.isNotEmpty) {
        postSnapshot.docs.forEach((element) async {
          Post currentPost =
              Post.fromJson(element.data() as Map<String, dynamic>);

          // Edit Comments
          QuerySnapshot<Object?> postComments = await _allComments
              .where('postName', isEqualTo: currentPost.name)
              .where('postLink', isEqualTo: currentPost.youtubeLink)
              .where('postCreator', isEqualTo: currentPost.creator)
              .where('postGroup', isEqualTo: currentPost.groupName)
              .get();
          if (postComments.docs.isNotEmpty) {
            postComments.docs.forEach((element) async {
              Comment currentComment =
                  Comment.fromJson(element.data() as Map<String, dynamic>);
              currentComment.docId = element.id;
              currentComment.postGroup = finalName;
              _allComments.doc(element.id).update(currentComment.toJson());
            });
          }
          //  ----

          currentPost.docId = element.id;
          currentPost.groupName = initialGroup.name;
          _allPosts.doc(currentPost.docId).update(currentPost.toJson());
        });
      }
      // -------------------

      if (currGroup.docId!.isNotEmpty) {
        currGroup.name = initialGroup.name;
        currGroup.tags = tags;
        currGroup.lastUpdatedTime = DateTime.now();
        await _groups.doc(currGroup.docId).update(currGroup.toJson());
      } else {
        QuerySnapshot<Object?> querySnapshot =
            await _groups.where('name', isEqualTo: currGroup.name).get();
        if (querySnapshot.docs.isNotEmpty) {
          currGroup.docId = querySnapshot.docs.first.id;
          currGroup.name = initialGroup.name;
          currGroup.tags = tags;
          currGroup.lastUpdatedTime = DateTime.now();
          await _groups.doc(currGroup.docId).update(currGroup.toJson());
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  deleteGroup(Group currGroup, int index) {
    viewGroupcontroller.deleteGroup(currGroup, index);
    favController.refreshPosts();
    yourGroupsController.refreshGroups();
  }
}
