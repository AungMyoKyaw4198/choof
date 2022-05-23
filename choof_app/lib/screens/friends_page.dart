import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

import '../controllers/landing_page_controller.dart';
import '../models/group.dart';
import '../utils/app_constant.dart';

class FriendsPage extends StatefulWidget {
  final Group group;
  const FriendsPage({Key? key, required this.group}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final landingPagecontroller = Get.find<LandingPageController>();
  final TextEditingController _filter = TextEditingController();

  @override
  void initState() {
    _filter.clear();
    landingPagecontroller.updateIsFilter(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(bgColor),
        centerTitle: true,
        title: const Text(
          'Members',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
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
                            image: NetworkImage(widget.group.ownerImageUrl)))),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'By',
                  style: TextStyle(
                      color: Colors.white54, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.group.owner,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            const Text(
              'Members',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),

            const Text(
              'The group is private and can only be seen by its members.',
              style: TextStyle(color: Color(0xff888888), fontSize: 13),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              height: 82,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // Show my profile if I'm not owner
                  Obx(
                    () => // Only members can remove thyself
                        landingPagecontroller.userProfile.value.name !=
                                widget.group.owner
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        landingPagecontroller
                                                            .userProfile
                                                            .value
                                                            .imageUrl)))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          landingPagecontroller
                                              .userProfile.value.name,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            infoDialog(
                                                title:
                                                    'Are you sure you want to remove yourself from this group?',
                                                content:
                                                    'You cannot see posts and updates from this group anymore.',
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                        Group newGroup =
                                                            widget.group;
                                                        newGroup.members.removeWhere(
                                                            (element) =>
                                                                element
                                                                    .trim() ==
                                                                landingPagecontroller
                                                                    .userProfile
                                                                    .value
                                                                    .name
                                                                    .trim());
                                                        landingPagecontroller
                                                            .leaveGroup(
                                                                newGroup);
                                                      },
                                                      child: const Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                                ]);
                                          },
                                          child: const CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.white70,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 8,
                                            ),
                                          ),
                                        ))
                                  ],
                                ))
                            : const SizedBox.shrink(),
                  ),
                  // Friends horixontal view
                  // print(email.replaceRange(2,"example@gmail.com".indexOf("@"),"****"));
                  // GROUP
                  Obx(
                    () => landingPagecontroller.groupedUsers.length > 1
                        ? ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            children: List.generate(
                                landingPagecontroller.groupedUsers.length,
                                (index) {
                              return landingPagecontroller
                                          .userProfile.value.name
                                          .trim() ==
                                      landingPagecontroller
                                          .groupedUsers[index].name
                                          .trim()
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .imageUrl)))),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              landingPagecontroller
                                                      .groupedUsers[index]
                                                      .isInvited
                                                  ? Text(
                                                      landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .length >
                                                              10
                                                          ? landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .replaceRange(
                                                                      2,
                                                                      landingPagecontroller.groupedUsers[index].name.indexOf(
                                                                          "@"),
                                                                      "*" *
                                                                          (landingPagecontroller.groupedUsers[index].name.length -
                                                                              12))
                                                                  .substring(
                                                                      0, 10) +
                                                              '...'
                                                          : landingPagecontroller.groupedUsers[index].name.replaceRange(
                                                              2,
                                                              landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .indexOf("@"),
                                                              "*" *
                                                                  (landingPagecontroller
                                                                          .groupedUsers[index]
                                                                          .name
                                                                          .length -
                                                                      12)),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .length >
                                                              10
                                                          ? landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .substring(
                                                                      0, 10) +
                                                              '...'
                                                          : landingPagecontroller
                                                              .groupedUsers[
                                                                  index]
                                                              .name,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            ],
                                          ),
                                          // Only owner can remove other members
                                          landingPagecontroller
                                                      .userProfile.value.name ==
                                                  widget.group.owner
                                              ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Group newGroup =
                                                          widget.group;
                                                      newGroup.members.removeWhere(
                                                          (element) =>
                                                              element.trim() ==
                                                              landingPagecontroller
                                                                  .groupedUsers[
                                                                      index]
                                                                  .name
                                                                  .trim());
                                                      landingPagecontroller
                                                          .updateGroupUser(
                                                              newGroup);
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.white70,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.black,
                                                        size: 8,
                                                      ),
                                                    ),
                                                  ))
                                              : const SizedBox.shrink(),
                                        ],
                                      ));
                            }),
                          )
                        : Container(
                            height: 82,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                'No members yet.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            landingPagecontroller.userProfile.value.name == widget.group.owner
                ? const Text(
                    'Add a friend',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 20,
            ),

            // filter
            landingPagecontroller.userProfile.value.name == widget.group.owner
                ? Row(
                    children: [
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width / 1.22,
                        child: TextFormField(
                          controller: _filter,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              landingPagecontroller.updateIsFilter(false);
                            } else {
                              landingPagecontroller.updateIsFilter(true);
                              landingPagecontroller.filterUsers(value);
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.grey[800],
                              fontStyle: FontStyle.italic,
                            ),
                            hintText:
                                "Search a member or type an email to invite",
                            fillColor: Colors.white70,
                            suffixIcon: IconButton(
                              onPressed: () {
                                _filter.clear();
                                landingPagecontroller.updateIsFilter(false);
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // Send email
                      IconButton(
                          onPressed: () async {
                            if (landingPagecontroller.userProfile.value.name ==
                                widget.group.owner) {
                              if (_filter.text.isEmail) {
                                final Email email = Email(
                                  subject:
                                      '${widget.group.owner} added you to the Choof group: ${widget.group.name}.',
                                  body:
                                      '''${widget.group.owner} has some recommendation for you in the Choof group: ${widget.group.name}.
             Download the Choof app and sign in with a social account linked to your email: ${_filter.text}''',
                                  recipients: [_filter.text],
                                  isHTML: false,
                                );

                                await FlutterEmailSender.send(email)
                                    .then((value) {
                                  landingPagecontroller.addInvitedUserToGroup(
                                      _filter.text, widget.group);
                                  _filter.clear();
                                  landingPagecontroller.updateIsFilter(false);
                                  Get.snackbar(
                                    'Email Sent',
                                    '',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                    duration: const Duration(seconds: 3),
                                  );
                                }).catchError((e) {
                                  Get.snackbar(
                                    'Failed to send Email.',
                                    '',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                  );
                                });
                              }
                            }
                          },
                          icon: Image.asset(
                            'assets/icons/EmailSend.png',
                            width: 30,
                            height: 30,
                          ))
                    ],
                  )
                : const SizedBox.shrink(),

            const SizedBox(
              height: 20,
            ),
            // All Friends
            Obx(() {
              // when searched
              if (landingPagecontroller.userProfile.value.name ==
                  widget.group.owner) {
                if (landingPagecontroller.isFilter.value) {
                  return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      children: List.generate(
                          landingPagecontroller.filteredUsersResult.length,
                          (index) {
                        return InkWell(
                          onTap: () {
                            // Only owner can add new members
                            if (landingPagecontroller.userProfile.value.name ==
                                widget.group.owner) {
                              if (landingPagecontroller
                                      .userProfile.value.blockedUsers !=
                                  null) {
                                if (landingPagecontroller
                                    .userProfile.value.blockedUsers!
                                    .contains(landingPagecontroller
                                        .filteredUsersResult[index].name)) {
                                  Get.defaultDialog(
                                      title:
                                          'Unblock ${landingPagecontroller.filteredUsersResult[index].name}? ',
                                      content: const SizedBox.shrink(),
                                      textConfirm: 'Unblock',
                                      textCancel: 'Cancel',
                                      onConfirm: () {
                                        landingPagecontroller.unBlockUser(
                                            landingPagecontroller
                                                .filteredUsersResult[index].name
                                                .trim());
                                        Get.back();
                                      });
                                } else {
                                  Group newGroup = widget.group;
                                  newGroup.members.add(landingPagecontroller
                                      .filteredUsersResult[index].name);
                                  landingPagecontroller
                                      .updateGroupUser(newGroup);
                                }
                              } else {
                                Group newGroup = widget.group;
                                newGroup.members.add(landingPagecontroller
                                    .freeUsers[index].name);
                                landingPagecontroller.updateGroupUser(newGroup);
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                landingPagecontroller
                                            .userProfile.value.blockedUsers !=
                                        null
                                    ? landingPagecontroller
                                            .userProfile.value.blockedUsers!
                                            .contains(landingPagecontroller
                                                .filteredUsersResult[index]
                                                .name)
                                        ? Image.asset(
                                            'assets/icons/block.png',
                                            width: 30,
                                            height: 30,
                                          )
                                        : Image.asset(
                                            'assets/icons/un-block.png',
                                            width: 30,
                                            height: 30,
                                          )
                                    : Image.asset(
                                        'assets/icons/un-block.png',
                                        width: 30,
                                        height: 30,
                                      ),
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
                                                landingPagecontroller
                                                    .filteredUsersResult[index]
                                                    .imageUrl)))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  landingPagecontroller
                                      .filteredUsersResult[index].name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }));
                }
                // no search
                else {
                  return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      children: landingPagecontroller.freeUsers.isNotEmpty
                          ? List.generate(
                              landingPagecontroller.freeUsers.length, (index) {
                              return InkWell(
                                onTap: () {
                                  // Only owner can add new members
                                  if (landingPagecontroller
                                          .userProfile.value.name ==
                                      widget.group.owner) {
                                    if (landingPagecontroller
                                            .userProfile.value.blockedUsers !=
                                        null) {
                                      if (landingPagecontroller
                                          .userProfile.value.blockedUsers!
                                          .contains(landingPagecontroller
                                              .freeUsers[index].name)) {
                                        Get.defaultDialog(
                                            title:
                                                'Unblock ${landingPagecontroller.freeUsers[index].name}? ',
                                            content: const SizedBox.shrink(),
                                            textConfirm: 'Unblock',
                                            textCancel: 'Cancel',
                                            onConfirm: () {
                                              landingPagecontroller.unBlockUser(
                                                  landingPagecontroller
                                                      .freeUsers[index].name
                                                      .trim());
                                              Get.back();
                                            });
                                      } else {
                                        Group newGroup = widget.group;
                                        newGroup.members.add(
                                            landingPagecontroller
                                                .freeUsers[index].name);
                                        landingPagecontroller
                                            .updateGroupUser(newGroup);
                                      }
                                    } else {
                                      Group newGroup = widget.group;
                                      newGroup.members.add(landingPagecontroller
                                          .freeUsers[index].name);
                                      landingPagecontroller
                                          .updateGroupUser(newGroup);
                                    }
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      landingPagecontroller.userProfile.value
                                                  .blockedUsers !=
                                              null
                                          ? landingPagecontroller.userProfile
                                                  .value.blockedUsers!
                                                  .contains(
                                                      landingPagecontroller
                                                          .freeUsers[index]
                                                          .name)
                                              ? Image.asset(
                                                  'assets/icons/block.png',
                                                  width: 30,
                                                  height: 30,
                                                )
                                              : Image.asset(
                                                  'assets/icons/un-block.png',
                                                  width: 30,
                                                  height: 30,
                                                )
                                          : Image.asset(
                                              'assets/icons/un-block.png',
                                              width: 30,
                                              height: 30,
                                            ),
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
                                                      landingPagecontroller
                                                          .freeUsers[index]
                                                          .imageUrl)))),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        landingPagecontroller
                                            .freeUsers[index].name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                          : [const SizedBox.shrink()]);
                }
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
