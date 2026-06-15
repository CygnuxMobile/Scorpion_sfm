import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/expance/expense_screen/expense_model.dart';

import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ExpenseController extends GetxController {
  RxList<ExpenseDatum> expenseData = <ExpenseDatum>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;

  /// Controllers
  Rx<TextEditingController> startDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 30)))).obs;
  Rx<TextEditingController> endDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()).obs;


  RxBool isLoading = false.obs;

  Future<void> getExpenseData({
    required int page,
    bool loading = false,
    String? startDate,
    String? endDate,
    bool isAssign = false,
    bool dataClear = false,
    bool isExpense = true,
  }) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      expenseData.clear();
    }

    var url = isExpense
        ? "${ApiEndPoint.expense}?userId=${Pref.getUserId()}&Page=$page&PageSize=15&startDate=${startDate ?? ""}&endDate=${endDate ?? ""}"
        : "${ApiEndPoint.expenseApprovalList}?userId=${Pref.getUserId()}&Page=$page&PageSize=15";

    var response = await ApiHandler.getRequest(url);

    if (response.statusCode == 200) {
      ExpenseResponseModel expenseResponseModel = expenseResponseModelFromJson(response.data);

      if (isAssign) {
        expenseData.assignAll(expenseResponseModel.expenseData);
      } else {
        expenseData.addAll(expenseResponseModel.expenseData);
      }
      totalCount.value = expenseResponseModel.totalCount;
      if (loading) {
        isLoading.value = false;
      }
    } else {
      if (loading) {
        isLoading.value = false;
      }
    }
  }

// Future<void> statesApproved({
//   bool loading = false,
//   String? expenseDate,
//   required Map<String, String> data,
//   int? index,
//   bool isApprove = false,
// }) async {
//   if (loading) {
//     isLoading.value = true;
//   }
//
//   var response = await ApiHandler.postRequest(url: ApiEndPoint.expenseApproval, body: data);
//
//   if (response.statusCode == 200) {
//     Logger logger = Logger();
//     logger.i(response.data);
//     expenseData[index!].status = isApprove ? "Approved" : "Rejected";
//     expenseData.refresh();
//     if (loading) {
//       isLoading.value = false;
//     }
//     /*for (int i = 1; i <= pageCount.value; i++) {
//       await getExpenseData(page: i, isAssign: i == 1 ? true : false);
//     }*/
//   } else {
//     if (loading) {
//       isLoading.value = false;
//     }
//   }
// }
}
