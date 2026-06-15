import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/customer/customer_screen/model/customer_model.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../meeting/add_meeting_screen/get_customer_list_model.dart';

class CustomerController extends GetxController {
  ///Bool
  RxBool isLoading = false.obs;
  RxBool isCustomerDialogLoading = false.obs;
  RxBool isSearchOnTap = false.obs;

  ///List
  RxList<CustomerList> customerList = <CustomerList>[].obs;

  RxList<CustomerData> customerListData = <CustomerData>[].obs;
  Rx<String?> customerId = Rx<String?>(null);
  Rx<CustomerData?> selectedCustomer = Rx<CustomerData?>(null);

  // Rx<String?> customerName = Rx<String?>(null);

  Rx<TextEditingController> customerName = TextEditingController().obs;

  ///Int
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;

  /// Controllers
  Rx<TextEditingController> startDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 30)))).obs;
  Rx<TextEditingController> endDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()).obs;

  /// Fetches customer data from the API
  Future<void> getCustomerData({
    required int page,
    String? customerName,
    bool loading = false,
  }) async {
    if (loading) {
      isLoading.value = true;
    }
    String apiUrl = "${ApiEndPoint.getCustomerList}?CustomerName=${customerName ?? ""}&Page=$page&UserID=${Pref.getUserId()}&PageSize=15&startDate=${startDate.value.text}&endDate=${endDate.value.text}";

    var response = await ApiHandler.getRequest(apiUrl);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);

      if (data["success"] == true) {
        CustomerResponse customerResponse = customerResponseFromJson(response.data);
        customerList.value = customerResponse.customerList;
        totalCount.value = customerResponse.totalCount;
      }
    }

    if (loading) {
      isLoading.value = false;
    }
  }

  /// Customer filter api
  Future<void> getCustomer({bool isLoading = false, String? text}) async {
    if (isLoading) {
      isCustomerDialogLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getCustomer}?searchtext=$text");

    if (response.statusCode == 200) {
      GetCustomerResponseModel getCustomerResponseModel = getCustomerResponseModelFromJson(response.data);
      customerListData.value = getCustomerResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
    }
    if (isLoading) {
      isCustomerDialogLoading.value = false;
    }
  }
}
