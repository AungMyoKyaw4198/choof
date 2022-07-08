import 'package:choof_app/models/comment.dart';
import 'package:choof_app/models/group.dart';
import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/view_group.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:choof_app/utils/datetime_ext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/full_screen_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../models/post.dart';
import '../models/youtubeVideoResponse.dart';
import '../services/youtube_service.dart';
import '../utils/app_constant.dart';
import 'edit_favorite_page.dart';
import 'widgets/shared_widgets.dart';

class FullScreenPage extends StatefulWidget {
  final int index;
  final Post post;
  final bool isOwner;
  final bool isViewComment;
  final bool? isToRefresh;
  final TextEditingController commentController;
  final Function addCommentFunction;
  const FullScreenPage(
      {Key? key,
      required this.post,
      required this.index,
      required this.isOwner,
      required this.isViewComment,
      required this.commentController,
      required this.addCommentFunction,
      this.isToRefresh})
      : super(key: key);

  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final fullScreenController = Get.put(FullScreenController());
  final landingPagecontroller = Get.find<LandingPageController>();
  late YoutubeVideoResponse videoDetail;
  bool isLoading = true;
  bool isFinished = true;
  bool isError = false;
  bool isFullScreen = false;
  late YoutubePlayerController currentPlayer;

  @override
  void initState() {
    viewVideoDetail(widget.post.youtubeLink);
    _tabController = TabController(length: 2, vsync: this);
    if (widget.isViewComment) {
      _tabController.index = 1;
    } else {
      _tabController.index = 0;
    }

    fullScreenController.setPost(widget.post);
    currentPlayer = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.post.youtubeLink)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    landingPagecontroller.incrementBackIndex();

