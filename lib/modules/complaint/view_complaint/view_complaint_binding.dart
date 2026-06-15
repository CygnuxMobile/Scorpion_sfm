import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/view_complaint/view_complaint_controller.dart';


class ViewComplaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewComplaintController());
  }
}
