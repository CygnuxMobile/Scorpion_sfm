import 'package:get/get.dart';
import 'package:scorpforce/modules/customer/customer_screen/customer_controller.dart';
import '../../meeting/add_meeting_screen/add_meeting_binding.dart';
import '../../my_call/add_my_call_screen/add_call_binding.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    AddMeetingBinding().dependencies();
    AddCallBinding().dependencies();
    // TODO: implement dependencies
    Get.lazyPut(() => CustomerController());
  }
}