    super.initState();
  }

  setYoutubePlayer(Post newPost) {
    currentPlayer = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(newPost.youtubeLink)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  viewVideoDetail(String videoLink) async {
    String videoId = YoutubePlayer.convertUrlToId(videoLink)!;
    await YouTubeService.instance.fetchVideoInfo(id: videoId).then((value) {
      setState(() {
        videoDetail = value;
        isLoading = false;
        isError = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    currentPlayer.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: currentPlayer,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) => Scaffold(
        // Bottom Navigation
        bottomNavigationBar: Obx(() {
          return landingPagecontroller.isDeviceTablet.value
              ? const SizedBox.shrink()
              : BottomMenu(deactivatedIndex: widget.index);
        }),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(mainBgColor),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Obx(() {
                  return IndexedStack(
                    index: landingPagecontroller.tabIndex.value,
                    children: [
                      widget.index == 0
                          ? Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).viewPadding.top,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      player,
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          fullScreenController.post.value.name,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              30.0,
                                            ),
                                            color: const Color(bgColor),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            padding: const EdgeInsets.all(5),
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30.0,
                                              ),
                                              color: const Color(mainBgColor),
                                            ),
                                            labelColor: Colors.white,
                                            unselectedLabelColor: Colors.white,
                                            tabs: [
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      child: Image.asset(
                                                          'assets/icons/Info.png'),
                                                    ),
                                                    const Text(
                                                      'Info',
                                                    )
                                                  ],
                                                ),
                                                iconMargin:
                                                    const EdgeInsets.only(
                                                        bottom: 0.0),
                                              ),
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5),
                                                        child: Image.asset(
                                                            'assets/icons/Comment.png')),
                                                    const Text(
                                                      'Comments',
                                                    ),
                                                  ],
                                                ),
                                                iconMargin:
                                                    const EdgeInsets.only(
                                                        bottom: 0.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            // Info
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              children: [
                                                fullScreenController.post.value
                                                        .tags.isNotEmpty
                                                    ? Container(
                                                        height: 30,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              fullScreenController
                                                                  .post
                                                                  .value
                                                                  .tags
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child: Chip(
                                                                backgroundColor:
                                                                    const Color(
                                                                        bgColor),
                                                                label: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          5),
                                                                  child: Text(
                                                                      fullScreenController
                                                                          .post
                                                                          .value
                                                                          .tags[
                                                                              index]
                                                                          .trim()),
                                                                ),
                                                                labelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(height: 10),
                                                Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: NetworkImage(fullScreenController
                                                                          .post
                                                                          .value
                                                                          .creatorImageUrl)))),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: Text(
                                                            'By: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            fullScreenController
                                                                .post
                                                                .value
                                                                .creator,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: CircleAvatar(
                                                            radius: 2,
                                                            backgroundColor:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: Text(
                                                            'In: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (widget
                                                                    .isToRefresh !=
                                                                null) {
                                                              Get.back();
                                                            } else {
                                                              final CollectionReference
                                                                  _allGroups =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "groups");
                                                              QuerySnapshot<
                                                                      Object?>
                                                                  group =
                                                                  await _allGroups
                                                                      .where(
                                                                          'name',
                                                                          isEqualTo: widget
                                                                              .post
                                                                              .groupName)
                                                                      .get();
                                                              if (group.docs
                                                                  .isNotEmpty) {
                                                                Group gp = Group
                                                                    .fromJson(group
                                                                            .docs
                                                                            .first
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>);

                                                                Get.to(() =>
                                                                    ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup:
                                                                          gp,
                                                                      isFromGroup: widget.index ==
                                                                              1
                                                                          ? true
                                                                          : false,
                                                                      isFromFullScreenPage:
                                                                          true,
                                                                      isFromAddGroup:
                                                                          false,
                                                                    ));
                                                              }
                                                            }
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName
                                                                      .contains(
                                                                          '#')
                                                                  ? fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName
                                                                      .substring(
                                                                          0,
                                                                          fullScreenController
                                                                              .post
                                                                              .value
                                                                              .groupName
                                                                              .indexOf(
                                                                                  '#'))
                                                                  : fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            ' | ${fullScreenController.post.value.addedTime.getTimeAgo()}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                const SizedBox(height: 10),
                                                videoDetail.items![0].snippet!
                                                            .description !=
                                                        null
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          videoDetail
                                                              .items![0]
                                                              .snippet!
                                                              .description!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ))
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),

                                            // Comments
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              children: [
                                                Obx(() => Container(
                                                      height: fullScreenController
                                                              .textFieldExpanded
                                                              .value
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              10
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              20,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/Comment.png',
                                                                width: 30,
                                                                height: 30,
                                                              )),
                                                          Expanded(
                                                              child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            expands: true,
                                                            maxLines: null,
                                                            controller: widget
                                                                .commentController,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            onChanged: (e) {
                                                              int numLines = '\n'
                                                                      .allMatches(
                                                                          e)
                                                                      .length +
                                                                  1;
                                                              if (numLines >
                                                                      1 ||
                                                                  e.length >
                                                                      30) {
                                                                fullScreenController
                                                                    .setTextFieldExpanded(
                                                                        true);
                                                              } else {
                                                                fullScreenController
                                                                    .setTextFieldExpanded(
                                                                        false);
                                                              }
                                                            },
                                                            onSubmitted:
                                                                (value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                Comment currentCmt = Comment(
                                                                    postName:
                                                                        widget
                                                                            .post
                                                                            .name,
                                                                    postLink: widget
                                                                        .post
                                                                        .youtubeLink,
                                                                    postCreator:
                                                                        widget
                                                                            .post
                                                                            .creator,
                                                                    postGroup: widget
                                                                        .post
                                                                        .groupName,
                                                                    commenter: landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                    commenterUrl: landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .imageUrl,
                                                                    commentText:
                                                                        widget
                                                                            .commentController
                                                                            .text,
                                                                    addedTime:
                                                                        DateTime
                                                                            .now());
                                                                widget
                                                                    .addCommentFunction();
                                                                fullScreenController
                                                                    .addCommentToPost(
                                                                        currentCmt);
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                widget
                                                                    .commentController
                                                                    .clear();
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintText:
                                                                        'Add a comment...',
                                                                    hintStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white70),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white24,
                                                                    suffixIcon:
                                                                        IconButton(
                                                                      icon: Image
                                                                          .asset(
                                                                        'assets/icons/EmailSend.png',
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        if (widget
                                                                            .commentController
                                                                            .text
                                                                            .isNotEmpty) {
                                                                          Comment currentCmt = Comment(
                                                                              postName: widget.post.name,
                                                                              postLink: widget.post.youtubeLink,
                                                                              postCreator: widget.post.creator,
                                                                              postGroup: widget.post.groupName,
                                                                              commenter: landingPagecontroller.userProfile.value.name,
                                                                              commenterUrl: landingPagecontroller.userProfile.value.imageUrl,
                                                                              commentText: widget.commentController.text,
                                                                              addedTime: DateTime.now());
                                                                          fullScreenController
                                                                              .addCommentToPost(currentCmt);
                                                                          widget
                                                                              .addCommentFunction();
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          widget
                                                                              .commentController
                                                                              .clear();
                                                                        }
                                                                      },
                                                                    )),
                                                          )),
                                                        ],
                                                      ),
                                                    )),

                                                // Sorting Container
                                                Obx(
                                                  () => fullScreenController
                                                          .post
                                                          .value
                                                          .comments!
                                                          .isNotEmpty
                                                      ? Obx(() =>
                                                          !fullScreenController
                                                                  .sortByRecent
                                                                  .value
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    fullScreenController
                                                                        .sortComments(
                                                                            true);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    height: 40,
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/icons/UpDownArrow.png',
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          'Most recent',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    fullScreenController
                                                                        .sortComments(
                                                                            false);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    height: 40,
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/icons/UpDownArrow.png',
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          'Alphabetical',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))
                                                      : const SizedBox.shrink(),
                                                ),

                                                // Comments list
                                                Obx(() {
                                                  return fullScreenController
                                                          .post
                                                          .value
                                                          .comments!
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount:
                                                              fullScreenController
                                                                  .post
                                                                  .value
                                                                  .comments!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return fullScreenController
                                                                        .isInEditingMode
                                                                        .value &&
                                                                    fullScreenController.post.value.comments![
                                                                            index] ==
                                                                        fullScreenController
                                                                            .editingComment
                                                                            .value
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Obx(
                                                                          () =>
                                                                              Container(
                                                                            height: fullScreenController.editingTextFieldExpanded.value
                                                                                ? MediaQuery.of(context).size.height / 10
                                                                                : MediaQuery.of(context).size.height / 20,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 2,
                                                                                ),
                                                                                Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  child: TextField(
                                                                                      controller: fullScreenController.editingController,
                                                                                      expands: true,
                                                                                      maxLines: null,
                                                                                      style: const TextStyle(color: Colors.white),
                                                                                      onChanged: (e) {
                                                                                        int numLines = '\n'.allMatches(e).length + 1;
                                                                                        if (numLines > 1 || e.length > 30) {
                                                                                          fullScreenController.setEditingTextFieldExpanded(true);
                                                                                        } else {
                                                                                          fullScreenController.setEditingTextFieldExpanded(false);
                                                                                        }
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(30.0),
                                                                                        ),
                                                                                        contentPadding: const EdgeInsets.all(10),
                                                                                        hintText: 'Add a comment...',
                                                                                        hintStyle: const TextStyle(color: Colors.white70),
                                                                                        filled: true,
                                                                                        fillColor: Colors.white24,
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        // buttons
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  fullScreenController.deleteComment(widget.commentController, context);
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  fullScreenController.clearEditingMode();
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text('Cancel', style: TextStyle(color: Colors.white70))),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  if (fullScreenController.editingController.text != fullScreenController.editingComment.value.commentText) {
                                                                                    fullScreenController.editComment(widget.commentController, context);
                                                                                  }

                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text(
                                                                                  'Save',
                                                                                  style: TextStyle(color: Color(mainColor)),
                                                                                )),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ))
                                                                : InkWell(
                                                                    onTap: () {
                                                                      if (fullScreenController
                                                                              .post
                                                                              .value
                                                                              .comments![
                                                                                  index]
                                                                              .commenter ==
                                                                          landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .name) {
                                                                        fullScreenController.setEditingMode(
                                                                            true,
                                                                            fullScreenController.post.value.comments![index]);
                                                                      }
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          Container(
                                                                              width: 30,
                                                                              height: 30,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  fullScreenController.post.value.comments![index].commentText,
                                                                                  overflow: TextOverflow.fade,
                                                                                  style: const TextStyle(fontSize: 15, color: Colors.white),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(fullScreenController.post.value.comments![index].commenter, style: const TextStyle(color: Colors.white54)),
                                                                                    const Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Icon(Icons.circle, size: 5, color: Colors.white54),
                                                                                    ),
                                                                                    Text(
                                                                                      DateTime.parse(fullScreenController.post.value.comments![index].addedTime.toString()).getTimeAgo(),
                                                                                      style: const TextStyle(color: Colors.white54),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                          })
                                                      : const SizedBox.shrink();
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Back Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 35),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                                // Edit Button
                                widget.isOwner
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 40),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 13,
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => EditFavoritePage(
                                                        index: 0,
                                                        post:
                                                            fullScreenController
                                                                .post.value,
                                                        isFromGroup: false,
                                                      ))!
                                                  .then((value) {
                                                currentPlayer.load(YoutubePlayer
                                                    .convertUrlToId(
                                                        fullScreenController
                                                            .post
                                                            .value
                                                            .youtubeLink)!);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            )
                          : const FavouritePage(isFirstTime: false),
                      widget.index == 1
                          ? Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).viewPadding.top,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      player,
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          fullScreenController.post.value.name,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              30.0,
                                            ),
                                            color: const Color(bgColor),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            padding: const EdgeInsets.all(5),
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30.0,
                                              ),
                                              color: const Color(mainBgColor),
                                            ),
                                            labelColor: Colors.white,
                                            unselectedLabelColor: Colors.white,
                                            tabs: [
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      child: Image.asset(
                                                          'assets/icons/Info.png'),
                                                    ),
                                                    const Text(
                                                      'Info',
                                                    )
                                                  ],
                                                ),
                                                iconMargin:
                                                    const EdgeInsets.only(
                                                        bottom: 0.0),
                                              ),
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5),
                                                        child: Image.asset(
                                                            'assets/icons/Comment.png')),
                                                    const Text(
                                                      'Comments',
                                                    ),
                                                  ],
                                                ),
                                                iconMargin:
                                                    const EdgeInsets.only(
                                                        bottom: 0.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            // Info
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              children: [
                                                fullScreenController.post.value
                                                        .tags.isNotEmpty
                                                    ? Container(
                                                        height: 30,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              fullScreenController
                                                                  .post
                                                                  .value
                                                                  .tags
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child: Chip(
                                                                backgroundColor:
                                                                    const Color(
                                                                        bgColor),
                                                                label: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          5),
                                                                  child: Text(
                                                                      fullScreenController
                                                                          .post
                                                                          .value
                                                                          .tags[
                                                                              index]
                                                                          .trim()),
                                                                ),
                                                                labelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(height: 10),
                                                Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: NetworkImage(fullScreenController
                                                                          .post
                                                                          .value
                                                                          .creatorImageUrl)))),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: Text(
                                                            'By: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            fullScreenController
                                                                .post
                                                                .value
                                                                .creator,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: CircleAvatar(
                                                            radius: 2,
                                                            backgroundColor:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Center(
                                                          child: Text(
                                                            'In: ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            Get.back();
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName
                                                                      .contains(
                                                                          '#')
                                                                  ? fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName
                                                                      .substring(
                                                                          0,
                                                                          fullScreenController
                                                                              .post
                                                                              .value
                                                                              .groupName
                                                                              .indexOf(
                                                                                  '#'))
                                                                  : fullScreenController
                                                                      .post
                                                                      .value
                                                                      .groupName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            ' | ${fullScreenController.post.value.addedTime.getTimeAgo()}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                const SizedBox(height: 10),
                                                videoDetail.items![0].snippet!
                                                            .description !=
                                                        null
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          videoDetail
                                                              .items![0]
                                                              .snippet!
                                                              .description!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ))
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),

                                            // Comments
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              children: [
                                                Obx(() => Container(
                                                      height: fullScreenController
                                                              .textFieldExpanded
                                                              .value
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              10
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              20,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/Comment.png',
                                                                width: 30,
                                                                height: 30,
                                                              )),
                                                          Expanded(
                                                              child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            expands: true,
                                                            maxLines: null,
                                                            controller: widget
                                                                .commentController,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            onChanged: (e) {
                                                              int numLines = '\n'
                                                                      .allMatches(
                                                                          e)
                                                                      .length +
                                                                  1;
                                                              if (numLines >
                                                                      1 ||
                                                                  e.length >
                                                                      30) {
                                                                fullScreenController
                                                                    .setTextFieldExpanded(
                                                                        true);
                                                              } else {
                                                                fullScreenController
                                                                    .setTextFieldExpanded(
                                                                        false);
                                                              }
                                                            },
                                                            onSubmitted:
                                                                (value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                Comment currentCmt = Comment(
                                                                    postName:
                                                                        widget
                                                                            .post
                                                                            .name,
                                                                    postLink: widget
                                                                        .post
                                                                        .youtubeLink,
                                                                    postCreator:
                                                                        widget
                                                                            .post
                                                                            .creator,
                                                                    postGroup: widget
                                                                        .post
                                                                        .groupName,
                                                                    commenter: landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                    commenterUrl: landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .imageUrl,
                                                                    commentText:
                                                                        widget
                                                                            .commentController
                                                                            .text,
                                                                    addedTime:
                                                                        DateTime
                                                                            .now());
                                                                widget
                                                                    .addCommentFunction();
                                                                fullScreenController
                                                                    .addCommentToPost(
                                                                        currentCmt);
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    hintText:
                                                                        'Add a comment...',
                                                                    hintStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white70),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white24,
                                                                    suffixIcon:
                                                                        IconButton(
                                                                      icon: Image
                                                                          .asset(
                                                                        'assets/icons/EmailSend.png',
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        if (widget
                                                                            .commentController
                                                                            .text
                                                                            .isNotEmpty) {
                                                                          Comment currentCmt = Comment(
                                                                              postName: widget.post.name,
                                                                              postLink: widget.post.youtubeLink,
                                                                              postCreator: widget.post.creator,
                                                                              postGroup: widget.post.groupName,
                                                                              commenter: landingPagecontroller.userProfile.value.name,
                                                                              commenterUrl: landingPagecontroller.userProfile.value.imageUrl,
                                                                              commentText: widget.commentController.text,
                                                                              addedTime: DateTime.now());
                                                                          fullScreenController
                                                                              .addCommentToPost(currentCmt);
                                                                          widget
                                                                              .addCommentFunction();
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          widget
                                                                              .commentController
                                                                              .clear();
                                                                        }
                                                                      },
                                                                    )),
                                                          )),
                                                        ],
                                                      ),
                                                    )),
                                                // Sorting Container
                                                Obx(
                                                  () => fullScreenController
                                                          .post
                                                          .value
                                                          .comments!
                                                          .isNotEmpty
                                                      ? Obx(() =>
                                                          !fullScreenController
                                                                  .sortByRecent
                                                                  .value
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    fullScreenController
                                                                        .sortComments(
                                                                            true);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    height: 40,
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/icons/UpDownArrow.png',
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          'Most recent',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    fullScreenController
                                                                        .sortComments(
                                                                            false);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    height: 40,
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/icons/UpDownArrow.png',
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          'Default',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))
                                                      : const SizedBox.shrink(),
                                                ),

                                                Obx(() {
                                                  return fullScreenController
                                                          .post
                                                          .value
                                                          .comments!
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          itemCount:
                                                              fullScreenController
                                                                  .post
                                                                  .value
                                                                  .comments!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return fullScreenController
                                                                        .isInEditingMode
                                                                        .value &&
                                                                    fullScreenController.post.value.comments![
                                                                            index] ==
                                                                        fullScreenController
                                                                            .editingComment
                                                                            .value
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Obx(
                                                                          () =>
                                                                              Container(
                                                                            height: fullScreenController.editingTextFieldExpanded.value
                                                                                ? MediaQuery.of(context).size.height / 10
                                                                                : MediaQuery.of(context).size.height / 20,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 2,
                                                                                ),
                                                                                Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  child: TextField(
                                                                                      controller: fullScreenController.editingController,
                                                                                      expands: true,
                                                                                      maxLines: null,
                                                                                      style: const TextStyle(color: Colors.white),
                                                                                      onChanged: (e) {
                                                                                        int numLines = '\n'.allMatches(e).length + 1;
                                                                                        if (numLines > 1 || e.length > 30) {
                                                                                          fullScreenController.setEditingTextFieldExpanded(true);
                                                                                        } else {
                                                                                          fullScreenController.setEditingTextFieldExpanded(false);
                                                                                        }
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(30.0),
                                                                                        ),
                                                                                        contentPadding: const EdgeInsets.all(10),
                                                                                        hintText: 'Add a comment...',
                                                                                        hintStyle: const TextStyle(color: Colors.white70),
                                                                                        filled: true,
                                                                                        fillColor: Colors.white24,
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // buttons
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  fullScreenController.deleteComment(widget.commentController, context);
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  fullScreenController.clearEditingMode();
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text('Cancel', style: TextStyle(color: Colors.white70))),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  if (fullScreenController.editingController.text != fullScreenController.editingComment.value.commentText) {
                                                                                    fullScreenController.editComment(widget.commentController, context);
                                                                                  }
                                                                                  fullScreenController.clearEditingMode();
                                                                                  FocusScope.of(context).unfocus();
                                                                                  widget.commentController.clear();
                                                                                  setState(() {});
                                                                                },
                                                                                child: const Text(
                                                                                  'Save',
                                                                                  style: TextStyle(color: Color(mainColor)),
                                                                                )),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ))
                                                                : InkWell(
                                                                    onTap: () {
                                                                      if (fullScreenController
                                                                              .post
                                                                              .value
                                                                              .comments![
                                                                                  index]
                                                                              .commenter ==
                                                                          landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .name) {
                                                                        fullScreenController.setEditingMode(
                                                                            true,
                                                                            fullScreenController.post.value.comments![index]);
                                                                      }
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          Container(
                                                                              width: 30,
                                                                              height: 30,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  fullScreenController.post.value.comments![index].commentText,
                                                                                  overflow: TextOverflow.fade,
                                                                                  style: const TextStyle(fontSize: 15, color: Colors.white),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(fullScreenController.post.value.comments![index].commenter, style: const TextStyle(color: Colors.white54)),
                                                                                    const Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Icon(Icons.circle, size: 5, color: Colors.white54),
                                                                                    ),
                                                                                    Text(
                                                                                      DateTime.parse(fullScreenController.post.value.comments![index].addedTime.toString()).getTimeAgo(),
                                                                                      style: const TextStyle(color: Colors.white54),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                          })
                                                      : const SizedBox.shrink();
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Back Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 35),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                                // Edit Button
                                widget.isOwner
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 40),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 13,
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => EditFavoritePage(
                                                        index: 1,
                                                        post:
                                                            fullScreenController
                                                                .post.value,
                                                        isFromGroup: true,
                                                      ))!
                                                  .then((value) {
                                                currentPlayer.load(YoutubePlayer
                                                    .convertUrlToId(
                                                        fullScreenController
                                                            .post
                                                            .value
                                                            .youtubeLink)!);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            )
                          : const YourGroupsPage(
                              isFirstTime: false,
                            ),
                      SettingsPage(),
                    ],
                  );
                }),
        ),
      ),
    );
  }
}
