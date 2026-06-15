import 'dart:convert';
import 'package:get/get.dart';
import 'package:scorpforce/modules/lead/view_lead/view_lead_model.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ViewLeadController extends GetxController {
  Rx<Data> leadetail = Data(
    cityId: 0,
    branchId: "",
    regionId: "",
    designationId: "",
    leadSourceId: "",
    leadSource: "",
    assignedToId: "assignedToId",
    industryTypeId: "",
    region: "",
    branch: "",
    industryType: "",
    city: "",
    serviceInterestedNames: "",
    serviceInteresteds: "",
    leadId: "",
    leadCategory: "",
    leadCategoryId: 0,
    companyName: "",
    leadDate: "",
    assignedTo: "",
    contactName: "",
    email: "",
    contactNo: "",
    address: "",
    isActive: true,
    modifiedBy: '',
    createdBy: '',
    customerName: '',
    designation: '',
  ).obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getLeadData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.getLead}/$id?UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      ViewLeadModel viewLeadModel = ViewLeadModel.fromJson(json.decode(response.data));
      leadetail.value = viewLeadModel.data;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
