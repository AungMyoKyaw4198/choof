import 'package:choof_app/screens/add_video.dart';
import 'package:choof_app/screens/favourite_page.dart';
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
  final bool isFromAddGroup;
  const ViewGroup(
      {Key? key,
      required this.index,
      required this.currentGroup,
      required this.isFromGroup,
      required this.isFromAddGroup,
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
    landingPagecontroller.incrementBackIndex();
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
          preferredSize: const Size(50, 50),
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
                      leadingWidth: 200,
                      leading: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              if (widget.isFromAddGroup) {
                                Get.back();
                                Get.back();
                              } else if (widget.isFromGroup) {
                                landingPagecontroller.changeTabIndex(1);
                                if (widget.isFromFullScreenPage) {
                                  Get.back();
                                  Get.back();
                                } else {
                                  Get.back();
                                }
                              } else {
                                landingPagecontroller.changeTabIndex(0);
                                if (widget.isFromFullScreenPage) {
                                  Get.back();
                                  Get.back();
                                } else {
                                  Get.back();
                                }
                              }
                            },
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
                                              .then((value) => _pullRefresh());
                                        } else {
                                          Get.to(() => EditGroupPage(
                                                    currentGroup:
                                                        widget.currentGroup,
                                                    index: 0,
                                                  ))!
                                              .then((value) => _pullRefresh());
                                        }
                                      },
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 12,
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            size: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
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
      bottomNavigationBar: Obx(() {
        return landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : BottomMenu(deactivatedIndex: widget.index);
      }),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        child: Obx(() {
          return IndexedStack(
            index: landingPagecontroller.tabIndex.value,
            children: [
              // Index == 0
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
                          // Group Name
                          Center(
                            child: Obx(
                              () => !landingPagecontroller.isDeviceTablet.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Obx(
                                        () => Text(
                                          viewGroupController.groupName.value
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
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 23),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),

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
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
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
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Text(
                                        widget.currentGroup.owner,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Obx(() {
                                        if (landingPagecontroller
                                            .groupedUsers.isEmpty) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => FriendsPage(
                                                  group: widget.currentGroup));
                                            },
                                            child: const Text(
                                              'Add Friends',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        } else {
                                          List<Profile> groupMembers = [];
                                          for (var member
                                              in landingPagecontroller
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
                                                    right: index * 20,
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
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: NetworkImage(
                                                                    groupMembers[
                                                                            index]
                                                                        .imageUrl)))));
                                              }, growable: true)),
                                            ),
                                          );
                                        }
                                      }),
                                      // Show +7
                                      Obx(() {
                                        if (landingPagecontroller
                                            .groupedUsers.isNotEmpty) {
                                          List<Profile> groupMembers = [];
                                          for (var member
                                              in landingPagecontroller
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
                                              : const SizedBox(
                                                  width: 10,
                                                );
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
                                          // width: 40,
                                          height: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Filter tag
                          Container(
                            height: MediaQuery.of(context).size.height / 20,
                            width: MediaQuery.of(context).size.width / 1.05,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Autocomplete(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                } else {
                                  return viewGroupController.allTags
                                      .where((String option) {
                                    return option
                                        .trim()
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .trim()
                                            .toLowerCase());
                                  });
                                }
                              },
                              optionsViewBuilder: (context,
                                  Function(String) onSelected, options) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    color: const Color(bgColor),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(4.0)),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option.toString().trim(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              viewGroupController.addTags(
                                                  option.toString().trim());
                                              viewGroupController.tagName
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: options.length,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onSelected: (selectedString) {
                                viewGroupController
                                    .addTags(selectedString.toString().trim());
                                viewGroupController.tagName.clear();
                                FocusScope.of(context).unfocus();
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onEditingComplete) {
                                viewGroupController.tagName = controller;

                                return TextField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: controller,
                                    focusNode: focusNode,
                                    onEditingComplete: onEditingComplete,
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        // Split if input contains ,
                                        if (value.contains(',')) {
                                          List<String> splitedString =
                                              value.split(',');
                                          splitedString.forEach((element) {
                                            viewGroupController
                                                .addTags(element.trim());
                                          });
                                        } else {
                                          viewGroupController
                                              .addTags(value.trim());
                                        }
                                      }
                                      viewGroupController.tagName.clear();
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        fillColor: const Color(bgColor),
                                        hintText: 'Filter by tag',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            viewGroupController.setFilterOn();
                                          },
                                          child: const Icon(
                                            Icons.search,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            viewGroupController.tagName.clear();
                                          },
                                          icon: const CircleAvatar(
                                            backgroundColor: Colors.white24,
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )));
                              },
                            ),
                          ),

                          // Sorting Container
                          Container(
                            height: MediaQuery.of(context).size.height / 30,
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Obx(() => viewGroupController.sortByRecent.value
                                    ? InkWell(
                                        onTap: () {
                                          viewGroupController.sort(false);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/UpDownArrow.png',
                                                width: 20,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Most recent',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              horizontal: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.arrowUpAZ,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Alphabetical',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
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
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            20,
                                                    decoration: const BoxDecoration(
                                                        color: Color(bgColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Center(
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
                                                            Alignment.topRight,
                                                        child: CircleAvatar(
                                                          radius: 8,
                                                          backgroundColor:
                                                              Colors.white70,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.black,
                                                            size: 10,
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
                                                                isToRefresh:
                                                                    true,
                                                                index: 0,
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
                                                      if (widget
                                                          .isFromFullScreenPage) {
                                                        setState(
                                                          () {},
                                                        );
                                                      }
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
                                                                      isFromAddGroup:
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
                                                      commentFunction: (value) {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[
                                                                    index]
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
                                                            commentText: value,
                                                            addedTime: DateTime
                                                                .now()));
                                                        commentController
                                                            .clear();
                                                        _pullRefresh();
                                                      },
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  isToRefresh:
                                                                      true,
                                                                  index: 0,
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
                                                        if (widget
                                                            .isFromFullScreenPage) {
                                                          setState(
                                                            () {},
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                              FullScreenPage(
                                                                isToRefresh:
                                                                    true,
                                                                index: 0,
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
                                                      if (widget
                                                          .isFromFullScreenPage) {
                                                        setState(
                                                          () {},
                                                        );
                                                      }
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  index: 0,
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
                                                        if (widget
                                                            .isFromFullScreenPage) {
                                                          setState(
                                                            () {},
                                                          );
                                                        }
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
                                                                      isFromAddGroup:
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
                                                      commentFunction: (value) {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[
                                                                    index]
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
                                                            commentText: value,
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
                                                                isToRefresh:
                                                                    true,
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
                                                      if (widget
                                                          .isFromFullScreenPage) {
                                                        setState(
                                                          () {},
                                                        );
                                                      }
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  isToRefresh:
                                                                      true,
                                                                  index: 0,
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
                                                        if (widget
                                                            .isFromFullScreenPage) {
                                                          setState(
                                                            () {},
                                                          );
                                                        }
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
                                                                      isFromAddGroup:
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
                                                      commentFunction: (value) {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[
                                                                    index]
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
                                                            commentText: value,
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
                                                                isToRefresh:
                                                                    true,
                                                                index: 0,
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
                                                      if (widget
                                                          .isFromFullScreenPage) {
                                                        setState(
                                                          () {},
                                                        );
                                                      }
                                                    },
                                                    child: VideoWidget(
                                                      viewCommentFunction: () {
                                                        Get.to(() =>
                                                                FullScreenPage(
                                                                  isToRefresh:
                                                                      true,
                                                                  index: 0,
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
                                                        if (widget
                                                            .isFromFullScreenPage) {
                                                          setState(
                                                            () {},
                                                          );
                                                        }
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
                                                                      isFromAddGroup:
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
                                                      commentFunction: (value) {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[
                                                                    index]
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
                                                            commentText: value,
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
              ///// Index == 1
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
                          // Group Name
                          Center(
                            child: Obx(
                              () => !landingPagecontroller.isDeviceTablet.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Obx(
                                        () => Text(
                                          viewGroupController.groupName.value
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
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 23),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
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
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
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
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Text(
                                        widget.currentGroup.owner,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Obx(() {
                                        if (landingPagecontroller
                                            .groupedUsers.isEmpty) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => FriendsPage(
                                                  group: widget.currentGroup));
                                            },
                                            child: const Text(
                                              'Add Friends',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        } else {
                                          List<Profile> groupMembers = [];
                                          for (var member
                                              in landingPagecontroller
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
                                                    right: index * 20,
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
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: NetworkImage(
                                                                    groupMembers[
                                                                            index]
                                                                        .imageUrl)))));
                                              }, growable: true)),
                                            ),
                                          );
                                        }
                                      }),
                                      // Show +7
                                      Obx(() {
                                        if (landingPagecontroller
                                            .groupedUsers.isNotEmpty) {
                                          List<Profile> groupMembers = [];
                                          for (var member
                                              in landingPagecontroller
                                                  .groupedUsers) {
                                            if (member.name !=
                                                widget.currentGroup.owner) {
                                              groupMembers.add(member);
                                            }
                                          }
                                          return groupMembers.length > 5
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Text(
                                                    '+${groupMembers.length - 5}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : const SizedBox(width: 10);
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
                                          height: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Filter tag
                          Container(
                            height: MediaQuery.of(context).size.height / 20,
                            width: MediaQuery.of(context).size.width / 1.05,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Autocomplete(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                } else {
                                  return viewGroupController.allTags
                                      .where((String option) {
                                    return option
                                        .trim()
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .trim()
                                            .toLowerCase());
                                  });
                                }
                              },
                              optionsViewBuilder: (context,
                                  Function(String) onSelected, options) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    color: const Color(bgColor),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(4.0)),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option.toString().trim(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              viewGroupController.addTags(
                                                  option.toString().trim());
                                              viewGroupController.tagName
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: options.length,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onSelected: (selectedString) {
                                viewGroupController
                                    .addTags(selectedString.toString().trim());
                                viewGroupController.tagName.clear();
                                FocusScope.of(context).unfocus();
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onEditingComplete) {
                                viewGroupController.tagName = controller;

                                return TextField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: controller,
                                    focusNode: focusNode,
                                    onEditingComplete: onEditingComplete,
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        // Split if input contains ,
                                        if (value.contains(',')) {
                                          List<String> splitedString =
                                              value.split(',');
                                          splitedString.forEach((element) {
                                            viewGroupController
                                                .addTags(element.trim());
                                          });
                                        } else {
                                          viewGroupController
                                              .addTags(value.trim());
                                        }
                                      }
                                      viewGroupController.tagName.clear();
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        filled: true,
                                        fillColor: const Color(bgColor),
                                        hintText: 'Filter by tag',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            viewGroupController.setFilterOn();
                                          },
                                          child: const Icon(
                                            Icons.search,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            viewGroupController.tagName.clear();
                                          },
                                          icon: const CircleAvatar(
                                            backgroundColor: Colors.white24,
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )));
                              },
                            ),
                          ),

                          // Sorting Container
                          Container(
                            height: MediaQuery.of(context).size.height / 30,
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Obx(() => viewGroupController.sortByRecent.value
                                    ? InkWell(
                                        onTap: () {
                                          viewGroupController.sort(false);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/UpDownArrow.png',
                                                width: 20,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Most recent',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              horizontal: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.arrowUpAZ,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    40,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Alphabetical',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
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
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            20,
                                                    decoration: const BoxDecoration(
                                                        color: Color(bgColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Center(
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
                                                            Alignment.topRight,
                                                        child: CircleAvatar(
                                                          radius: 8,
                                                          backgroundColor:
                                                              Colors.white70,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.black,
                                                            size: 10,
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
                                                                      isFromAddGroup:
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
                                                      commentFunction: (value) {
                                                        viewGroupController.addComment(Comment(
                                                            postName: currentPosts[
                                                                    index]
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
                                                            commentText: value,
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
                                                                    isFromAddGroup:
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
                                                        commentFunction:
                                                            (value) {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[
                                                                      index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup:
                                                                  currentPosts[
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
                                                                  value,
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
                                                                    isFromAddGroup:
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
                                                        commentFunction:
                                                            (value) {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[
                                                                      index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup:
                                                                  currentPosts[
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
                                                                  value,
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
                                                                    isFromAddGroup:
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
                                                        commentFunction:
                                                            (value) {
                                                          viewGroupController.addComment(Comment(
                                                              postName: currentPosts[
                                                                      index]
                                                                  .name,
                                                              postLink: currentPosts[
                                                                      index]
                                                                  .youtubeLink,
                                                              postCreator:
                                                                  currentPosts[index]
                                                                      .creator,
                                                              postGroup:
                                                                  currentPosts[
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
                                                                  value,
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
