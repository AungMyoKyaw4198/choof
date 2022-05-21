import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/landing_page_controller.dart';
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
      // Bottom Navigation
      bottomNavigationBar: BottomMenu(),
      body: Obx(() => IndexedStack(
            index: landingPagecontroller.tabIndex.value,
            children: [
              const FavouritePage(),
              const YourGroupsPage(),
              SettingsPage(),
            ],
          )),
    );
  }
}
