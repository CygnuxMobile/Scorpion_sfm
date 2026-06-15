import 'package:get/get.dart';
import '../controller/add_task_controller.dart';


class AddTaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddTaskController>(()=>AddTaskController());
    // TODO: implement dependencies
  }

}