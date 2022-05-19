import 'package:choof_app/controllers/view_group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/group.dart';
import '../models/post.dart';
import '../screens/view_group.dart';
import '../screens/widgets/shared_widgets.dart';

class EditGroupContoller extends GetxController {
  static EditGroupContoller get to => Get.find();
  final viewGroupcontroller = Get.find<ViewGroupController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");

  TextEditingController groupName = TextEditingController();
  final tagName = TextEditingController();
  final tags = <String>[].obs;

  setInitialValue(String currName, List<String> currTags) {
    groupName = TextEditingController(text: currName);
    tags(currTags);
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
      // Update GroupName From Posts
      QuerySnapshot<Object?> postSnapshot = await _allPosts
          .where('groupName', isEqualTo: initialGroup.name)
          .get();
      if (postSnapshot.docs.isNotEmpty) {
        postSnapshot.docs.forEach((element) async {
          Post currentPost =
              Post.fromJson(element.data() as Map<String, dynamic>);
          currentPost.docId = element.id;
          currentPost.groupName = groupName.text;
          await _allPosts.doc(currentPost.docId).update(currentPost.toJson());
        });
      }

      if (currGroup.docId!.isNotEmpty) {
        currGroup.name = groupName.text;
        currGroup.tags = tags;
        await _groups.doc(currGroup.docId).update(currGroup.toJson());
      } else {
        QuerySnapshot<Object?> querySnapshot =
            await _groups.where('name', isEqualTo: currGroup.name).get();
        if (querySnapshot.docs.isNotEmpty) {
          currGroup.docId = querySnapshot.docs.first.id;
          currGroup.name = groupName.text;
          currGroup.tags = tags;
          currGroup.lastUpdatedTime = DateTime.now();
          await _groups.doc(currGroup.docId).update(currGroup.toJson());
        }
      }

      Get.back();
      Get.off(() => ViewGroup(
            currentGroup: currGroup,
            isFromGroup: true,
          ));
      return true;
    } catch (e) {
      Get.back(result: groupName.text);
      return false;
    }
  }
}
