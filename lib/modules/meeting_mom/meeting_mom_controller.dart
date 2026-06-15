import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/config/app_colors.dart';
import 'package:scorpforce/modules/widget/toast_message.dart';

import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../utils/api_handler.dart';
import '../meeting/add_meeting_screen/model/momList_response_model.dart';
import 'model/meeting_mom_response.dart';

class MeetingMomController extends GetxController {
  RxList<MeetingMomDatum> meetingMomList = <MeetingMomDatum>[].obs;
  Rx<List<MomListDatum>?> momList = Rx<List<MomListDatum>?>(null);

  Rx<TextEditingController> remarksController = TextEditingController().obs;

  Rx<List<MomListDatum>?> selectedMom = Rx<List<MomListDatum>?>(null);

  RxBool isLoading = false.obs;
  RxBool isMomLoading = false.obs;

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

  Future<void> submitMeetingMom(Map<String, dynamic> data) async {
    try {
      final response = await ApiHandler.postRequest(url: '${ApiEndPoint.submitMeetingMom}${Pref.getUserId()}', body: data);

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint("mom mom == ${response.data}");
        debugPrint("mom mom == ${response.data.runtimeType}");

        if (data['success'] == true) {
          toastMessage(text: data['data']['message'], color: AppColors.redColor);
          meetingMomApi();
        } else {
          toastMessage(text: "Error In MOM Submit", color: AppColors.redColor);
        }
      } else {
        toastMessage(text: "Error In MOM Submit", color: AppColors.redColor);
      }
    } catch (e) {
      debugPrint("Meeting MOM API Error: $e");
    } finally {}
  }
}
