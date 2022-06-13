import 'dart:convert';

import 'package:choof_app/controllers/full_screen_controller.dart';
import 'package:choof_app/controllers/home_page_controller.dart';
import 'package:choof_app/controllers/your_group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/post.dart';
import '../models/youtubeVideoResponse.dart';
import '../screens/widgets/shared_widgets.dart';
import '../services/youtube_service.dart';
import 'landing_page_controller.dart';

class EditVideoController extends GetxController {
  static EditVideoController get to => Get.find();
  final landingPagecontroller = Get.find<LandingPageController>();
  final fullScreenController = Get.find<FullScreenController>();
  final favController = Get.find<HomePageController>();
  final yourGroupsController = Get.find<YourGroupController>();

  final CollectionReference _allPosts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _allComments =
      FirebaseFirestore.instance.collection("comments");

  TextEditingController postName = TextEditingController();
  TextEditingController youtubeLink = TextEditingController();
  final youtubeThumbnail = ''.obs;
  final isVerify = false.obs;
  TextEditingController tagName = TextEditingController();
  final tagList = <String>[].obs;
  final post = Post(
    name: '',
    youtubeLink: '',
    tags: [],
    groupName: '',
    creator: '',
    creatorImageUrl: '',
    addedTime: DateTime.now(),
  ).obs;

  setInitialPost(Post newPost) {
    post(newPost);
    postName.text = newPost.name;
    youtubeLink.text = newPost.youtubeLink;
    tagList(newPost.tags);
    isVerify(true);
    youtubeThumbnail(newPost.thumbnailUrl);
  }

  bool checkYoutubeLink(String link) {
    if (link.contains('https://youtu.be/')) {
      return true;
    } else {
      return false;
    }
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

  editVideo({required isFromFavPage}) async {
    try {
      loadingDialog();
      String videoName = await getDetail(youtubeLink.text);

      // Get Thumbnail URL
      String videID = youtubeLink.text.replaceAll('https://youtu.be/', '');
      YoutubeVideoResponse resposne =
          await YouTubeService.instance.fetchVideoInfo(id: videID);

      Post currentPost = Post(
          docId: post.value.docId,
          name: postName.text != '' ? postName.text : videoName,
          youtubeLink: youtubeLink.text,
          thumbnailUrl:
              resposne.items!.first.snippet!.thumbnails!.defaultQ!.url,
          tags: tagList,
          creator: landingPagecontroller.userProfile.value.name,
          creatorImageUrl: landingPagecontroller.userProfile.value.imageUrl,
          addedTime: DateTime.now(),
          groupName: post.value.groupName);

      if (currentPost.docId != null) {
        await _allPosts.doc(currentPost.docId).update(currentPost.toJson());
      } else {
        QuerySnapshot<Object?> postSnapshot = await _allPosts
            .where('name', isEqualTo: post.value.name)
            .where('creator', isEqualTo: post.value.creator)
            .where('groupName', isEqualTo: post.value.groupName)
            .get();
        if (postSnapshot.docs.isNotEmpty) {
          currentPost = Post.fromJson(
              postSnapshot.docs.first.data() as Map<String, dynamic>);
          currentPost.docId = postSnapshot.docs.first.id;
          await _allPosts.doc(currentPost.docId).update(currentPost.toJson());
        }
      }

      // Edit Comments
      List<Comment> metaCmt = [];
      QuerySnapshot<Object?> postComments = await _allComments
          .where('postName', isEqualTo: fullScreenController.post.value.name)
          .where('postLink',
              isEqualTo: fullScreenController.post.value.youtubeLink)
          .where('postCreator',
              isEqualTo: fullScreenController.post.value.creator)
          .where('postGroup',
              isEqualTo: fullScreenController.post.value.groupName)
          .get();
      if (postComments.docs.isNotEmpty) {
        postComments.docs.forEach((element) async {
          Comment currentComment =
              Comment.fromJson(element.data() as Map<String, dynamic>);
          currentComment.postName = currentPost.name;
          currentComment.postLink = currentPost.youtubeLink;
          currentComment.postGroup = currentPost.groupName;
          metaCmt.add(currentComment);
          await _allComments.doc(element.id).update(currentComment.toJson());
        });
      }
      //  ----
      currentPost.comments = metaCmt;
      fullScreenController.setPost(currentPost);
      favController.refreshPosts();
      yourGroupsController.refreshGroups();
      Get.back();
      Get.back();
      return true;
    } catch (e) {
      // ignore: avoid_print
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
}
