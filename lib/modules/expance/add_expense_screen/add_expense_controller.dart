import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/add_expence_response_model.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/edit_expense_response_model.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_expense_generalMaster_response_model.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../widget/toast_message.dart';

class AddExpenseController extends GetxController {
  // RxString transportMode = "".obs;
  Rx<TextEditingController> dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())).obs;
  Rx<TextEditingController> punchInLocationController = TextEditingController().obs;
  Rx<TextEditingController> checkedInLocationController = TextEditingController().obs;
  Rx<TextEditingController> distanceInKmController = TextEditingController().obs;
  Rx<TextEditingController> auditorRemarksController = TextEditingController().obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> remarkController = TextEditingController().obs;
  Rx<File?> image = Rx<File?>(null);
  Rx<bool> isLoading = false.obs;
  Rx<bool> isApproveLoading = false.obs;
  Rx<bool> isRejectLoading = false.obs;
  RxList<TransportMode> transportModeList = <TransportMode>[].obs;
  RxList<GetExpenseGeneralMasterDatum> getExpenseGeneralMasterData = <GetExpenseGeneralMasterDatum>[].obs;
  Rx<TransportMode?> selectedTransportMode = Rx<TransportMode?>(null);
  Rx<String?> transportId = Rx<String?>(null);
  Rx<String?> selectedImage = Rx<String?>(null);
  Rx<String?> meetingId = Rx<String?>(null);
  Rx<String?> attendeeCode = Rx<String?>(null);
  RxInt pageCount = 1.obs;
  RxInt totalCount = 1.obs;

  Rx<TextEditingController> customerNameController = TextEditingController().obs;
  Rx<TextEditingController> reqIDDateTimeController = TextEditingController().obs;
  Rx<TextEditingController> meetingDateController = TextEditingController().obs;
  Rx<TextEditingController> checkedOutLocationController = TextEditingController().obs;
  Rx<TextEditingController> expRateController = TextEditingController().obs;
  Rx<TextEditingController> expenseCodeController = TextEditingController().obs;

  Future<void> clear() async {
    customerNameController.value.clear();
    meetingDateController.value.clear();
    checkedOutLocationController.value.clear();
    expRateController.value.clear();
    expenseCodeController.value.clear();

    dateController.value.clear();
    amountController.value.clear();
    distanceInKmController.value.clear();
    checkedInLocationController.value.clear();
    punchInLocationController.value.clear();
    remarkController.value.clear();
    image.value = null;
    selectedImage.value = null;
    selectedTransportMode.value = null;
    transportId.value = null;
    meetingId.value = null;
    attendeeCode.value = null;
    update();
  }

  Future<void> addExpense({
    bool loading = false,
    bool isUpdate = false,
    String? id,
    String? meetingID,
    String? attendeeCode,
    File? image,
  }) async {
    http.StreamedResponse response;
    if (loading) {
      isLoading.value = true;
    }
    if (isUpdate) {
      response = await ApiHandler.multiPartRequest(
          url: "${ApiEndPoint.expense}/$id",
          data: {
            'MeetingId': meetingID.toString(),
            'AttendeeCode': attendeeCode.toString(),
            'TransportModeId': transportId.value!,
            'ExpenseDate': DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(dateController.value.text)),
            'PunchedInLocation': punchInLocationController.value.text,
            'CheckedInLocation': checkedInLocationController.value.text,
            'DistanceInKm': distanceInKmController.value.text,
            'Amount': amountController.value.text,
            'Remarks': remarkController.value.text,
            "userId": Pref.getUserId().toString(),
            "ModifiedBy": Pref.getUserId().toString(),
            "CreatedBy": Pref.getUserId().toString(),
            "file": "",
          },
          image: image);
    } else {
      response = await ApiHandler.multiPartRequest(url: ApiEndPoint.expense, image: image, data: {
        "ModifiedBy": "",
        'CheckedInLocation': checkedInLocationController.value.text,
        'ExpenseDate': DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(dateController.value.text)),
        "UserId": Pref.getUserId().toString(),
        'PunchedInLocation': punchInLocationController.value.text,
        'TransportModeId': transportId.value!,
        'Remarks': remarkController.value.text,
        'MeetingId': meetingID.toString(),
        'AttendeeCode': attendeeCode.toString(),
        'Amount': amountController.value.text,
        "file": "",
        'DistanceInKm': distanceInKmController.value.text,
        "CreatedBy": Pref.getUserId().toString(),
      });
    }
    if (response.statusCode == 200) {
      debugPrint("Added");

      AddExpenseResponseModel addExpenseResponseModel = addExpenseResponseModelFromJson(await response.stream.bytesToString());
      if (addExpenseResponseModel.success == true) {
        await clear();
        toastMessage(isTop: false, color: AppColors.greenColor, text: "Expense added successfully");
        if (loading) {
          isLoading.value = false;
        }
        Get.back();
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> editExpense({bool loading = false, String? id, bool isEdit = true, bool isExpenseApproval = false}) async {
    if (loading) {
      isLoading.value = true;
    }

    var response = await ApiHandler.getRequest("${ApiEndPoint.expense}/$id?userId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      EditExpenseResponseModel editExpenseResponseModel = editExpenseResponseModelFromJson(response.data);

      expenseCodeController.value.text = editExpenseResponseModel.editExpensedData.expenseId;
      customerNameController.value.text = editExpenseResponseModel.editExpensedData.companyName;
      meetingDateController.value.text = editExpenseResponseModel.editExpensedData.expenseDate;
      transportId.value = editExpenseResponseModel.editExpensedData.transportModeId;
      dateController.value.text = editExpenseResponseModel.editExpensedData.expenseDate;
      punchInLocationController.value.text = editExpenseResponseModel.editExpensedData.checkedInLocation;
      checkedInLocationController.value.text = editExpenseResponseModel.editExpensedData.checkedInLocation;
      checkedOutLocationController.value.text = editExpenseResponseModel.editExpensedData.checkedInLocation;
      distanceInKmController.value.text = editExpenseResponseModel.editExpensedData.distanceTravelled.toString();
      remarkController.value.text = editExpenseResponseModel.editExpensedData.remarks;
      meetingId.value = editExpenseResponseModel.editExpensedData.meetingId;
      attendeeCode.value = editExpenseResponseModel.editExpensedData.attendeeCode;
      reqIDDateTimeController.value.text =
          editExpenseResponseModel.editExpensedData.requestDate.isEmpty ? "" : DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(editExpenseResponseModel.editExpensedData.requestDate));
      selectedImage.value = editExpenseResponseModel.editExpensedData.supportingDocument == "" ? null : editExpenseResponseModel.editExpensedData.supportingDocument;

      if (!isEdit) {
        if (isExpenseApproval) {
          selectedTransportMode.value = TransportMode(
              codeType: editExpenseResponseModel.editExpensedData.transportMode,
              codeId: editExpenseResponseModel.editExpensedData.transportModeId,
              codeDesc: editExpenseResponseModel.editExpensedData.transportMode);
          /*GetExpenseGeneralMasterDatum? matchingExpense = getExpenseGeneralMasterData.firstWhere(
            (element) {
              return element.transportModeId == int.parse(editExpenseResponseModel.editExpensedData.transportModeId) && element.designationId == int.parse(Pref.getDesignationId().toString());
            },
            orElse: () {
              return GetExpenseGeneralMasterDatum(
                  id: 0,
                  designationId: -1,
                  designation: "designation",
                  transportModeId: -1,
                  transportMode: "transportMode",
                  ratePerKm: 0,
                  createdBy: "createdBy",
                  createdDate: "createdDate",
                  modifiedBy: "modifiedBy",
                  modifiedDate: "modifiedDate",
                  isActive: false,
                  totalCount: 0);
            }, // Use a default object
          );*/
          distanceInKmController.value.text = editExpenseResponseModel.editExpensedData.distanceTravelled.toString();
          expRateController.value.text = double.tryParse(editExpenseResponseModel.editExpensedData.distanceTravelled.toString()) == 0
              ? "0"
              : ((double.tryParse(editExpenseResponseModel.editExpensedData.amount.toString()) ?? 0) / (double.tryParse(editExpenseResponseModel.editExpensedData.distanceTravelled.toString()) ?? 0))
                  .toStringAsFixed(0);
          // amountController.value.text = ((double.tryParse(expRateController.value.text) ?? 0) * (double.tryParse(distanceInKmController.value.text) ?? 0)).toInt().toString();
          amountController.value.text = editExpenseResponseModel.editExpensedData.amount.toStringAsFixed(0);
        } else {
          selectedTransportMode.value = null;
          expRateController.value.text = "0";
          amountController.value.text = ((double.tryParse(expRateController.value.text) ?? 0) * (double.tryParse(distanceInKmController.value.text) ?? 0)).toInt().toString();
        }
      } else {
        debugPrint("getDesignationId === ${Pref.getDesignationId()}");

        selectedTransportMode.value = TransportMode(
            codeType: editExpenseResponseModel.editExpensedData.transportMode,
            codeId: editExpenseResponseModel.editExpensedData.transportModeId,
            codeDesc: editExpenseResponseModel.editExpensedData.transportMode);
        GetExpenseGeneralMasterDatum? matchingExpense = getExpenseGeneralMasterData.firstWhere(
          (element) {
            return element.transportModeId == int.parse(editExpenseResponseModel.editExpensedData.transportModeId) && element.designationId == int.parse(Pref.getDesignationId().toString());
          },
          orElse: () {
            return GetExpenseGeneralMasterDatum(
                id: 0,
                designationId: -1,
                designation: "designation",
                transportModeId: -1,
                transportMode: "transportMode",
                ratePerKm: 0,
                createdBy: "createdBy",
                createdDate: "createdDate",
                modifiedBy: "modifiedBy",
                modifiedDate: "modifiedDate",
                isActive: false,
                totalCount: 0);
          }, // Use a default object
        );
        expRateController.value.text = matchingExpense.ratePerKm.toInt().toString();
        amountController.value.text = ((double.tryParse(expRateController.value.text) ?? 0) * (double.tryParse(distanceInKmController.value.text) ?? 0)).toInt().toString();
      }

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

  Future<void> getTransportMode({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getTransportMode);

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

  Future<void> getExpenseGeneralMaster({
    required int page,
    bool isLoading = false,
    Map<String, dynamic>? data,
  }) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getExpenseGeneralMaster}?Page=$page&PageSize=5000");

    if (response.statusCode == 200) {
      GetExpenseGeneralMasterResponseModel getTransportModeResponseModel = getExpenseGeneralMasterResponseModelFromJson(response.data);
      getExpenseGeneralMasterData.value = getTransportModeResponseModel.getExpenseGeneralMasterData;

      debugPrint("getExpenseGeneralMasterData length ===== ${getExpenseGeneralMasterData.length}");
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> statesApproved({
    bool loading = false,
    required bool isApproved,
    required String expenseId,
  }) async {
    if (loading) {
      isApproved ? isApproveLoading.value = true : isRejectLoading.value = true;
    }

    var response = await ApiHandler.postRequest(url: ApiEndPoint.expenseApproval, body: {
      "expenseId": expenseId,
      "meetingId": meetingId.value,
      "attendeeCode": attendeeCode.value,
      "isApproved": isApproved ? true : false,
      "approvedBy": Pref.getUserId(),
      "reasonRemark": auditorRemarksController.value.text,
    });

    if (response.statusCode == 200) {
      if (response.data["success"] == true) {
        Logger logger = Logger();
        logger.i(response.data);
        if (loading) {
          isApproved ? isApproveLoading.value = false : isRejectLoading.value = false;
        }
        if (isApproved) {
          toastMessage(text: "Expense approved successfully", color: AppColors.primaryColor);
        } else {
          toastMessage(text: "Expense reject successfully", color: AppColors.primaryColor);
        }
        Get.back();
        Get.back();
        auditorRemarksController.value.clear();
      } else {
        if (loading) {
          isApproved ? isApproveLoading.value = false : isRejectLoading.value = false;
        }
        toastMessage(text: "${response.data['error']['message']}", color: AppColors.yellow100);
      }
    } else {
      if (loading) {
        isApproved ? isApproveLoading.value = false : isRejectLoading.value = false;
      }
      toastMessage(text: "${response.data['error']['message']}", color: AppColors.yellow100);
    }
  }
}
