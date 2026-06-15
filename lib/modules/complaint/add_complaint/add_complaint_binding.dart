import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/add_complaint/add_complaint_controller.dart';

class AddComplaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddComplaintController());
  }
}
