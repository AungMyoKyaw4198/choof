import 'package:get/get.dart';

import 'controllers/home_page_controller.dart';
import 'controllers/landing_page_controller.dart';
import 'controllers/your_group_controller.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    //  Get.lazyPut(() => LandingPageController());
    Get.put(LandingPageController());
    Get.put(HomePageController());
    Get.put(YourGroupController());
  }
}
