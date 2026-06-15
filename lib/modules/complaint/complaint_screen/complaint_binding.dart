import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/complaint_screen/complaint_controller.dart';
import '../../meeting/add_meeting_screen/add_meeting_binding.dart';
import '../add_complaint/add_complaint_binding.dart';

class ComplaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ComplaintController());
    AddComplaintBinding().dependencies();
    AddMeetingBinding().dependencies();
  }
}
