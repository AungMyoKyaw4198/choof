import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/landing_page_controller.dart';
import '../utils/app_constant.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final controller = Get.find<LandingPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(mainBgColor),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              'assets/logos/logo.png',
              width: MediaQuery.of(context).size.width / 4.5,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        child: Obx(() => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      controller.userProfile.value.imageUrl)))),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        controller.userProfile.value.name,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // Sign Out
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Switch(
                        onChanged: (val) => controller.toggleSignOut(val),
                        value: controller.signOut.value,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Push Notifications
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Switch(
                        onChanged: (val) =>
                            controller.toggleAllowNotification(val),
                        value: controller.allowNoti.value,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Push Notifications',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Delet Account
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Switch(
                        onChanged: (val) => controller.toggleDeleteUser(val),
                        value: controller.deleteUser.value,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Delete my account',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
