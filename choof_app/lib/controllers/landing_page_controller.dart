import 'package:choof_app/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

import '../models/group.dart';
import '../models/post.dart';
import '../screens/home_page.dart';
import '../screens/landing_page.dart';
import '../screens/widgets/shared_widgets.dart';
import '../services/user_auth.dart';
import 'home_page_controller.dart';
import 'your_group_controller.dart';

class LandingPageController extends GetxController {
  final UserAuthService _userAuthService = UserAuthService();

  final CollectionReference _registeredUsers =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _groups =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection("posts");
  final CollectionReference _notis =
      FirebaseFirestore.instance.collection("notifications");

  final isDeviceTablet = false.obs;
  var tabIndex = 0.obs;
  final userProfile = Profile(
          name: 'test',
          imageUrl: 'test',
          email: 'test',
          allowNotifications: true,
          isInvited: false)
      .obs;
  final signOut = false.obs;
  final allowNoti = true.obs;
  final deleteUser = false.obs;
  final allUsers = <Profile>[].obs;
  final groupedUsers = <Profile>[].obs;
  final freeUsers = <Profile>[].obs;

  final isFilter = false.obs;
  final filteredUsersResult = <Profile>[].obs;

  final autoTags = <String>[].obs;

  final backIndex = 0.obs;

  incrementBackIndex() {
    int value = backIndex.value + 1;
    backIndex(value);
  }

  setBackIndex(int index) {
    backIndex(index);
  }

  setIsDeviceTablet(bool value) {
    isDeviceTablet(value);
  }

  resetData() {
    loadingDialog();
    userProfile(Profile(
        name: 'test',
        imageUrl: 'test',
        email: 'test',
        allowNotifications: true,
        isInvited: false));
    signOut(false);
    allowNoti(true);
    deleteUser(false);
    allUsers([]);
    groupedUsers([]);
    freeUsers([]);
    isFilter(false);
    filteredUsersResult([]);
    tabIndex(0);
  }

