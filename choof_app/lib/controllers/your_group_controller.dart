import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/group.dart';
import '../models/profile.dart';
import 'landing_page_controller.dart';

class YourGroupController extends GetxController {
  static YourGroupController get to => Get.find();
  final landingPagecontroller = Get.find<LandingPageController>();

  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");

  final allGroups = <Group>[].obs;
  final groups = <Group>[].obs;
  final user = UserCredential;
  final owners = <Profile>[].obs;
  final allTags = <String>[].obs;
  final selectedFriend = 'all'.obs;
  final loaded = false.obs;
  final isFilter = false.obs;
  final filteredTags = <String>[].obs;
  final filteredTagResult = <Group>[].obs;

  final sortByRecent = true.obs;

  final groupLimit = 15.obs;

  setGroupLimit(int value) {
    groupLimit(value);
  }

  addGroupLimit() {
    int value = groupLimit.value + 15;
    groupLimit(value);
  }

  getGroupsData() async {
    try {
      loaded(false);
      List<Profile> allOwners = [];
      List<String> metaAllTags = [];
      QuerySnapshot<Object?> querySnapshot = await _groups.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          final Group meta =
              Group.fromJson(element.data() as Map<String, dynamic>);
          meta.docId = element.id;

          for (int i = 0; i < meta.members.length; i++) {
            if (meta.members[i].trim() ==
                landingPagecontroller.userProfile.value.name.trim()) {
              Group currentGroup = meta;
              allOwners.add(Profile(
                  allowNotifications: false,
                  imageUrl: currentGroup.ownerImageUrl,
                  name: currentGroup.owner,
                  email: '',
                  isInvited: false));
              // Get all post which is in group
              QuerySnapshot<Object?> postSnapshot = await _allPosts
                  .where('groupName', isEqualTo: currentGroup.name)
                  .get();
              if (postSnapshot.docs.isNotEmpty) {
                currentGroup.videoNumber = postSnapshot.docs.length;
              } else {
                currentGroup.videoNumber = 0;
              }
              groups.add(currentGroup);
              allGroups.add(currentGroup);
              for (var tag in currentGroup.tags) {
                metaAllTags.add(tag.trim());
              }
            }

            if (i < meta.members.length - 1) {
              // Remove Duplicate From Tags
              var set = Set<String>();
              List<String> uniquelist =
                  metaAllTags.where((tag) => set.add(tag.trim())).toList();
              allTags(uniquelist);
              // ---------------------
            }
          }
        }

        var set = Set<String>();
        List<Profile> uniquelist =
            allOwners.where((student) => set.add(student.name)).toList();
        owners(uniquelist);
        //
        sort(true);
        loaded(true);
      } else {
        loaded(true);
      }
    } catch (e) {
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
  refreshGroups() {
    allGroups([]);
    groups([]);
    owners([]);
    allTags([]);
    selectedFriend('all');
    isFilter(false);
    filteredTags([]);
    filteredTagResult([]);
    sortByRecent(true);
    loaded(false);
    getGroupsData();
    update();
  }

  // Sort by Profiles
  selectProfile(String name) {
    loaded(false);
    selectedFriend(name);
    if (name == 'all') {
      groups(allGroups);
      sort(sortByRecent.value);
      loaded(true);
    } else {
      groups([]);
      for (var currentGroup in allGroups) {
        if (currentGroup.owner == name) {
          groups.add(currentGroup);
        }
      }
      sort(sortByRecent.value);
      loaded(true);
    }
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
      for (var group in groups) {
        // AND Operation
        List<bool> checker = [];
        for (var postTag in group.tags) {
          if (filteredTags.contains(postTag)) {
            checker.add(true);
          } else {
            checker.add(false);
          }
        }
        final filteredChecker = checker.where((value) => value == true);
        if (filteredChecker.length == filteredTags.length) {
          filteredTagResult.add(group);
        }
      }
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
      groups.sort((a, b) => b.lastUpdatedTime.compareTo(a.lastUpdatedTime));
      loaded(true);
    } else {
      groups
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      loaded(true);
    }
  }
}
