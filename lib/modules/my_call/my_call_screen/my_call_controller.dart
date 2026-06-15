import 'package:get/get.dart';
import 'package:scorpforce/modules/my_call/my_call_screen/my_call_model.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../add_my_call_screen/call_module_response_model.dart';
class MyCallController extends GetxController{
  RxList<CallDatum> callData = <CallDatum>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;

  Rx<String?> dateController = Rx<String?>(null);
  Rx<String?> callCategory = Rx<String?>(null);
  Rx<CallType?> selectedCallCategory = Rx<CallType?>(null);

  RxBool isLoading = false.obs;


  void getCallData({
    required int page,
    bool loading = false,
    String? callDate,
    String? callCategory,
    bool dataClear = false,
}) async {
    if (loading) {
      isLoading.value = true;
    }
    if (dataClear) {
      callData.clear();
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.call}?Page=$page&PageSize=5&CallCategory=${callCategory ?? ""}&CallDate=${callDate ?? ""}&UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      CallResponseModel callResponseModel = callResponseModelFromJson(response.data);
      callData.addAll(callResponseModel.callData);
      totalCount.value = callResponseModel.totalCount;
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