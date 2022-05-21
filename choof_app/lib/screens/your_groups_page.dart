import 'package:choof_app/screens/add_group_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
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
  const YourGroupsPage({Key? key}) : super(key: key);

  @override
  State<YourGroupsPage> createState() => _YourGroupsPageState();
}

class _YourGroupsPageState extends State<YourGroupsPage> {
  final controller = Get.find<YourGroupController>();
  final landingPagecontroller = Get.find<LandingPageController>();

  final tagName = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    controller.getGroupsData();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    controller.refreshGroups();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Get.to(() => AddGroupPage())!;
              },
              icon: Image.asset(
                'assets/icons/FriendsAdd.png',
                width: 30,
                height: 30,
              ))
        ],
        elevation: 0.0,
      ),
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
            if (controller.allGroups.length - controller.groupLimit.value > 0) {
              if (controller.allGroups.length - controller.groupLimit.value <=
                  15) {
                controller.setGroupLimit(controller.allGroups.length);
              } else {
                controller.addGroupLimit();
              }
              _refreshController.loadComplete();
            } else {
              controller.setGroupLimit(controller.allGroups.length);
              _refreshController.loadNoData();
            }
          },
          child: ListView(
            children: [
              // Profiles
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                height: MediaQuery.of(context).size.height / 9,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      // All Profiles
                      Obx((() => InkWell(
                            onTap: () {
                              controller.selectProfile('all');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ProfileVerticalWidget(
                                name: 'All',
                                imageUrl:
                                    'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                                size: 60,
                                isSelected:
                                    controller.selectedFriend.value == 'all',
                              ),
                            ),
                          ))),
                      // My Profile
                      Obx(
                        () => InkWell(
                          onTap: () {
                            controller.selectProfile(
                                landingPagecontroller.userProfile.value.name);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ProfileVerticalWidget(
                              name:
                                  landingPagecontroller.userProfile.value.name,
                              imageUrl: landingPagecontroller
                                  .userProfile.value.imageUrl,
                              size: 60,
                              isSelected: controller.selectedFriend.value ==
                                  landingPagecontroller.userProfile.value.name,
                            ),
                          ),
                        ),
                      ),
                      // Rest of the creators
                      Obx(() {
                        List<Profile> owners = [];
                        for (var owner in controller.owners) {
                          if (owner.name.trim() !=
                              landingPagecontroller.userProfile.value.name
                                  .trim()) {
                            if (landingPagecontroller
                                    .userProfile.value.blockedUsers !=
                                null) {
                              if (!landingPagecontroller
                                  .userProfile.value.blockedUsers!
                                  .contains(owner.name.trim())) {
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
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: owners.length,
                                itemBuilder: (context, index) {
                                  return Obx(() => InkWell(
                                        onTap: () {
                                          controller.selectProfile(
                                              owners[index].name);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ProfileVerticalWidget(
                                            name: owners[index].name,
                                            imageUrl: owners[index].imageUrl,
                                            size: 60,
                                            isSelected: controller
                                                    .selectedFriend.value ==
                                                owners[index].name,
                                          ),
                                        ),
                                      ));
                                })
                            : const SizedBox.shrink();
                      })
                    ]),
              ),
              ////
              const SizedBox(
                height: 5,
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
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: const EdgeInsets.all(10),
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
                                displayStringForOption: (c) => c.toString(),
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return controller.allTags
                                      .where((String option) {
                                    return option.trim().toLowerCase().contains(
                                        textEditingValue.text
                                            .trim()
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  controller.addTags(selection);
                                  tagName.clear();
                                  FocusScope.of(context).unfocus();
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
                      () => controller.filteredTags.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.filteredTags.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade800,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30))),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Text(
                                          controller.filteredTags[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.removeTag(
                                              controller.filteredTags[index]);
                                        },
                                        child: const Align(
                                            alignment: Alignment.topLeft,
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.white70,
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
              Obx(() => controller.sortByRecent.value
                  ? InkWell(
                      onTap: () {
                        controller.sort(false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              'Last Updated',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        controller.sort(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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

              // group Cards
              Obx(() => !controller.loaded.value
                  ? const Center(child: CircularProgressIndicator())
                  : !controller.isFilter.value
                      ?
                      // NO filter
                      controller.groups.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                ),
                                const Text(
                                  'Create a group',
                                  style: TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => AddGroupPage())!;
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: List.generate(
                                  controller.groups.length,
                                  (index) => InkWell(
                                      onTap: () {
                                        Get.to(() => ViewGroup(
                                                  currentGroup:
                                                      controller.groups[index],
                                                  isFromGroup: true,
                                                ))!
                                            .then((value) =>
                                                controller.refreshGroups());
                                      },
                                      child: landingPagecontroller.userProfile
                                                  .value.blockedUsers !=
                                              null
                                          ? landingPagecontroller.userProfile
                                                  .value.blockedUsers!
                                                  .contains(controller
                                                      .groups[index].owner)
                                              ? const SizedBox.shrink()
                                              : GroupWidget(
                                                  group:
                                                      controller.groups[index],
                                                )
                                          : GroupWidget(
                                              group: controller.groups[index],
                                            )),
                                ),
                              ),
                            )
                      : controller.filteredTagResult.isEmpty
                          ? const Center(
                              child: Text(
                                'No Result Found',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: List.generate(
                                  controller.filteredTagResult.length,
                                  (index) => InkWell(
                                    onTap: () {
                                      Get.to(() => ViewGroup(
                                                currentGroup: controller
                                                    .filteredTagResult[index],
                                                isFromGroup: true,
                                              ))!
                                          .then((value) =>
                                              controller.refreshGroups());
                                    },
                                    child: landingPagecontroller.userProfile
                                                .value.blockedUsers !=
                                            null
                                        ? landingPagecontroller
                                                .userProfile.value.blockedUsers!
                                                .contains(controller
                                                    .groups[index].owner)
                                            ? const SizedBox.shrink()
                                            : GroupWidget(
                                                group: controller
                                                    .filteredTagResult[index],
                                              )
                                        : GroupWidget(
                                            group: controller
                                                .filteredTagResult[index],
                                          ),
                                  ),
                                ),
                              ),
                            )),
            ],
          ),
        ),
      ),
    );
  }
}
