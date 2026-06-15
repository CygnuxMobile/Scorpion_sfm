import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting/meeting_screen/meeting_controller.dart';

import '../../my_call/add_my_call_screen/add_call_binding.dart';
import '../add_meeting_screen/add_meeting_binding.dart';

class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeetingController());
    AddMeetingBinding().dependencies();
    AddCallBinding().dependencies();
    // TODO: implement dependencies
  }
}
