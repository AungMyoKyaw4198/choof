import 'package:choof_app/models/group.dart';
import 'package:choof_app/screens/favourite_page.dart';
import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_group_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../utils/app_constant.dart';

class EditGroupPage extends StatefulWidget {
  final int index;
  final Group currentGroup;
  const EditGroupPage(
      {Key? key, required this.index, required this.currentGroup})
      : super(key: key);

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final editGroupController = Get.put(EditGroupContoller());
  final landingPagecontroller = Get.find<LandingPageController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    List<String> tags = [];
    editGroupController.setInitialGroupName(widget.currentGroup.name);
    widget.currentGroup.tags.forEach((element) {
      tags.add(element.trim());
    });
    editGroupController.setInitialValue(
        widget.currentGroup.name.contains('#')
            ? widget.currentGroup.name
                .substring(0, widget.currentGroup.name.indexOf('#'))
            : widget.currentGroup.name,
        tags);
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
            : landingPagecontroller.tabIndex.value == widget.index
                ? AppBar(
                    backgroundColor: const Color(bgColor),
                    centerTitle: true,
                    title: const Text(
                      'Edit Group',
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
      body: Obx(() {
        return IndexedStack(
          index: landingPagecontroller.tabIndex.value,
          children: [
            widget.index == 0
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
                                            'Edit Group',
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
                            child: TextFormField(
                              controller: editGroupController.groupName,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Type in group name",
                                  fillColor: Colors.white70,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      editGroupController.groupName.clear();
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.25,
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
                                            .contains(textEditingValue.text
                                                .trim()
                                                .toLowerCase());
                                      });
                                    }
                                  },
                                  optionsViewBuilder: (context,
                                      Function(String) onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(option.toString()),
                                            onTap: () {
                                              editGroupController.addTags(
                                                  option.toString().trim());
                                              editGroupController.tagName
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) {
                                    editGroupController.addTags(
                                        selectedString.toString().trim());
                                    editGroupController.tagName.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    editGroupController.tagName = controller;

                                    return TextField(
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
                                              editGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editGroupController
                                                .addTags(value.trim());
                                          }
                                        }
                                        editGroupController.tagName.clear();
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
                                              controller.clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (editGroupController
                                        .tagName.text.isNotEmpty) {
                                      // Split if input contains ,
                                      if (editGroupController.tagName.text
                                          .contains(',')) {
                                        List<String> splitedString =
                                            editGroupController.tagName.text
                                                .split(',');
                                        for (var element in splitedString) {
                                          editGroupController
                                              .addTags(element.trim());
                                        }
                                      } else {
                                        editGroupController.addTags(
                                            editGroupController.tagName.text
                                                .trim());
                                      }
                                    }
                                    editGroupController.tagName.clear();
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Obx(
                              () => editGroupController.tags.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          editGroupController.tags.length,
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
                                                  editGroupController
                                                      .tags[index],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  editGroupController.removeTag(
                                                      editGroupController
                                                          .tags[index]);
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
                                    if (editGroupController.tags.isEmpty) {
                                      Get.dialog(tagEmptyDialog());
                                    } else {
                                      if (editGroupController
                                          .tagName.text.isNotEmpty) {
                                        // Split if input contains ,
                                        if (editGroupController.tagName.text
                                            .contains(',')) {
                                          List<String> splitedString =
                                              editGroupController.tagName.text
                                                  .split(',');
                                          for (var element in splitedString) {
                                            editGroupController
                                                .addTags(element.trim());
                                          }
                                        } else {
                                          editGroupController.addTags(
                                              editGroupController.tagName.text
                                                  .trim());
                                        }
                                      }
                                      editGroupController
                                          .editGroup(widget.currentGroup);
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
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          IconButton(
                              onPressed: () {
                                editGroupController
                                    .deleteGroup(widget.currentGroup);
                              },
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/Remove.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Delete group',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                : const FavouritePage(isFirstTime: false),
            widget.index == 1
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
                                            'Edit Group',
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
                            child: TextFormField(
                              controller: editGroupController.groupName,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "Type in group name",
                                  fillColor: Colors.white70,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      editGroupController.groupName.clear();
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.25,
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
                                            .contains(textEditingValue.text
                                                .trim()
                                                .toLowerCase());
                                      });
                                    }
                                  },
                                  optionsViewBuilder: (context,
                                      Function(String) onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(option.toString()),
                                            onTap: () {
                                              editGroupController.addTags(
                                                  option.toString().trim());
                                              editGroupController.tagName
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) {
                                    editGroupController.addTags(
                                        selectedString.toString().trim());
                                    editGroupController.tagName.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    editGroupController.tagName = controller;

                                    return TextField(
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
                                              editGroupController
                                                  .addTags(element.trim());
                                            });
                                          } else {
                                            editGroupController
                                                .addTags(value.trim());
                                          }
                                        }
                                        editGroupController.tagName.clear();
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
                                              controller.clear();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                          )),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (editGroupController
                                        .tagName.text.isNotEmpty) {
                                      // Split if input contains ,
                                      if (editGroupController.tagName.text
                                          .contains(',')) {
                                        List<String> splitedString =
                                            editGroupController.tagName.text
                                                .split(',');
                                        for (var element in splitedString) {
                                          editGroupController
                                              .addTags(element.trim());
                                        }
                                      } else {
                                        editGroupController.addTags(
                                            editGroupController.tagName.text
                                                .trim());
                                      }
                                    }
                                    editGroupController.tagName.clear();
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Obx(
                              () => editGroupController.tags.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          editGroupController.tags.length,
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
                                                  editGroupController
                                                      .tags[index],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  editGroupController.removeTag(
                                                      editGroupController
                                                          .tags[index]);
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
                                    if (editGroupController.tags.isEmpty) {
                                      Get.dialog(tagEmptyDialog());
                                    } else {
                                      if (editGroupController
                                          .tagName.text.isNotEmpty) {
                                        // Split if input contains ,
                                        if (editGroupController.tagName.text
                                            .contains(',')) {
                                          List<String> splitedString =
                                              editGroupController.tagName.text
                                                  .split(',');
                                          for (var element in splitedString) {
                                            editGroupController
                                                .addTags(element.trim());
                                          }
                                        } else {
                                          editGroupController.addTags(
                                              editGroupController.tagName.text
                                                  .trim());
                                        }
                                      }
                                      editGroupController
                                          .editGroup(widget.currentGroup);
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
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          IconButton(
                              onPressed: () {
                                editGroupController
                                    .deleteGroup(widget.currentGroup);
                              },
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/Remove.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Delete group',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                : const YourGroupsPage(isFirstTime: false),
            SettingsPage()
          ],
        );
      }),
    );
  }
}
