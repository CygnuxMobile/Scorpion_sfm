import 'package:get/get.dart';
import 'package:scorpforce/modules/myTask/task_screen/task_controller.dart';

import '../add_task/binding/add_task_binding.dart';

class TaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
    AddTaskBinding().dependencies();
    // TODO: implement dependencies
  }
}