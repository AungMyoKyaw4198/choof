import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_video_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../models/group.dart';
import '../utils/app_constant.dart';
import 'favourite_page.dart';
import 'search_video_page.dart';
import 'widgets/shared_widgets.dart';

class AddVideoPage extends StatefulWidget {
  final int index;
  final Group group;
  final bool isFromFavPage;
  final bool isFromViewGroup;
  const AddVideoPage(
      {Key? key,
      required this.index,
      required this.group,
      required this.isFromFavPage,
      required this.isFromViewGroup})
      : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final addVideoController = Get.put(AddVideoContoller());
  final landingPagecontroller = Get.find<LandingPageController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    addVideoController.clearValue();
    if (widget.isFromFavPage) {
      addVideoController.getGroups();
    } else {
      addVideoController.setCurrentGroup(widget.group);
      addVideoController.setTags(widget.group.tags);
      addVideoController.setGroupName(widget.group.name);
      addVideoController.setGroupMembers(widget.group.members);
    }

    super.initState();
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
                                    color:
                                        landingPagecontroller.tabIndex.value ==
                                                0
                                            ? const Color(mainColor)
                                            : Colors.white),
                              ),
                              Image.asset(
                                'assets/icons/Favorite.png',
                                width: 50,
                                height: 50,
                                color: landingPagecontroller.tabIndex.value == 0
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
                                    color:
                                        landingPagecontroller.tabIndex.value ==
                                                1
                                            ? const Color(mainColor)
                                            : Colors.white),
                              ),
                              Image.asset(
                                'assets/icons/Users.png',
                                width: 50,
                                height: 50,
                                color: landingPagecontroller.tabIndex.value == 1
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
                                    color:
                                        landingPagecontroller.tabIndex.value ==
                                                2
                                            ? const Color(mainColor)
                                            : Colors.white),
                              ),
                              Image.asset(
                                'assets/icons/Settings.png',
                                width: 50,
                                height: 50,
                                color: landingPagecontroller.tabIndex.value == 2
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
                    title: const Text(
                      'Add Favorite',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    elevation: 0.0,
                  )
                : Container(
                    height: MediaQuery.of(context).padding.top,
                    color: const Color(mainBgColor),
                  )),
      ),
      // Bottom Navigation
      bottomNavigationBar: Obx(
        () => landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : BottomMenu(),
      ),
      body: Obx(
        () => IndexedStack(
            index: landingPagecontroller.tabIndex.value,
            children: [
              widget.isFromFavPage
                  ? !widget.isFromViewGroup
                      ? Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: const Color(mainBgColor),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView(
                              children: [
                                // Title
                                Obx(
                                  () => landingPagecontroller
                                          .isDeviceTablet.value
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'Add Favorites',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),

                                widget.isFromFavPage
                                    ? Obx(() {
                                        return Row(
                                          children: [
                                            const Text(
                                              'Group : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            DropdownButton<Group>(
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                              ),
                                              hint: const Text(
                                                'Select Group...',
                                              ),
                                              dropdownColor:
                                                  const Color(bgColor),
                                              onChanged: (newGroup) {
                                                addVideoController
                                                    .setCurrentGroup(newGroup!);
                                                addVideoController
                                                    .setTags(newGroup.tags);
                                                addVideoController.setGroupName(
                                                    newGroup.name);
                                                addVideoController
                                                    .setGroupMembers(
                                                        newGroup.members);
                                              },
                                              value: addVideoController
                                                  .currentGroup.value,
                                              items: addVideoController
                                                  .usergroupList
                                                  .map((selectedType) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                      selectedType.name
                                                              .contains('#')
                                                          ? selectedType.name
                                                              .substring(
                                                                  0,
                                                                  selectedType
                                                                      .name
                                                                      .indexOf(
                                                                          '#'))
                                                          : selectedType.name,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                  value: selectedType,
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        );
                                      })
                                    : Text(
                                        "Group : ${addVideoController.currentGroup.value.name.contains('#') ? addVideoController.currentGroup.value.name.substring(0, addVideoController.currentGroup.value.name.indexOf('#')) : addVideoController.currentGroup.value.name}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                // Show Group owner
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      addVideoController
                                                          .currentGroup
                                                          .value
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
                                        addVideoController
                                            .currentGroup.value.owner,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Youtube Link',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller:
                                              addVideoController.youtubeLink,
                                          enableInteractiveSelection: true,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white70),
                                              hintText:
                                                  "Seach title or paste link",
                                              fillColor: const Color(bgColor),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  addVideoController.youtubeLink
                                                      .clear();
                                                },
                                                child: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some words or link';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            bool isYoutubeLink =
                                                addVideoController
                                                    .checkYoutubeLink(
                                                        addVideoController
                                                            .youtubeLink.text);
                                            if (isYoutubeLink) {
                                              addVideoController
                                                  .verifyYoutubeLink();
                                            } else {
                                              Get.to(() => SearchVideoPage(
                                                    searchedWord:
                                                        addVideoController
                                                            .youtubeLink.text,
                                                    isFromAddVideo: true,
                                                  ));
                                            }
                                          },
                                          icon: Image.asset(
                                            'assets/icons/EmailSend.png',
                                            width: 30,
                                            height: 30,
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Show Thumbnail
                                Obx(
                                  () => addVideoController.isVerify.isTrue
                                      ? Image.network(
                                          addVideoController
                                              .youtubeThumbnail.string,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Colors.black,
                                          child: const Center(
                                            child: Text(
                                              "To get the link: on Youtube, click 'Share then 'Copy link.",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Tags',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Enter tags
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller:
                                              addVideoController.tagName,
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              // Split if input contains ,
                                              if (value.contains(',')) {
                                                List<String> splitedString =
                                                    value.split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addVideoController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addVideoController
                                                    .addTags(value.trim());
                                              }
                                            }
                                            addVideoController.tagName.clear();
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white70),
                                              hintText:
                                                  ''' “At least one tag (food, music, etc.)”''',
                                              fillColor: const Color(bgColor),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  addVideoController.tagName
                                                      .clear();
                                                },
                                                child: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (addVideoController
                                                .tagName.text.isNotEmpty) {
                                              // Split if input contains ,
                                              if (addVideoController
                                                  .tagName.text
                                                  .contains(',')) {
                                                List<String> splitedString =
                                                    addVideoController
                                                        .tagName.text
                                                        .split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addVideoController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addVideoController.addTags(
                                                    addVideoController
                                                        .tagName.text
                                                        .trim());
                                              }
                                            }
                                            addVideoController.tagName.clear();
                                          },
                                          icon: Image.asset(
                                            'assets/icons/AddTag.png',
                                            width: 30,
                                            height: 30,
                                          ))
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                // Added Tags
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Obx(
                                    () => addVideoController.tagList.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: addVideoController
                                                .tagList.length,
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
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20),
                                                      child: Text(
                                                        addVideoController
                                                            .tagList[index],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        addVideoController
                                                            .removeTag(
                                                                addVideoController
                                                                        .tagList[
                                                                    index]);
                                                      },
                                                      child: const Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: CircleAvatar(
                                                            radius: 8,
                                                            backgroundColor:
                                                                Colors.white70,
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
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
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        addVideoController.cancelAddVideo(
                                            isFromFavPage:
                                                widget.isFromFavPage);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (addVideoController
                                              .tagList.isEmpty) {
                                            Get.dialog(tagEmptyDialog());
                                          } else {
                                            addVideoController.addNewVideo(
                                                isFromFavPage:
                                                    widget.isFromFavPage);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        decoration: const BoxDecoration(
                                            color: Color(mainColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: const Color(mainBgColor),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView(
                              children: [
                                // Title
                                Obx(
                                  () =>
                                      landingPagecontroller.isDeviceTablet.value
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'Add Favorites',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Group : ${widget.group.name.contains('#') ? widget.group.name.substring(0, widget.group.name.indexOf('#')) : widget.group.name}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                // Show Group owner
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      addVideoController
                                                          .currentGroup
                                                          .value
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
                                        addVideoController
                                            .currentGroup.value.owner,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Youtube Link',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller:
                                              addVideoController.youtubeLink,
                                          enableInteractiveSelection: true,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white70),
                                              hintText:
                                                  "Seach title or paste link",
                                              fillColor: const Color(bgColor),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  addVideoController.youtubeLink
                                                      .clear();
                                                },
                                                child: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some words or link';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            bool isYoutubeLink =
                                                addVideoController
                                                    .checkYoutubeLink(
                                                        addVideoController
                                                            .youtubeLink.text);
                                            if (isYoutubeLink) {
                                              addVideoController
                                                  .verifyYoutubeLink();
                                            } else {
                                              Get.to(() => SearchVideoPage(
                                                    searchedWord:
                                                        addVideoController
                                                            .youtubeLink.text,
                                                    isFromAddVideo: true,
                                                  ));
                                            }
                                          },
                                          icon: Image.asset(
                                            'assets/icons/EmailSend.png',
                                            width: 30,
                                            height: 30,
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // Show Thumbnail
                                Obx(
                                  () => addVideoController.isVerify.isTrue
                                      ? Image.network(
                                          addVideoController
                                              .youtubeThumbnail.string,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Colors.black,
                                          child: const Center(
                                            child: Text(
                                              "To get the link: on Youtube, click 'Share then 'Copy link.",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Tags',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Enter tags
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        child: TextField(
                                          controller:
                                              addVideoController.tagName,
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              // Split if input contains ,
                                              if (value.contains(',')) {
                                                List<String> splitedString =
                                                    value.split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addVideoController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addVideoController
                                                    .addTags(value.trim());
                                              }
                                            }
                                            addVideoController.tagName.clear();
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              filled: true,
                                              hintStyle: const TextStyle(
                                                  color: Colors.white70),
                                              hintText:
                                                  ''' “At least one tag (food, music, etc.)”''',
                                              fillColor: const Color(bgColor),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  addVideoController.tagName
                                                      .clear();
                                                },
                                                child: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (addVideoController
                                                .tagName.text.isNotEmpty) {
                                              // Split if input contains ,
                                              if (addVideoController
                                                  .tagName.text
                                                  .contains(',')) {
                                                List<String> splitedString =
                                                    addVideoController
                                                        .tagName.text
                                                        .split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addVideoController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addVideoController.addTags(
                                                    addVideoController
                                                        .tagName.text
                                                        .trim());
                                              }
                                            }
                                            addVideoController.tagName.clear();
                                          },
                                          icon: Image.asset(
                                            'assets/icons/AddTag.png',
                                            width: 30,
                                            height: 30,
                                          ))
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                // Added Tags
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Obx(
                                    () => addVideoController.tagList.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: addVideoController
                                                .tagList.length,
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
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20),
                                                      child: Text(
                                                        addVideoController
                                                            .tagList[index],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        addVideoController
                                                            .removeTag(
                                                                addVideoController
                                                                        .tagList[
                                                                    index]);
                                                      },
                                                      child: const Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: CircleAvatar(
                                                            radius: 8,
                                                            backgroundColor:
                                                                Colors.white70,
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
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
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        addVideoController.cancelAddVideo(
                                            isFromFavPage:
                                                widget.isFromFavPage);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (addVideoController
                                              .tagList.isEmpty) {
                                            Get.dialog(tagEmptyDialog());
                                          } else {
                                            addVideoController.addNewVideo(
                                                isFromFavPage:
                                                    widget.isFromFavPage);
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        decoration: const BoxDecoration(
                                            color: Color(mainColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                  : const FavouritePage(isFirstTime: false),
              // Add Favorite Page -------------//
              !widget.isFromFavPage
                  ? Form(
                      key: _formKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: const Color(mainBgColor),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView(
                          children: [
                            // Title
                            Obx(
                              () => landingPagecontroller.isDeviceTablet.value
                                  ? Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Center(
                                            child: Text(
                                              'Add Favorites',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Group : ${widget.group.name.contains('#') ? widget.group.name.substring(0, widget.group.name.indexOf('#')) : widget.group.name}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            // Show Group owner
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(widget
                                                  .group.ownerImageUrl)))),
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
                                    widget.group.owner,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Youtube Link',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller:
                                          addVideoController.youtubeLink,
                                      enableInteractiveSelection: true,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: const TextStyle(
                                              color: Colors.white70),
                                          hintText:
                                              "Search a title or paste a link",
                                          fillColor: const Color(bgColor),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              addVideoController.youtubeLink
                                                  .clear();
                                            },
                                            child:
                                                const Icon(Icons.close_rounded),
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some link';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        bool isYoutubeLink = addVideoController
                                            .checkYoutubeLink(addVideoController
                                                .youtubeLink.text);
                                        if (isYoutubeLink) {
                                          addVideoController
                                              .verifyYoutubeLink();
                                        } else {
                                          Get.to(() => SearchVideoPage(
                                                searchedWord: addVideoController
                                                    .youtubeLink.text,
                                                isFromAddVideo: true,
                                              ));
                                        }
                                      },
                                      icon: Image.asset(
                                        'assets/icons/EmailSend.png',
                                        width: 30,
                                        height: 30,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // Show Thumbnail
                            Obx(
                              () => addVideoController.isVerify.isTrue
                                  ? Image.network(
                                      addVideoController
                                          .youtubeThumbnail.string,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: Colors.black,
                                      child: const Center(
                                        child: Text(
                                          "To get the link: on Youtube, click 'Share then 'Copy link.",
                                          style: TextStyle(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Tags',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Enter tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller: addVideoController.tagName,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: const TextStyle(
                                              color: Colors.white70),
                                          hintText:
                                              ''' “At least one tag (food, music, etc.)”''',
                                          fillColor: const Color(bgColor),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              addVideoController.tagName
                                                  .clear();
                                            },
                                            child:
                                                const Icon(Icons.close_rounded),
                                          )),
                                      onFieldSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          // Split if input contains ,
                                          if (value.contains(',')) {
                                            List<String> splitedString =
                                                value.split(',');
                                            splitedString.forEach((element) {
                                              addVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addVideoController
                                                .addTags(value.trim());
                                          }
                                        }
                                        addVideoController.tagName.clear();
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (addVideoController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addVideoController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addVideoController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addVideoController.addTags(
                                                addVideoController.tagName.text
                                                    .trim());
                                          }
                                        }
                                        addVideoController.tagName.clear();
                                      },
                                      icon: Image.asset(
                                        'assets/icons/AddTag.png',
                                        width: 30,
                                        height: 30,
                                      ))
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            // Added Tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Obx(
                                () => addVideoController.tagList.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            addVideoController.tagList.length,
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
                                                      20,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color(bgColor),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Text(
                                                    addVideoController
                                                        .tagList[index],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    addVideoController
                                                        .removeTag(
                                                            addVideoController
                                                                    .tagList[
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
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    addVideoController.cancelAddVideo(
                                        isFromFavPage: widget.isFromFavPage);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (addVideoController.tagList.isEmpty) {
                                        Get.dialog(tagEmptyDialog());
                                      } else {
                                        addVideoController.verifyYoutubeLink();
                                        if (addVideoController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addVideoController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addVideoController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addVideoController.addTags(
                                                addVideoController.tagName.text
                                                    .trim());
                                          }
                                        }
                                        if (addVideoController.isVerify.value) {
                                          addVideoController.addNewVideo(
                                              isFromFavPage:
                                                  widget.isFromFavPage);
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    decoration: const BoxDecoration(
                                        color: Color(mainColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : const YourGroupsPage(
                      isFirstTime: false,
                    ),
              //--------//
              SettingsPage(),
            ]),
      ),
    );
  }
}
