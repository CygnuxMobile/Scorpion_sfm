import 'package:get/get.dart';
import 'package:scorpforce/modules/my_call/view_expense/call_view_controller.dart';

class CallViewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CallViewController>(()=> CallViewController());
    // TODO: implement dependencies
  }

}