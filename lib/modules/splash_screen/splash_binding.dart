import 'package:get/get.dart';
import 'package:scorpforce/modules/splash_screen/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
