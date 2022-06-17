import 'package:choof_app/screens/add_video.dart';
import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/home_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/landing_page_controller.dart';
import '../controllers/view_group_controller.dart';
import '../models/comment.dart';
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
  final bool isFromFullScreenPage;
  const ViewGroup(
      {Key? key,
      required this.index,
      required this.currentGroup,
      required this.isFromGroup,
      required this.isFromFullScreenPage})
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
    viewGroupController.setGroupName(widget.currentGroup.name);
    super.initState();
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
          child: Obx(() => landingPagecontroller.isDeviceTablet.value
              ? AppBar(
                  backgroundColor: const Color(bgColor),
                  leadingWidth: MediaQuery.of(context).size.width / 4.5,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/logos/logo.png',
                    ),
                  ),
                  titleSpacing: 0.0,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 4, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: IconButton(
                            icon: Row(
                              children: [
                                Text(
                                  'Favorites',
                                  style: TextStyle(
                                      color: landingPagecontroller
                                                  .tabIndex.value ==
                                              0
                                          ? const Color(mainColor)
                                          : Colors.white),
                                ),
                                Image.asset(
                                  'assets/icons/Favorite.png',
                                  width: 50,
                                  height: 50,
                                  color:
                                      landingPagecontroller.tabIndex.value == 0
                                          ? const Color(mainColor)
                                          : Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              landingPagecontroller.changeTabIndex(0);
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: IconButton(
                            icon: Row(
                              children: [
                                Text(
                                  'Groups',
                                  style: TextStyle(
                                      color: landingPagecontroller
                                                  .tabIndex.value ==
                                              1
                                          ? const Color(mainColor)
                                          : Colors.white),
                                ),
                                Image.asset(
                                  'assets/icons/Users.png',
                                  width: 50,
                                  height: 50,
                                  color:
                                      landingPagecontroller.tabIndex.value == 1
                                          ? const Color(mainColor)
                                          : Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              landingPagecontroller.changeTabIndex(1);
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          child: IconButton(
                            icon: Row(
                              children: [
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: landingPagecontroller
                                                  .tabIndex.value ==
                                              2
                                          ? const Color(mainColor)
                                          : Colors.white),
                                ),
                                Image.asset(
                                  'assets/icons/Settings.png',
                                  width: 50,
                                  height: 50,
                                  color:
                                      landingPagecontroller.tabIndex.value == 2
                                          ? const Color(mainColor)
                                          : Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              landingPagecontroller.changeTabIndex(2);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : widget.index == landingPagecontroller.tabIndex.value
                  ? AppBar(
                      backgroundColor: const Color(bgColor),
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (widget.isFromGroup) {
                            landingPagecontroller.changeTabIndex(1);
                            if (widget.isFromFullScreenPage) {
                              Get.to(() => const HomePage());
                            } else {
                              Get.back();
                              Get.back();
                            }
                          } else {
                            landingPagecontroller.changeTabIndex(0);
                            if (widget.isFromFullScreenPage) {
                              Get.to(() => const HomePage());
                            } else {
                              Get.back();
                              Get.back();
                            }
                          }
                        },
                      ),
                      title: Row(
                        children: [
                          Obx(
                            () => Text(
                              viewGroupController.groupName.value.contains('#')
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
                          landingPagecontroller.userProfile.value.name ==
                                  widget.currentGroup.owner
                              ? Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (widget.isFromGroup) {
                                            Get.to(() => EditGroupPage(
                                                      currentGroup:
                                                          widget.currentGroup,
                                                      index: 1,
                                                    ))!
                                                .then(
                                                    (value) => _pullRefresh());
                                          } else {
                                            Get.to(() => EditGroupPage(
                                                      currentGroup:
                                                          widget.currentGroup,
                                                      index: 0,
                                                    ))!
                                                .then(
                                                    (value) => _pullRefresh());
                                          }
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
                                            index: widget.isFromGroup ? 1 : 0,
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
                    ))),
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
        child: Obx(() {
          return IndexedStack(
            index: landingPagecontroller.tabIndex.value,
            children: [
              widget.isFromGroup
                  ? const FavouritePage(isFirstTime: false)
                  : RefresherWidget(
                      controller: _refreshController,
                      pullrefreshFunction: _pullRefresh,
                      onLoadingFunction: () {
                        if (viewGroupController.allpost.length -
                                viewGroupController.postLimit.value >
                            0) {
                          if (viewGroupController.allpost.length -
                                  viewGroupController.postLimit.value <=
                              15) {
                            viewGroupController.setPostLimit(
                                viewGroupController.allpost.length);
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
                      child: ListView(
                        children: [
                          // Title
                          Obx(
                            () => landingPagecontroller.isDeviceTablet.value
                                ? Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (widget.isFromGroup) {
                                            landingPagecontroller
                                                .changeTabIndex(1);
                                            Get.back();
                                            Get.back();
                                          } else {
                                            landingPagecontroller
                                                .changeTabIndex(0);
                                            Get.back();
                                            Get.back();
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                viewGroupController
                                                        .groupName.value
                                                        .contains('#')
                                                    ? viewGroupController
                                                        .groupName.value
                                                        .substring(
                                                            0,
                                                            viewGroupController
                                                                .groupName.value
                                                                .indexOf('#'))
                                                    : viewGroupController
                                                        .groupName.value,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            landingPagecontroller.userProfile
                                                        .value.name ==
                                                    widget.currentGroup.owner
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            if (widget
                                                                .isFromGroup) {
                                                              Get.to(() =>
                                                                      EditGroupPage(
                                                                        currentGroup:
                                                                            widget.currentGroup,
                                                                        index:
                                                                            1,
                                                                      ))!
                                                                  .then((value) =>
                                                                      _pullRefresh());
                                                            } else {
                                                              Get.to(() =>
                                                                      EditGroupPage(
                                                                        currentGroup:
                                                                            widget.currentGroup,
                                                                        index:
                                                                            0,
                                                                      ))!
                                                                  .then((value) =>
                                                                      _pullRefresh());
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ))
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      // Only owner can add video to group
                                      landingPagecontroller
                                                  .userProfile.value.name ==
                                              widget.currentGroup.owner
                                          ? IconButton(
                                              onPressed: () {
                                                Get.to(() => AddVideoPage(
                                                          index:
                                                              widget.isFromGroup
                                                                  ? 1
                                                                  : 0,
                                                          group: widget
                                                              .currentGroup,
                                                          isFromFavPage: !widget
                                                              .isFromGroup,
                                                          isFromViewGroup: true,
                                                        ))!
                                                    .then((value) =>
                                                        _pullRefresh());
                                              },
                                              icon: Image.asset(
                                                'assets/icons/FavAdd.png',
                                                width: 60,
                                                height: 60,
                                              ))
                                          : const SizedBox.shrink(),
                                    ],
                                  )
                                : const SizedBox.shrink(),
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
                                    width: 5,
                                  ),
                                  const Text(
                                    'By',
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.currentGroup.owner,
                                    overflow: TextOverflow.ellipsis,
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
                                          style: TextStyle(color: Colors.white),
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
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.grey,
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
                                Obx(
                                  () => viewGroupController
                                              .filteredTags.isNotEmpty &&
                                          viewGroupController.isFilterOn.value
                                      ? IconButton(
                                          onPressed: () {
                                            viewGroupController.setFilterOn();
                                          },
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.search,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    50,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ))
                                      : Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.8,
                                          child: InputDecorator(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                prefixIcon: InkWell(
                                                  onTap: () {
                                                    viewGroupController
                                                        .setFilterOn();
                                                  },
                                                  child: const Icon(
                                                    Icons.search,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Autocomplete<String>(
                                                    displayStringForOption:
                                                        (c) => c.toString(),
                                                    optionsBuilder:
                                                        (TextEditingValue
                                                            textEditingValue) {
                                                      if (textEditingValue
                                                              .text ==
                                                          '') {
                                                        return const Iterable<
                                                            String>.empty();
                                                      }
                                                      return viewGroupController
                                                          .allTags
                                                          .where(
                                                              (String option) {
                                                        return option
                                                            .trim()
                                                            .toLowerCase()
                                                            .contains(
                                                                textEditingValue
                                                                    .text
                                                                    .trim()
                                                                    .toLowerCase());
                                                      });
                                                    },
                                                    onSelected:
                                                        (String selection) {
                                                      viewGroupController
                                                          .addTags(selection);
                                                      tagName.clear();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                  ),
                                                  const Text(
                                                    'Filter by tag',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                        ),
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
                                                      horizontal: 5,
                                                      vertical: 10),
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
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                    child: Text(
                                                      viewGroupController
                                                          .filteredTags[index],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                            color: Colors.black,
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
                                          style: TextStyle(color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
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
                              ? const Center(child: CircularProgressIndicator())
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                ),
                                                const Text(
                                                  'Your group is empty...',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Add a favorite',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(() => AddVideoPage(
                                                              index: widget
                                                                      .isFromGroup
                                                                  ? 1
                                                                  : 0,
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
                                          itemCount:
                                              viewGroupController.posts.length,
                                          itemBuilder: (context, index) {
                                            List<Post> currentPosts =
                                                viewGroupController.posts;

                                            YoutubePlayerController
                                                _controller =
                                                YoutubePlayerController(
                                              initialVideoId:
                                                  YoutubePlayer.convertUrlToId(
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
                                            TextEditingController
                                                commentController =
                                                TextEditingController();

                                            return landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .name ==
                                                    widget.currentGroup.owner
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                      post: currentPosts[index],
                                                      user:
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value,
                                                      thumbnailUrl:
                                                          "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                      viewGroupFunc: () {
                                                        loadingDialog();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "groups")
                                                            .where('name',
                                                                isEqualTo:
                                                                    currentPosts[
                                                                            index]
                                                                        .groupName)
                                                            .get()
                                                            .then((value) {
                                                          Get.back();
                                                          if (value.docs
                                                              .isNotEmpty) {
                                                            Get.to(
                                                                () => ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          true,
                                                                      isFromFullScreenPage:
                                                                          false,
                                                                    ));
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: true,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[index]
                                                                .name,
                                                            postLink:
                                                                currentPosts[index]
                                                                    .youtubeLink,
                                                            postCreator:
                                                                currentPosts[index]
                                                                    .creator,
                                                            postGroup:
                                                                currentPosts[index]
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
                                                            commentText:
                                                                commentController
                                                                    .text,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
                                                        _pullRefresh();
                                                      },
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 1,
                                                                  post:
                                                                      currentPosts[
                                                                          index],
                                                                  isOwner: currentPosts[
                                                                              index]
                                                                          .creator ==
                                                                      landingPagecontroller
                                                                          .userProfile
                                                                          .value
                                                                          .name,
                                                                  commentController:
                                                                      commentController,
                                                                  addCommentFunction:
                                                                      () {
                                                                    viewGroupController.addComment(Comment(
                                                                        postName:
                                                                            currentPosts[index]
                                                                                .name,
                                                                        postLink:
                                                                            currentPosts[index]
                                                                                .youtubeLink,
                                                                        postCreator:
                                                                            currentPosts[index]
                                                                                .creator,
                                                                        postGroup:
                                                                            currentPosts[index]
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
                                                                            commentController
                                                                                .text,
                                                                        addedTime:
                                                                            DateTime.now()));
                                                                    commentController
                                                                        .clear();
                                                                  },
                                                                  isViewComment:
                                                                      true,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 1,
                                                                  post:
                                                                      currentPosts[
                                                                          index],
                                                                  isOwner: currentPosts[
                                                                              index]
                                                                          .creator ==
                                                                      landingPagecontroller
                                                                          .userProfile
                                                                          .value
                                                                          .name,
                                                                  commentController:
                                                                      commentController,
                                                                  addCommentFunction:
                                                                      () {
                                                                    viewGroupController.addComment(Comment(
                                                                        postName:
                                                                            currentPosts[index]
                                                                                .name,
                                                                        postLink:
                                                                            currentPosts[index]
                                                                                .youtubeLink,
                                                                        postCreator:
                                                                            currentPosts[index]
                                                                                .creator,
                                                                        postGroup:
                                                                            currentPosts[index]
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
                                                                            commentController
                                                                                .text,
                                                                        addedTime:
                                                                            DateTime.now()));
                                                                    commentController
                                                                        .clear();
                                                                  },
                                                                  isViewComment:
                                                                      true,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                      post: currentPosts[index],
                                                      user:
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value,
                                                      thumbnailUrl:
                                                          "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                      viewGroupFunc: () {
                                                        loadingDialog();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "groups")
                                                            .where('name',
                                                                isEqualTo:
                                                                    currentPosts[
                                                                            index]
                                                                        .groupName)
                                                            .get()
                                                            .then((value) {
                                                          Get.back();
                                                          if (value.docs
                                                              .isNotEmpty) {
                                                            Get.to(
                                                                () => ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          true,
                                                                      isFromFullScreenPage:
                                                                          false,
                                                                    ));
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: true,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[index]
                                                                .name,
                                                            postLink:
                                                                currentPosts[index]
                                                                    .youtubeLink,
                                                            postCreator:
                                                                currentPosts[index]
                                                                    .creator,
                                                            postGroup:
                                                                currentPosts[index]
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
                                                            commentText:
                                                                commentController
                                                                    .text,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                              initialVideoId:
                                                  YoutubePlayer.convertUrlToId(
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
                                            TextEditingController
                                                commentController =
                                                TextEditingController();

                                            return landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .name ==
                                                    widget.currentGroup.owner
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 1,
                                                                  post:
                                                                      currentPosts[
                                                                          index],
                                                                  isOwner: currentPosts[
                                                                              index]
                                                                          .creator ==
                                                                      landingPagecontroller
                                                                          .userProfile
                                                                          .value
                                                                          .name,
                                                                  commentController:
                                                                      commentController,
                                                                  addCommentFunction:
                                                                      () {
                                                                    viewGroupController.addComment(Comment(
                                                                        postName:
                                                                            currentPosts[index]
                                                                                .name,
                                                                        postLink:
                                                                            currentPosts[index]
                                                                                .youtubeLink,
                                                                        postCreator:
                                                                            currentPosts[index]
                                                                                .creator,
                                                                        postGroup:
                                                                            currentPosts[index]
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
                                                                            commentController
                                                                                .text,
                                                                        addedTime:
                                                                            DateTime.now()));
                                                                    commentController
                                                                        .clear();
                                                                  },
                                                                  isViewComment:
                                                                      true,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                      post: currentPosts[index],
                                                      user:
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value,
                                                      thumbnailUrl:
                                                          "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                      viewGroupFunc: () {
                                                        loadingDialog();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "groups")
                                                            .where('name',
                                                                isEqualTo:
                                                                    currentPosts[
                                                                            index]
                                                                        .groupName)
                                                            .get()
                                                            .then((value) {
                                                          Get.back();
                                                          if (value.docs
                                                              .isNotEmpty) {
                                                            Get.to(
                                                                () => ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          true,
                                                                      isFromFullScreenPage:
                                                                          false,
                                                                    ));
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: true,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[index]
                                                                .name,
                                                            postLink:
                                                                currentPosts[index]
                                                                    .youtubeLink,
                                                            postCreator:
                                                                currentPosts[index]
                                                                    .creator,
                                                            postGroup:
                                                                currentPosts[index]
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
                                                            commentText:
                                                                commentController
                                                                    .text,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
                                                        _pullRefresh();
                                                      },
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 1,
                                                                  post:
                                                                      currentPosts[
                                                                          index],
                                                                  isOwner: currentPosts[
                                                                              index]
                                                                          .creator ==
                                                                      landingPagecontroller
                                                                          .userProfile
                                                                          .value
                                                                          .name,
                                                                  commentController:
                                                                      commentController,
                                                                  addCommentFunction:
                                                                      () {
                                                                    viewGroupController.addComment(Comment(
                                                                        postName:
                                                                            currentPosts[index]
                                                                                .name,
                                                                        postLink:
                                                                            currentPosts[index]
                                                                                .youtubeLink,
                                                                        postCreator:
                                                                            currentPosts[index]
                                                                                .creator,
                                                                        postGroup:
                                                                            currentPosts[index]
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
                                                                            commentController
                                                                                .text,
                                                                        addedTime:
                                                                            DateTime.now()));
                                                                    commentController
                                                                        .clear();
                                                                  },
                                                                  isViewComment:
                                                                      true,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                      post: currentPosts[index],
                                                      user:
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value,
                                                      thumbnailUrl:
                                                          "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                      viewGroupFunc: () {
                                                        loadingDialog();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "groups")
                                                            .where('name',
                                                                isEqualTo:
                                                                    currentPosts[
                                                                            index]
                                                                        .groupName)
                                                            .get()
                                                            .then((value) {
                                                          Get.back();
                                                          if (value.docs
                                                              .isNotEmpty) {
                                                            Get.to(
                                                                () => ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          true,
                                                                      isFromFullScreenPage:
                                                                          false,
                                                                    ));
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: true,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[index]
                                                                .name,
                                                            postLink:
                                                                currentPosts[index]
                                                                    .youtubeLink,
                                                            postCreator:
                                                                currentPosts[index]
                                                                    .creator,
                                                            postGroup:
                                                                currentPosts[index]
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
                                                            commentText:
                                                                commentController
                                                                    .text,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
                                                        _pullRefresh();
                                                      },
                                                    ),
                                                  );
                                          })),

                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                        ],
                      ),
                    ),

              ///------------------------------------------------//
              widget.isFromGroup
                  ? RefresherWidget(
                      controller: _refreshController,
                      pullrefreshFunction: _pullRefresh,
                      onLoadingFunction: () {
                        if (viewGroupController.allpost.length -
                                viewGroupController.postLimit.value >
                            0) {
                          if (viewGroupController.allpost.length -
                                  viewGroupController.postLimit.value <=
                              15) {
                            viewGroupController.setPostLimit(
                                viewGroupController.allpost.length);
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
                      child: ListView(
                        children: [
                          // Title
                          Obx(
                            () => landingPagecontroller.isDeviceTablet.value
                                ? Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (widget.isFromGroup) {
                                            landingPagecontroller
                                                .changeTabIndex(1);
                                            Get.back();
                                            Get.back();
                                          } else {
                                            landingPagecontroller
                                                .changeTabIndex(0);
                                            Get.back();
                                            Get.back();
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                viewGroupController
                                                        .groupName.value
                                                        .contains('#')
                                                    ? viewGroupController
                                                        .groupName.value
                                                        .substring(
                                                            0,
                                                            viewGroupController
                                                                .groupName.value
                                                                .indexOf('#'))
                                                    : viewGroupController
                                                        .groupName.value,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            landingPagecontroller.userProfile
                                                        .value.name ==
                                                    widget.currentGroup.owner
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            if (widget
                                                                .isFromGroup) {
                                                              Get.to(() =>
                                                                      EditGroupPage(
                                                                        currentGroup:
                                                                            widget.currentGroup,
                                                                        index:
                                                                            1,
                                                                      ))!
                                                                  .then((value) =>
                                                                      _pullRefresh());
                                                            } else {
                                                              Get.to(() =>
                                                                      EditGroupPage(
                                                                        currentGroup:
                                                                            widget.currentGroup,
                                                                        index:
                                                                            0,
                                                                      ))!
                                                                  .then((value) =>
                                                                      _pullRefresh());
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ))
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      // Only owner can add video to group
                                      landingPagecontroller
                                                  .userProfile.value.name ==
                                              widget.currentGroup.owner
                                          ? IconButton(
                                              onPressed: () {
                                                Get.to(() => AddVideoPage(
                                                          index:
                                                              widget.isFromGroup
                                                                  ? 1
                                                                  : 0,
                                                          group: widget
                                                              .currentGroup,
                                                          isFromFavPage: !widget
                                                              .isFromGroup,
                                                          isFromViewGroup: true,
                                                        ))!
                                                    .then((value) =>
                                                        _pullRefresh());
                                              },
                                              icon: Image.asset(
                                                'assets/icons/FavAdd.png',
                                                width: 60,
                                                height: 60,
                                              ))
                                          : const SizedBox.shrink(),
                                    ],
                                  )
                                : const SizedBox.shrink(),
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
                                    width: 5,
                                  ),
                                  const Text(
                                    'By',
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.currentGroup.owner,
                                    overflow: TextOverflow.ellipsis,
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
                                          style: TextStyle(color: Colors.white),
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
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.grey,
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
                                Obx(
                                  () => viewGroupController
                                              .filteredTags.isNotEmpty &&
                                          viewGroupController.isFilterOn.value
                                      ? IconButton(
                                          onPressed: () {
                                            viewGroupController.setFilterOn();
                                          },
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.search,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    50,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ))
                                      : Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.8,
                                          child: InputDecorator(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                prefixIcon: InkWell(
                                                  onTap: () {
                                                    viewGroupController
                                                        .setFilterOn();
                                                  },
                                                  child: const Icon(
                                                    Icons.search,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Autocomplete<String>(
                                                    displayStringForOption:
                                                        (c) => c.toString(),
                                                    optionsBuilder:
                                                        (TextEditingValue
                                                            textEditingValue) {
                                                      if (textEditingValue
                                                              .text ==
                                                          '') {
                                                        return const Iterable<
                                                            String>.empty();
                                                      }
                                                      return viewGroupController
                                                          .allTags
                                                          .where(
                                                              (String option) {
                                                        return option
                                                            .trim()
                                                            .toLowerCase()
                                                            .contains(
                                                                textEditingValue
                                                                    .text
                                                                    .trim()
                                                                    .toLowerCase());
                                                      });
                                                    },
                                                    onSelected:
                                                        (String selection) {
                                                      viewGroupController
                                                          .addTags(selection);
                                                      tagName.clear();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                  ),
                                                  const Text(
                                                    'Filter by tag',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                        ),
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
                                                      horizontal: 5,
                                                      vertical: 10),
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
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                    child: Text(
                                                      viewGroupController
                                                          .filteredTags[index],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                            color: Colors.black,
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
                                          style: TextStyle(color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
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
                              ? const Center(child: CircularProgressIndicator())
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                ),
                                                const Text(
                                                  'Your group is empty...',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Add a favorite',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(() => AddVideoPage(
                                                              index: widget
                                                                      .isFromGroup
                                                                  ? 1
                                                                  : 0,
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
                                          itemCount:
                                              viewGroupController.posts.length,
                                          itemBuilder: (context, index) {
                                            List<Post> currentPosts =
                                                viewGroupController.posts;

                                            YoutubePlayerController
                                                _controller =
                                                YoutubePlayerController(
                                              initialVideoId:
                                                  YoutubePlayer.convertUrlToId(
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
                                            TextEditingController
                                                commentController =
                                                TextEditingController();
                                            return landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .name ==
                                                    widget.currentGroup.owner
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 1,
                                                                  post:
                                                                      currentPosts[
                                                                          index],
                                                                  isOwner: currentPosts[
                                                                              index]
                                                                          .creator ==
                                                                      landingPagecontroller
                                                                          .userProfile
                                                                          .value
                                                                          .name,
                                                                  commentController:
                                                                      commentController,
                                                                  addCommentFunction:
                                                                      () {
                                                                    viewGroupController.addComment(Comment(
                                                                        postName:
                                                                            currentPosts[index]
                                                                                .name,
                                                                        postLink:
                                                                            currentPosts[index]
                                                                                .youtubeLink,
                                                                        postCreator:
                                                                            currentPosts[index]
                                                                                .creator,
                                                                        postGroup:
                                                                            currentPosts[index]
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
                                                                            commentController
                                                                                .text,
                                                                        addedTime:
                                                                            DateTime.now()));
                                                                    commentController
                                                                        .clear();
                                                                  },
                                                                  isViewComment:
                                                                      true,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                      post: currentPosts[index],
                                                      user:
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value,
                                                      thumbnailUrl:
                                                          "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                      viewGroupFunc: () {
                                                        loadingDialog();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "groups")
                                                            .where('name',
                                                                isEqualTo:
                                                                    currentPosts[
                                                                            index]
                                                                        .groupName)
                                                            .get()
                                                            .then((value) {
                                                          Get.back();
                                                          if (value.docs
                                                              .isNotEmpty) {
                                                            Get.to(
                                                                () => ViewGroup(
                                                                      index: widget
                                                                          .index,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          true,
                                                                      isFromFullScreenPage:
                                                                          false,
                                                                    ));
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: true,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[index]
                                                                .name,
                                                            postLink:
                                                                currentPosts[index]
                                                                    .youtubeLink,
                                                            postCreator:
                                                                currentPosts[index]
                                                                    .creator,
                                                            postGroup:
                                                                currentPosts[index]
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
                                                            commentText:
                                                                commentController
                                                                    .text,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
                                                        _pullRefresh();
                                                      },
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                        viewCommentFunction:
                                                            () {
                                                          Get.to(() =>
                                                                  FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index],
                                                                    isOwner: currentPosts[index]
                                                                            .creator ==
                                                                        landingPagecontroller
                                                                            .userProfile
                                                                            .value
                                                                            .name,
                                                                    commentController:
                                                                        commentController,
                                                                    addCommentFunction:
                                                                        () {
                                                                      viewGroupController.addComment(Comment(
                                                                          postName: currentPosts[index]
                                                                              .name,
                                                                          postLink: currentPosts[index]
                                                                              .youtubeLink,
                                                                          postCreator: currentPosts[index]
                                                                              .creator,
                                                                          postGroup: currentPosts[index]
                                                                              .groupName,
                                                                          commenter: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .name,
                                                                          commenterUrl: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .imageUrl,
                                                                          commentText: commentController
                                                                              .text,
                                                                          addedTime:
                                                                              DateTime.now()));
                                                                      commentController
                                                                          .clear();
                                                                    },
                                                                    isViewComment:
                                                                        true,
                                                                  ))!
                                                              .then((value) =>
                                                                  _pullRefresh());
                                                        },
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl:
                                                            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
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
                                                                    isFromFullScreenPage:
                                                                        false,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                        commentList:
                                                            currentPosts[
                                                                        index]
                                                                    .comments ??
                                                                [],
                                                        textController:
                                                            commentController,
                                                        commentFunction: () {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup: currentPosts[
                                                                      index]
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
                                                              commentText:
                                                                  commentController
                                                                      .text,
                                                              addedTime:
                                                                  DateTime.now()));
                                                          commentController
                                                              .clear();
                                                          _pullRefresh();
                                                        }),
                                                  );
                                          })
                                  // Filtered
                                  : viewGroupController
                                          .filteredTagResult.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'No Result Found',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                              initialVideoId:
                                                  YoutubePlayer.convertUrlToId(
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
                                            TextEditingController
                                                commentController =
                                                TextEditingController();
                                            return landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .name ==
                                                    widget.currentGroup.owner
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                        viewCommentFunction:
                                                            () {
                                                          Get.to(() =>
                                                                  FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index],
                                                                    isOwner: currentPosts[index]
                                                                            .creator ==
                                                                        landingPagecontroller
                                                                            .userProfile
                                                                            .value
                                                                            .name,
                                                                    commentController:
                                                                        commentController,
                                                                    addCommentFunction:
                                                                        () {
                                                                      viewGroupController.addComment(Comment(
                                                                          postName: currentPosts[index]
                                                                              .name,
                                                                          postLink: currentPosts[index]
                                                                              .youtubeLink,
                                                                          postCreator: currentPosts[index]
                                                                              .creator,
                                                                          postGroup: currentPosts[index]
                                                                              .groupName,
                                                                          commenter: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .name,
                                                                          commenterUrl: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .imageUrl,
                                                                          commentText: commentController
                                                                              .text,
                                                                          addedTime:
                                                                              DateTime.now()));
                                                                      commentController
                                                                          .clear();
                                                                    },
                                                                    isViewComment:
                                                                        true,
                                                                  ))!
                                                              .then((value) =>
                                                                  _pullRefresh());
                                                        },
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl:
                                                            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
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
                                                                    isFromFullScreenPage:
                                                                        false,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                        commentList:
                                                            currentPosts[
                                                                        index]
                                                                    .comments ??
                                                                [],
                                                        textController:
                                                            commentController,
                                                        commentFunction: () {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup: currentPosts[
                                                                      index]
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
                                                              commentText:
                                                                  commentController
                                                                      .text,
                                                              addedTime:
                                                                  DateTime.now()));
                                                          commentController
                                                              .clear();
                                                          _pullRefresh();
                                                        }),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                index: 1,
                                                                post:
                                                                    currentPosts[
                                                                        index],
                                                                isOwner: currentPosts[
                                                                            index]
                                                                        .creator ==
                                                                    landingPagecontroller
                                                                        .userProfile
                                                                        .value
                                                                        .name,
                                                                commentController:
                                                                    commentController,
                                                                addCommentFunction:
                                                                    () {
                                                                  viewGroupController.addComment(Comment(
                                                                      postName:
                                                                          currentPosts[index]
                                                                              .name,
                                                                      postLink:
                                                                          currentPosts[index]
                                                                              .youtubeLink,
                                                                      postCreator:
                                                                          currentPosts[index]
                                                                              .creator,
                                                                      postGroup:
                                                                          currentPosts[index]
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
                                                                          commentController
                                                                              .text,
                                                                      addedTime:
                                                                          DateTime
                                                                              .now()));
                                                                  commentController
                                                                      .clear();
                                                                },
                                                                isViewComment:
                                                                    false,
                                                              ))!
                                                          .then((value) =>
                                                              _pullRefresh());
                                                    },
                                                    child: VideoWidget(
                                                        viewCommentFunction:
                                                            () {
                                                          Get.to(() =>
                                                                  FullScreenPage(
                                                                    index: 1,
                                                                    post: currentPosts[
                                                                        index],
                                                                    isOwner: currentPosts[index]
                                                                            .creator ==
                                                                        landingPagecontroller
                                                                            .userProfile
                                                                            .value
                                                                            .name,
                                                                    commentController:
                                                                        commentController,
                                                                    addCommentFunction:
                                                                        () {
                                                                      viewGroupController.addComment(Comment(
                                                                          postName: currentPosts[index]
                                                                              .name,
                                                                          postLink: currentPosts[index]
                                                                              .youtubeLink,
                                                                          postCreator: currentPosts[index]
                                                                              .creator,
                                                                          postGroup: currentPosts[index]
                                                                              .groupName,
                                                                          commenter: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .name,
                                                                          commenterUrl: landingPagecontroller
                                                                              .userProfile
                                                                              .value
                                                                              .imageUrl,
                                                                          commentText: commentController
                                                                              .text,
                                                                          addedTime:
                                                                              DateTime.now()));
                                                                      commentController
                                                                          .clear();
                                                                    },
                                                                    isViewComment:
                                                                        true,
                                                                  ))!
                                                              .then((value) =>
                                                                  _pullRefresh());
                                                        },
                                                        post:
                                                            currentPosts[index],
                                                        user:
                                                            landingPagecontroller
                                                                .userProfile
                                                                .value,
                                                        thumbnailUrl:
                                                            "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
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
                                                                    isFromFullScreenPage:
                                                                        false,
                                                                  ));
                                                            }
                                                          });
                                                        },
                                                        isInsideGroup: true,
                                                        reportFunction: () {
                                                          _pullRefresh();
                                                        },
                                                        commentList:
                                                            currentPosts[
                                                                        index]
                                                                    .comments ??
                                                                [],
                                                        textController:
                                                            commentController,
                                                        commentFunction: () {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup: currentPosts[
                                                                      index]
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
                                                              commentText:
                                                                  commentController
                                                                      .text,
                                                              addedTime:
                                                                  DateTime.now()));
                                                          commentController
                                                              .clear();
                                                          _pullRefresh();
                                                        }),
                                                  );
                                          })),

                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                        ],
                      ),
                    )
                  : const YourGroupsPage(
                      isFirstTime: false,
                    ),

              ///------------------------------------------------//
              SettingsPage()
            ],
          );
        }),
      ),
    );
  }
}
