import 'package:choof_app/models/group.dart';
import 'package:choof_app/screens/view_group.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_group_controller.dart';
import '../utils/app_constant.dart';

class EditGroupPage extends StatefulWidget {
  final Group currentGroup;
  const EditGroupPage({Key? key, required this.currentGroup}) : super(key: key);

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final editGroupController = Get.put(EditGroupContoller());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    List<String> tags = [];

    widget.currentGroup.tags.forEach((element) {
      tags.add(element.trim());
    });
    editGroupController.setInitialValue(widget.currentGroup.name, tags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Form(
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
                      controller: editGroupController.tagName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "At least one tag(food, music, etc...)",
                          fillColor: Colors.white70,
                          suffixIcon: IconButton(
                            onPressed: () {
                              editGroupController.tagName.clear();
                            },
                            icon: const Icon(Icons.close_rounded),
                          )),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          // Split if input contains ,
                          if (value.contains(',')) {
                            List<String> splitedString = value.split(',');
                            for (var element in splitedString) {
                              editGroupController.addTags(element.trim());
                            }
                          } else {
                            editGroupController.addTags(value.trim());
                          }
                        }
                        editGroupController.tagName.clear();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (editGroupController.tagName.text.isNotEmpty) {
                          // Split if input contains ,
                          if (editGroupController.tagName.text.contains(',')) {
                            List<String> splitedString =
                                editGroupController.tagName.text.split(',');
                            for (var element in splitedString) {
                              editGroupController.addTags(element.trim());
                            }
                          } else {
                            editGroupController.addTags(
                                editGroupController.tagName.text.trim());
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
                          itemCount: editGroupController.tags.length,
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30))),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Text(
                                      editGroupController.tags[index],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      editGroupController.removeTag(
                                          editGroupController.tags[index]);
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
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => ViewGroup(
                            currentGroup: widget.currentGroup,
                            isFromGroup: true,
                          ));
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
                          print(widget.currentGroup.name);
                          editGroupController.editGroup(widget.currentGroup);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      decoration: const BoxDecoration(
                          color: Color(mainColor),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
    );
  }
}
