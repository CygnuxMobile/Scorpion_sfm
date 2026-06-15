import 'package:get/get.dart';
import 'package:scorpforce/modules/lead/view_lead/view_lead_controller.dart';

class ViewLeadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ViewLeadController>(()=> ViewLeadController());
    // TODO: implement dependencies
  }

}