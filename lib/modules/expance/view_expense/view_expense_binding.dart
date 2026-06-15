import 'package:get/get.dart';
import 'package:scorpforce/modules/expance/view_expense/view_expense_controller.dart';


class ViewExpenseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ViewExpenseController>(()=> ViewExpenseController());
    // TODO: implement dependencies
  }

}