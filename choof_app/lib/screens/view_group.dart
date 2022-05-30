import 'package:choof_app/screens/add_video.dart';
import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/home_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/landing_page_controller.dart';
import '../controllers/view_group_controller.dart';
import '../models/profile.dart';

import '../models/group.dart';
import '../models/post.dart';
import '../utils/app_constant.dart';
import 'edit_group_page.dart';
import 'friends_page.dart';
import 'full_screen_page.dart';

class ViewGroup extends StatefulWidget {
  final int index;
  final Group currentGroup;
  final bool isFromGroup;
  const ViewGroup(
      {Key? key,
      required this.index,
      required this.currentGroup,
      required this.isFromGroup})
      : super(key: key);

  @override
  State<ViewGroup> createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  final viewGroupController = Get.put(ViewGroupController());
  final landingPagecontroller = Get.find<LandingPageController>();

  final tagName = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    landingPagecontroller.getAllUsers(widget.currentGroup);
    viewGroupController.getAllPost(widget.currentGroup);
    super.initState();
  }

  @override
  void dispose() {
    viewGroupController.disposeControllerList();
    super.dispose();
  }

  Future<void> _pullRefresh() async {
    viewGroupController.refreshPosts(widget.currentGroup);
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(60, 60),
        child: Obx(() => widget.index == landingPagecontroller.tabIndex.value
            ? AppBar(
                backgroundColor: const Color(bgColor),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    if (widget.isFromGroup) {
                      landingPagecontroller.changeTabIndex(1);
                      Get.offAll(() => const HomePage());
                    } else {
                      landingPagecontroller.changeTabIndex(0);
                      Get.offAll(() => const HomePage());
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Row(
                  children: [
                    Obx(
                      () => Expanded(
                        child: Text(
                          viewGroupController.groupName.value.isEmpty
                              ? widget.currentGroup.name.contains('#')
                                  ? widget.currentGroup.name.substring(
                                      0, widget.currentGroup.name.indexOf('#'))
                                  : widget.currentGroup.name
                              : viewGroupController.groupName.value
                                      .contains('#')
                                  ? viewGroupController.groupName.value
                                      .substring(
                                          0,
                                          viewGroupController.groupName.value
                                              .indexOf('#'))
                                  : viewGroupController.groupName.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    landingPagecontroller.userProfile.value.name ==
                            widget.currentGroup.owner
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  viewGroupController
                                      .deleteGroup(widget.currentGroup);
                                },
                                child: const Align(
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white70,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => EditGroupPage(
                                              currentGroup: widget.currentGroup,
                                            ))!
                                        .then((value) => _pullRefresh());
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ))
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                actions: [
                  // Only owner can add video to group
                  landingPagecontroller.userProfile.value.name ==
                          widget.currentGroup.owner
                      ? IconButton(
                          onPressed: () {
                            Get.to(() => AddVideoPage(
                                      index: 1,
                                      group: widget.currentGroup,
                                      isFromFavPage: !widget.isFromGroup,
                                      isFromViewGroup: true,
                                    ))!
                                .then((value) => _pullRefresh());
                          },
                          icon: Image.asset(
                            'assets/icons/FavAdd.png',
                            width: 60,
                            height: 60,
                          ))
                      : const SizedBox.shrink(),
                ],
                elevation: 0.0,
              )
            : Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(mainBgColor),
              )),
      ),
      bottomNavigationBar: BottomMenu(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _pullRefresh,
            enablePullUp: true,
            enablePullDown: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("release to load more");
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
              if (viewGroupController.allpost.length -
                      viewGroupController.postLimit.value >
                  0) {
                if (viewGroupController.allpost.length -
                        viewGroupController.postLimit.value <=
                    15) {
                  viewGroupController
                      .setPostLimit(viewGroupController.allpost.length);
                } else {
                  viewGroupController.addPostLimit();
                }
                _refreshController.loadComplete();
              } else {
                viewGroupController
                    .setPostLimit(viewGroupController.allpost.length);
                _refreshController.loadNoData();
              }
            },
            child: Obx(() {
              return IndexedStack(
                index: landingPagecontroller.tabIndex.value,
                children: [
                  widget.isFromGroup
                      ? const FavouritePage()
                      : ListView(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // Friends area
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(widget
                                                    .currentGroup
                                                    .ownerImageUrl)))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'By',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.currentGroup.owner,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (landingPagecontroller
                                          .groupedUsers.isEmpty) {
                                        return const SizedBox.shrink();
                                      } else if (landingPagecontroller
                                              .groupedUsers.length ==
                                          1) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => FriendsPage(
                                                group: widget.currentGroup));
                                          },
                                          child: const Text(
                                            'Add Friends',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      } else if (landingPagecontroller
                                          .groupedUsers.isNotEmpty) {
                                        List<Profile> groupMembers = [];
                                        for (var member in landingPagecontroller
                                            .groupedUsers) {
                                          if (member.name !=
                                              widget.currentGroup.owner) {
                                            groupMembers.add(member);
                                          }
                                        }
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => FriendsPage(
                                                group: widget.currentGroup));
                                          },
                                          child: Container(
                                            width: (35 * 3.5).toDouble(),
                                            height: 40,
                                            child: Stack(
                                                children: List.generate(
                                                    groupMembers.length > 5
                                                        ? 5
                                                        : groupMembers.length,
                                                    (index) {
                                              return Positioned(
                                                  left: index * 20,
                                                  child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  groupMembers[
                                                                          index]
                                                                      .imageUrl)))));
                                            }, growable: true)),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                    // Show +7
                                    Obx(() {
                                      if (landingPagecontroller
                                          .groupedUsers.isNotEmpty) {
                                        List<Profile> groupMembers = [];
                                        for (var member in landingPagecontroller
                                            .groupedUsers) {
                                          if (member.name !=
                                              widget.currentGroup.owner) {
                                            groupMembers.add(member);
                                          }
                                        }
                                        return groupMembers.length > 5
                                            ? Text(
                                                '+${groupMembers.length - 5}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const SizedBox.shrink();
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                    // Firends Area Button
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => FriendsPage(
                                            group: widget.currentGroup));
                                      },
                                      child: Image.asset(
                                        'assets/icons/BackTo.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            // Filter tag
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    child: InputDecorator(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          filled: true,
                                          fillColor: Colors.white70,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Autocomplete<String>(
                                              displayStringForOption: (c) =>
                                                  c.toString(),
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                if (textEditingValue.text ==
                                                    '') {
                                                  return const Iterable<
                                                      String>.empty();
                                                }
                                                return viewGroupController
                                                    .allTags
                                                    .where((String option) {
                                                  return option
                                                      .trim()
                                                      .toLowerCase()
                                                      .contains(textEditingValue
                                                          .text
                                                          .trim()
                                                          .toLowerCase());
                                                });
                                              },
                                              onSelected: (String selection) {
                                                viewGroupController
                                                    .addTags(selection);
                                                tagName.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                            ),
                                            const Text(
                                              'Filter by tag',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // Show Filtered tags
                                  Obx(
                                    () => viewGroupController
                                            .filteredTags.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: viewGroupController
                                                .filteredTags.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade800,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20),
                                                      child: Text(
                                                        viewGroupController
                                                                .filteredTags[
                                                            index],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        viewGroupController.removeTag(
                                                            viewGroupController
                                                                    .filteredTags[
                                                                index]);
                                                      },
                                                      child: const Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.white70,
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
                                                              size: 8,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              );
                                            })
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),

                            // Sorting Container
                            Obx(() => viewGroupController.sortByRecent.value
                                ? InkWell(
                                    onTap: () {
                                      viewGroupController.sort(false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/UpDownArrow.png',
                                            width: 20,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
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
                                      viewGroupController.sort(true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        children: const [
                                          FaIcon(
                                            FontAwesomeIcons.arrowUpAZ,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Alphabetical',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),

                            ///
                            const Divider(
                              color: Colors.white,
                              height: 2,
                            ),

                            // Video Widget
                            Obx(() => !viewGroupController.loaded.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : !viewGroupController.isFilter.value
                                    ?
                                    // No filter
                                    viewGroupController.posts.isEmpty
                                        ? widget.currentGroup.owner ==
                                                landingPagecontroller
                                                    .userProfile.value.name
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                  ),
                                                  const Text(
                                                    'Add a favorite',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => AddVideoPage(
                                                                index: 1,
                                                                group: widget
                                                                    .currentGroup,
                                                                isFromFavPage:
                                                                    !widget
                                                                        .isFromGroup,
                                                                isFromViewGroup:
                                                                    true,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: Image.asset(
                                                      'assets/icons/FavAdd.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'and some friends.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Center(
                                                    child: Text(
                                                      'No Post Here',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: viewGroupController
                                                .posts.length,
                                            itemBuilder: (context, index) {
                                              List<Post> currentPosts =
                                                  viewGroupController.posts;

                                              YoutubePlayerController
                                                  _controller =
                                                  YoutubePlayerController(
                                                initialVideoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        currentPosts[index]
                                                            .youtubeLink)!,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              );
                                              viewGroupController
                                                  .addToControllerList(
                                                      _controller);

                                              return landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .name ==
                                                      widget.currentGroup.owner
                                                  ? Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index]));
                                                          },
                                                          child: VideoWidget(
                                                            post: currentPosts[
                                                                index],
                                                            user:
                                                                landingPagecontroller
                                                                    .userProfile
                                                                    .value,
                                                            thumbnailUrl: YoutubePlayer.getThumbnail(
                                                                videoId: YoutubePlayer.convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                            viewGroupFunc: () {
                                                              loadingDialog();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "groups")
                                                                  .where('name',
                                                                      isEqualTo:
                                                                          currentPosts[index]
                                                                              .groupName)
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                Get.back();
                                                                if (value.docs
                                                                    .isNotEmpty) {
                                                                  Get.to(() =>
                                                                      ViewGroup(
                                                                        index: widget
                                                                            .index,
                                                                        currentGroup: Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                        isFromGroup:
                                                                            true,
                                                                      ));
                                                                }
                                                              });
                                                            },
                                                            isInsideGroup: true,
                                                            reportFunction: () {
                                                              _pullRefresh();
                                                            },
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            viewGroupController
                                                                .deletePost(
                                                                    widget
                                                                        .currentGroup,
                                                                    currentPosts[
                                                                        index]);
                                                          },
                                                          child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white70,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 8,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index]));
                                                      },
                                                      child: VideoWidget(
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl: YoutubePlayer.getThumbnail(
                                                            videoId: YoutubePlayer
                                                                .convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                        viewGroupFunc: () {
                                                          loadingDialog();
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "groups")
                                                              .where('name',
                                                                  isEqualTo: currentPosts[
                                                                          index]
                                                                      .groupName)
                                                              .get()
                                                              .then((value) {
                                                            Get.back();
                                                            if (value.docs
                                                                .isNotEmpty) {
                                                              Get.to(() =>
                                                                  ViewGroup(
                                                                    index: widget
                                                                        .index,
                                                                    currentGroup:
                                                                        Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                    isFromGroup:
                                                                        true,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                      ),
                                                    );
                                            })
                                    // Filtered
                                    : viewGroupController
                                            .filteredTagResult.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'No Result Found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: viewGroupController
                                                .filteredTagResult.length,
                                            itemBuilder: (context, index) {
                                              List<Post> currentPosts =
                                                  viewGroupController
                                                      .filteredTagResult;

                                              YoutubePlayerController
                                                  _controller =
                                                  YoutubePlayerController(
                                                initialVideoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        currentPosts[index]
                                                            .youtubeLink)!,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              );
                                              viewGroupController
                                                  .addToControllerList(
                                                      _controller);

                                              return landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .name ==
                                                      widget.currentGroup.owner
                                                  ? Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index]));
                                                          },
                                                          child: VideoWidget(
                                                            post: currentPosts[
                                                                index],
                                                            user:
                                                                landingPagecontroller
                                                                    .userProfile
                                                                    .value,
                                                            thumbnailUrl: YoutubePlayer.getThumbnail(
                                                                videoId: YoutubePlayer.convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                            viewGroupFunc: () {
                                                              loadingDialog();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "groups")
                                                                  .where('name',
                                                                      isEqualTo:
                                                                          currentPosts[index]
                                                                              .groupName)
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                Get.back();
                                                                if (value.docs
                                                                    .isNotEmpty) {
                                                                  Get.to(() =>
                                                                      ViewGroup(
                                                                        index: widget
                                                                            .index,
                                                                        currentGroup: Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                        isFromGroup:
                                                                            true,
                                                                      ));
                                                                }
                                                              });
                                                            },
                                                            isInsideGroup: true,
                                                            reportFunction: () {
                                                              _pullRefresh();
                                                            },
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            viewGroupController
                                                                .deletePost(
                                                                    widget
                                                                        .currentGroup,
                                                                    currentPosts[
                                                                        index]);
                                                          },
                                                          child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white70,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 8,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index]));
                                                      },
                                                      child: VideoWidget(
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl: YoutubePlayer.getThumbnail(
                                                            videoId: YoutubePlayer
                                                                .convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                        viewGroupFunc: () {
                                                          loadingDialog();
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "groups")
                                                              .where('name',
                                                                  isEqualTo: currentPosts[
                                                                          index]
                                                                      .groupName)
                                                              .get()
                                                              .then((value) {
                                                            Get.back();
                                                            if (value.docs
                                                                .isNotEmpty) {
                                                              Get.to(() =>
                                                                  ViewGroup(
                                                                    index: widget
                                                                        .index,
                                                                    currentGroup:
                                                                        Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                    isFromGroup:
                                                                        true,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                      ),
                                                    );
                                            })),
                          ],
                        ),
                  widget.isFromGroup
                      ? ListView(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // Friends area
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(widget
                                                    .currentGroup
                                                    .ownerImageUrl)))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'By',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.currentGroup.owner,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (landingPagecontroller
                                          .groupedUsers.isEmpty) {
                                        return const SizedBox.shrink();
                                      } else if (landingPagecontroller
                                              .groupedUsers.length ==
                                          1) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => FriendsPage(
                                                group: widget.currentGroup));
                                          },
                                          child: const Text(
                                            'Add Friends',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      } else if (landingPagecontroller
                                          .groupedUsers.isNotEmpty) {
                                        List<Profile> groupMembers = [];
                                        for (var member in landingPagecontroller
                                            .groupedUsers) {
                                          if (member.name !=
                                              widget.currentGroup.owner) {
                                            groupMembers.add(member);
                                          }
                                        }
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => FriendsPage(
                                                group: widget.currentGroup));
                                          },
                                          child: Container(
                                            width: (35 * 3.5).toDouble(),
                                            height: 40,
                                            child: Stack(
                                                children: List.generate(
                                                    groupMembers.length > 5
                                                        ? 5
                                                        : groupMembers.length,
                                                    (index) {
                                              return Positioned(
                                                  left: index * 20,
                                                  child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  groupMembers[
                                                                          index]
                                                                      .imageUrl)))));
                                            }, growable: true)),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                    // Show +7
                                    Obx(() {
                                      if (landingPagecontroller
                                          .groupedUsers.isNotEmpty) {
                                        List<Profile> groupMembers = [];
                                        for (var member in landingPagecontroller
                                            .groupedUsers) {
                                          if (member.name !=
                                              widget.currentGroup.owner) {
                                            groupMembers.add(member);
                                          }
                                        }
                                        return groupMembers.length > 5
                                            ? Text(
                                                '+${groupMembers.length - 5}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const SizedBox.shrink();
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                                    // Firends Area Button
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => FriendsPage(
                                            group: widget.currentGroup));
                                      },
                                      child: Image.asset(
                                        'assets/icons/BackTo.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            // Filter tag
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    child: InputDecorator(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          filled: true,
                                          fillColor: Colors.white70,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Autocomplete<String>(
                                              displayStringForOption: (c) =>
                                                  c.toString(),
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                if (textEditingValue.text ==
                                                    '') {
                                                  return const Iterable<
                                                      String>.empty();
                                                }
                                                return viewGroupController
                                                    .allTags
                                                    .where((String option) {
                                                  return option
                                                      .trim()
                                                      .toLowerCase()
                                                      .contains(textEditingValue
                                                          .text
                                                          .trim()
                                                          .toLowerCase());
                                                });
                                              },
                                              onSelected: (String selection) {
                                                viewGroupController
                                                    .addTags(selection);
                                                tagName.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                            ),
                                            const Text(
                                              'Filter by tag',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // Show Filtered tags
                                  Obx(
                                    () => viewGroupController
                                            .filteredTags.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: viewGroupController
                                                .filteredTags.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade800,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20),
                                                      child: Text(
                                                        viewGroupController
                                                                .filteredTags[
                                                            index],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        viewGroupController.removeTag(
                                                            viewGroupController
                                                                    .filteredTags[
                                                                index]);
                                                      },
                                                      child: const Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.white70,
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
                                                              size: 8,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              );
                                            })
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),

                            // Sorting Container
                            Obx(() => viewGroupController.sortByRecent.value
                                ? InkWell(
                                    onTap: () {
                                      viewGroupController.sort(false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/UpDownArrow.png',
                                            width: 20,
                                            height: 15,
                                          ),
                                          const SizedBox(
                                            width: 10,
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
                                      viewGroupController.sort(true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 50,
                                      child: Row(
                                        children: const [
                                          FaIcon(
                                            FontAwesomeIcons.arrowUpAZ,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Alphabetical',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),

                            ///
                            const Divider(
                              color: Colors.white,
                              height: 2,
                            ),

                            // Video Widget
                            Obx(() => !viewGroupController.loaded.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : !viewGroupController.isFilter.value
                                    ?
                                    // No filter
                                    viewGroupController.posts.isEmpty
                                        ? widget.currentGroup.owner ==
                                                landingPagecontroller
                                                    .userProfile.value.name
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                  ),
                                                  const Text(
                                                    'Add a favorite',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => AddVideoPage(
                                                                index: 1,
                                                                group: widget
                                                                    .currentGroup,
                                                                isFromFavPage:
                                                                    !widget
                                                                        .isFromGroup,
                                                                isFromViewGroup:
                                                                    true,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: Image.asset(
                                                      'assets/icons/FavAdd.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'and some friends.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Center(
                                                    child: Text(
                                                      'No Post Here',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: viewGroupController
                                                .posts.length,
                                            itemBuilder: (context, index) {
                                              List<Post> currentPosts =
                                                  viewGroupController.posts;

                                              YoutubePlayerController
                                                  _controller =
                                                  YoutubePlayerController(
                                                initialVideoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        currentPosts[index]
                                                            .youtubeLink)!,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              );
                                              viewGroupController
                                                  .addToControllerList(
                                                      _controller);

                                              return landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .name ==
                                                      widget.currentGroup.owner
                                                  ? Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index]));
                                                          },
                                                          child: VideoWidget(
                                                            post: currentPosts[
                                                                index],
                                                            user:
                                                                landingPagecontroller
                                                                    .userProfile
                                                                    .value,
                                                            thumbnailUrl: YoutubePlayer.getThumbnail(
                                                                videoId: YoutubePlayer.convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                            viewGroupFunc: () {
                                                              loadingDialog();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "groups")
                                                                  .where('name',
                                                                      isEqualTo:
                                                                          currentPosts[index]
                                                                              .groupName)
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                Get.back();
                                                                if (value.docs
                                                                    .isNotEmpty) {
                                                                  Get.to(() =>
                                                                      ViewGroup(
                                                                        index: widget
                                                                            .index,
                                                                        currentGroup: Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                        isFromGroup:
                                                                            true,
                                                                      ));
                                                                }
                                                              });
                                                            },
                                                            isInsideGroup: true,
                                                            reportFunction: () {
                                                              _pullRefresh();
                                                            },
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            viewGroupController
                                                                .deletePost(
                                                                    widget
                                                                        .currentGroup,
                                                                    currentPosts[
                                                                        index]);
                                                          },
                                                          child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white70,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 8,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index]));
                                                      },
                                                      child: VideoWidget(
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl: YoutubePlayer.getThumbnail(
                                                            videoId: YoutubePlayer
                                                                .convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                        viewGroupFunc: () {
                                                          loadingDialog();
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "groups")
                                                              .where('name',
                                                                  isEqualTo: currentPosts[
                                                                          index]
                                                                      .groupName)
                                                              .get()
                                                              .then((value) {
                                                            Get.back();
                                                            if (value.docs
                                                                .isNotEmpty) {
                                                              Get.to(() =>
                                                                  ViewGroup(
                                                                    index: widget
                                                                        .index,
                                                                    currentGroup:
                                                                        Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                    isFromGroup:
                                                                        true,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                      ),
                                                    );
                                            })
                                    // Filtered
                                    : viewGroupController
                                            .filteredTagResult.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'No Result Found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: viewGroupController
                                                .filteredTagResult.length,
                                            itemBuilder: (context, index) {
                                              List<Post> currentPosts =
                                                  viewGroupController
                                                      .filteredTagResult;

                                              YoutubePlayerController
                                                  _controller =
                                                  YoutubePlayerController(
                                                initialVideoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        currentPosts[index]
                                                            .youtubeLink)!,
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              );
                                              viewGroupController
                                                  .addToControllerList(
                                                      _controller);

                                              return landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .name ==
                                                      widget.currentGroup.owner
                                                  ? Stack(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index]));
                                                          },
                                                          child: VideoWidget(
                                                            post: currentPosts[
                                                                index],
                                                            user:
                                                                landingPagecontroller
                                                                    .userProfile
                                                                    .value,
                                                            thumbnailUrl: YoutubePlayer.getThumbnail(
                                                                videoId: YoutubePlayer.convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                            viewGroupFunc: () {
                                                              loadingDialog();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "groups")
                                                                  .where('name',
                                                                      isEqualTo:
                                                                          currentPosts[index]
                                                                              .groupName)
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                Get.back();
                                                                if (value.docs
                                                                    .isNotEmpty) {
                                                                  Get.to(() =>
                                                                      ViewGroup(
                                                                        index: widget
                                                                            .index,
                                                                        currentGroup: Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                        isFromGroup:
                                                                            true,
                                                                      ));
                                                                }
                                                              });
                                                            },
                                                            isInsideGroup: true,
                                                            reportFunction: () {
                                                              _pullRefresh();
                                                            },
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            viewGroupController
                                                                .deletePost(
                                                                    widget
                                                                        .currentGroup,
                                                                    currentPosts[
                                                                        index]);
                                                          },
                                                          child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white70,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 8,
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index]));
                                                      },
                                                      child: VideoWidget(
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl: YoutubePlayer.getThumbnail(
                                                            videoId: YoutubePlayer
                                                                .convertUrlToId(
                                                                    currentPosts[
                                                                            index]
                                                                        .youtubeLink)!),
                                                        viewGroupFunc: () {
                                                          loadingDialog();
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "groups")
                                                              .where('name',
                                                                  isEqualTo: currentPosts[
                                                                          index]
                                                                      .groupName)
                                                              .get()
                                                              .then((value) {
                                                            Get.back();
                                                            if (value.docs
                                                                .isNotEmpty) {
                                                              Get.to(() =>
                                                                  ViewGroup(
                                                                    index: widget
                                                                        .index,
                                                                    currentGroup:
                                                                        Group.fromJson(value
                                                                            .docs
                                                                            .first
                                                                            .data()),
                                                                    isFromGroup:
                                                                        true,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                      ),
                                                    );
                                            })),
                          ],
                        )
                      : const YourGroupsPage(),
                  SettingsPage()
                ],
              );
            })),
      ),
    );
  }
}
