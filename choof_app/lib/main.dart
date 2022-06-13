import 'package:choof_app/main_bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/landing_page_controller.dart';
import 'screens/splash_screen_page.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  NotificationService.init();
  MainBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final landingPagecontroller = Get.find<LandingPageController>();

  setDevice() {
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    final bool useTabletLayout = data.size.shortestSide > 600;
    landingPagecontroller.setIsDeviceTablet(useTabletLayout);
  }

  @override
  void initState() {
    setDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHOOF',
      initialBinding: MainBindings(),
      defaultTransition: Transition.fade,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
