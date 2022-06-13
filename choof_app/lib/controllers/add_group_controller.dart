import 'package:choof_app/controllers/your_group_controller.dart';
import 'package:choof_app/models/group.dart';
import 'package:choof_app/screens/view_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/widgets/shared_widgets.dart';
import 'home_page_controller.dart';
import 'landing_page_controller.dart';

class AddGroupContoller extends GetxController {
  static AddGroupContoller get to => Get.find();
  final yourGroupcontroller = Get.find<YourGroupController>();
  final favController = Get.find<HomePageController>();
  final landingPagecontroller = Get.find<LandingPageController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");

  final groupName = TextEditingController();
  TextEditingController tagName = TextEditingController();
  final tags = <String>[].obs;

  addTags(String newTag) {
    tags.add(newTag);
  }

  removeTag(String currentTag) {
    tags.remove(currentTag);
  }

  clearTags() {
    tags([]);
  }

  addGroup(int index, bool isFromGroup) async {
    try {
      loadingDialog();
      List<String> currentMembers = [];
      currentMembers.add(landingPagecontroller.userProfile.value.name);

      final Group _currentGroup = Group(
          name: groupName.text,
          tags: tags,
          owner: landingPagecontroller.userProfile.value.name,
          ownerImageUrl: landingPagecontroller.userProfile.value.imageUrl,
          members: currentMembers,
          lastUpdatedTime: DateTime.now(),
          createdTime: DateTime.now());

      // Check Group Already Exist??
      QuerySnapshot<Object?> querySnapshot =
          await _groups.where('name', isEqualTo: _currentGroup.name).get();
      if (querySnapshot.docs.isEmpty) {
        _currentGroup.name = _currentGroup.name;
      } else {
        _currentGroup.name =
            _currentGroup.name + '#ID${querySnapshot.docs.length + 1}';
      }
      await _groups.add(_currentGroup.toJson());
      Get.back();
      yourGroupcontroller.refreshGroups();
      favController.refreshPosts();
      Get.to(() => ViewGroup(
          index: index, currentGroup: _currentGroup, isFromGroup: isFromGroup));

      return true;
    } catch (e) {
      Get.back();
      return false;
    }
  }
}
