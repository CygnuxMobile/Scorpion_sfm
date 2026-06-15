import 'dart:convert';
import 'package:get/get.dart';
import 'package:scorpforce/modules/myTask/view_task/view_task_model.dart';

import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ViewTaskController extends GetxController{

    Rx<Task> taskDetail = Task(taskDescription: "", taskName: "", leadId: "", priorityId: 0, leadCategoryId: 0, assignedTos: "assignedTos", taskId: "", leadCategoryName: "", taskDate: "", customerName: "", startTime: "", endTime: "", taskStatus: "", assignedToNames: '', priority: '', leadCategory: '').obs;
RxBool isLoading = false.obs;
  @override
  void onInit() {

    // TODO: implement onInit
    super.onInit();
  }


  void getTaskData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.task}/$id");

    if (response.statusCode == 200) {
      ViewTaskResponseModel viewTaskResponseModel = ViewTaskResponseModel.fromJson(json.decode(response.data));
      taskDetail.value = viewTaskResponseModel.data;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}