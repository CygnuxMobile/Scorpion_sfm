import 'package:get/get.dart';
import 'package:scorpforce/modules/expance/view_expense/view_expense_model.dart';

import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ViewExpenseController extends GetxController {
  late Rx<ViewExpenseData> expenseDetail = ViewExpenseData(
    punchedInLocation: "punchedInLocation",
    checkedInLocation: "checkedInLocation",
    distanceInKm: 0,
    supportingDocument: 'supportingDocument',
    remarks: 'remarks',
    transportMode: 'transportMode',
    transportModeId: 'transportModeId',
    expenseId: 'expenseId',
    expenseCreated: false,
    expenseCode: 'expenseCode',
    expenseDate: 'expenseDate',
    expenseRate: 0,
    amount: 0,
    status: 'status',
    totalCount: 0,
    meetingId: 'meetingId',
    createdBy: 'createdBy',
    leadId: 'leadId',
    companyName: 'companyName',
    meetingLat: 0,
    meetingLng: 0,
    checkIn: 'checkIn',
    checkOut: 'checkOut',
    distanceTravelled: 0,
    requestId: 'requestId',
    requestDate: 'requestDate',
    isApproved: false,
    approvedBy: 'approvedBy',
    approvedDate: 'approvedDate',
    isAuditApproved: false,
    auditedBy: 'auditedBy',
    auditDate: 'auditDate',
    auditRemarks: 'auditRemarks',
    expenseAddedDate: 'expenseAddedDate',
    expenseAddedTime: 'expenseAddedTime',
    expenseModifiedDate: 'expenseModifiedDate',
    expenseModifiedTime: 'expenseModifiedTime',
    isEdit: 'isEdit',
    adminApproved: false,
    managerApproved: false,
    managerRemark: 'managerRemark',
    auditRemark: 'auditRemark',
    expenseAddedBy: 'expenseAddedBy',
    expenseEditedBy: 'expenseEditedBy',
    expensEditDate: 'expensEditDate',
    approveByManagerName: 'approveByManagerName',
    approvedManagerDate: 'approvedManagerDate',
    approvedByAuditorName: 'approvedByAuditorName',
    approvedByAuditDate: 'approvedByAuditDate',
  ).obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getExpenseViewData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.expense}/$id?userId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      ViewExpenseResponseModel viewExpenseResponseModel = viewExpenseResponseModelFromJson(response.data);
      expenseDetail.value = viewExpenseResponseModel.viewExpenseData;
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
