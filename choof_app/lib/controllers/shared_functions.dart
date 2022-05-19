import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

import '../models/group.dart';
import '../models/post.dart';
import '../models/profile.dart';
import '../screens/widgets/shared_widgets.dart';
import 'landing_page_controller.dart';

Future<void> reportPost(
    {required Post post,
    required Profile reportedUser,
    required String reportedReason}) async {
  try {
    final CollectionReference _allPosts =
        FirebaseFirestore.instance.collection("posts");
    final CollectionReference _reportedPosts =
        FirebaseFirestore.instance.collection("reportPosts");
    Post editPost = post;

    final Email email = Email(
      subject: 'Report Post',
      body: '''
          Post Details : ${post.toJson()},
          Reported Reason : $reportedReason,
          Reported By : ${reportedUser.name},
          Issue Date : ${DateTime.now()}
      ''',
      recipients: ['report@choof.club'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email).then((value) async {
      loadingDialog();
      QuerySnapshot<Object?> querySnapshot =
          await _allPosts.where('name', isEqualTo: post.name).get();
      if (querySnapshot.docs.isNotEmpty) {
        editPost.docId = querySnapshot.docs.first.id;
        editPost.isReported = true;
        await _allPosts.doc(editPost.docId).update(editPost.toJson());
        await _reportedPosts.add({
          'videoDocId': editPost.docId,
          'videoName': editPost.name,
          'videoLink': editPost.youtubeLink,
          'videoCreator': editPost.creator,
          'reportedUser': reportedUser.name,
          'reportedReason': reportedReason,
        });
      }
      Get.back();
      infoDialog(
        title:
            'Thank you for your action, we will investigate the issue promptly.',
        content: '',
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'))
        ],
      );
    }).catchError((e) {
      Get.snackbar(
        'Sorry. Actions cannot be fullfill this time.',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    });
  } catch (e) {
    Get.snackbar(
      'Error! Please try again later.',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
    );
  }
}

Future<void> reportUser(
    {required Post post,
    required Profile reportedUser,
    required String reportedReason}) async {
  try {
    final Email email = Email(
      subject: 'Report User',
      body: '''
          Reported User Name : ${post.creator}',
          Post Details : ${post.toJson()},
          Reported Reason : $reportedReason,
          Reported By : ${reportedUser.name},
          Issue Date : ${DateTime.now()}
      ''',
      recipients: ['report@choof.club'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email).then((value) async {
      loadingDialog();
      Get.back();
      infoDialog(
        title:
            'Thank you for your action, we will investigate the issue promptly.',
        content: '',
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'))
        ],
      );
    }).catchError((e) {
      Get.snackbar(
        'Sorry. Actions cannot be fullfill this time.',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    });
  } catch (e) {}
}

Future<void> blockUser({
  required Profile currentUser,
  required String reportedName,
}) async {
  try {
    final landingPagecontroller = Get.find<LandingPageController>();
    loadingDialog();
    final CollectionReference _registeredUsers =
        FirebaseFirestore.instance.collection("users");
    final CollectionReference _allGroups =
        FirebaseFirestore.instance.collection("groups");
    final CollectionReference _notifications =
        FirebaseFirestore.instance.collection("notifications");

    // Update Users
    QuerySnapshot<Object?> querySnapshot = await _registeredUsers.get();
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((document) {
        // Updating Current User
        if (document['name'].trim() == currentUser.name.trim()) {
          Profile user = currentUser;
          user.docId = document.id;
          if (user.blockedUsers != null) {
            user.blockedUsers!.add(reportedName);
          } else {
            user.blockedUsers = [reportedName];
          }
          _registeredUsers.doc(user.docId).update(user.toJson());
        }
        // Updating reported user
        else if (document['name'].trim() == reportedName.trim()) {
          Profile reportedUser =
              Profile.fromJson(document.data() as Map<String, dynamic>);
          reportedUser.docId = document.id;
          if (reportedUser.blockByUsers != null) {
            reportedUser.blockByUsers!.add(currentUser.name);
          } else {
            reportedUser.blockByUsers = [currentUser.name];
          }
          landingPagecontroller.storeUserProfile(reportedUser);
          _registeredUsers
              .doc(reportedUser.docId)
              .update(reportedUser.toJson());
        }
      });
    }
    // Remove from groups
    List<Group> userGroups = await getUserGroup(currentUser: currentUser);
    userGroups.forEach((group) async {
      if (group.owner.trim() == reportedName.trim()) {
        Group meta = group;
        meta.members.removeWhere(
            (element) => element.trim() == currentUser.name.trim());
        await _allGroups.doc(meta.docId).update(meta.toJson());
      }
    });

    // remove loading dialog
    Get.back();
    infoDialog(
      title: 'User : $reportedName has been blocked.',
      content: '',
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'))
      ],
    );
  } catch (e) {
    Get.back();
  }
}

Future<List<Group>> getUserGroup({required Profile currentUser}) async {
  int index = 1;
  final CollectionReference _allGroups =
      FirebaseFirestore.instance.collection("groups");
  List<Group> userGroups = [];
  QuerySnapshot<Object?> groups = await _allGroups.get();
  for (var element in groups.docs) {
    final Group meta = Group.fromJson(element.data() as Map<String, dynamic>);
    meta.docId = element.id;

    meta.members.forEach((element) {
      if (element.trim() == currentUser.name.trim()) {
        Group currentGroup = meta;
        userGroups.add(currentGroup);
      }
    });

    if (index == groups.docs.length) {
      return userGroups;
    } else {
      index++;
    }
  }
  return userGroups;
}
