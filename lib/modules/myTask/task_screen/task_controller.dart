import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/myTask/task_screen/task_responce_model.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../lead/add_lead/model/get_category_response_model.dart';

class TaskController extends GetxController {
  RxList<Task> taskData = <Task>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;

  Rx<String?> dateController = Rx<String?>(null);
  Rx<String?> leadCategory = Rx<String?>(null);
  Rx<Categories?> selectedCategory = Rx<Categories?>(null);

  RxBool isLoading = false.obs;

  void getTaskData({
    required int page,
    bool loading = false,
    String? taskDate,
    String? leadCategory,
    bool dataClear = false,
  }) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      taskData.clear();
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.task}?Page=$page&PageSize=10&TaskDate=${taskDate ?? ""}&userid=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      TaskDataResponseModel taskDataResponseModel = taskDataResponseModelFromJson(response.data);
      taskData.addAll(taskDataResponseModel.data);
      totalCount.value = taskDataResponseModel.totalCount;
      debugPrint("Lead data === $taskData");
      if (loading) {
        isLoading.value = false;
      }
    } else {
      if (loading) {
        isLoading.value = false;
      }
    }
  }
}
