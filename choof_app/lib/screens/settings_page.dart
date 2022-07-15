import 'package:choof_app/screens/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/landing_page_controller.dart';
import '../utils/app_constant.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final landingPagecontroller = Get.find<LandingPageController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(50, 50),
        child: Obx(() => landingPagecontroller.isDeviceTablet.value
            ? const SizedBox.shrink()
            : landingPagecontroller.tabIndex.value == 2
                ? AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(bgColor),
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
                  )
                : Container(
                    height: MediaQuery.of(context).padding.top,
                    color: const Color(mainBgColor),
                  )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(mainBgColor),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  margin: const EdgeInsets.symmetric(vertical: 30),
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
                                  image: NetworkImage(landingPagecontroller
                                      .userProfile.value.imageUrl)))),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        landingPagecontroller.userProfile.value.name,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                // Sign Out
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Switch(
                        onChanged: (val) =>
                            landingPagecontroller.toggleSignOut(val),
                        value: landingPagecontroller.signOut.value,
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
                            landingPagecontroller.toggleAllowNotification(val),
                        value: landingPagecontroller.allowNoti.value,
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
                        onChanged: (val) =>
                            landingPagecontroller.toggleDeleteUser(val),
                        value: landingPagecontroller.deleteUser.value,
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
                const SizedBox(
                  height: 40,
                ),
                // Help Button
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 43),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const WebViewPage(
                              url: 'http://choof.club/help/',
                            ));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.help,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 37,
                          ),
                          Text(
                            'Help',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
