import 'package:get/get.dart';
import 'package:scorpforce/modules/lead/lead_screen/lead_controller.dart';
import '../../meeting/add_meeting_screen/add_meeting_binding.dart';
import '../add_lead/binding/add_lead_binding.dart';
class LeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LeadController>(() => LeadController());
    AddLeadBinding().dependencies();
    AddMeetingBinding().dependencies();
    // TODO: implement dependencies
  }

}