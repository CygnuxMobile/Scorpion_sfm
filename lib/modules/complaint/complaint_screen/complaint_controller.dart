import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/complaint_screen/model/complaint_list_response.dart';

import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ComplaintController extends GetxController {
  Rx<TextEditingController> filterListController = TextEditingController(text: 'All').obs;


  RxBool isLoading = false.obs;

  RxList<ComplaintListDatum> complaintListData = <ComplaintListDatum>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;


  Future<void> getComplaintList({
    required int page,
    bool loading = false,
    bool isAssign = false,
    bool dataClear = false,
  }) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      complaintListData.clear();
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getComplaintList}?Page=$page&PageSize=5&UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      ComplaintListResponseModel complaintListResponseModel = complaintListResponseModelFromJson(response.data);

      if (isAssign) {
        complaintListData.assignAll(complaintListResponseModel.complaintListData);
      } else {
        complaintListData.addAll(complaintListResponseModel.complaintListData);

      }
      totalCount.value = complaintListResponseModel.totalCount;
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
