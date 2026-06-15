import 'package:get/get.dart';
import 'package:scorpforce/modules/myTask/view_task/view_task_controller.dart';

class ViewTaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ViewTaskController>(()=> ViewTaskController());
    // TODO: implement dependencies
  }

}