  // Sign in with Google
  signInWithGoogle() async {
    loadingDialog();
    await _userAuthService.signOut();
    final result = await _userAuthService.signInWithGoogle();
    if (result != null) {
      UserCredential _userCredential = result;
      userProfile(Profile(
          name: _userCredential.user!.displayName!,
          imageUrl: _userCredential.user!.photoURL!,
          email: _userCredential.user!.providerData[0].email ?? '',
          allowNotifications: true,
          isInvited: false));
      await addNewUser();
      String name = GetStorage().read('name') ?? '';
      if (name == '') {
        storeUserProfile(userProfile.value);
      }
      Get.back();
      Get.offAll(() => const HomePage(
            isFristTime: true,
          ));
    } else {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Sign in with apple
  signInWithApple() async {
    loadingDialog();
    await _userAuthService.signOut();
    final result = await _userAuthService.signInWithApple();
    if (result != null) {
      AuthorizationResult appleResult = GetStorage().read('appleCredential');
      final UserCredential _userCredential = result;
      userProfile(Profile(
          name: appleResult.credential!.fullName!.givenName ?? 'user',
          email: _userCredential.user!.providerData[0].email ?? '',
          imageUrl: _userCredential.user!.photoURL ??
              'https://graph.facebook.com/4892879454127549/picture',
          allowNotifications: true,
          isInvited: false,
          blockByUsers: [],
          blockedUsers: []));
      await addNewUser();
      String name = GetStorage().read('name') ?? '';
      if (name == '') {
        storeUserProfile(userProfile.value);
      }
      Get.back();
      Get.offAll(() => const HomePage(
            isFristTime: true,
          ));
    } else {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Sign in with Facebook
  signInWithFacebook() async {
    loadingDialog();
    await _userAuthService.signOut();
    final result = await _userAuthService.signInWithFacebook();
    if (result != null) {
      final UserCredential _userCredential = result;
      userProfile(Profile(
          name: _userCredential.user!.displayName!,
          email: _userCredential.user!.providerData[0].email ?? '',
          imageUrl: _userCredential.user!.photoURL!,
          allowNotifications: true,
          isInvited: false,
          blockByUsers: [],
          blockedUsers: []));
      await addNewUser();
      String name = GetStorage().read('name') ?? '';
      if (name == '') {
        storeUserProfile(userProfile.value);
      }
      Get.back();
      Get.offAll(() => const HomePage(
            isFristTime: true,
          ));
    } else {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Sign in with Twitter
  signInWithTwitter() async {
    loadingDialog();

    await _userAuthService.signOut();
    final twitterLogin = TwitterLogin(
        apiKey: 'SorRtCYPqzRR4PtwMW2Y1CmcO',
        apiSecretKey: 'q6IKKCcPSg0fw1ZXII46T57EVv4gQlpbVg3rPKZ9ttMfU1frxX',
        redirectURI: 'choofapp://');

    await twitterLogin.login(forceLogin: true).then((value) async {
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: value.authToken!,
        secret: value.authTokenSecret!,
      );
      final result = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
      if (result != null) {
        final UserCredential _userCredential = result;
        userProfile(Profile(
            name: _userCredential.user!.displayName!,
            email: _userCredential.user!.providerData[0].email ?? '',
            imageUrl: _userCredential.user!.photoURL!,
            allowNotifications: true,
            isInvited: false,
            blockByUsers: [],
            blockedUsers: []));
        await addNewUser();
        storeUserProfile(userProfile.value);
        Get.back();
        Get.offAll(() => const HomePage(
              isFristTime: true,
            ));
      } else {
        Get.back();
        Get.snackbar(
          "Something went wrong!",
          "Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }).onError((error, stackTrace) {
      Get.back();
    });
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  toggleSignOut(bool value) async {
    final homePagecontroller = Get.find<HomePageController>();
    final yourGroupsPagecontroller = Get.find<YourGroupController>();
    loadingDialog();
    signOut(value);
    if (value) {
      await _userAuthService.signOut();
      deleteUserProfile();
      resetData();

      Get.back();
      Get.offAll(() => LandingPage());
      homePagecontroller.refreshPosts();
      yourGroupsPagecontroller.refreshGroups();
    }
  }

  toggleAllowNotification(bool value) {
    loadingDialog();
    Profile newProfile = userProfile.value;
    newProfile.allowNotifications = value;
    userProfile(newProfile);
    allowNoti(value);
    _registeredUsers.doc(newProfile.docId).update(newProfile.toJson());
    Get.back();
  }

  unBlockUser(String name) async {
    Get.back();
    loadingDialog();
    // Update current user
    Profile newProfile = userProfile.value;
    List<String> metaBlockedUsers = newProfile.blockedUsers!;
    for (int i = 0; i < newProfile.blockedUsers!.length; i++) {
      if (newProfile.blockedUsers![i].trim() == name) {
        metaBlockedUsers.removeAt(i);
      }
    }
    newProfile.blockedUsers = metaBlockedUsers;
    userProfile(newProfile);
    await _registeredUsers.doc(newProfile.docId).update(newProfile.toJson());

    // Update blocked User
    QuerySnapshot<Object?> querySnapshot =
        await _registeredUsers.where('name', isEqualTo: name).get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var element in querySnapshot.docs) {
        Profile reportedUser =
            Profile.fromJson(element.data() as Map<String, dynamic>);
        reportedUser.docId = element.id;

        if (reportedUser.blockByUsers != null) {
          List<String> metaUsers = reportedUser.blockByUsers!;
          for (int i = 0; i < reportedUser.blockByUsers!.length; i++) {
            if (reportedUser.blockByUsers![i].trim() ==
                userProfile.value.name.trim()) {
              metaUsers.removeAt(i);
            }
          }
          reportedUser.blockByUsers = metaUsers;
        } else {
          reportedUser.blockByUsers = [];
        }
        storeUserProfile(reportedUser);
        await _registeredUsers
            .doc(reportedUser.docId)
            .update(reportedUser.toJson());
      }
    }

    Get.back();
  }

  toggleDeleteUser(bool value) async {
    infoDialog(
        title: 'Are you sure you want to delete your account?',
        content: 'All of your data will be deleted.',
        actions: [
          TextButton(
              onPressed: () {
                deleteUser(false);
                Get.back();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                Get.back();
                // Do Deleting
                try {
                  loadingDialog();
                  deleteUser(value);
                  if (value) {
                    // Delet user from Users DB

                    QuerySnapshot<Object?> querySnapshot =
                        await _registeredUsers
                            .where('name', isEqualTo: userProfile.value.name)
                            .get();
                    String docId = querySnapshot.docs.first.id;
                    await _registeredUsers.doc(docId).delete();

                    // Delet user from rest of the DBs
                    // Clear users's groups
                    QuerySnapshot<Object?> groupSnapshot = await _groups
                        .where('owner', isEqualTo: userProfile.value.name)
                        .get();
                    if (groupSnapshot.docs.isNotEmpty) {
                      for (var element in groupSnapshot.docs) {
                        _groups.doc(element.id).delete();
                      }
                    }

                    // Clear Members Group
                    QuerySnapshot<Object?> memberSnapshot = await _groups.get();
                    if (memberSnapshot.docs.isNotEmpty) {
                      for (var doc in memberSnapshot.docs) {
                        final Group meta =
                            Group.fromJson(doc.data() as Map<String, dynamic>);
                        meta.docId = doc.id;
                        if (meta.members
                            .toString()
                            .contains(userProfile.value.name)) {
                          List<String> members = meta.members;
                          for (int i = 0; i < meta.members.length; i++) {
                            if (meta.members[i].trim() ==
                                userProfile.value.name.trim()) {
                              members.removeAt(i);
                            }
                          }
                          meta.members = members;
                          await _groups.doc(meta.docId).update(meta.toJson());
                        }
                      }
                    }
                    // Clear users's posts
                    QuerySnapshot<Object?> postSnapshot = await _posts
                        .where('creator', isEqualTo: userProfile.value.name)
                        .get();
                    if (postSnapshot.docs.isNotEmpty) {
                      for (var element in postSnapshot.docs) {
                        _posts.doc(element.id).delete();
                      }
                    }

                    // Clear users's notis
                    QuerySnapshot<Object?> notiSnapshot = await _notis
                        .where('sender', isEqualTo: userProfile.value.name)
                        .get();
                    if (notiSnapshot.docs.isNotEmpty) {
                      for (var element in notiSnapshot.docs) {
                        _notis.doc(element.id).delete();
                      }
                    }
                    //--------------------
                    deleteUserProfile();
                    resetData();
                    Get.back();
                    Get.offAll(() => LandingPage());
                  } else {
                    Get.back();
                  }
                } catch (e) {
                  Get.snackbar(
                    "Something went wrong!",
                    "Please try again later.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                  );
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )),
        ]);
  }

  // Add new user to Database
  addNewUser() async {
    try {
      QuerySnapshot<Object?> querySnapshot = await _registeredUsers
          .where('email', isEqualTo: userProfile.value.email)
          .get();
      // user existed
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        Profile _resultProfile = Profile.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        userProfile.value.docId = docId;
        userProfile.value.blockedUsers = _resultProfile.blockedUsers;
        userProfile.value.blockByUsers = _resultProfile.blockByUsers;

        //User is invited
        if (_resultProfile.isInvited) {
          userProfile.value.isInvited = false;
          await _registeredUsers.doc(docId).update(userProfile.value.toJson());
          // Search for use email in groups // if found replace with user name
          QuerySnapshot<Object?> memberSnapshot = await _groups.get();
          if (memberSnapshot.docs.isNotEmpty) {
            for (var element in memberSnapshot.docs) {
              final Group meta =
                  Group.fromJson(element.data() as Map<String, dynamic>);
              meta.docId = element.id;
              if (meta.members.toString().contains(userProfile.value.email)) {
                List<String> members = meta.members;
                for (int i = 0; i < meta.members.length; i++) {
                  if (meta.members[i].trim() ==
                      userProfile.value.email.trim()) {
                    members[i] = userProfile.value.name;
                  }
                  if (i == meta.members.length - 1) {
                    meta.members = members;
                    await _groups.doc(meta.docId).update(meta.toJson());
                  }
                }
              }
            }
          }
        }
      }
      // no user existed
      else {
        DocumentReference docRef =
            await _registeredUsers.add(userProfile.value.toJson());
        Profile newProfile = userProfile.value;
        newProfile.docId = docRef.id;
        userProfile(newProfile);
      }
    } catch (e) {
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // Add Invited User
  addInvitedUserToGroup(String email, Group currentGroup) async {
    try {
      QuerySnapshot<Object?> querySnapshot =
          await _registeredUsers.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isEmpty) {
        Profile invitedUser = Profile(
            name: email,
            email: email,
            imageUrl: 'https://graph.facebook.com/4892879454127549/picture',
            allowNotifications: true,
            isInvited: true);
        await _registeredUsers.add(invitedUser.toJson());
        currentGroup.members.add(email);
        updateGroupUser(currentGroup);
      } else {
        Profile invitedUser = Profile.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        currentGroup.members.add(invitedUser.name);

        updateGroupUser(currentGroup);
      }
    } catch (e) {
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  storeUserProfile(Profile user) {
    setData('docId', user.docId);
    setData('name', user.name);
    setData('email', user.email);
    setData('imageUrl', user.imageUrl);
    setData('allow', user.allowNotifications);
    setData('isInvited', user.isInvited);
    setData('blockByUsers', user.blockByUsers);
    setData('blockedUsers', user.blockedUsers);
  }

  storeAppleInformation(AuthorizationResult result) {
    setData('appleCredential', result);
  }

  deleteUserProfile() {
    setData('docId', '');
    setData('name', '');
    setData('email', '');
    setData('imageUrl', '');
    setData('allow', '');
    setData('isInvited', '');
    setData('blockByUsers', '');
    setData('notiTime', '');
  }

  setUserFromStorage() {
    userProfile(Profile(
      docId: GetStorage().read('docId'),
      name: GetStorage().read('name'),
      email: GetStorage().read('email') ?? '',
      imageUrl: GetStorage().read('imageUrl'),
      allowNotifications: GetStorage().read('allow'),
      isInvited: GetStorage().read('isInvited') ?? false,
      blockByUsers: GetStorage().read('blockByUsers').cast<String>() ?? [],
      blockedUsers: GetStorage().read('blockedUsers').cast<String>() ?? [],
    ));
  }

  void setData(String key, dynamic value) => GetStorage().write(key, value);

  // get all users profiles
  getAllUsers(Group group) async {
    try {
      List<Profile> metaAllUsers = [];
      allUsers.clear();
      groupedUsers.clear();
      freeUsers.clear();
      QuerySnapshot<Object?> querySnapshot = await _registeredUsers.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          allUsers.add(Profile.fromJson(
              querySnapshot.docs[i].data() as Map<String, dynamic>));
          metaAllUsers.add(Profile.fromJson(
              querySnapshot.docs[i].data() as Map<String, dynamic>));
          // add group members
          for (var element in group.members) {
            if (element.trim() == querySnapshot.docs[i]['name']) {
              groupedUsers.add(Profile.fromJson(
                  querySnapshot.docs[i].data() as Map<String, dynamic>));
            }
          }
        }

        // Add Free users
        for (var targetUser in group.members) {
          metaAllUsers.removeWhere(
              (element) => element.name.trim() == targetUser.trim());
        }

        // freeUsers(metaAllUsers);
        List<String> blockByList = [];

        // Check If current user is in blocklist
        if (userProfile.value.blockByUsers != null) {
          for (var element in userProfile.value.blockByUsers!) {
            blockByList.add(element.trim());
          }
          metaAllUsers
              .removeWhere((element) => blockByList.contains(element.name));
          freeUsers(metaAllUsers);
        } else {
          freeUsers(metaAllUsers);
        }
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  leaveGroup(Group group) async {
    try {
      isFilter(false);
      loadingDialog();
      await _groups.doc(group.docId).update(group.toJson()).then((value) {
        Get.back();
        // Back to View Group Page
        Get.back();
        // Back to your groups page / Home Page
        Get.back();
      });
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  updateGroupUser(Group group) async {
    try {
      loadingDialog();
      isFilter(false);
      Group currentGroup = group;
      QuerySnapshot<Object?> postSnapshot =
          await _groups.where('name', isEqualTo: group.name).get();
      if (postSnapshot.docs.isNotEmpty) {
        currentGroup.docId = postSnapshot.docs.first.id;
        await _groups
            .doc(currentGroup.docId)
            .update(currentGroup.toJson())
            .then((value) {
          Get.back();
          getAllUsers(currentGroup);
        });
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  removePostFromGroup(Post post) async {
    try {
      loadingDialog();
      await _posts.doc(post.docId).delete();
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Something went wrong!",
        "Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  updateIsFilter(bool value) {
    isFilter(value);
  }

  filterUsers(String name) {
    filteredUsersResult.clear();
    for (var element in freeUsers) {
      if (element.name.toLowerCase().contains(name.toLowerCase())) {
        filteredUsersResult.add(element);
      }
    }
  }

  clearAutoTags() {
    autoTags([]);
  }

  addAutoTags(String tag) {
    autoTags.add(tag);
  }

  setAutoTags(List<String> tags) {
    autoTags(tags);
  }

  bool checkUserBlockState(List<String> userList, String name) {
    bool isBlock = false;
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].trim() == name.trim()) {
        isBlock = true;
        break;
      } else {
        isBlock = false;
      }
    }
    return isBlock;
  }
}
