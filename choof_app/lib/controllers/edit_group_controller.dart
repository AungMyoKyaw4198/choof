import 'package:choof_app/controllers/view_group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/group.dart';
import '../models/post.dart';
import '../screens/widgets/shared_widgets.dart';

class EditGroupContoller extends GetxController {
  static EditGroupContoller get to => Get.find();
  final viewGroupcontroller = Get.find<ViewGroupController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");

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
      String realName = initialGroupName.value.contains('#')
          ? initialGroupName.value
              .substring(0, initialGroupName.value.indexOf('#'))
          : initialGroupName.value;
      // ----------------------------------------------------
      /*----------  when name is edited ------------------- */
      if (groupName.text.trim() != realName.trim()) {
        // Check Group Already Exist??
        QuerySnapshot<Object?> querySnapshot = await _groups
            .where('name', isEqualTo: initialGroupName.value)
            .get();
        // Editied Group name exist
        if (querySnapshot.docs.isNotEmpty) {
          String finalName =
              groupName.text.trim() + '#ID${querySnapshot.docs.length + 1}';
          currGroup.name = finalName;
        }
        // Editied Group not exist
        else {
          String finalName = groupName.text.trim() + '#ID1';
          currGroup.name = finalName;
        }
        initialGroupName(currGroup.name);

        // Update GroupName From Posts
        QuerySnapshot<Object?> postSnapshot = await _allPosts
            .where('groupName', isEqualTo: initialGroup.name)
            .get();
        if (postSnapshot.docs.isNotEmpty) {
          postSnapshot.docs.forEach((element) async {
            Post currentPost =
                Post.fromJson(element.data() as Map<String, dynamic>);
            currentPost.docId = element.id;
            currentPost.groupName = initialGroupName.value;
            await _allPosts.doc(currentPost.docId).update(currentPost.toJson());
          });
        }

        if (currGroup.docId!.isNotEmpty) {
          currGroup.name = initialGroupName.value;
          currGroup.tags = tags;
          await _groups.doc(currGroup.docId).update(currGroup.toJson());
        } else {
          QuerySnapshot<Object?> querySnapshot =
              await _groups.where('name', isEqualTo: currGroup.name).get();
          if (querySnapshot.docs.isNotEmpty) {
            currGroup.docId = querySnapshot.docs.first.id;
            currGroup.name = initialGroupName.value;
            currGroup.tags = tags;
            currGroup.lastUpdatedTime = DateTime.now();
            await _groups.doc(currGroup.docId).update(currGroup.toJson());
          }
        }
      }
      // ----------------------------------------------------
      /*----------  when name is not edited ------------------- */
      else {
        // Update GroupName From Posts
        QuerySnapshot<Object?> postSnapshot = await _allPosts
            .where('groupName', isEqualTo: initialGroup.name)
            .get();
        if (postSnapshot.docs.isNotEmpty) {
          postSnapshot.docs.forEach((element) async {
            Post currentPost =
                Post.fromJson(element.data() as Map<String, dynamic>);
            currentPost.docId = element.id;
            currentPost.groupName = initialGroup.name;
            await _allPosts.doc(currentPost.docId).update(currentPost.toJson());
          });
        }

        if (currGroup.docId!.isNotEmpty) {
          currGroup.name = initialGroup.name;
          currGroup.tags = tags;
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
      }

      Get.back();
      Get.back();
      return true;
    } catch (e) {
      Get.back(result: initialGroupName.value);
      return false;
    }
  }
}
