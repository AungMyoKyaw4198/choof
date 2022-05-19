import 'package:choof_app/screens/settings_page.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_group_controller.dart';
import '../controllers/landing_page_controller.dart';
import 'favourite_page.dart';

class AddGroupPage extends StatelessWidget {
  AddGroupPage({Key? key}) : super(key: key);

  final addGroupController = Get.put(AddGroupContoller());
  final landingPagecontroller = Get.find<LandingPageController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(bgColor),
        centerTitle: true,
        title: const Text(
          'Add Group',
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
              const FavouritePage(),
              //  Addd Group Page---------------- //
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(mainBgColor),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 50,
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
                          controller: addGroupController.groupName,
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
                                  addGroupController.groupName.clear();
                                },
                                icon: const Icon(Icons.close_rounded),
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            child: TextFormField(
                              controller: addGroupController.tagName,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText:
                                      ''' “At least one tag (food, music, etc.)”''',
                                  fillColor: Colors.white70,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      addGroupController.tagName.clear();
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
                                      addGroupController
                                          .addTags(element.trim());
                                    });
                                  } else {
                                    addGroupController.addTags(value.trim());
                                  }
                                }
                                addGroupController.tagName.clear();
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
                                        addGroupController.tagName.text);
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

                      const SizedBox(
                        height: 10,
                      ),

                      // Added Tags
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(
                          () => addGroupController.tags.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: addGroupController.tags.length,
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
                                                        Radius.circular(30))),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Text(
                                              addGroupController.tags[index],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              addGroupController.removeTag(
                                                  addGroupController
                                                      .tags[index]);
                                            },
                                            child: const Align(
                                                alignment: Alignment.topLeft,
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
                                if (addGroupController.tags.isEmpty) {
                                  Get.dialog(tagEmptyDialog());
                                } else {
                                  addGroupController.addGroup();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: const BoxDecoration(
                                  color: Color(mainColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
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
            ]),
      ),
    );
  }
}
