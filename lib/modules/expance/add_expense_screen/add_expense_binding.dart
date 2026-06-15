import 'package:get/get.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/add_expense_controller.dart';

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseController());
    // TODO: implement dependencies
  }
}
