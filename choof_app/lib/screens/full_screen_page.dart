import 'package:choof_app/models/comment.dart';
import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:choof_app/utils/datetime_ext.dart';
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
  final TextEditingController commentController;
  final Function addCommentFunction;
  const FullScreenPage(
      {Key? key,
      required this.post,
      required this.index,
      required this.isOwner,
      required this.commentController,
      required this.addCommentFunction})
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
    widget.commentController.clear();
    _tabController = TabController(length: 2, vsync: this);
    fullScreenController.setPost(widget.post);
    currentPlayer = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.post.youtubeLink)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    viewVideoDetail(widget.post.youtubeLink);

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
        bottomNavigationBar: Obx(
          () => landingPagecontroller.isDeviceTablet.value
              ? const SizedBox.shrink()
              : BottomMenu(),
        ),
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
                                              fontSize: 20,
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
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              border: Border.all(
                                                  color: Colors.white),
                                              color: const Color(mainColor),
                                            ),
                                            labelColor: Colors.black,
                                            unselectedLabelColor: Colors.white,
                                            tabs: [
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: Icon(Icons.info),
                                                    ),
                                                    Text(
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
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: Icon(
                                                        Icons.comment_outlined,
                                                      ),
                                                    ),
                                                    Text(
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
                                                                    Colors.grey
                                                                        .shade800,
                                                                label: Text(
                                                                    fullScreenController
                                                                            .post
                                                                            .value
                                                                            .tags[
                                                                        index]),
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
                                                          width: 10,
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
                                                          width: 20,
                                                        ),
                                                        const Center(
                                                          child: CircleAvatar(
                                                            radius: 2,
                                                            backgroundColor:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
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
                                                        Center(
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
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
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
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        child: Icon(
                                                          Icons
                                                              .comment_outlined,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: TextField(
                                                        controller: widget
                                                            .commentController,
                                                        onSubmitted: (value) {
                                                          if (value
                                                              .isNotEmpty) {
                                                            Comment currentCmt = Comment(
                                                                postName: widget
                                                                    .post.name,
                                                                postLink: widget
                                                                    .post
                                                                    .youtubeLink,
                                                                postCreator: widget
                                                                    .post
                                                                    .creator,
                                                                postGroup: widget
                                                                    .post
                                                                    .groupName,
                                                                commenter:
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commenterUrl:
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .imageUrl,
                                                                commentText: widget
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
                                                            setState(() {});
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10),
                                                                hintText:
                                                                    'Add a comment...',
                                                                hintStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white54),
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .white24,
                                                                suffixIcon:
                                                                    IconButton(
                                                                  icon: Image
                                                                      .asset(
                                                                    'assets/icons/EmailSend.png',
                                                                    width: 30,
                                                                    height: 30,
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
                                                                          postName: widget
                                                                              .post
                                                                              .name,
                                                                          postLink: widget
                                                                              .post
                                                                              .youtubeLink,
                                                                          postCreator: widget
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
                                                                          commentText: widget
                                                                              .commentController
                                                                              .text,
                                                                          addedTime:
                                                                              DateTime.now());
                                                                      fullScreenController
                                                                          .addCommentToPost(
                                                                              currentCmt);
                                                                      widget
                                                                          .addCommentFunction();
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                )),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
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
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.fill,
                                                                              image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          fullScreenController
                                                                              .post
                                                                              .value
                                                                              .comments![index]
                                                                              .commentText,
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.white),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(fullScreenController.post.value.comments![index].commenter,
                                                                                style: const TextStyle(color: Colors.white54)),
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
                                        padding: const EdgeInsets.only(
                                            top: 40, right: 30),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 13,
                                              child: Icon(
                                                Icons.edit,
                                                size: 10,
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
                                // Delete Button
                                widget.isOwner
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 40),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 10,
                                              ),
                                            ),
                                            onPressed: () {
                                              fullScreenController.deletePost(
                                                  fullScreenController
                                                      .post.value);
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
                                              fontSize: 20,
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
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            indicator: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              border: Border.all(
                                                  color: Colors.white),
                                              color: const Color(mainColor),
                                            ),
                                            labelColor: Colors.black,
                                            unselectedLabelColor: Colors.white,
                                            tabs: [
                                              Tab(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: Icon(Icons.info),
                                                    ),
                                                    Text(
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
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: Icon(
                                                        Icons.comment_outlined,
                                                      ),
                                                    ),
                                                    Text(
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
                                                                    Colors.grey
                                                                        .shade800,
                                                                label: Text(
                                                                    fullScreenController
                                                                            .post
                                                                            .value
                                                                            .tags[
                                                                        index]),
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
                                                          width: 10,
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
                                                          width: 20,
                                                        ),
                                                        const Center(
                                                          child: CircleAvatar(
                                                            radius: 2,
                                                            backgroundColor:
                                                                Colors.white54,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
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
                                                        Center(
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
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
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
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        child: Icon(
                                                          Icons
                                                              .comment_outlined,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: TextField(
                                                        controller: widget
                                                            .commentController,
                                                        onSubmitted: (value) {
                                                          if (value
                                                              .isNotEmpty) {
                                                            Comment currentCmt = Comment(
                                                                postName: widget
                                                                    .post.name,
                                                                postLink: widget
                                                                    .post
                                                                    .youtubeLink,
                                                                postCreator: widget
                                                                    .post
                                                                    .creator,
                                                                postGroup: widget
                                                                    .post
                                                                    .groupName,
                                                                commenter:
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commenterUrl:
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .imageUrl,
                                                                commentText: widget
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
                                                            setState(() {});
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10),
                                                                hintText:
                                                                    'Add a comment...',
                                                                hintStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white54),
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .white24,
                                                                suffixIcon:
                                                                    IconButton(
                                                                  icon: Image
                                                                      .asset(
                                                                    'assets/icons/EmailSend.png',
                                                                    width: 30,
                                                                    height: 30,
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
                                                                          postName: widget
                                                                              .post
                                                                              .name,
                                                                          postLink: widget
                                                                              .post
                                                                              .youtubeLink,
                                                                          postCreator: widget
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
                                                                          commentText: widget
                                                                              .commentController
                                                                              .text,
                                                                          addedTime:
                                                                              DateTime.now());
                                                                      fullScreenController
                                                                          .addCommentToPost(
                                                                              currentCmt);
                                                                      widget
                                                                          .addCommentFunction();
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                )),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
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
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.fill,
                                                                              image: NetworkImage(fullScreenController.post.value.comments![index].commenterUrl)))),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          fullScreenController
                                                                              .post
                                                                              .value
                                                                              .comments![index]
                                                                              .commentText,
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.white),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(fullScreenController.post.value.comments![index].commenter,
                                                                                style: const TextStyle(color: Colors.white54)),
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
                                        padding: const EdgeInsets.only(
                                            top: 40, right: 30),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 13,
                                              child: Icon(
                                                Icons.edit,
                                                size: 10,
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
                                // Delete Button
                                widget.isOwner
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 40),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: const CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 8,
                                              ),
                                            ),
                                            onPressed: () {
                                              fullScreenController.deletePost(
                                                  fullScreenController
                                                      .post.value);
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
