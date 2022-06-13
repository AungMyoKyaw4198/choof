import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/search_video_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/edit_video_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../models/post.dart';
import '../utils/app_constant.dart';
import 'widgets/shared_widgets.dart';

class EditFavoritePage extends StatefulWidget {
  final int index;
  final Post post;
  final bool isFromGroup;
  const EditFavoritePage(
      {Key? key,
      required this.index,
      required this.post,
      required this.isFromGroup})
      : super(key: key);

  @override
  State<EditFavoritePage> createState() => _EditFavoritePageState();
}

class _EditFavoritePageState extends State<EditFavoritePage> {
  final editVideoController = Get.put(EditVideoController());
  final landingPagecontroller = Get.find<LandingPageController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    editVideoController.setInitialPost(widget.post);
    super.initState();
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
                      title: const Text(
                        'Edit Favorite',
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
        body: Obx(() => IndexedStack(
              index: landingPagecontroller.tabIndex.value,
              children: [
                widget.isFromGroup
                    ? const FavouritePage(isFirstTime: false)
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
                                                'Edit Favorites',
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
                                height: 20,
                              ),
                              Text(
                                "Group : ${editVideoController.post.value.groupName.contains('#') ? editVideoController.post.value.groupName.substring(0, editVideoController.post.value.groupName.indexOf('#')) : editVideoController.post.value.groupName}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Show Group owner
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  editVideoController.post.value
                                                      .creatorImageUrl)))),
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
                                    editVideoController.post.value.creator,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Post Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: editVideoController.postName,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: ''' “Enter Post Name”''',
                                    fillColor: Colors.white70,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        editVideoController.postName.clear();
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Youtube Link',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          editVideoController.youtubeLink,
                                      enableInteractiveSelection: true,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "Paste the link here",
                                          fillColor: Colors.white70,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              editVideoController.youtubeLink
                                                  .clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
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
                                        bool isYoutubeLink = editVideoController
                                            .checkYoutubeLink(
                                                editVideoController
                                                    .youtubeLink.text);
                                        if (isYoutubeLink) {
                                          editVideoController
                                              .verifyYoutubeLink();
                                        } else {
                                          Get.to(() => SearchVideoPage(
                                                searchedWord:
                                                    editVideoController
                                                        .youtubeLink.text,
                                                isFromAddVideo: false,
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
                              const SizedBox(
                                height: 10,
                              ),
                              // Show Thumbnail
                              Obx(
                                () => editVideoController.isVerify.isTrue
                                    ? Image.network(
                                        editVideoController
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
                                height: 20,
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
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: TextField(
                                      controller: editVideoController.tagName,
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          // Split if input contains ,
                                          if (value.contains(',')) {
                                            List<String> splitedString =
                                                value.split(',');
                                            splitedString.forEach((element) {
                                              editVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editVideoController
                                                .addTags(value.trim());
                                          }
                                        }
                                        editVideoController.tagName.clear();
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText:
                                              ''' “At least one tag (food, music, etc.)”''',
                                          fillColor: Colors.white70,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              editVideoController.tagName
                                                  .clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (editVideoController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (editVideoController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                editVideoController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              editVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editVideoController.addTags(
                                                editVideoController.tagName.text
                                                    .trim());
                                          }
                                        }
                                        editVideoController.tagName.clear();
                                      },
                                      icon: Image.asset(
                                        'assets/icons/AddTag.png',
                                        width: 30,
                                        height: 30,
                                      ))
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              // Added Tags
                              Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Obx(
                                  () => editVideoController.tagList.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: editVideoController
                                              .tagList.length,
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
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                    child: Text(
                                                      editVideoController
                                                          .tagList[index],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      editVideoController
                                                          .removeTag(
                                                              editVideoController
                                                                      .tagList[
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
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (editVideoController
                                            .tagList.isEmpty) {
                                          Get.dialog(tagEmptyDialog());
                                        } else {
                                          editVideoController.editVideo(
                                              isFromFavPage:
                                                  !widget.isFromGroup);
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
                      ),

                // ---------- EditPage --------------
                widget.isFromGroup
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
                                                'Edit Favorites',
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
                                height: 20,
                              ),
                              Text(
                                "Group : ${editVideoController.post.value.groupName.contains('#') ? editVideoController.post.value.groupName.substring(0, editVideoController.post.value.groupName.indexOf('#')) : editVideoController.post.value.groupName}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Show Group owner
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  editVideoController.post.value
                                                      .creatorImageUrl)))),
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
                                    editVideoController.post.value.creator,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Post Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: editVideoController.postName,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: ''' “Enter Post Name”''',
                                    fillColor: Colors.white70,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        editVideoController.postName.clear();
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Youtube Link',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          editVideoController.youtubeLink,
                                      enableInteractiveSelection: true,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText: "Paste the link here",
                                          fillColor: Colors.white70,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              editVideoController.youtubeLink
                                                  .clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
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
                                        bool isYoutubeLink = editVideoController
                                            .checkYoutubeLink(
                                                editVideoController
                                                    .youtubeLink.text);
                                        if (isYoutubeLink) {
                                          editVideoController
                                              .verifyYoutubeLink();
                                        } else {
                                          Get.to(() => SearchVideoPage(
                                                searchedWord:
                                                    editVideoController
                                                        .youtubeLink.text,
                                                isFromAddVideo: false,
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
                              const SizedBox(
                                height: 10,
                              ),
                              // Show Thumbnail
                              Obx(
                                () => editVideoController.isVerify.isTrue
                                    ? Image.network(
                                        editVideoController
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
                                height: 20,
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
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: TextField(
                                      controller: editVideoController.tagName,
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          // Split if input contains ,
                                          if (value.contains(',')) {
                                            List<String> splitedString =
                                                value.split(',');
                                            splitedString.forEach((element) {
                                              editVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editVideoController
                                                .addTags(value.trim());
                                          }
                                        }
                                        editVideoController.tagName.clear();
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[800]),
                                          hintText:
                                              ''' “At least one tag (food, music, etc.)”''',
                                          fillColor: Colors.white70,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              editVideoController.tagName
                                                  .clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (editVideoController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (editVideoController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                editVideoController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              editVideoController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editVideoController.addTags(
                                                editVideoController.tagName.text
                                                    .trim());
                                          }
                                        }
                                        editVideoController.tagName.clear();
                                      },
                                      icon: Image.asset(
                                        'assets/icons/AddTag.png',
                                        width: 30,
                                        height: 30,
                                      ))
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              // Added Tags
                              Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Obx(
                                  () => editVideoController.tagList.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: editVideoController
                                              .tagList.length,
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
                                                                Radius.circular(
                                                                    30))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 20),
                                                    child: Text(
                                                      editVideoController
                                                          .tagList[index],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      editVideoController
                                                          .removeTag(
                                                              editVideoController
                                                                      .tagList[
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
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (editVideoController
                                            .tagList.isEmpty) {
                                          Get.dialog(tagEmptyDialog());
                                        } else {
                                          editVideoController.editVideo(
                                              isFromFavPage:
                                                  !widget.isFromGroup);
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

                // ----------------------------------
                SettingsPage(),
              ],
            )));
  }
}
