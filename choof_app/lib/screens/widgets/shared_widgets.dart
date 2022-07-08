import 'dart:io';

import 'package:choof_app/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/landing_page_controller.dart';
import '../../controllers/shared_functions.dart';
import '../../models/comment.dart';
import '../../models/group.dart';
import '../../models/post.dart';
import '../../models/profile.dart';
import '../../utils/datetime_ext.dart';

// Video Widget
class VideoWidget extends StatefulWidget {
  final Post post;
  final Profile user;
  final Function viewGroupFunc;
  final String? thumbnailUrl;
  final bool isInsideGroup;
  final Function reportFunction;
  final List<Comment> commentList;
  final Function(String) commentFunction;
  final Function viewCommentFunction;
  const VideoWidget(
      {Key? key,
      required this.post,
      required this.user,
      required this.thumbnailUrl,
      required this.viewGroupFunc,
      required this.isInsideGroup,
      required this.reportFunction,
      required this.commentList,
      required this.commentFunction,
      required this.viewCommentFunction})
      : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  final TextEditingController controller = TextEditingController();
  bool isHide = true;
  bool textFieldExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        color: const Color(bgColor),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            // Video Widget
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.post.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                // Report Button
                widget.post.creator.trim() == widget.user.name.trim()
                    ? const SizedBox(
                        width: 30,
                        height: 50,
                      )
                    : IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                              backgroundColor: const Color(bgColor),
                              title: '',
                              content: Container(
                                height: 200,
                                color: const Color(bgColor),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Report this post
                                      TextButton(
                                        // when report is pressed
                                        onPressed: () {
                                          TextEditingController _controller =
                                              TextEditingController();
                                          Get.back();
                                          // Choose report reasons
                                          Get.defaultDialog(
                                              backgroundColor:
                                                  const Color(bgColor),
                                              title: '',
                                              content: Container(
                                                height: 300,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                color: const Color(bgColor),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Sexual content')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Sexual content',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Violent or Repulsive content')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Violent or Repulsive content',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Hateful or abusive content')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Hateful or abusive content',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Harmful or dangerous acts')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Harmful or dangerous acts',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Spam')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Spam',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportPost(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      ' False or misleading')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            ' False or misleading',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          Get.defaultDialog(
                                                              backgroundColor:
                                                                  const Color(
                                                                      mainBgColor),
                                                              title:
                                                                  'Please specify reason',
                                                              titleStyle: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              textConfirm: 'OK',
                                                              confirmTextColor:
                                                                  const Color(
                                                                      mainColor),
                                                              buttonColor:
                                                                  Colors.white,
                                                              onConfirm:
                                                                  () async {
                                                                Get.back();
                                                                await reportPost(
                                                                        post: widget
                                                                            .post,
                                                                        reportedUser:
                                                                            widget
                                                                                .user,
                                                                        reportedReason:
                                                                            _controller
                                                                                .text)
                                                                    .then(
                                                                        (value) {
                                                                  widget
                                                                      .reportFunction();
                                                                });
                                                              },
                                                              content:
                                                                  Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _controller,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    hintText:
                                                                        "Enter here....",
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide: const BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1.0),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  minLines: 1,
                                                                  maxLines: 5,
                                                                ),
                                                              ));
                                                        },
                                                        child: const Text(
                                                            'Other (please specify)',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                  ],
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/Flag.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Flag Content',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )),
                                      ),

