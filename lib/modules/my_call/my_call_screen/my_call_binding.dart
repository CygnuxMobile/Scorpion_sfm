import 'package:get/get.dart';
import 'package:scorpforce/modules/my_call/my_call_screen/my_call_controller.dart';
import '../add_my_call_screen/add_call_binding.dart';

class MyCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCallController());
    AddCallBinding().dependencies();
    // TODO: implement dependencies
  }
}
