import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/view_expense_general_master/view_expense_general_master_controller.dart';

class ViewExpenseGeneralMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewExpenseGeneralMasterController());
    // TODO: implement dependencies
  }
}
