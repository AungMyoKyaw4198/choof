import 'package:choof_app/screens/add_group_page.dart';
import 'package:choof_app/screens/view_group.dart';
import 'package:choof_app/screens/widgets/shared_widgets.dart';
import 'package:choof_app/screens/your_groups_page.dart';
import 'package:choof_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/home_page_controller.dart';
import '../controllers/landing_page_controller.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../models/profile.dart';
import 'favourite_page.dart';
import 'full_screen_page.dart';
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
