import 'package:get/get.dart';

import 'controllers/landing_page_controller.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    //  Get.lazyPut(() => LandingPageController());
    Get.put(LandingPageController());
  }
}
