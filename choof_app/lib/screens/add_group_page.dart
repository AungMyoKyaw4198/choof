import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:choof_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_group_controller.dart';
import '../controllers/landing_page_controller.dart';
import 'favourite_page.dart';

class AddGroupPage extends StatefulWidget {
  final int index;
  final bool isFromFavPage;
  const AddGroupPage(
      {Key? key, required this.index, required this.isFromFavPage})
      : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final addGroupController = Get.put(AddGroupContoller());

  final landingPagecontroller = Get.find<LandingPageController>();

  final _formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  @override
  void initState() {
    addGroupController.groupName.clear();
    addGroupController.tagName.clear();
    addGroupController.clearTags();
    landingPagecontroller.incrementBackIndex();
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
                    elevation: 0.0,
                    title: widget.index == landingPagecontroller.tabIndex.value
                        ? const Text(
                            'Add Group',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                : Container(
                    height: MediaQuery.of(context).padding.top,
                    color: const Color(mainBgColor),
                  )),
      ),
      // Bottom Navigation
      bottomNavigationBar: Obx(() {
        return landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : BottomMenu(deactivatedIndex: widget.index);
      }),
      body: Obx(() {
        return IndexedStack(
            index: landingPagecontroller.tabIndex.value,
            children: [
              widget.isFromFavPage
                  ? Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: const Color(mainBgColor),
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
                                              'Add Group',
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
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Add Group name
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                controller: addGroupController.groupName,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    hintText: "Type in group name",
                                    fillColor: const Color(bgColor),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        addGroupController.groupName.clear();
                                      },
                                      child: const Icon(Icons.close_rounded),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Tags',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Add tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Autocomplete(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        } else {
                                          return landingPagecontroller.autoTags
                                              .where((String option) {
                                            return option
                                                .trim()
                                                .toLowerCase()
                                                .startsWith(textEditingValue
                                                    .text
                                                    .trim()
                                                    .toLowerCase());
                                          });
                                        }
                                      },
                                      optionsViewBuilder: (context,
                                          Function(String) onSelected,
                                          options) {
                                        return Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            color: const Color(bgColor),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(4.0)),
                                            ),
                                            elevation: 4,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
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
                                                      addGroupController
                                                          .addTags(option
                                                              .toString()
                                                              .trim());
                                                      addGroupController.tagName
                                                          .clear();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                itemCount: options.length,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      onSelected: (selectedString) {
                                        addGroupController.addTags(
                                            selectedString.toString().trim());
                                        addGroupController.tagName.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      fieldViewBuilder: (context, controller,
                                          focusNode, onEditingComplete) {
                                        addGroupController.tagName = controller;

                                        return TextField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              // Split if input contains ,
                                              if (value.contains(',')) {
                                                List<String> splitedString =
                                                    value.split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addGroupController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addGroupController
                                                    .addTags(value.trim());
                                              }
                                            }
                                            addGroupController.tagName.clear();
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
                                                  controller.clear();
                                                },
                                                child: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (addGroupController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addGroupController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addGroupController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addGroupController.addTags(
                                                addGroupController
                                                    .tagName.text);
                                          }
                                        }
                                        addGroupController.tagName.clear();
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
                              height: 20,
                            ),

                            // Added Tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Obx(
                                () => addGroupController.tags.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            addGroupController.tags.length,
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
                                                    addGroupController
                                                        .tags[index],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    addGroupController
                                                        .removeTag(
                                                            addGroupController
                                                                .tags[index]);
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
                                      if (addGroupController.tags.isEmpty) {
                                        // Get.dialog(tagEmptyDialog());
                                        addGroupController.addTags(
                                            addGroupController.groupName.text);
                                        addGroupController.addGroup(
                                            widget.index,
                                            !widget.isFromFavPage);
                                        addGroupController.tagName.clear();
                                      } else {
                                        if (addGroupController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addGroupController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addGroupController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addGroupController.addTags(
                                                addGroupController
                                                    .tagName.text);
                                          }
                                        }

                                        addGroupController.addGroup(
                                            widget.index,
                                            !widget.isFromFavPage);
                                        addGroupController.tagName.clear();
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
                                      'Add Group',
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
                  : const FavouritePage(
                      isFirstTime: false,
                    ),
              //  Addd Group Page---------------- //
              widget.isFromFavPage
                  ? const YourGroupsPage(
                      isFirstTime: false,
                    )
                  : Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: const Color(mainBgColor),
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
                                              'Add Group',
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
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Add Group name
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                controller: addGroupController.groupName,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
                                    hintText: "Type in group name",
                                    fillColor: const Color(bgColor),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        addGroupController.groupName.clear();
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Tags',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Add tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Autocomplete(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        } else {
                                          return landingPagecontroller.autoTags
                                              .where((String option) {
                                            return option
                                                .trim()
                                                .toLowerCase()
                                                .startsWith(textEditingValue
                                                    .text
                                                    .trim()
                                                    .toLowerCase());
                                          });
                                        }
                                      },
                                      optionsViewBuilder: (context,
                                          Function(String) onSelected,
                                          options) {
                                        return Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            color: const Color(bgColor),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(4.0)),
                                            ),
                                            elevation: 4,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
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
                                                      addGroupController
                                                          .addTags(option
                                                              .toString()
                                                              .trim());
                                                      addGroupController.tagName
                                                          .clear();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                itemCount: options.length,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      onSelected: (selectedString) {
                                        addGroupController.addTags(
                                            selectedString.toString().trim());
                                        addGroupController.tagName.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      fieldViewBuilder: (context, controller,
                                          focusNode, onEditingComplete) {
                                        addGroupController.tagName = controller;

                                        return TextField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              // Split if input contains ,
                                              if (value.contains(',')) {
                                                List<String> splitedString =
                                                    value.split(',');
                                                splitedString
                                                    .forEach((element) {
                                                  addGroupController
                                                      .addTags(element.trim());
                                                });
                                              } else {
                                                addGroupController
                                                    .addTags(value.trim());
                                              }
                                            }
                                            addGroupController.tagName.clear();
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
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  controller.clear();
                                                },
                                                icon: const Icon(
                                                    Icons.close_rounded),
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (addGroupController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addGroupController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addGroupController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addGroupController.addTags(
                                                addGroupController
                                                    .tagName.text);
                                          }
                                        }
                                        addGroupController.tagName.clear();
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
                              height: 20,
                            ),

                            // Added Tags
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              child: Obx(
                                () => addGroupController.tags.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            addGroupController.tags.length,
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
                                                    addGroupController
                                                        .tags[index],
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    addGroupController
                                                        .removeTag(
                                                            addGroupController
                                                                .tags[index]);
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
                                      if (addGroupController.tags.isEmpty) {
                                        // Get.dialog(tagEmptyDialog());
                                        addGroupController.addTags(
                                            addGroupController.groupName.text);
                                        addGroupController.addGroup(
                                            widget.index,
                                            !widget.isFromFavPage);
                                        addGroupController.tagName.clear();
                                      } else {
                                        if (addGroupController
                                            .tagName.text.isNotEmpty) {
                                          // Split if input contains ,
                                          if (addGroupController.tagName.text
                                              .contains(',')) {
                                            List<String> splitedString =
                                                addGroupController.tagName.text
                                                    .split(',');
                                            splitedString.forEach((element) {
                                              addGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            addGroupController.addTags(
                                                addGroupController
                                                    .tagName.text);
                                          }
                                        }
                                        addGroupController.addGroup(
                                            widget.index,
                                            !widget.isFromFavPage);
                                        addGroupController.tagName.clear();
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
                                      'Add Group',
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
              // ---------------------------------- //
              SettingsPage(),
            ]);
      }),
    );
  }
}
