import 'package:choof_app/controllers/your_group_controller.dart';
import 'package:choof_app/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/view_group.dart';
import '../screens/widgets/shared_widgets.dart';

class AddGroupContoller extends GetxController {
  static AddGroupContoller get to => Get.find();
  final yourGroupcontroller = Get.find<YourGroupController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");

  final groupName = TextEditingController();
  final tagName = TextEditingController();
  final tags = <String>[].obs;

  addTags(String newTag) {
    tags.add(newTag);
  }

  removeTag(String currentTag) {
    tags.remove(currentTag);
  }

  addGroup() async {
    try {
      loadingDialog();
      List<String> currentMembers = [];
      User currentUser = FirebaseAuth.instance.currentUser!;
      currentMembers.add(currentUser.displayName!);

      final Group _currentGroup = Group(
          name: groupName.text,
          tags: tags,
          owner: currentUser.displayName!,
          ownerImageUrl: currentUser.photoURL!,
          members: currentMembers,
          lastUpdatedTime: DateTime.now(),
          createdTime: DateTime.now());
      // Check Group Already Exist??
      QuerySnapshot<Object?> querySnapshot =
          await _groups.where('name', isEqualTo: _currentGroup.name).get();
      if (querySnapshot.docs.isEmpty) {
        await _groups.add(_currentGroup.toJson());
        Get.back();
        yourGroupcontroller.refreshGroups();
        Get.to(() => ViewGroup(
              currentGroup: _currentGroup,
              isFromGroup: true,
            ));
      } else {
        Get.back();
        infoDialog(
            title: 'Group with the same name already exists.',
            content: 'Please try again.',
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Get.back();
                },
              )
            ]);
      }

      return true;
    } catch (e) {
      Get.back();
      return false;
    }
  }
}
