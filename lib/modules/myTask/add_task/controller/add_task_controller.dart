import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_url.dart';
import '../../../../utils/api_handler.dart';
import '../../../lead/add_lead/model/get_category_response_model.dart';
import '../../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../../lead/add_lead/model/get_user_response_model.dart';
import '../../../meeting/add_meeting_screen/get_customer_list_model.dart';
import '../../../widget/toast_message.dart';
import '../../view_task/view_task_model.dart';

class AddTaskController extends GetxController {
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> taskNameController = TextEditingController().obs;
  Rx<TextEditingController> taskDescriptionController = TextEditingController().obs;
  Rx<MultiSelectController<User>> controller = MultiSelectController<User>().obs;

  RxList<Categories> categoryList = <Categories>[].obs;
  Rx<Categories?> selectedCategory = Rx<Categories?>(null);
  Rx<String?> categoryId = Rx<String?>(null);

  RxList<User> userList = <User>[].obs;
  Rx<List<User>?> selectedUsers = Rx<List<User>?>(null);

  RxList<LeadSource> priorityList = <LeadSource>[].obs;
  Rx<String?> priorityId = Rx<String?>(null);
  Rx<LeadSource?> selectedPriority = Rx<LeadSource?>(null);

  RxList<CustomerData> customerList = <CustomerData>[].obs;
  Rx<String?> customerId = Rx<String?>(null);
  Rx<CustomerData?> selectedCustomer = Rx<CustomerData?>(null);

  RxBool isLoading = false.obs;

  Future<void> addTask({
    bool loading = false,
    Map<String, dynamic>? data,
    bool isUpdate = false,
    String? id,
    MultiSelectController? a,
  }) async {
    d.Response? response;
    if (loading) {
      isLoading.value = true;
    }
    if (isUpdate) {
      response = await ApiHandler.postRequest(url: "${ApiEndPoint.task}/$id", body: data!);
    } else {
      response = await ApiHandler.postRequest(url: ApiEndPoint.task, body: data!);
    }
    if (response.statusCode == 200) {
      if (isUpdate) {
        toastMessage(text: "Task update Successfully", color: AppColors.greenColor, isTop: false);
      } else {
        toastMessage(text: "Task added Successfully", color: AppColors.greenColor, isTop: false);
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

  Future<void> editTask({bool loading = false, String? id, MultiSelectController? a}) async {
    if (loading) {
      isLoading.value = true;
    }

    var response = await ApiHandler.getRequest("${ApiEndPoint.task}/$id");

    if (response.statusCode == 200) {
      ViewTaskResponseModel editTaskResponseModel = viewTaskResponseModelFromJson(response.data);

      dateController.value.text = editTaskResponseModel.data.taskDate.toString();
      taskNameController.value.text = editTaskResponseModel.data.taskName;

      taskDescriptionController.value.text = editTaskResponseModel.data.taskDescription;

      selectedCategory.value = Categories(codeType: "", codeId: editTaskResponseModel.data.leadCategoryId.toString(), codeDesc: editTaskResponseModel.data.leadCategoryName);
      categoryId.value = editTaskResponseModel.data.leadCategoryId.toString();

      selectedCustomer.value = CustomerData(customerCode: editTaskResponseModel.data.leadId, customerName: editTaskResponseModel.data.customerName);
      customerId.value = editTaskResponseModel.data.leadId;

      selectedPriority.value = LeadSource(
          codeDesc: editTaskResponseModel.data.priority.toString(),/*priorityList.firstWhere((element) => int.parse(element.codeId) == int.parse(editTaskResponseModel.data.priorityId.toString())).codeDesc,*/
          codeType: '',
          codeId: editTaskResponseModel.data.priorityId.toString());
      priorityId.value = editTaskResponseModel.data.priorityId.toString();

      final serviceInterestids = editTaskResponseModel.data.assignedTos;
      final attendeeIds = serviceInterestids.split(",");
      final serviceInterestids11 = editTaskResponseModel.data.assignedToNames  ;
      final attendeeNamesList = serviceInterestids11.split(",");


      if (attendeeIds.length == attendeeNamesList.length) {
        final user = List<User>.generate(attendeeIds.length, (index) => User(userId: attendeeIds[index], name: attendeeNamesList[index]));
        selectedUsers.value = user;
      }

      debugPrint("Datassss === $attendeeNamesList");
      a!.selectWhere((item) {
        return selectedUsers.value!.map((user) => user.userId).toList().contains(item.value.userId);
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

  void clear({MultiSelectController? a}) {
    taskNameController.value.clear();
    dateController.value.clear();
    taskDescriptionController.value.clear();
    selectedUsers.value = null;
    priorityId.value = null;
    selectedPriority.value = null;
    categoryId.value = null;
    selectedCategory.value = null;
    isLoading.value = false;
    selectedCustomer.value = null;
    customerId.value = null;
    a!.clearAll();
    update();
  }

  Future<void> getCategory({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getLeadCategory);

    if (response.statusCode == 200) {
      GetCategoryResponseModel callModuleResponseModel = getCategoryResponseModelFromJson(response.data);
      categoryList.value = callModuleResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
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
      userList.value = getUserResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getPriority({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getPriority);

    if (response.statusCode == 200) {
      GetLeadSourceResponseModel getLeadSourceResponseModel = getLeadSourceResponseModelFromJson(response.data);
      priorityList.value = getLeadSourceResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getCustomer({bool isLoading = false}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getCustomer);

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
