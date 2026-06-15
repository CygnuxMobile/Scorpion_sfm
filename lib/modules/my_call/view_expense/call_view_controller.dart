import 'dart:convert';
import 'package:get/get.dart';
import 'package:scorpforce/modules/my_call/view_expense/call_view_model.dart';

import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
class CallViewController extends GetxController {
  Rx<CallViewData> callViewData = CallViewData(
    remarks: "remarks",
    leadId: 'leadId',
    callPurpose: 'callPurpose',
    attendees: 'attendees',
    callId: 'callId',
    callCategoryId: 0,
    callCategoryName: 'callCategoryName',
    callDate: 'callDate',
    customerName: 'customerName',
    startTime: 'startTime',
    endTime: 'endTime',
    callStatus: 'callStatus',
    createdBy: 'createdBy',
    createdDate: 'createdDate',
    purpose: 'purpose',
    modifiedBy: 'modifiedBy',
    modifiedDate: 'modifiedDate',
  ).obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getCallViewData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.call}/$id?UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      CallViewResponseModel callViewResponseModel = CallViewResponseModel.fromJson(json.decode(response.data));
      callViewData.value = callViewResponseModel.callViewData;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
