import 'package:get/get.dart';
import 'package:scorpforce/modules/my_call/add_my_call_screen/add_call_controller.dart';

class AddCallBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => AddCallController());
    // TODO: implement dependencies
  }
}
