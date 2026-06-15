import 'package:get/get.dart';
import 'package:scorpforce/modules/calender/my_calender_controller.dart';
import '../meeting/add_meeting_screen/add_meeting_binding.dart';
import '../my_call/add_my_call_screen/add_call_binding.dart';

class MyCalenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCalenderController());
    AddMeetingBinding().dependencies();
    AddCallBinding().dependencies();
    // TODO: implement dependencies
  }
}
