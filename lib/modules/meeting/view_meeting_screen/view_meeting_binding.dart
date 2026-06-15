import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting/view_meeting_screen/view_meeting_controller.dart';

class ViewMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewMeetingController>(() => ViewMeetingController());
    // TODO: implement dependencies
  }
}