                                      // Report this user
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          // User reported User
                                          Get.defaultDialog(
                                              backgroundColor:
                                                  const Color(bgColor),
                                              title: '',
                                              content: Container(
                                                height: 300,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                color: const Color(bgColor),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportUser(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Pretending to be someone')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Pretending to be someone',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportUser(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Fake account')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Fake account',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportUser(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Fake name')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Fake name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          await reportUser(
                                                                  post: widget
                                                                      .post,
                                                                  reportedUser:
                                                                      widget
                                                                          .user,
                                                                  reportedReason:
                                                                      'Posting inappropriate content')
                                                              .then((value) {
                                                            widget
                                                                .reportFunction();
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Posting inappropriate content',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                    TextButton(
                                                        onPressed: () async {
                                                          TextEditingController
                                                              _controller =
                                                              TextEditingController();
                                                          Get.back();

                                                          Get.defaultDialog(
                                                              backgroundColor:
                                                                  const Color(
                                                                      mainBgColor),
                                                              title:
                                                                  'Please specify reason',
                                                              titleStyle: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              textConfirm: 'OK',
                                                              confirmTextColor:
                                                                  const Color(
                                                                      mainColor),
                                                              buttonColor:
                                                                  Colors.white,
                                                              onConfirm:
                                                                  () async {
                                                                Get.back();
                                                                await reportUser(
                                                                        post: widget
                                                                            .post,
                                                                        reportedUser:
                                                                            widget
                                                                                .user,
                                                                        reportedReason:
                                                                            _controller
                                                                                .text)
                                                                    .then(
                                                                        (value) {
                                                                  widget
                                                                      .reportFunction();
                                                                });
                                                              },
                                                              content:
                                                                  Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _controller,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    hintText:
                                                                        "Enter here....",
                                                                    hintStyle: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide: const BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              1.0),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                    ),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  minLines: 1,
                                                                  maxLines: 5,
                                                                ),
                                                              ));
                                                        },
                                                        child: const Text(
                                                            'Other (please specify)',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/ReportUser.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Report User',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )),
                                      ),
                                      // Block this user
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          Get.defaultDialog(
                                              backgroundColor:
                                                  const Color(bgColor),
                                              title: 'Are you sure?',
                                              titleStyle: const TextStyle(
                                                  color: Colors.white),
                                              content: Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '1. You will be removed from all groups created by ${widget.post.creator}. ',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '2. ${widget.post.creator} will not be able to add you to any of their groups',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              textCancel: 'Cancel',
                                              textConfirm: 'OK',
                                              cancelTextColor: Colors.white,
                                              confirmTextColor:
                                                  const Color(mainColor),
                                              buttonColor: Colors.white,
                                              onCancel: () {
                                                Get.back();
                                              },
                                              onConfirm: () async {
                                                Get.back();
                                                await blockUser(
                                                        currentUser:
                                                            widget.user,
                                                        reportedName:
                                                            widget.post.creator)
                                                    .then((value) {
                                                  widget.reportFunction();
                                                });
                                              });
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/BlockUser.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text('Block User',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )),
                                      )
                                    ]),
                              ));
                        },
                        icon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            )))
              ],
            ),

            widget.post.isReported != null
                ? widget.post.isReported!
                    ? Stack(
                        children: [
                          widget.thumbnailUrl != null
                              ? Container(
                                  height: 200,
                                  child: Image.network(
                                    widget.thumbnailUrl!,
                                    fit: BoxFit.fitWidth,
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  color: Colors.black,
                                  child: const Center(
                                      child: Text('Unable to get thumnail',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                          isHide
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(bgColor),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'This post contains sensitive subjects!',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isHide = false;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'View',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.visibility,
                                                  color: Color(mainColor),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isHide = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility_off,
                                        color: Color(mainColor),
                                      ))),
                        ],
                      )
                    : widget.thumbnailUrl != null
                        ? Container(
                            height: 200,
                            child: Image.network(
                              widget.thumbnailUrl!,
                              fit: BoxFit.fitWidth,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )
                        : Container(
                            height: 200,
                            color: Colors.black,
                            child: const Center(
                                child: Text('Unable to get thumbnail',
                                    style: TextStyle(color: Colors.white))),
                          )
                : widget.thumbnailUrl != null
                    ? Container(
                        height: 200,
                        child: Image.network(
                          widget.thumbnailUrl!,
                          fit: BoxFit.fitWidth,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                        ),
                      )
                    : Container(
                        height: 200,
                        color: Colors.black,
                        child: const Center(
                            child: Text('Unable to get thumbnail',
                                style: TextStyle(color: Colors.white))),
                      ),

            const SizedBox(
              height: 10,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 30,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.post.addedTime.getTimeAgo(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.post.youtubeLink));
                        Get.snackbar(
                          'Link Copied to Clipboard.',
                          widget.post.youtubeLink,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(mainBgColor),
                            child: FaIcon(
                              FontAwesomeIcons.link,
                              color: Colors.white,
                              size: 15,
                            ),
                          )),
                    ),
                    Row(
                      children: List.generate(
                          widget.post.tags.length,
                          (index2) => Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      widget.post.tags[index2],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  index2 != widget.post.tags.length - 1
                                      ? const CircleAvatar(
                                          radius: 2,
                                          backgroundColor: Colors.white54,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              )),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),

            widget.isInsideGroup
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        widget.post.creatorImageUrl)))),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'By: ',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.post.creator,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.white54,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'In: ',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.clear();
                              // widget.textController.clear();
                              widget.viewGroupFunc();
                            },
                            child: Text(
                              widget.post.groupName.contains('#')
                                  ? widget.post.groupName.substring(
                                      0, widget.post.groupName.indexOf('#'))
                                  : widget.post.groupName,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            widget.commentList.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(widget
                                            .commentList.first.commenterUrl)))),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: widget.commentList.first.commentText
                                          .length <
                                      300
                                  ? Text(
                                      widget.commentList.first.commentText,
                                      overflow: TextOverflow.fade,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                          Container(
                                            child: Text(
                                              widget.commentList.first
                                                      .commentText
                                                      .substring(0, 300) +
                                                  '...',
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              widget.viewCommentFunction();
                                            },
                                            child: const Text(
                                              'more',
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ]),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              widget.viewCommentFunction();
                            },
                            child: Text(
                              widget.commentList.length == 1
                                  ? 'View all ${widget.commentList.length} comment'
                                  : 'View all ${widget.commentList.length} comments',
                              style: const TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            Container(
              height: textFieldExpanded
                  ? MediaQuery.of(context).size.height / 10
                  : MediaQuery.of(context).size.height / 25,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Image.asset(
                        'assets/icons/Comment.png',
                        width: 30,
                        height: 30,
                      )),
                  Expanded(
                      child: TextField(
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    controller: controller,
                    onChanged: (e) {
                      int numLines = '\n'.allMatches(e).length + 1;
                      if (numLines > 1 || e.length > 30) {
                        setState(() {
                          textFieldExpanded = true;
                        });
                      } else {
                        setState(() {
                          textFieldExpanded = false;
                        });
                      }
                    },
                    onSubmitted: (value) {
                      widget.commentFunction(controller.text);
                      setState(() {
                        textFieldExpanded = false;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      contentPadding: const EdgeInsets.only(top: 6, left: 3),
                      filled: true,
                      fillColor: const Color(bgColor),
                      suffixIcon: Padding(
                        padding: textFieldExpanded
                            ? const EdgeInsets.all(10)
                            : const EdgeInsets.all(3),
                        child: InkWell(
                          child: Image.asset(
                            'assets/icons/EmailSend.png',
                            width: 10,
                            height: 10,
                            color: Colors.white24,
                          ),
                          onTap: () {
                            widget.commentFunction(controller.text);
                            setState(() {
                              textFieldExpanded = false;
                              controller.clear();
                            });
                          },
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Group Widget
class GroupWidget extends StatelessWidget {
  final Group group;
  const GroupWidget({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(200))),
      child: Card(
        color: const Color(bgColor),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      group.name.contains('#')
                          ? group.name.substring(0, group.name.indexOf('#'))
                          : group.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    DateTime.parse(group.lastUpdatedTime.toString())
                        .getTimeAgo(),
                    style: const TextStyle(color: Colors.white54),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(group.ownerImageUrl)))),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'By',
                    style: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    group.owner,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 16,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(
                      group.members.length > 1
                          ? '${group.members.length} members'
                          : '${group.members.length} member',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      group.videoNumber! > 1
                          ? '${group.videoNumber} favorites'
                          : '${group.videoNumber} favorite',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: List.generate(
                          group.tags.length,
                          (index2) => Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      group.tags[index2],
                                      style: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                  index2 != group.tags.length - 1
                                      ? const CircleAvatar(
                                          radius: 2,
                                          backgroundColor: Colors.white54,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// profile vertical widget
class ProfileVerticalWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double size;
  final bool isSelected;
  const ProfileVerticalWidget(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.size,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: const Color(mainColor), width: 2.0)
                      : Border.all(color: Colors.white),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(imageUrl)))),
          const SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: TextStyle(
                color: isSelected ? const Color(mainColor) : Colors.white),
          )
        ],
      ),
    );
  }
}

// tag widget
class TagWidget extends StatelessWidget {
  final String name;
  const TagWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Show this dialog when tags are empty
Widget tagEmptyDialog() {
  return Scaffold(
    body: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Please enter at least one tag.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "For example: TV show, HBO, English, funny, California...",
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: const BoxDecoration(
                  color: Color(mainColor),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Loding Dialog
loadingDialog() {
  Get.dialog(Container(
    decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
    child: const Center(child: CircularProgressIndicator()),
  ));
}

// Infodialog
infoDialog(
    {required String title,
    required String content,
    required List<Widget>? actions}) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 30),
    contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
    backgroundColor: const Color(mainBgColor),
    title: title,
    titleStyle: const TextStyle(fontSize: 15, color: Colors.white),
    content: Text(
      content,
      style: const TextStyle(fontSize: 12, color: Colors.white),
    ),
    actions: actions,
  );
}

class BottomMenu extends StatelessWidget {
  final int? deactivatedIndex;
  BottomMenu({Key? key, this.deactivatedIndex}) : super(key: key);
  final landingPagecontroller = Get.find<LandingPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SizedBox(
            height: Platform.isIOS ? 95 : 60,
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              showSelectedLabels: true,
              onTap: (index) {
                landingPagecontroller.changeTabIndex(index);
                if (index == deactivatedIndex) {
                  for (int i = 0;
                      i < landingPagecontroller.backIndex.value;
                      i++) {
                    Get.back();
                  }
                  landingPagecontroller.setBackIndex(0);
                }
              },
              currentIndex: landingPagecontroller.tabIndex.value,
              backgroundColor: const Color(bgColor),
              unselectedItemColor: Colors.white.withOpacity(0.5),
              selectedItemColor: deactivatedIndex != null
                  ? landingPagecontroller.tabIndex.value == deactivatedIndex
                      ? Colors.white.withOpacity(0.5)
                      : const Color(mainColor)
                  : const Color(mainColor),
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/Favorite.png',
                    width: 30,
                    height: 30,
                  ),
                  activeIcon: deactivatedIndex != null
                      ? deactivatedIndex == 0
                          ? Image.asset('assets/icons/Favorite.png',
                              width: 30, height: 30)
                          : Image.asset(
                              'assets/icons/Favorite.png',
                              width: 30,
                              height: 30,
                              color: const Color(mainColor),
                            )
                      : Image.asset(
                          'assets/icons/Favorite.png',
                          width: 30,
                          height: 30,
                          color: const Color(mainColor),
                        ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/Users.png',
                    width: 30,
                    height: 30,
                  ),
                  activeIcon: deactivatedIndex != null
                      ? deactivatedIndex == 1
                          ? Image.asset(
                              'assets/icons/Users.png',
                              width: 30,
                              height: 30,
                            )
                          : Image.asset(
                              'assets/icons/Users.png',
                              width: 30,
                              height: 30,
                              color: const Color(mainColor),
                            )
                      : Image.asset(
                          'assets/icons/Users.png',
                          width: 30,
                          height: 30,
                          color: const Color(mainColor),
                        ),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/Settings.png',
                    width: 30,
                    height: 30,
                  ),
                  activeIcon: Image.asset(
                    'assets/icons/Settings.png',
                    width: 30,
                    height: 30,
                    color: const Color(mainColor),
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ));
  }
}

class RefresherWidget extends StatelessWidget {
  final RefreshController controller;
  final Function pullrefreshFunction;
  final Function onLoadingFunction;
  final Widget child;
  const RefresherWidget({
    Key? key,
    required this.controller,
    required this.pullrefreshFunction,
    required this.onLoadingFunction,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      onRefresh: () {
        pullrefreshFunction();
      },
      enablePullUp: true,
      enablePullDown: true,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text(
              "Pull up to load more",
              style: TextStyle(color: Colors.white),
            );
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text(
              "Load Failed!Click retry!",
              style: TextStyle(color: Colors.white),
            );
          } else if (mode == LoadStatus.canLoading) {
            body = const Text(
              "Release to load more",
              style: TextStyle(color: Colors.white),
            );
          } else {
            body = const Text("");
          }
          return mode == LoadStatus.noMore
              ? const SizedBox.shrink()
              : Container(
                  height: 30.0,
                  child: Center(child: body),
                );
        },
      ),
      onLoading: () {
        onLoadingFunction();
      },
      child: child,
    );
  }
}
