
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../config/app_colors.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../../widget/toast_message.dart';

class AddExpenseGeneralMasterController extends GetxController {
  Rx<TextEditingController> ratePerKmController = TextEditingController().obs;

  RxList<TransportMode> transportModeList = <TransportMode>[].obs;
  RxList<TransportMode> designationList = <TransportMode>[].obs;

  Rx<String?> transportId = Rx<String?>(null);
  Rx<String?> designationId = Rx<String?>(null);
  Rx<String> filterTransport = "".obs;
  Rx<String> filterDesignation = "".obs;
  Rx<TransportMode?> selectedTransportMode = Rx<TransportMode?>(null);
  Rx<TransportMode?> selectedDesignation = Rx<TransportMode?>(null);

  Rx<bool> isLoading = false.obs;
  RxBool isActive = true.obs;

  ctrlClear() {
    selectedTransportMode.value = null;
    selectedDesignation.value = null;
    ratePerKmController.value.clear();
    transportId.value = '';
    designationId.value = '';
  }

  Future<void> getTransportMode({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.generalMaster}?codeType=SERCAT");

    if (response.statusCode == 200) {
      GetTransportModeResponseModel getTransportModeResponseModel = getTransportModeResponseModelFromJson(response.data);
      transportModeList.value = getTransportModeResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getDesignationMode({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.generalMaster}?codeType=DESIG");

    if (response.statusCode == 200) {
      GetTransportModeResponseModel getTransportModeResponseModel = getTransportModeResponseModelFromJson(response.data);
      designationList.value = getTransportModeResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> addExpense({
    bool isEdit = false,
    bool loading = false,
    String id = "0",
    String designationId = "",
    String transportModeId = "",
    String ratePerKM = "",
    String createdBy = "",
    String modifiedBy = "",
  }) async {
    dio.Response response;
    if (loading) {
      isLoading.value = true;
    }
    String url = "";

    if (isEdit) {
      url = "edit?id=1";
    } else {
      url = "add";
    }

    response = await ApiHandler.postRequest(
      url: "${ApiEndPoint.expenseGeneralMaster}$url",
      body: {
        "id": id,
        "designationId": designationId,
        "transportModeId": transportModeId,
        "ratePerKM": ratePerKM,
        "createdBy": isEdit ? createdBy : Pref.getUserId(),
        "modifiedBy": isEdit ? Pref.getUserId() : modifiedBy,
        "active": isActive.value,
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Added");

      if (response.data["success"] == true) {
        await ctrlClear();
        toastMessage(isTop: false, color: AppColors.greenColor, text: "Expense added successfully");

        if (loading) {
          isLoading.value = false;
        }
        Get.back();
      }else{
        toastMessage(isTop: false, color: AppColors.yellow500, text: response.data["error"]["message"]);
        if (loading) {
          isLoading.value = false;
        }
      }
    } else {
      debugPrint("Not Added");
      toastMessage(isTop: false, color: AppColors.redColor, text: "Not Added");
      debugPrint("${response.statusCode}");
      if (loading) {
        isLoading.value = false;
      }
    }
  }
}
