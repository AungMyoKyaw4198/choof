import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/add_video_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../models/group.dart';
import '../utils/app_constant.dart';
import 'favourite_page.dart';
import 'search_video_page.dart';
import 'widgets/shared_widgets.dart';

class AddVideoPage extends StatefulWidget {
  final Group group;
  final bool isFromFavPage;
  final bool isFromViewGroup;
  const AddVideoPage(
      {Key? key,
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
      appBar: AppBar(
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
      ),
      bottomNavigationBar: BottomMenu(),
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
                                const SizedBox(
                                  height: 20,
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
                                                  fontSize: 18),
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
                                                  child: Text(selectedType.name,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18)),
                                                  value: selectedType,
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        );
                                      })
                                    : Text(
                                        'Group : ${addVideoController.currentGroup.value.name}',
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
                                            addVideoController.youtubeLink,
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
                                                addVideoController.youtubeLink
                                                    .clear();
                                              },
                                              icon: const Icon(
                                                  Icons.close_rounded),
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
                                          addVideoController
                                              .verifyYoutubeLink();
                                        },
                                        icon: Image.asset(
                                          'assets/icons/AddLink.png',
                                          width: 30,
                                          height: 30,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          Get.to(() => const SearchVideoPage());
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.searchengin,
                                          color: Colors.white,
                                          size: 30,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
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
                                      child: TextFormField(
                                        controller: addVideoController.tagName,
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
                                                addVideoController.tagName
                                                    .clear();
                                              },
                                              icon: const Icon(
                                                  Icons.close_rounded),
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
                                                  addVideoController
                                                      .tagName.text
                                                      .split(',');
                                              splitedString.forEach((element) {
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

                                const SizedBox(
                                  height: 10,
                                ),
                                // Added Tags
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                                        addVideoController
                                                            .tagList[index],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Group : ${widget.group.name}',
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
                                            addVideoController.youtubeLink,
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
                                                addVideoController.youtubeLink
                                                    .clear();
                                              },
                                              icon: const Icon(
                                                  Icons.close_rounded),
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
                                          addVideoController
                                              .verifyYoutubeLink();
                                        },
                                        icon: Image.asset(
                                          'assets/icons/AddLink.png',
                                          width: 30,
                                          height: 30,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          Get.to(() => const SearchVideoPage());
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.searchengin,
                                          color: Colors.white,
                                          size: 30,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
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
                                      child: TextFormField(
                                        controller: addVideoController.tagName,
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
                                                addVideoController.tagName
                                                    .clear();
                                              },
                                              icon: const Icon(
                                                  Icons.close_rounded),
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
                                                  addVideoController
                                                      .tagName.text
                                                      .split(',');
                                              splitedString.forEach((element) {
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

                                const SizedBox(
                                  height: 10,
                                ),
                                // Added Tags
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                                        addVideoController
                                                            .tagList[index],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                  : const FavouritePage(),
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
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Group : ${widget.group.name}',
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
                                                widget.group.ownerImageUrl)))),
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
                                    controller: addVideoController.youtubeLink,
                                    enableInteractiveSelection: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        filled: true,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[800]),
                                        hintText: "Paste the link here",
                                        fillColor: Colors.white70,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            addVideoController.youtubeLink
                                                .clear();
                                          },
                                          icon: const Icon(Icons.close_rounded),
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
                                      addVideoController.verifyYoutubeLink();
                                    },
                                    icon: Image.asset(
                                      'assets/icons/AddLink.png',
                                      width: 30,
                                      height: 30,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Get.to(() => const SearchVideoPage());
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.searchengin,
                                      color: Colors.white,
                                      size: 30,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  child: TextFormField(
                                    controller: addVideoController.tagName,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        filled: true,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[800]),
                                        hintText:
                                            ''' “At least one tag (food, music, etc.)”''',
                                        fillColor: Colors.white70,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            addVideoController.tagName.clear();
                                          },
                                          icon: const Icon(Icons.close_rounded),
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

                            const SizedBox(
                              height: 10,
                            ),
                            // Added Tags
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade800,
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
                                                    addVideoController
                                                        .tagList[index],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                  : const YourGroupsPage(),
              //--------//
              SettingsPage(),
            ]),
      ),
    );
  }
}
