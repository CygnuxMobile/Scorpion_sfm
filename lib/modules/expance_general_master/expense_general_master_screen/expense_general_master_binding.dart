import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/expense_general_master_screen/expense_general_master_controller.dart';

import '../add_expense_general_master/add_expense_general_master_binding.dart';

class ExpenseGeneralMasterBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ExpenseGeneralMasterController());
    AddExpenseGeneralMasterBinding().dependencies();
    // TODO: implement dependencies
  }

}