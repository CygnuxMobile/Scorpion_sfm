import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scorpforce/config/app_colors.dart';
import 'package:scorpforce/modules/widget/toast_message.dart';

import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../utils/api_handler.dart';
import '../expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../meeting/add_meeting_screen/model/momList_response_model.dart';
import '../my_call/add_my_call_screen/call_module_response_model.dart';
import 'model/meeting_mom_response.dart';

class MeetingMomController extends GetxController {
  RxList<MeetingMomDatum> meetingMomList = <MeetingMomDatum>[].obs;
  Rx<List<MomListDatum>?> momList = Rx<List<MomListDatum>?>(null);

  RxList<TransportMode> transportModeList = <TransportMode>[].obs;
  RxList<CallType> otherExpensesList = <CallType>[].obs;

  Rx<TextEditingController> remarksController = TextEditingController().obs;

  Rx<List<MomListDatum>?> selectedMom = Rx<List<MomListDatum>?>(null);

  RxBool isLoading = false.obs;
  RxBool isMomLoading = false.obs;

  Future<void> getTransportMode({bool showLoader = false}) async {
    try {
      var response = await ApiHandler.getRequest("${ApiEndPoint.generalMaster}?codeType=SERCAT");
      if (response.statusCode == 200) {
        GetTransportModeResponseModel getTransportModeResponseModel = getTransportModeResponseModelFromJson(response.data);
        transportModeList.value = getTransportModeResponseModel.data;
      }
    } catch (e) {
      debugPrint("Transport Mode API Error: $e");
    }
  }

  Future<void> getOtherExpensesList({bool showLoader = false}) async {
    try {
      var response = await ApiHandler.getRequest("${ApiEndPoint.genralmaster}OTHEREXPENSES");
      if (response.statusCode == 200) {
        final model = callModuleResponseModelFromJson(response.data);
        otherExpensesList.assignAll(model.data);
      }
    } catch (e) {
      debugPrint("Other Expenses API Error: $e");
    }
  }

  Future<void> meetingMomApi() async {
    try {
      isLoading.value = true;

      final response = await ApiHandler.getRequest('${ApiEndPoint.meetingMomList}?userid=${Pref.getUserId()}');

      if (response.statusCode == 200 && response.data != null) {
        MeetingMom meetingMomResponse = meetingMomFromJson(response.data);

        meetingMomList.value = meetingMomResponse.data;
      }
    } catch (e) {
      debugPrint("Meeting MOM API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMomList({bool showLoader = false}) async {
    try {
      final response = await ApiHandler.getRequest(ApiEndPoint.momList);

      if (response.statusCode == 200) {
        final model = momListResponseModelFromJson(response.data);
        momList.value = model.momListData;
      } else {
        throw Exception("MOM List API failed");
      }
    } catch (e) {
      debugPrint("MOM List Error: $e");
    }
  }

  Future<void> submitMeetingMom({
    required String meetingId,
    required String meetingMom,
    required String attendeeCode,
    required String remarks,
    required String transportMode,
    required String otherExpenses,
    required String otherExpenseAmt,
    File? documentFile,
  }) async {
    try {
      String userId = Pref.getUserId() ?? "";
      // String docName = documentFile != null ? documentFile.path.split('/').last : "";

      String url = "${ApiEndPoint.submitMeetingMom}?UserId=${Uri.encodeComponent(userId)}";

      debugPrint("SubmitMom URL: $url");

      var dioClient = ApiHandler.createRequest();
      
      Map<String, dynamic> body = {
        "MeetingId": meetingId,
        "MeetingMOM": meetingMom,
        "AttendeeCode": attendeeCode,
        "Remarks": remarks,
        "TransportMode": transportMode,
        "OtherExpenses": otherExpenses,
        "OtherExpenseAmt": otherExpenseAmt,
        "OtherExpenseDocument": documentFile,
      };

      var formData = dio.FormData.fromMap(body);

      if (documentFile != null && await documentFile.exists()) {
        formData.files.add(
          MapEntry(
            "OtherExpenseDocumentFile",
            await dio.MultipartFile.fromFile(
              documentFile.path,
              filename: documentFile.path,
            ),
          ),
        );
      }

      dio.Response response = await dioClient.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'accept': '*/*',
            'Authorization': "Bearer ${Pref.getToken()}",
          },
        ),
      );

      if (response.statusCode == 200) {
        var resData = response.data;
        if (resData is String) {
          resData = jsonDecode(resData);
        }
        if (resData['success'] == true) {
          toastMessage(text: resData['data']?['message'] ?? "MOM Submitted Successfully", color: AppColors.greenColor);
          meetingMomApi();
        } else {
          toastMessage(text: resData['error']?['message'] ?? "Error In MOM Submit", color: AppColors.redColor);
        }
      } else {
        toastMessage(text: "Error In MOM Submit", color: AppColors.redColor);
      }
    } catch (e) {
      debugPrint("Meeting MOM API Error: $e");
      toastMessage(text: "Error In MOM Submit: $e", color: AppColors.redColor);
    }
  }
}
