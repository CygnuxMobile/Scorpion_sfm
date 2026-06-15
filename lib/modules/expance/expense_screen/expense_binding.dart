import 'package:get/get.dart';
import 'package:scorpforce/modules/expance/expense_screen/expense_controller.dart';

import '../add_expense_screen/add_expense_binding.dart';
class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpenseController());
    AddExpenseBinding().dependencies();
    // TODO: implement dependencies
  }
}
