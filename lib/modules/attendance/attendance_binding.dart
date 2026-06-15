import 'package:get/get.dart';
import 'package:scorpforce/modules/attendance/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceController());
  }
}
