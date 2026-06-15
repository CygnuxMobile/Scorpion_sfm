import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/complaint/view_complaint/model/escalated_history_response_model.dart';
import 'package:scorpforce/modules/complaint/view_complaint/model/update_history_response_model.dart';
import 'package:scorpforce/modules/complaint/view_complaint/view_complaint_response_model.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../add_complaint/model/get_docData_response.dart';
class ViewComplaintController extends GetxController {
  late Rx<ViewComplaintData> expenseDetail = ViewComplaintData(
    complaintId: "complaintId",
    documentNo: "documentNo",
    edd: "edd",
    documentDate: "documentDate",
    origin: "origin",
    destination: "destination",
    customerName: 'customerName',
    compalaintDate: 'compalaintDate',
    compaintStatus: 'compaintStatus',
    resolutionDate: 'resolutionDate',
    slaInHr: 'slaInHr',
    raisedBy: 'raisedBy',
    assignedTo: 'assignedTo',
    isEscalated: false,
    isClosed: false,
    ticketAddressTo: 'ticketAddressTo',
    ticketSource: 'ticketSource',
    ticketDate: 'ticketDate',
    ticketType: 'ticketType',
    ticketSubType: 'ticketSubType',
    ticketPriority: 'ticketPriority',
    source: 0,
    type: 0,
    subType: 0,
    priority: 0,
    description: 'description',
    customerEmail: 'customerEmail',
    document: 'document',
    escalationId: 'escalationId',
    escalationTo: 'escalationTo',
    escalationDate: 'escalationDate',
    escalationHistory: 'escalationHistory',
    escEmailId: 'escEmailId',
    updateDate: 'updateDate',
    updateRemark: 'updateRemark',
    updateHistory: 'updateHistory',
    closeBy: 'closeBy',
    closeDate: 'closeDate',
    totalCount: 0,
  ).obs;

  RxList<EscalatedHistoryDatum>  escalatedHistoryData = <EscalatedHistoryDatum>[].obs;
  RxList<UpdateHistoryDatum>  updateHistoryData = <UpdateHistoryDatum>[].obs;
  RxBool isLoading = false.obs;


  RxString billingParty  = ''.obs;
  RxString origin  = ''.obs;
  RxString destination  = ''.obs;
  RxString currentLocation  = ''.obs;
  RxString currentStatus  = ''.obs;
  RxString eDD  = ''.obs;
  RxString docDate  = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getComplaintViewData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.getDetail}/$id&UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      ViewComplaintResponseModel viewComplaintResponseModel = viewComplaintResponseModelFromJson(response.data);
      expenseDetail.value = viewComplaintResponseModel.viewComplaintData;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  void getUpdateHistoryData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.getUpdateHistory}$id");

    if (response.statusCode == 200) {
      UpdateHistoryResponseModel updateHistoryResponseModel = updateHistoryResponseModelFromJson(response.data);
      updateHistoryData.value = updateHistoryResponseModel.updateHistoryData;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  void getEscalatedHistoryData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.getEscalatedHistory}$id");

    if (response.statusCode == 200) {
      EscalatedHistoryResponseModel escalatedHistoryResponseModel = escalatedHistoryResponseModelFromJson(response.data);
      escalatedHistoryData.value = escalatedHistoryResponseModel.escalatedHistoryData;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  String convertDateFormat(String inputDate) {
    try {
      DateFormat inputFormat = DateFormat("dd MMM yyyy");

      DateTime parsedDate = inputFormat.parseStrict(inputDate);

      DateFormat outputFormat = DateFormat("dd/MM/yyyy");
      return outputFormat.format(parsedDate);
    } catch (e) {
      return "-";
    }
  }

  Future<void> getDocketData({bool loading = false, Map<String, dynamic>? data, required String docId, bool? isDocket = false}) async {
    if (loading) {
      isLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getDocData}$docId");

    if (response.statusCode == 200) {
      GetDocDataResponseModel getDocDataResponseModel = getDocDataResponseModelFromJson(response.data);
      GetDocData getDocData = getDocDataResponseModel.getDocData;

      billingParty.value = getDocData.customerName;
      origin.value = getDocData.origin;
      destination.value = getDocData.destination;
      currentLocation.value = getDocData.currentLocation;
      currentStatus.value = getDocData.currentStatus;
      eDD.value = convertDateFormat(getDocData.edd);
      docDate.value = convertDateFormat(getDocData.documentDate);

      if (loading) {
        isLoading.value = false;
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (loading) {
        isLoading.value = false;
      }
    }
  }
}
