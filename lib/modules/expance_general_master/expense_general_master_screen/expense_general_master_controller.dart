import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/expense_general_master_screen/expense_model.dart';

import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
class ExpenseGeneralMasterController extends GetxController{
  RxList<ExpensesGeneralMaster> expensesGeneralMasterList = <ExpensesGeneralMaster>[].obs;

  RxBool isLoading = false.obs;

  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;

  Rx<String?> dateController = Rx<String?>(null);

  Future<void> getExpenseData({
    int? page,
    bool loading = false,
    String transportMode = '',
    String designation = '',
    bool isAssign = false,
    bool dataClear = false,
  }) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      expensesGeneralMasterList.clear();
    }

    String url = '';

    if(transportMode.isNotEmpty){
      url += "&TransportMode=$transportMode";
    }

    if(designation.isNotEmpty){
      url += "&Designation=$designation";
    }


    var response = await ApiHandler.getRequest("${ApiEndPoint.expenseGeneralMaster}list?Page=$page&PageSize=15$url&export=false");

    if (response.statusCode == 200) {
      ExpensesGeneralMasterListResponse expensesGeneralMasterListResponse = expensesGeneralMasterListResponseFromJson(response.data);

      if (isAssign) {
        expensesGeneralMasterList.assignAll(expensesGeneralMasterListResponse.expensesGeneralMasterList);
      } else {
        expensesGeneralMasterList.addAll(expensesGeneralMasterListResponse.expensesGeneralMasterList);

      }
      totalCount.value = expensesGeneralMasterListResponse.totalCount;
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