import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/add_expense_general_master/add_expense_general_master_controller.dart';

class AddExpenseGeneralMasterBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseGeneralMasterController());
    // TODO: implement dependencies
  }

}