import 'package:choof_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/landing_page_controller.dart';
import '../../controllers/shared_functions.dart';
import '../../models/group.dart';
import '../../models/post.dart';
import '../../models/profile.dart';
import '../../utils/datetime_ext.dart';

// Video Widget
class VideoWidget extends StatefulWidget {
  final Post post;
  final Profile user;
  final Widget youtubePlayer;
  final Function viewGroupFunc;
  final bool isInsideGroup;
  final Function reportFunction;
  const VideoWidget(
      {Key? key,
      required this.post,
      required this.user,
      required this.youtubePlayer,
      required this.viewGroupFunc,
      required this.isInsideGroup,
      required this.reportFunction})
      : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(bgColor),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
                        fontSize: 20),
                  ),
                ),
                // Report Button
                IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: '',
                          content: Container(
                            height: 200,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          title: '',
                                          content: Container(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            color: Colors.white,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Sexual content')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Sexual content',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Violent or Repulsive content')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Violent or Repulsive content',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Hateful or abusive content')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Hateful or abusive content',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Harmful or dangerous acts')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Harmful or dangerous acts',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Spam')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text('Spam',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportPost(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  ' False or misleading')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        ' False or misleading',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      Get.defaultDialog(
                                                          title:
                                                              'Please specify reason',
                                                          titlePadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          textConfirm: 'OK',
                                                          onConfirm: () async {
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
                                                                .then((value) {
                                                              widget
                                                                  .reportFunction();
                                                            });
                                                          },
                                                          content: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: TextField(
                                                              controller:
                                                                  _controller,
                                                              decoration:
                                                                  InputDecoration(
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                            color:
                                                                Colors.red))),
                                              ],
                                            ),
                                          ));
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.flag),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Flag Content',
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        )),
                                  ),

                                  // Report this user
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      // User reported User
                                      Get.defaultDialog(
                                          title: '',
                                          content: Container(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            color: Colors.white,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportUser(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Pretending to be someone')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Pretending to be someone',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportUser(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Fake account')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Fake account',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportUser(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Fake name')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Fake name',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      await reportUser(
                                                              post: widget.post,
                                                              reportedUser:
                                                                  widget.user,
                                                              reportedReason:
                                                                  'Posting inappropriate content')
                                                          .then((value) {
                                                        widget.reportFunction();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'Posting inappropriate content',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                                TextButton(
                                                    onPressed: () async {
                                                      TextEditingController
                                                          _controller =
                                                          TextEditingController();
                                                      Get.back();

                                                      Get.defaultDialog(
                                                          title:
                                                              'Please specify reason',
                                                          titlePadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          textConfirm: 'OK',
                                                          onConfirm: () async {
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
                                                                .then((value) {
                                                              widget
                                                                  .reportFunction();
                                                            });
                                                          },
                                                          content: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: TextField(
                                                              controller:
                                                                  _controller,
                                                              decoration:
                                                                  InputDecoration(
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                            color:
                                                                Colors.red))),
                                                const Divider(),
                                              ],
                                            ),
                                          ));
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.info),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Report User',
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        )),
                                  ),
                                  // Block this user
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      Get.defaultDialog(
                                          title: 'Are you sure?',
                                          content: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                    '1. You will be removed from all groups created by ${widget.post.creator}. '),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    '2. ${widget.post.creator} will not be able to add you to any of their groups')
                                              ],
                                            ),
                                          ),
                                          textCancel: 'Cancel',
                                          textConfirm: 'OK',
                                          onCancel: () {
                                            Get.back();
                                          },
                                          onConfirm: () async {
                                            Get.back();
                                            await blockUser(
                                                    currentUser: widget.user,
                                                    reportedName:
                                                        widget.post.creator)
                                                .then((value) {
                                              widget.reportFunction();
                                            });
                                          });
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.block),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Block User',
                                                style: TextStyle(
                                                    color: Colors.black))
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

            const SizedBox(
              height: 5,
            ),

            widget.post.isReported != null
                ? widget.post.isReported!
                    ? Stack(
                        children: [
                          Container(
                            height: 200,
                            child: widget.youtubePlayer,
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
                    : Container(
                        height: 200,
                        child: widget.youtubePlayer,
                      )
                : Container(
                    height: 200,
                    child: widget.youtubePlayer,
                  ),

            const SizedBox(
              height: 5,
            ),

            Container(
              height: 20,
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FaIcon(
                          FontAwesomeIcons.link,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
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
              height: 5,
            ),

            widget.isInsideGroup
                ? const SizedBox.shrink()
                : Row(
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
                            color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.post.creator,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: Colors.white54,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'In:',
                        style: TextStyle(
                            color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            widget.viewGroupFunc();
                          },
                          child: Center(
                            child: Text(
                              widget.post.groupName,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 0,
              color: Colors.white,
            ),
          ],
        ));
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
        color: Colors.grey.shade800,
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
                      group.name,
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
    title: title,
    titleStyle: const TextStyle(fontSize: 15),
    content: Text(
      content,
      style: const TextStyle(fontSize: 12),
    ),
    actions: actions,
  );
}

class BottomMenu extends StatelessWidget {
  BottomMenu({Key? key}) : super(key: key);
  final landingPagecontroller = Get.find<LandingPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 95,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPagecontroller.changeTabIndex,
            currentIndex: landingPagecontroller.tabIndex.value,
            backgroundColor: const Color(bgColor),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: const Color(mainColor),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/Favorite.png',
                  width: 30,
                  height: 30,
                ),
                activeIcon: Image.asset(
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
                activeIcon: Image.asset(
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
        )));
  }
}
