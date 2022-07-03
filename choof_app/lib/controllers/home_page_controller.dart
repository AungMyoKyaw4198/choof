import 'package:choof_app/controllers/landing_page_controller.dart';
import 'package:choof_app/models/notification.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/comment.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../models/profile.dart';
import '../services/notification_service.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();
  final landingPagecontroller = Get.find<LandingPageController>();

  final CollectionReference _allGroups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection("notifications");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  final allpost = <Post>[].obs;
  final posts = <Post>[].obs;
  final creators = <Profile>[].obs;
  final allTags = <String>[].obs;
  final loaded = false.obs;
  final selectedFriend = 'all'.obs;

  final isFilterOn = false.obs;
  final isFilter = false.obs;
  final filteredTags = <String>[].obs;
  final filteredTagResult = <Post>[].obs;

  final sortByRecent = true.obs;

  final postLimit = 15.obs;
  TextEditingController tagName = TextEditingController();

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

  // Get groups which user is member of
  Future<List<Group>> getMemberedGroup() async {
    try {
      int index = 1;
      List<Group> userGroups = [];
      List<Profile> allOwners = [];
      List<String> allGroupsTag = [];
      QuerySnapshot<Object?> groups =
          await _allGroups.orderBy('lastUpdatedTime', descending: true).get();
      for (var element in groups.docs) {
        final Group meta =
            Group.fromJson(element.data() as Map<String, dynamic>);
        meta.docId = element.id;

        meta.tags.forEach((tag) {
          allGroupsTag.add(tag.trim());
        });

        meta.members.forEach((element) {
          if (element.trim() ==
              landingPagecontroller.userProfile.value.name.trim()) {
            Group currentGroup = meta;
            userGroups.add(currentGroup);
            allOwners.add(Profile(
                allowNotifications: false,
                imageUrl: currentGroup.ownerImageUrl,
                email: '',
                name: currentGroup.owner,
                isInvited: false));
          }
        });

        if (index == groups.docs.length) {
          var set = Set<String>();
          List<Profile> uniquelist = allOwners
              .where((creator) => set.add(creator.name.trim()))
              .toList();
          creators(uniquelist);

          // Remove Duplicate From Tags
          var set2 = Set<String>();
          List<String> uniquelist2 =
              allGroupsTag.where((tag) => set2.add(tag.trim())).toList();
          landingPagecontroller.setAutoTags(uniquelist2);

          return userGroups;
        } else {
          index++;
        }
      }

      print('doing');

      return userGroups;
    } catch (e) {
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return [];
    }
  }

  // Get posts of membered group
  getAllPost() async {
    try {
      loaded(false);
      List<String> metaAllTags = [];
      QuerySnapshot<Object?> allposts =
          await _allPosts.orderBy('addedTime', descending: true).get();
      await getMemberedGroup().then((userGroups) async {
        if (userGroups.isNotEmpty) {
          for (int i = 0; i < userGroups.length; i++) {
            for (var element in allposts.docs) {
              if (element['groupName'] == userGroups[i].name) {
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
                    Comment currentComment = Comment.fromJson(
                        element.data() as Map<String, dynamic>);
                    currentComment.docId = element.id;
                    metaCmts.add(currentComment);
                  });
                }
                metaCmts.sort((a, b) => b.addedTime.compareTo(a.addedTime));
                currentPost.comments = metaCmts;
                //  ----
                posts.add(currentPost);
                loaded(true);
                allpost.add(currentPost);

                currentPost.tags.forEach((tag) {
                  metaAllTags.add(tag.trim());
                });
              }
            }
          }
          // Remove Duplicate From Tags
          var set = Set<String>();
          List<String> uniquelist =
              metaAllTags.where((tag) => set.add(tag.trim())).toList();
          allTags(uniquelist);
        } else {
          loaded(true);
        }
      });
    } catch (e) {
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
  refreshPosts() {
    loaded(false);
    allpost([]);
    posts([]);
    creators([]);
    allTags([]);
    selectedFriend('all');
    isFilterOn(false);
    isFilter(false);
    filteredTags([]);
    filteredTagResult([]);
    sortByRecent(true);
    postLimit(15);
    landingPagecontroller.clearAutoTags();
    getAllPost();
    update();
  }

  // Sort by Profiles
  selectProfile(String name) {
    loaded(false);
    selectedFriend(name);
    if (name == 'all') {
      posts(allpost);
      sort(sortByRecent.value);
      loaded(true);
    } else {
      posts([]);
      for (var currentPost in allpost) {
        if (currentPost.creator == name) {
          posts.add(currentPost);
        }
      }
      sort(sortByRecent.value);
      // reloadControllerList();
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

      for (var post in posts) {
        List<bool> checker = [];
        // Remove Duplicate From Tags
        var set = Set<String>();
        List<String> uniquelist =
            post.tags.where((tag) => set.add(tag.trim())).toList();
        // ---------------------
        // OR Operation
        // if (post.tags.any((element) => filteredTags.contains(element))) {
        //   filteredTagResult.add(post);
        // }

        // AND Operation
        uniquelist.forEach((postTag) {
          if (filteredTags.contains(postTag.trim())) {
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
      loaded(true);
    } else {
      posts
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      loaded(true);
    }
  }

  // notofications test
  getNotifications() async {
    String latest = GetStorage().read('notiTime') ?? '';

    String groupNames = '';
    List<String> senderNames = [];
    List<Noti> notiList = [];
    List<DateTime> dates = [];

    if (landingPagecontroller.userProfile.value.name != 'test') {
      Stream<QuerySnapshot<Object?>> querySnapshot = _notifications.snapshots();
      querySnapshot.forEach((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (int i = 0; i < snapshot.docs.length; i++) {
            // Notifications has for you
            if (snapshot.docs[i]['groupMembers']
                    .toString()
                    .contains(landingPagecontroller.userProfile.value.name) &&
                snapshot.docs[i]['sender'] !=
                    landingPagecontroller.userProfile.value.name) {
              final currentNotis = Noti.fromJson(
                  snapshot.docs[i].data() as Map<String, dynamic>);
              // Check time is after
              if (latest != '') {
                DateTime latestDateTime = DateTime.parse(latest);
                if (currentNotis.sentTime.isAfter(latestDateTime)) {
                  senderNames.add(currentNotis.sender.trim());
                  notiList.add(currentNotis);
                  dates.add(currentNotis.sentTime);
                }
              } else {
                senderNames.add(currentNotis.sender.trim());
                notiList.add(currentNotis);
                dates.add(currentNotis.sentTime);
              }
            }

            if (i == snapshot.docs.length - 1) {
              if (senderNames.isNotEmpty) {
                List<String> metaSenders = senderNames;
                var set = Set<String>();
                List<String> uniquelist = metaSenders
                    .where((creator) => set.add(creator.trim()))
                    .toList();
                senderNames = uniquelist;

                if (notiList.isNotEmpty) {
                  // remove deuplicate groups
                  var seen = Set<String>();
                  List<Noti> uniquelist2 = notiList
                      .where((noti) => seen.add(noti.groupName))
                      .toList();
                  notiList = uniquelist2;
                  // ---------------------
                  for (int i = 0; i < senderNames.length; i++) {
                    groupNames = '';
                    notiList.forEach((noti) {
                      if (noti.sender.trim() == senderNames[i]) {
                        groupNames += noti.groupName + ';';
                      }
                    });
                    String payloadName = 'Notification';
                    if (landingPagecontroller
                        .userProfile.value.allowNotifications) {
                      if (groupNames.length > 1) {
                        NotificationService.showNotification(
                            body:
                                '${senderNames[i]} has some recommendation for you in the Choof groups: ${groupNames.substring(0, groupNames.length - 1)}',
                            payload: payloadName);
                      } else {
                        NotificationService.showNotification(
                            body:
                                '${senderNames[i]} has some recommendation for you in the Choof group: ${groupNames.substring(0, groupNames.length - 1)}',
                            payload: payloadName);
                      }
                    }
                  }
                }
              }
            }
          }
          if (dates.isNotEmpty) {
            final maxDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);
            GetStorage().write('notiTime', maxDate.toString());
          }
        }
      });
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
