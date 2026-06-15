import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../add_lead/model/get_category_response_model.dart';
import 'package:scorpforce/modules/lead/lead_screen/lead_responce_model.dart';

class LeadController extends GetxController {
  RxList<Datum> leadData = <Datum>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;
  Rx<String?> dateController = Rx<String?>(null);
  Rx<String?> leadCategory = Rx<String?>(null);
  Rx<Categories?> selectedCategory = Rx<Categories?>(null);
  Rx<TextEditingController> startDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, 1))).obs;
  Rx<TextEditingController> endDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()).obs;
  Rx<TextEditingController> customerNameSearch = TextEditingController().obs;

  RxBool isLoading = false.obs;
  RxBool isSearchOnTap = false.obs;
  Timer? _debounce;
  String lastQuery = "";

  void onSearchChanged(String query) {
    if (query == lastQuery) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      lastQuery = query;

      getLeadData(
        loading: true,
        page: 1,
        dataClear: true,
        searchCustomer: query,
        leadCategory: null,
      );
    });
  }

  void clearSearch() {
    customerNameSearch.value.clear();
    lastQuery = "";

    getLeadData(
      loading: true,
      page: 1,
      dataClear: true,
      searchCustomer: "",
      leadCategory: null,
    );
  }

  Future<void> getLeadData({required int page, bool loading = false, String? leadCategory, bool dataClear = false, String searchCustomer = ''}) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      leadData.clear();
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.leadList}?Page=$page&PageSize=15&SearchCustomer=$searchCustomer&UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      LeadModel leadModel = leadModelFromJson(response.data);

      leadData.addAll(leadModel.data);
      totalCount.value = leadModel.totalCount;

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
