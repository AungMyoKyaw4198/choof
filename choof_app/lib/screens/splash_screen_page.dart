import 'package:choof_app/controllers/landing_page_controller.dart';
import 'package:choof_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/app_constant.dart';
import 'landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final landingPagecontroller = Get.find<LandingPageController>();

  @override
  void initState() {
    super.initState();
    String name = GetStorage().read('name') ?? '';
    if (name == '') {
      Future.delayed(const Duration(seconds: 5)).then((val) {
        Get.offAll(() => LandingPage());
      });
    } else {
      landingPagecontroller.setUserFromStorage();
      Future.delayed(const Duration(seconds: 5)).then((val) {
        Get.offAll(() => const HomePage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(mainBgColor),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/logo.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
            const Text(
              'Share your faves',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
