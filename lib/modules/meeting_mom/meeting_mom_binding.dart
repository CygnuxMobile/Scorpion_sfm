import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting_mom/meeting_mom_controller.dart';

class MeetingMomBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => MeetingMomController());
  }
}
