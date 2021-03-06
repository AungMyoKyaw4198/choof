import 'package:choof_app/controllers/landing_page_controller.dart';
import 'package:choof_app/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  // final controllerList = <YoutubePlayerController>[].obs;
  final allpost = <Post>[].obs;
  final posts = <Post>[].obs;
  final creators = <Profile>[].obs;
  final allTags = <String>[].obs;
  final loaded = false.obs;
  final selectedFriend = 'all'.obs;

  final isFilter = false.obs;
  final filteredTags = <String>[].obs;
  final filteredTagResult = <Post>[].obs;

  final sortByRecent = true.obs;

  final postLimit = 15.obs;

  setPostLimit(int value) {
    postLimit(value);
  }

  addPostLimit() {
    int value = postLimit.value + 15;
    postLimit(value);
  }

  // reloadControllerList(List<Post> postlist) {
  //   for (int i = 0; i < postlist.length; i++) {
  //     controllerList[i]
  //         .load(YoutubePlayer.convertUrlToId(postlist[i].youtubeLink)!);
  //     controllerList[i].pause();
  //   }
  // }

  // disposeControllerList() {
  //   for (var element in controllerList) {
  //     element.dispose();
  //   }
  // }

  // Get groups which user is member of
  Future<List<Group>> getMemberedGroup() async {
    try {
      int index = 1;
      List<Group> userGroups = [];
      List<Profile> allOwners = [];
      QuerySnapshot<Object?> groups = await _allGroups.get();
      for (var element in groups.docs) {
        final Group meta =
            Group.fromJson(element.data() as Map<String, dynamic>);
        meta.docId = element.id;

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
          return userGroups;
        } else {
          index++;
        }
      }

      return userGroups;
    } catch (e) {
      loaded(true);
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
      int index = 0;
      List<String> metaAllTags = [];
      QuerySnapshot<Object?> allposts = await _allPosts.get();
      await getMemberedGroup().then((userGroups) async {
        if (userGroups.isNotEmpty) {
          for (int i = 0; i < userGroups.length; i++) {
            for (var element in allposts.docs) {
              if (element['groupName'] == userGroups[i].name) {
                Post currentPost =
                    Post.fromJson(element.data() as Map<String, dynamic>);
                currentPost.docId = element.id;
                currentPost.controllerIndex = index;
                currentPost.tags.forEach((tag) {
                  landingPagecontroller.addAutoTags(tag);
                });

                // Get Thumbnail URL
                // String videID =
                //     currentPost.youtubeLink.replaceAll('https://youtu.be/', '');
                // YoutubeVideoResponse resposne =
                //     await YouTubeService.instance.fetchVideoInfo(id: videID);
                // currentPost.thumbnailUrl =
                //     resposne.items!.first.snippet!.thumbnails!.defaultQ!.url;
                // --------------------------
                YoutubePlayerController _controller = YoutubePlayerController(
                  initialVideoId:
                      YoutubePlayer.convertUrlToId(currentPost.youtubeLink)!,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                );
                // controllerList.add(_controller);

                posts.add(currentPost);
                allpost.add(currentPost);
                currentPost.tags.forEach((tag) {
                  metaAllTags.add(tag);
                });
                index++;
              }
            }
          }
          // Remove Duplicate From Tags
          var set = Set<String>();
          List<String> uniquelist =
              metaAllTags.where((tag) => set.add(tag.trim())).toList();
          allTags(uniquelist);
          // ---------------------
          sort(true);
          loaded(true);
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
    // controllerList([]);
    allpost([]);
    posts([]);
    creators([]);
    allTags([]);
    selectedFriend('all');
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
      // reloadControllerList(pos);
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
        // OR Operation
        // if (post.tags.any((element) => filteredTags.contains(element))) {
        //   filteredTagResult.add(post);
        // }

        // AND Operation
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

      // reloadControllerList(posts);
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
      // reloadControllerList(posts);
      loaded(true);
    } else {
      posts
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      // reloadControllerList(posts);
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
                snapshot.docs[i]['sender'].trim() !=
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
                      NotificationService.showNotification(
                          body:
                              '${senderNames[i]} has some recommendation for you in the Choof group(s): ${groupNames.substring(0, groupNames.length - 1)}',
                          payload: payloadName);
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
    } else {
      print('user name is null');
    }
  }
}
