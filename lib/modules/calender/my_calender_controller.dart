import 'dart:convert';
import 'package:get/get.dart';
import 'package:scorpforce/modules/calender/my_calender_response_model.dart';

import '../../config/app_url.dart';
import '../../utils/api_handler.dart';

class MyCalenderController extends GetxController {
  @override
  void onInit() {
    getCalenderData();
    // TODO: implement onInit
    super.onInit();
  }

  RxBool isLoading = false.obs;

  RxList<Datum> calenderData = <Datum>[].obs;

  Future<void> getCalenderData() async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest(ApiEndPoint.calender);

    if (response.statusCode == 200) {
      MyCalendarResponceModel myCalendarResponceModel = MyCalendarResponceModel.fromJson(json.decode(response.data));
      calenderData.value = myCalendarResponceModel.data;
      update();
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
