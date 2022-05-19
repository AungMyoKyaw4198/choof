import 'dart:convert';

import 'package:choof_app/controllers/landing_page_controller.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';
import '../models/notification.dart';
import '../models/post.dart';
import '../screens/view_group.dart';

class AddVideoContoller extends GetxController {
  static AddVideoContoller get to => Get.find();
  final landingPagecontroller = Get.find<LandingPageController>();

  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection("notifications");

  final youtubeLink = TextEditingController();
  final youtubeThumbnail = ''.obs;
  final isVerify = false.obs;
  final tagName = TextEditingController();
  final tagList = <String>[].obs;
  final groupName = ''.obs;
  final groupMembers = <String>[].obs;
  final currentGroup = Group(
          name: '',
          tags: [],
          owner: '',
          ownerImageUrl: '',
          members: [],
          lastUpdatedTime: DateTime.now(),
          createdTime: DateTime.now())
      .obs;

  setCurrentGroup(Group group) {
    currentGroup(group);
  }

  verifyYoutubeLink() {
    String? videoId = YoutubePlayer.convertUrlToId(youtubeLink.text);
    if (videoId != null) {
      isVerify(true);
      youtubeThumbnail(YoutubePlayer.getThumbnail(videoId: videoId));
    } else {
      infoDialog(
          title: 'Cannot Verify current link',
          content: 'Please try again.',
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            )
          ]);
      isVerify(false);
    }
  }

  Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$userUrl&format=json";
    var res = await http.get(Uri.parse(embedUrl));
    try {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);
        return result['title'];
      } else {
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      return null;
    }
  }

  setGroupName(String value) {
    groupName(value);
  }

  setGroupMembers(List<String> members) {
    groupMembers(members);
  }

  setYoutubeLink(String value) {
    youtubeLink.text = value;
  }

  setTags(List<String> tagsList) {
    List<String> modifiedTags = [];
    for (var element in tagsList) {
      modifiedTags.add(element.trim());
    }

    tagList(modifiedTags);
  }

  addTags(String newTag) {
    tagList.add(newTag);
  }

  removeTag(String currentTag) {
    tagList.remove(currentTag);
  }

  addNewVideo() async {
    try {
      loadingDialog();
      String postName = await getDetail(youtubeLink.text);

      final Post currentPost = Post(
          name: postName,
          youtubeLink: youtubeLink.text,
          tags: tagList,
          creator: landingPagecontroller.userProfile.value.name,
          creatorImageUrl: landingPagecontroller.userProfile.value.imageUrl,
          addedTime: DateTime.now(),
          groupName: groupName.value);
      await _allPosts.add(currentPost.toJson());
      // Get cureent Group
      QuerySnapshot<Object?> groupSnapshot =
          await _groups.where('name', isEqualTo: currentGroup.value.name).get();
      if (groupSnapshot.docs.isNotEmpty) {
        groupSnapshot.docs.forEach((element) {
          Group thisGroup =
              Group.fromJson(element.data() as Map<String, dynamic>);
          thisGroup.lastUpdatedTime = DateTime.now();
          setCurrentGroup(thisGroup);
          _groups.doc(element.id).update(currentGroup.toJson());
        });
      }

      await _notifications.add(Noti(
              sender: landingPagecontroller.userProfile.value.name,
              groupName: groupName.value,
              groupMembers: groupMembers,
              sentTime: DateTime.now())
          .toJson());
      Get.back();
      Get.offAll(
          () => ViewGroup(currentGroup: currentGroup.value, isFromGroup: true));
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

  cancelAddVideo() async {
    loadingDialog();
    QuerySnapshot<Object?> groupSnapshot =
        await _groups.where('name', isEqualTo: currentGroup.value.name).get();
    if (groupSnapshot.docs.isNotEmpty) {
      groupSnapshot.docs.forEach((element) {
        Group thisGroup =
            Group.fromJson(element.data() as Map<String, dynamic>);
        thisGroup.lastUpdatedTime = DateTime.now();
        setCurrentGroup(thisGroup);
        _groups.doc(element.id).update(currentGroup.toJson());
      });
    }
    Get.back();
    Get.offAll(
        () => ViewGroup(currentGroup: currentGroup.value, isFromGroup: true));
  }
}
