import 'dart:ui';

import 'package:choof_app/models/comment.dart';
import 'package:choof_app/screens/view_group.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/home_page_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../controllers/your_group_controller.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../models/profile.dart';
import '../utils/app_constant.dart';
import 'add_group_page.dart';
import 'add_video.dart';
import 'full_screen_page.dart';

class FavouritePage extends StatefulWidget {
  final bool isFirstTime;
  const FavouritePage({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final homePageController = Get.find<HomePageController>();
  final yourGroupController = Get.find<YourGroupController>();
  final landingPagecontroller = Get.find<LandingPageController>();

  final tagName = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.isFirstTime) {
      homePageController.getNotifications();
      homePageController.getAllPost();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pullRefresh() async {
    homePageController.refreshPosts();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(60, 60),
        child: Obx(() => landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : Obx(() => landingPagecontroller.tabIndex.value == 0
                ? AppBar(
                    backgroundColor: const Color(bgColor),
                    centerTitle: true,
                    leadingWidth: MediaQuery.of(context).size.width / 4.5,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'assets/logos/logo.png',
                      ),
                    ),
                    title: const Text(
                      'Favorites',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    elevation: 0.0,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.to(() => AddVideoPage(
                                      index: 0,
                                      group: Group(
                                          name: '',
                                          tags: [],
                                          owner: '',
                                          ownerImageUrl: '',
                                          members: [],
                                          lastUpdatedTime: DateTime.now(),
                                          createdTime: DateTime.now()),
                                      isFromFavPage: true,
                                      isFromViewGroup: false,
                                    ))!
                                .then((value) {
                              _pullRefresh();
                            });
                          },
                          icon: Image.asset(
                            'assets/icons/FavAdd.png',
                            width: 60,
                            height: 60,
                          ))
                    ],
                  )
                : Obx(() => landingPagecontroller.isDeviceTablet.value
                    ? Container(
                        height: 0,
                        color: const Color(mainBgColor),
                      )
                    : Container(
                        height: MediaQuery.of(context).padding.top,
                        color: const Color(mainBgColor),
                      )))),
      ),

      // body
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
                  body = const Text("Pull up to load more");
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("Release to load more");
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
              if (homePageController.allpost.length -
                      homePageController.postLimit.value >
                  0) {
                if (homePageController.allpost.length -
                        homePageController.postLimit.value <=
                    15) {
                  homePageController
                      .setPostLimit(homePageController.allpost.length);
                } else {
                  homePageController.addPostLimit();
                }
                _refreshController.loadComplete();
              } else {
                homePageController
                    .setPostLimit(homePageController.allpost.length);
                _refreshController.loadNoData();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Tablet View
                Obx(
                  () => landingPagecontroller.isDeviceTablet.value
                      ? Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              color: Color(bgColor),
                              border: Border(
                                right: BorderSide(
                                  width: 5.0,
                                  color: Color(mainBgColor),
                                ),
                              )),
                          child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                // All Profiles
                                Obx((() => InkWell(
                                      onTap: () {
                                        homePageController.selectProfile('all');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: homePageController
                                                                .selectedFriend
                                                                .value ==
                                                            'all'
                                                        ? Border.all(
                                                            color: const Color(
                                                                mainColor),
                                                            width: 2.0)
                                                        : Border.all(
                                                            color:
                                                                Colors.white),
                                                    image: const DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=')))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'All',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: homePageController
                                                                .selectedFriend
                                                                .value ==
                                                            'all'
                                                        ? const Color(mainColor)
                                                        : Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))),

                                // My Profile
                                Obx(
                                  () => InkWell(
                                    onTap: () {
                                      homePageController.selectProfile(
                                          landingPagecontroller
                                              .userProfile.value.name);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: homePageController
                                                              .selectedFriend
                                                              .value ==
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value
                                                              .name
                                                      ? Border.all(
                                                          color: const Color(
                                                              mainColor),
                                                          width: 2.0)
                                                      : Border.all(
                                                          color: Colors.white),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value
                                                              .imageUrl)))),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              landingPagecontroller
                                                  .userProfile.value.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: homePageController
                                                              .selectedFriend
                                                              .value ==
                                                          landingPagecontroller
                                                              .userProfile
                                                              .value
                                                              .name
                                                      ? const Color(mainColor)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Rest of the creators
                                Obx(() {
                                  List<Profile> creators = [];
                                  for (var creator
                                      in homePageController.creators) {
                                    if (creator.name.trim() !=
                                        landingPagecontroller
                                            .userProfile.value.name
                                            .trim()) {
                                      if (landingPagecontroller
                                              .userProfile.value.blockedUsers !=
                                          null) {
                                        if (!landingPagecontroller
                                            .userProfile.value.blockedUsers!
                                            .contains(creator.name.trim())) {
                                          creators.add(creator);
                                        }
                                      } else {
                                        creators.add(creator);
                                      }
                                    }
                                  }
                                  return creators.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: creators.length,
                                          itemBuilder: (context, index) {
                                            return Obx(() => InkWell(
                                                  onTap: () {
                                                    homePageController
                                                        .selectProfile(
                                                            creators[index]
                                                                .name);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: homePageController.selectedFriend.value ==
                                                                            creators[index]
                                                                                .name
                                                                        ? Border.all(
                                                                            color: const Color(
                                                                                mainColor),
                                                                            width:
                                                                                2.0)
                                                                        : Border.all(
                                                                            color:
                                                                                Colors.white),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: NetworkImage(
                                                                          creators[index]
                                                                              .imageUrl,
                                                                        )))),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            creators[index]
                                                                .name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: homePageController
                                                                            .selectedFriend
                                                                            .value ==
                                                                        creators[index]
                                                                            .name
                                                                    ? const Color(
                                                                        mainColor)
                                                                    : Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          })
                                      : const SizedBox.shrink();
                                }),
                              ]),
                        )
                      : const SizedBox.shrink(),
                ),

                // Main View
                Container(
                  width: landingPagecontroller.isDeviceTablet.value
                      ? MediaQuery.of(context).size.width * 2 / 3
                      : MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      // Title
                      Obx(
                        () => landingPagecontroller.isDeviceTablet.value
                            ? Row(
                                children: [
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Favorites',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(() => AddVideoPage(
                                                  index: 0,
                                                  group: Group(
                                                      name: '',
                                                      tags: [],
                                                      owner: '',
                                                      ownerImageUrl: '',
                                                      members: [],
                                                      lastUpdatedTime:
                                                          DateTime.now(),
                                                      createdTime:
                                                          DateTime.now()),
                                                  isFromFavPage: true,
                                                  isFromViewGroup: false,
                                                ))!
                                            .then((value) {
                                          _pullRefresh();
                                        });
                                      },
                                      icon: Image.asset(
                                        'assets/icons/FavAdd.png',
                                        width: 60,
                                        height: 60,
                                      ))
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Profiles
                      Obx(
                        () => landingPagecontroller.isDeviceTablet.value
                            ? const SizedBox.shrink()
                            : Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                height: MediaQuery.of(context).size.height / 9,
                                child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      // All Profiles
                                      Obx((() => InkWell(
                                            onTap: () {
                                              homePageController
                                                  .selectProfile('all');
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ProfileVerticalWidget(
                                                name: 'All',
                                                imageUrl:
                                                    'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                                                size: 60,
                                                isSelected: homePageController
                                                        .selectedFriend.value ==
                                                    'all',
                                              ),
                                            ),
                                          ))),

                                      // My Profile
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            homePageController.selectProfile(
                                                landingPagecontroller
                                                    .userProfile.value.name);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: ProfileVerticalWidget(
                                              name: landingPagecontroller
                                                  .userProfile.value.name,
                                              imageUrl: landingPagecontroller
                                                  .userProfile.value.imageUrl,
                                              size: 60,
                                              isSelected: homePageController
                                                      .selectedFriend.value ==
                                                  landingPagecontroller
                                                      .userProfile.value.name,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Rest of the creators
                                      Obx(() {
                                        List<Profile> creators = [];
                                        for (var creator
                                            in homePageController.creators) {
                                          if (creator.name.trim() !=
                                              landingPagecontroller
                                                  .userProfile.value.name
                                                  .trim()) {
                                            if (landingPagecontroller
                                                    .userProfile
                                                    .value
                                                    .blockedUsers !=
                                                null) {
                                              if (!landingPagecontroller
                                                  .userProfile
                                                  .value
                                                  .blockedUsers!
                                                  .contains(
                                                      creator.name.trim())) {
                                                creators.add(creator);
                                              }
                                            } else {
                                              creators.add(creator);
                                            }
                                          }
                                        }
                                        return creators.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: creators.length,
                                                itemBuilder: (context, index) {
                                                  return Obx(() => InkWell(
                                                        onTap: () {
                                                          homePageController
                                                              .selectProfile(
                                                                  creators[
                                                                          index]
                                                                      .name);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child:
                                                              ProfileVerticalWidget(
                                                            name:
                                                                creators[index]
                                                                    .name,
                                                            imageUrl:
                                                                creators[index]
                                                                    .imageUrl,
                                                            size: 60,
                                                            isSelected:
                                                                homePageController
                                                                        .selectedFriend
                                                                        .value ==
                                                                    creators[
                                                                            index]
                                                                        .name,
                                                          ),
                                                        ),
                                                      ));
                                                })
                                            : const SizedBox.shrink();
                                      }),
                                    ]),
                              ),
                      ),

                      // Filter tag
                      Container(
                        height: MediaQuery.of(context).size.height / 16,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Obx(
                              () => !homePageController.isFilterOn.value
                                  ? IconButton(
                                      onPressed: () {
                                        homePageController.setFilterOn();
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
                                      padding: const EdgeInsets.only(left: 10),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
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
                                            prefixIcon: InkWell(
                                              onTap: () {
                                                homePageController
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
                                                displayStringForOption: (c) =>
                                                    c.toString(),
                                                optionsBuilder:
                                                    (TextEditingValue
                                                        textEditingValue) {
                                                  if (textEditingValue.text ==
                                                      '') {
                                                    return const Iterable<
                                                        String>.empty();
                                                  }
                                                  return homePageController
                                                      .allTags
                                                      .where((String option) {
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
                                                onSelected: (String selection) {
                                                  homePageController
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
                            ),

                            const SizedBox(
                              width: 10,
                            ),
                            // Show Filtered tags
                            Obx(
                              () => homePageController.filteredTags.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: homePageController
                                          .filteredTags.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade800,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                child: Text(
                                                  homePageController
                                                      .filteredTags[index],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  homePageController.removeTag(
                                                      homePageController
                                                          .filteredTags[index]);
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
                      Obx(() => homePageController.sortByRecent.value
                          ? InkWell(
                              onTap: () {
                                homePageController.sort(false);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                homePageController.sort(true);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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

                      // ----------------------------------------- //
                      // Video Widget
                      Obx(() => !homePageController.loaded.value
                          ? const Center(child: CircularProgressIndicator())
                          : !homePageController.isFilter.value
                              ?
                              // No filter
                              homePageController.posts.isEmpty
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
                                          'Create a group',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => const AddGroupPage(
                                                  isFromFavPage: true,
                                                  index: 0,
                                                ))!;
                                          },
                                          child: Image.asset(
                                            'assets/icons/FriendsAdd.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        const Text(
                                          'then add some favorites and friends.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: homePageController
                                                  .posts.length <
                                              homePageController.postLimit.value
                                          ? homePageController.posts.length
                                          : homePageController.postLimit.value,
                                      itemBuilder: (context, index) {
                                        List<Post> currentPosts =
                                            homePageController.posts;

                                        if (homePageController.posts.length <
                                            homePageController
                                                .postLimit.value) {
                                          _refreshController.loadNoData();
                                        }
                                        TextEditingController
                                            commentController =
                                            TextEditingController();

                                        return landingPagecontroller.userProfile
                                                    .value.blockedUsers !=
                                                null
                                            ? landingPagecontroller.userProfile
                                                    .value.blockedUsers!
                                                    .contains(
                                                        currentPosts[index]
                                                            .creator)
                                                ? const SizedBox.shrink()
                                                : InkWell(
                                                    onTap: () {
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
                                                                    homePageController.addComment(Comment(
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
                                                                  }))!
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
                                                            Get.to(() =>
                                                                    ViewGroup(
                                                                      index: 0,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          false,
                                                                    ))!
                                                                .then((value) =>
                                                                    _pullRefresh());
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: false,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                        yourGroupController
                                                            .refreshGroups();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        homePageController.addComment(Comment(
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
                                                                    index: 0,
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
                                                                      homePageController.addComment(Comment(
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
                                                                    }))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                    ),
                                                  )
                                            : InkWell(
                                                onTap: () {
                                                  Get.to(() => FullScreenPage(
                                                          index: 0,
                                                          post: currentPosts[
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
                                                            homePageController.addComment(Comment(
                                                                postName:
                                                                    currentPosts[index]
                                                                        .name,
                                                                postLink: currentPosts[index]
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
                                                                addedTime:
                                                                    DateTime
                                                                        .now()));
                                                            commentController
                                                                .clear();
                                                          }))!
                                                      .then((value) =>
                                                          _pullRefresh());
                                                },
                                                child: VideoWidget(
                                                  post: currentPosts[index],
                                                  user: landingPagecontroller
                                                      .userProfile.value,
                                                  thumbnailUrl:
                                                      "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                  viewGroupFunc: () {
                                                    loadingDialog();
                                                    FirebaseFirestore.instance
                                                        .collection("groups")
                                                        .where('name',
                                                            isEqualTo:
                                                                currentPosts[
                                                                        index]
                                                                    .groupName)
                                                        .get()
                                                        .then((value) {
                                                      Get.back();
                                                      if (value
                                                          .docs.isNotEmpty) {
                                                        Get.to(() => ViewGroup(
                                                                  index: 0,
                                                                  currentGroup:
                                                                      Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                  isFromGroup:
                                                                      false,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      }
                                                    });
                                                  },
                                                  isInsideGroup: false,
                                                  reportFunction: () {
                                                    _pullRefresh();
                                                    yourGroupController
                                                        .refreshGroups();
                                                  },
                                                  commentList:
                                                      currentPosts[index]
                                                              .comments ??
                                                          [],
                                                  textController:
                                                      commentController,
                                                  commentFunction: () {
                                                    homePageController.addComment(Comment(
                                                        postName: currentPosts[
                                                                index]
                                                            .name,
                                                        postLink: currentPosts[
                                                                index]
                                                            .youtubeLink,
                                                        postCreator:
                                                            currentPosts[index]
                                                                .creator,
                                                        postGroup: currentPosts[index]
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
                                                    commentController.clear();
                                                    _pullRefresh();
                                                  },
                                                  viewCommentFunction: () {
                                                    Get.to(() => FullScreenPage(
                                                            index: 0,
                                                            post: currentPosts[
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
                                                              homePageController.addComment(Comment(
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
                                                                  commentText:
                                                                      commentController
                                                                          .text,
                                                                  addedTime:
                                                                      DateTime
                                                                          .now()));
                                                              commentController
                                                                  .clear();
                                                            }))!
                                                        .then((value) =>
                                                            _pullRefresh());
                                                  },
                                                ),
                                              );
                                      })
                              // Filtered
                              : homePageController.filteredTagResult.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No Result Found',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: homePageController
                                          .filteredTagResult.length,
                                      itemBuilder: (context, index) {
                                        List<Post> currentPosts =
                                            homePageController
                                                .filteredTagResult;
                                        TextEditingController
                                            commentController =
                                            TextEditingController();
                                        return landingPagecontroller.userProfile
                                                    .value.blockedUsers !=
                                                null
                                            ? landingPagecontroller.userProfile
                                                    .value.blockedUsers!
                                                    .contains(
                                                        currentPosts[index]
                                                            .creator)
                                                ? const SizedBox.shrink()
                                                : InkWell(
                                                    onTap: () {
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
                                                                    homePageController.addComment(Comment(
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
                                                                  }))!
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
                                                            Get.to(() =>
                                                                    ViewGroup(
                                                                      index: 0,
                                                                      currentGroup: Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                      isFromGroup:
                                                                          false,
                                                                    ))!
                                                                .then((value) =>
                                                                    _pullRefresh());
                                                          }
                                                        });
                                                      },
                                                      isInsideGroup: false,
                                                      reportFunction: () {
                                                        _pullRefresh();
                                                        yourGroupController
                                                            .refreshGroups();
                                                      },
                                                      commentList:
                                                          currentPosts[index]
                                                                  .comments ??
                                                              [],
                                                      textController:
                                                          commentController,
                                                      commentFunction: () {
                                                        homePageController.addComment(Comment(
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
                                                                    index: 0,
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
                                                                      homePageController.addComment(Comment(
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
                                                                    }))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      },
                                                    ),
                                                  )
                                            : InkWell(
                                                onTap: () {
                                                  Get.to(() => FullScreenPage(
                                                          index: 0,
                                                          post: currentPosts[
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
                                                            homePageController.addComment(Comment(
                                                                postName:
                                                                    currentPosts[index]
                                                                        .name,
                                                                postLink: currentPosts[index]
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
                                                                addedTime:
                                                                    DateTime
                                                                        .now()));
                                                            commentController
                                                                .clear();
                                                          }))!
                                                      .then((value) =>
                                                          _pullRefresh());
                                                },
                                                child: VideoWidget(
                                                  post: currentPosts[index],
                                                  user: landingPagecontroller
                                                      .userProfile.value,
                                                  thumbnailUrl:
                                                      "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(currentPosts[index].youtubeLink)!}/hqdefault.jpg",
                                                  viewGroupFunc: () {
                                                    loadingDialog();
                                                    FirebaseFirestore.instance
                                                        .collection("groups")
                                                        .where('name',
                                                            isEqualTo:
                                                                currentPosts[
                                                                        index]
                                                                    .groupName)
                                                        .get()
                                                        .then((value) {
                                                      Get.back();
                                                      if (value
                                                          .docs.isNotEmpty) {
                                                        Get.to(() => ViewGroup(
                                                                  index: 0,
                                                                  currentGroup:
                                                                      Group.fromJson(value
                                                                          .docs
                                                                          .first
                                                                          .data()),
                                                                  isFromGroup:
                                                                      false,
                                                                ))!
                                                            .then((value) =>
                                                                _pullRefresh());
                                                      }
                                                    });
                                                  },
                                                  isInsideGroup: false,
                                                  reportFunction: () {
                                                    _pullRefresh();
                                                    yourGroupController
                                                        .refreshGroups();
                                                  },
                                                  commentList:
                                                      currentPosts[index]
                                                              .comments ??
                                                          [],
                                                  textController:
                                                      commentController,
                                                  commentFunction: () {
                                                    homePageController.addComment(Comment(
                                                        postName: currentPosts[
                                                                index]
                                                            .name,
                                                        postLink: currentPosts[
                                                                index]
                                                            .youtubeLink,
                                                        postCreator:
                                                            currentPosts[index]
                                                                .creator,
                                                        postGroup: currentPosts[index]
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
                                                    commentController.clear();
                                                    _pullRefresh();
                                                  },
                                                  viewCommentFunction: () {
                                                    Get.to(() => FullScreenPage(
                                                            index: 0,
                                                            post: currentPosts[
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
                                                              homePageController.addComment(Comment(
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
                                                                  commentText:
                                                                      commentController
                                                                          .text,
                                                                  addedTime:
                                                                      DateTime
                                                                          .now()));
                                                              commentController
                                                                  .clear();
                                                            }))!
                                                        .then((value) =>
                                                            _pullRefresh());
                                                  },
                                                ),
                                              );
                                      })),

                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
