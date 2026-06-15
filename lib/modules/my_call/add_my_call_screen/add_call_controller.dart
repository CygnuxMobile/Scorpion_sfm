import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../lead/add_lead/model/get_user_response_model.dart';
import '../../meeting/add_meeting_screen/get_customer_list_model.dart';
import '../../widget/toast_message.dart';
import 'call_module_response_model.dart';
import 'edit_call_response_model.dart';

class AddCallController extends GetxController {
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> remarksController = TextEditingController().obs;
  Rx<TextEditingController> addCallMOMController = TextEditingController().obs;
  Rx<TextEditingController> customerSearchController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;

  Rx<MultiSelectController<AssignedUser>> controller = MultiSelectController<AssignedUser>().obs;

  RxList<CallType> callCategoryList = <CallType>[].obs;
  Rx<String?> callCategoryId = Rx<String?>(null);
  Rx<CallType?> selectedCallCategory = Rx<CallType?>(null);

  RxList<CallType> callStatusList = <CallType>[].obs;
  Rx<String?> callStatusId = Rx<String?>(null);
  Rx<CallType?> selectedCallStatus = Rx<CallType?>(null);

  RxList<CallType> callPurposeList = <CallType>[].obs;
  Rx<String?> callPurposeId = Rx<String?>(null);
  Rx<CallType?> selectedCallPurpose = Rx<CallType?>(null);

  RxList<CustomerData> customerList = <CustomerData>[].obs;
  Rx<String?> callLeadId = Rx<String?>(null);
  Rx<CustomerData?> selectedCallLead = Rx<CustomerData?>(null);

  Rx<List<User>?> selectedUser = Rx<List<User>?>(null);

  RxBool isLoading = false.obs;
  RxBool isCustomerDialogLoading = false.obs;
  RxString startTime = "".obs;
  RxString endTime = "".obs;

  Rx<List<User>?> callUserList = Rx<List<User>?>(null);

  clear({MultiSelectController? a}) {
    dateController.value.clear();
    remarksController.value.clear();
    addCallMOMController.value.clear();
    companyNameController.value.clear();
    callCategoryId.value = null;
    selectedCallCategory.value = null;
    callStatusId.value = null;
    selectedCallStatus.value = null;
    callPurposeId.value = null;
    selectedCallPurpose.value = null;
    callLeadId.value = null;
    selectedCallLead.value = null;
    isLoading.value = false;
    startTime.value = "";
    endTime.value = "";
    selectedUser.value = null;
    a!.clearAll();
  }

  Future<void> addCall({bool loading = false, required Map<String, dynamic> data, bool isUpdate = false, String? id, MultiSelectController? a}) async {
    ApiHandler.logger.i(data);
    if (loading) {
      isLoading.value = true;
    }
    d.Response response;
    if (isUpdate) {
      response = await ApiHandler.postRequest(url: "${ApiEndPoint.call}/$id", body: data);
    } else {
      response = await ApiHandler.postRequest(url: ApiEndPoint.call, body: data);
    }

    if (response.statusCode == 200) {
      if (isUpdate) {
        toastMessage(text: "Call Update Successfully", color: AppColors.greenColor, isTop: false);
      } else {
        toastMessage(text: "Call added Successfully", color: AppColors.greenColor, isTop: false);
      }
      clear(a: a);
      if (loading) {
        isLoading.value = false;
      }
      Get.back();
    } else {
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> editCall({bool loading = false, String? id, MultiSelectController? a}) async {
    if (loading) {
      isLoading.value = true;
    }

    var response = await ApiHandler.getRequest("${ApiEndPoint.call}/$id?UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      EditCallResponseModel editCallResponseModel = editCallResponseModelFromJson((response.data));

     dateController.value.text = editCallResponseModel.data.callDate;
      callPurposeId.value = editCallResponseModel.data.callPurpose;
      selectedCallPurpose.value = CallType(codeDesc: editCallResponseModel.data.purpose, codeType: "", codeId: editCallResponseModel.data.callPurpose);
      callCategoryId.value = editCallResponseModel.data.callCategoryId.toString();
      selectedCallCategory.value = CallType(codeDesc: editCallResponseModel.data.callCategoryName, codeType: "", codeId: editCallResponseModel.data.callCategoryId.toString());
      callLeadId.value = editCallResponseModel.data.leadId;
      selectedCallLead.value = CustomerData(customerCode: editCallResponseModel.data.leadId, customerName: editCallResponseModel.data.customerName);
      callStatusId.value = editCallResponseModel.data.callStatusId.toString();
      selectedCallStatus.value = CallType(codeDesc: editCallResponseModel.data.callStatus, codeType: "", codeId: editCallResponseModel.data.callStatusId.toString());
      startTime.value = editCallResponseModel.data.startTime;
      endTime.value = editCallResponseModel.data.endTime;
      remarksController.value.text = editCallResponseModel.data.remarks;
      companyNameController.value.text = editCallResponseModel.data.customerName;
      callLeadId.value = editCallResponseModel.data.leadId;
      addCallMOMController.value.text = editCallResponseModel.data.callMOM;

      final attendees = editCallResponseModel.data.attendees;
      final attendeeNames = editCallResponseModel.data.attendeeNames;
      final attendeeIds = attendees.split(",");
      final attendeeNamesList = attendeeNames.split(",");

      if (attendeeIds.length == attendeeNamesList.length) {
        final users = List<User>.generate(attendeeIds.length, (index) => User(userId: attendeeIds[index], name: attendeeNamesList[index]));
        selectedUser.value = users;
      }
      a!.selectWhere((item) {
        return selectedUser.value!.map((user) => user.userId).toList().contains(item.value.userId);
      });
      if (loading) {
        isLoading.value = false;
      }
    } else {
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> getUser({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getUser);

    if (response.statusCode == 200) {
      GetUserResponseModel getUserResponseModel = getUserResponseModelFromJson(response.data);

      callUserList.value = getUserResponseModel.data;
      callUserList.refresh();
      update();
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getCategory({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getCallCategory);

    if (response.statusCode == 200) {
      CallModuleResponseModel callModuleResponseModel = callModuleResponseModelFromJson(response.data);
      callCategoryList.value = callModuleResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getStatus({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getCallStatus);

    if (response.statusCode == 200) {
      CallModuleResponseModel callModuleResponseModel = callModuleResponseModelFromJson(response.data);
      callStatusList.value = callModuleResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getPurpose({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getCallPurpose);

    if (response.statusCode == 200) {
      CallModuleResponseModel callModuleResponseModel = callModuleResponseModelFromJson(response.data);
      callPurposeList.value = callModuleResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getLead({bool isLoading = false, String? text}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getCustomer}?searchtext=${text}");

    if (response.statusCode == 200) {
      GetCustomerResponseModel getCustomerResponseModel = getCustomerResponseModelFromJson(response.data);
      customerList.value = getCustomerResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }
}
