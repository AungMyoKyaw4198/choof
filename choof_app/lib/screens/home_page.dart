import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/landing_page_controller.dart';
import '../utils/app_constant.dart';
import 'favourite_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final landingPagecontroller = Get.find<LandingPageController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
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
      body: SafeArea(
        child: Obx(() => IndexedStack(
              index: landingPagecontroller.tabIndex.value,
              children: [
                const FavouritePage(isFirstTime: true),
                const YourGroupsPage(
                  isFirstTime: true,
                ),
                SettingsPage(),
              ],
            )),
      ),
    );
  }
}
