import 'package:choof_app/screens/add_group_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/landing_page_controller.dart';
import '../models/profile.dart';
import '../controllers/your_group_controller.dart';
import '../utils/app_constant.dart';
import 'view_group.dart';

class YourGroupsPage extends StatefulWidget {
  final bool isFirstTime;
  const YourGroupsPage({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<YourGroupsPage> createState() => _YourGroupsPageState();
}

class _YourGroupsPageState extends State<YourGroupsPage> {
  final yourGroupsController = Get.find<YourGroupController>();
  final landingPagecontroller = Get.find<LandingPageController>();

  final tagName = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.isFirstTime) {
      yourGroupsController.getGroupsData();
    }

    super.initState();
  }

  Future<void> _pullRefresh() async {
    yourGroupsController.refreshGroups();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(50, 50),
        child: Obx(() => landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : landingPagecontroller.tabIndex.value == 1
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
                      'Groups',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.to(() => const AddGroupPage(
                                      isFromFavPage: false,
                                      index: 1,
                                    ))!
                                .then((value) => _pullRefresh());
                          },
                          icon: Image.asset(
                            'assets/icons/FriendsAdd.png',
                            width: 30,
                            height: 30,
                          ))
                    ],
                    elevation: 0.0,
                  )
                : Container(
                    height: MediaQuery.of(context).padding.top,
                    color: const Color(mainBgColor),
                  )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
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
                      child: RefresherWidget(
                        controller: _refreshController,
                        pullrefreshFunction: _pullRefresh,
                        onLoadingFunction: () {
                          if (yourGroupsController.allGroups.length -
                                  yourGroupsController.groupLimit.value >
                              0) {
                            if (yourGroupsController.allGroups.length -
                                    yourGroupsController.groupLimit.value <=
                                15) {
                              yourGroupsController.setGroupLimit(
                                  yourGroupsController.allGroups.length);
                            } else {
                              yourGroupsController.addGroupLimit();
                            }
                            _refreshController.loadComplete();
                          } else {
                            yourGroupsController.setGroupLimit(
                                yourGroupsController.allGroups.length);
                            _refreshController.loadNoData();
                          }
                        },
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
                                      yourGroupsController.selectProfile('all');
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
                                                  border: yourGroupsController
                                                              .selectedFriend
                                                              .value ==
                                                          'all'
                                                      ? Border.all(
                                                          color: const Color(
                                                              mainColor),
                                                          width: 2.0)
                                                      : Border.all(
                                                          color: Colors.white),
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
                                                  color: yourGroupsController
                                                              .selectedFriend
                                                              .value ==
                                                          'all'
                                                      ? const Color(mainColor)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.bold),
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
                                    yourGroupsController.selectProfile(
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
                                                border: yourGroupsController
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
                                                color: yourGroupsController
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
                                    in yourGroupsController.owners) {
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
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: creators.length,
                                        itemBuilder: (context, index) {
                                          return Obx(() => InkWell(
                                                onTap: () {
                                                  yourGroupsController
                                                      .selectProfile(
                                                          creators[index].name);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: yourGroupsController
                                                                              .selectedFriend
                                                                              .value ==
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
                                                          creators[index].name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: yourGroupsController
                                                                          .selectedFriend
                                                                          .value ==
                                                                      creators[
                                                                              index]
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
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Main View
            Expanded(
              child: Container(
                width: landingPagecontroller.isDeviceTablet.value
                    ? MediaQuery.of(context).size.width * 2 / 3
                    : MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RefresherWidget(
                  controller: _refreshController,
                  pullrefreshFunction: _pullRefresh,
                  onLoadingFunction: () {
                    if (yourGroupsController.allGroups.length -
                            yourGroupsController.groupLimit.value >
                        0) {
                      if (yourGroupsController.allGroups.length -
                              yourGroupsController.groupLimit.value <=
                          15) {
                        yourGroupsController.setGroupLimit(
                            yourGroupsController.allGroups.length);
                      } else {
                        yourGroupsController.addGroupLimit();
                      }
                      _refreshController.loadComplete();
                    } else {
                      yourGroupsController
                          .setGroupLimit(yourGroupsController.allGroups.length);
                      _refreshController.loadNoData();
                    }
                  },
                  child: ListView(
                    children: [
                      Obx(
                        () => landingPagecontroller.isDeviceTablet.value
                            ? Row(
                                children: [
                                  const Expanded(
                                      child: Center(
                                    child: Text(
                                      'Groups',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(() => const AddGroupPage(
                                                  isFromFavPage: false,
                                                  index: 1,
                                                ))!
                                            .then((value) => _pullRefresh());
                                      },
                                      icon: Image.asset(
                                        'assets/icons/FriendsAdd.png',
                                        width: 30,
                                        height: 30,
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                height:
                                    MediaQuery.of(context).size.height / 9.8,
                                child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      // All Profiles
                                      Obx((() => InkWell(
                                            onTap: () {
                                              yourGroupsController
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
                                                isSelected: yourGroupsController
                                                        .selectedFriend.value ==
                                                    'all',
                                              ),
                                            ),
                                          ))),
                                      // My Profile
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            yourGroupsController.selectProfile(
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
                                              isSelected: yourGroupsController
                                                      .selectedFriend.value ==
                                                  landingPagecontroller
                                                      .userProfile.value.name,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Rest of the creators
                                      Obx(() {
                                        List<Profile> owners = [];
                                        for (var owner
                                            in yourGroupsController.owners) {
                                          if (owner.name.trim() !=
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
                                                      owner.name.trim())) {
                                                owners.add(owner);
                                              }
                                            } else {
                                              owners.add(owner);
                                            }
                                          }
                                        }
                                        return owners.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: owners.length,
                                                itemBuilder: (context, index) {
                                                  return Obx(() => InkWell(
                                                        onTap: () {
                                                          yourGroupsController
                                                              .selectProfile(
                                                                  owners[index]
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
                                                            name: owners[index]
                                                                .name,
                                                            imageUrl:
                                                                owners[index]
                                                                    .imageUrl,
                                                            size: 60,
                                                            isSelected:
                                                                yourGroupsController
                                                                        .selectedFriend
                                                                        .value ==
                                                                    owners[index]
                                                                        .name,
                                                          ),
                                                        ),
                                                      ));
                                                })
                                            : const SizedBox.shrink();
                                      })
                                    ]),
                              ),
                      ),

                      // Filter tag
                      Container(
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width / 1.05,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            } else {
                              return yourGroupsController.allTags
                                  .where((String option) {
                                return option.trim().toLowerCase().startsWith(
                                    textEditingValue.text.trim().toLowerCase());
                              });
                            }
                          },
                          optionsViewBuilder:
                              (context, Function(String) onSelected, options) {
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
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(
                                          option.toString().trim(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          yourGroupsController.addTags(
                                              option.toString().trim());
                                          yourGroupsController.tagName.clear();
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
                            yourGroupsController
                                .addTags(selectedString.toString().trim());
                            yourGroupsController.tagName.clear();
                            FocusScope.of(context).unfocus();
                          },
                          fieldViewBuilder: (context, controller, focusNode,
                              onEditingComplete) {
                            yourGroupsController.tagName = controller;

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
                                        yourGroupsController
                                            .addTags(element.trim());
                                      });
                                    } else {
                                      yourGroupsController
                                          .addTags(value.trim());
                                    }
                                  }
                                  yourGroupsController.tagName.clear();
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
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: const Color(bgColor),
                                    hintText: 'Filter by tag',
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        yourGroupsController.setFilterOn();
                                      },
                                      child: const Icon(
                                        Icons.search,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        yourGroupsController.tagName.clear();
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
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Obx(() => yourGroupsController.sortByRecent.value
                                ? InkWell(
                                    onTap: () {
                                      yourGroupsController.sort(false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height:
                                          MediaQuery.of(context).size.height /
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
                                            'Last Updated',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      yourGroupsController.sort(true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height:
                                          MediaQuery.of(context).size.height /
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            // Show Filtered tags
                            Obx(
                              () => yourGroupsController.filteredTags.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: yourGroupsController
                                          .filteredTags.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    30,
                                                decoration: const BoxDecoration(
                                                    color: Color(bgColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Center(
                                                  child: Text(
                                                    yourGroupsController
                                                        .filteredTags[index],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  yourGroupsController
                                                      .removeTag(
                                                          yourGroupsController
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

                      // group Cards
                      Obx(() => !yourGroupsController.loaded.value
                          ? const Center(child: CircularProgressIndicator())
                          : !yourGroupsController.isFilter.value
                              ?
                              // NO filter
                              yourGroupsController.groups.isEmpty
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
                                                      isFromFavPage: false,
                                                      index: 1,
                                                    ))!
                                                .then(
                                                    (value) => _pullRefresh());
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
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: List.generate(
                                          yourGroupsController.groups.length,
                                          (index) => InkWell(
                                              onTap: () {
                                                Get.to(() => ViewGroup(
                                                          index: 1,
                                                          currentGroup:
                                                              yourGroupsController
                                                                      .groups[
                                                                  index],
                                                          isFromGroup: true,
                                                          isFromFullScreenPage:
                                                              false,
                                                          isFromAddGroup: false,
                                                        ))!
                                                    .then((value) =>
                                                        _pullRefresh());
                                              },
                                              child: landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .blockedUsers !=
                                                      null
                                                  ? landingPagecontroller
                                                          .userProfile
                                                          .value
                                                          .blockedUsers!
                                                          .contains(
                                                              yourGroupsController
                                                                  .groups[index]
                                                                  .owner)
                                                      ? const SizedBox.shrink()
                                                      : GroupWidget(
                                                          group:
                                                              yourGroupsController
                                                                      .groups[
                                                                  index],
                                                        )
                                                  : GroupWidget(
                                                      group:
                                                          yourGroupsController
                                                              .groups[index],
                                                    )),
                                        ),
                                      ),
                                    )
                              : yourGroupsController.filteredTagResult.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No Result Found',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: List.generate(
                                          yourGroupsController
                                              .filteredTagResult.length,
                                          (index) => InkWell(
                                            onTap: () {
                                              Get.to(() => ViewGroup(
                                                        index: 1,
                                                        currentGroup:
                                                            yourGroupsController
                                                                    .filteredTagResult[
                                                                index],
                                                        isFromGroup: true,
                                                        isFromFullScreenPage:
                                                            false,
                                                        isFromAddGroup: false,
                                                      ))!
                                                  .then((value) =>
                                                      _pullRefresh());
                                            },
                                            child: landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .blockedUsers !=
                                                    null
                                                ? landingPagecontroller
                                                        .userProfile
                                                        .value
                                                        .blockedUsers!
                                                        .contains(
                                                            yourGroupsController
                                                                .groups[index]
                                                                .owner)
                                                    ? const SizedBox.shrink()
                                                    : GroupWidget(
                                                        group: yourGroupsController
                                                                .filteredTagResult[
                                                            index],
                                                      )
                                                : GroupWidget(
                                                    group: yourGroupsController
                                                            .filteredTagResult[
                                                        index],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )),

                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
