import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/add_meeting_controller.dart';

class AddMeetingBinding extends Bindings {
  @override
  void dependencies() {
    print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
    Get.lazyPut(() => AddMeetingController());
    // TODO: implement dependencies
  }
}
