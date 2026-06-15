import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:dio/dio.dart' as dio;
import 'package:scorpforce/modules/complaint/add_complaint/model/get_complaint_subType_response_model.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_complaint_type_response_model.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_docData_response.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_userData_response.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../lead/add_lead/model/get_assign_response.dart';
import '../../lead/add_lead/model/get_branch_response_model.dart';
import '../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../lead/add_lead/model/get_user_response_model.dart';
import '../../meeting/add_meeting_screen/add_meeting_controller.dart';
import '../../widget/toast_message.dart';
import '../complaint_screen/model/get_ticket_address_to_response_model.dart';

class AddComplaintController extends GetxController {
  /// Add

  Rx<TextEditingController> docketNoController = TextEditingController().obs;
  Rx<TextEditingController> originController = TextEditingController().obs;
  Rx<TextEditingController> destinationController = TextEditingController().obs;
  Rx<TextEditingController> currentLocationController = TextEditingController().obs;
  Rx<TextEditingController> docketStatusController = TextEditingController().obs;
  Rx<TextEditingController> complaintDateController = TextEditingController().obs;
  Rx<TextEditingController> complaintDescriptionController = TextEditingController().obs;
  Rx<MultiSelectController<Assign>> assignToController = MultiSelectController<Assign>().obs;
  Rx<MultiSelectController<Assign>> escalateToController = MultiSelectController<Assign>().obs;
  Rx<bool> isSearch = false.obs;
  Rx<bool> isEscalationLoader = false.obs;

  /// Update Ticket

  Rx<TextEditingController> userIDController = TextEditingController().obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> managerIDController = TextEditingController().obs;
  Rx<TextEditingController> managerNameController = TextEditingController().obs;
  Rx<TextEditingController> docDateController = TextEditingController().obs;
  Rx<TextEditingController> eDDController = TextEditingController().obs;
  Rx<TextEditingController> billingPartyController = TextEditingController().obs;
  // Rx<TextEditingController> ticketAddressToController = TextEditingController().obs;
  Rx<TextEditingController> currentController = TextEditingController().obs;
  Rx<TextEditingController> ticketDateController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> custEmailIDController = TextEditingController().obs;
  Rx<TextEditingController> updateDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now())).obs;
  Rx<TextEditingController> closerDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now())).obs;
  Rx<TextEditingController> closeByController = TextEditingController().obs;
  Rx<TextEditingController> updateRemarksController = TextEditingController().obs;
  Rx<TextEditingController> closeRemarksController = TextEditingController().obs;

  ///Escalation

  Rx<TextEditingController> complaintIDController = TextEditingController().obs;
  Rx<TextEditingController> ticketStatusController = TextEditingController().obs;
  Rx<TextEditingController> escEmailIDController = TextEditingController().obs;
  Rx<TextEditingController> escDateController = TextEditingController().obs;
  Rx<TextEditingController> remarksController = TextEditingController().obs;

  Rx<File?> image = Rx<File?>(null);
  Rx<bool> isLoading = false.obs;
  Rx<bool> isGetData = false.obs;

  /// Designation Api
  // RxList<Designation> designationList = <Designation>[].obs;
  // Rx<String?> designationId = Rx<String?>(null);
  // Rx<Designation?> selectedDesignation = Rx<Designation?>(null);

  /// branch Api
  RxList<Branch> branchList = <Branch>[].obs;
  Rx<String?> branchId = Rx<String?>(null);
  Rx<Branch?> selectedBranch = Rx<Branch?>(null);

  RxList<TicketAddressTo> ticketAddressToList = <TicketAddressTo>[].obs;
  Rx<String?> ticketAddressToId = Rx<String?>(null);
  Rx<TicketAddressTo?> selectedTicketAddressTo = Rx<TicketAddressTo?>(null);

  /// Complaint Type Api
  RxList<ComplaintTypeDatum> complaintTypeList = <ComplaintTypeDatum>[].obs;
  Rx<String?> complaintType = Rx<String?>(null);
  Rx<ComplaintTypeDatum?> selectedComplaintType = Rx<ComplaintTypeDatum?>(null);

  /// Complaint Type Api
  RxList<ComplaintSubTypeDatum> complaintSubTypeList = <ComplaintSubTypeDatum>[].obs;
  Rx<String?> complaintSubType = Rx<String?>(null);
  Rx<ComplaintSubTypeDatum?> selectedComplaintSubType = Rx<ComplaintSubTypeDatum?>(null);

  /// priority Api
  RxList<LeadSource> priorityList = <LeadSource>[].obs;
  Rx<String?> priorityId = Rx<String?>(null);
  Rx<LeadSource?> selectedPriority = Rx<LeadSource?>(null);

  /// user Api
  RxList<User> userList = <User>[].obs;
  Rx<String?> assignedTo = Rx<String?>(null);
  Rx<User?> selectedUser = Rx<User?>(null);

  ///Ticket Address
  Rx<String?> ticketAddressId = Rx<String?>(null);
  Rx<Branch?> selectTicketAddress = Rx<Branch?>(null);

  /// leadSource
  Rx<Escalation?> escalationDetail = Rx<Escalation?>(null);

  RxList<LeadSource> leadSourceList = <LeadSource>[].obs;
  Rx<String?> leadSourceId = Rx<String?>(null);
  Rx<LeadSource?> selectedSource = Rx<LeadSource?>(null);

  ///Assign to

  Rx<List<Assign>?> assignList = Rx<List<Assign>?>(null);
  Rx<String?> assignToId = Rx<String?>(null);
  Rx<Assign?> selectedAssign = Rx<Assign?>(null);

  ///Escalate To
  RxList<Assign?> selectedEscalateTo = <Assign?>[].obs;
  RxList<String> emailIdList = <String>[].obs;
  RxString errorMessage = ''.obs;

  /// DocData
  GetDocData? getDocData;
  UserData? userData;

  RxInt pageCount = 1.obs;
  Future<void> clear() async {
    /// Add
    docketNoController.value.clear();
    originController.value.clear();
    destinationController.value.clear();
    docketStatusController.value.clear();
    complaintDescriptionController.value.clear();

    /// Update
    userIDController.value.clear();
    usernameController.value.clear();
    managerIDController.value.clear();
    managerNameController.value.clear();
    docDateController.value.clear();
    eDDController.value.clear();
    billingPartyController.value.clear();
    // ticketAddressToController.value.clear();
    currentController.value.clear();
    ticketDateController.value.clear();
    descriptionController.value.clear();
    custEmailIDController.value.clear();
    updateDateController.value.clear();
    closerDateController.value.clear();
    closeByController.value.clear();
    updateRemarksController.value.clear();
    closeRemarksController.value.clear();

    /// Close
    complaintIDController.value.clear();
    ticketStatusController.value.clear();
    escEmailIDController.value.clear();
    escDateController.value.clear();
    remarksController.value.clear();
    image.value = null;
    isLoading.value = false;
    isGetData.value = false;
    selectedBranch.value = null;
    selectedComplaintType.value = null;
    selectedComplaintSubType.value = null;
    selectedPriority.value = null;
    selectedSource.value = null;
    assignedTo.value = null;
    selectTicketAddress.value = null;
    emailIdList.clear();
    selectedAssign.value = null;
    update();
  }

  // Future<void> getDesignation({bool isLoading = false, Map<String, dynamic>? data}) async {
  //   if (isLoading) {
  //     isLoading = true;
  //   }
  //   var response = await ApiHandler.getRequest(ApiEndPoint.getDesignation);
  //
  //   if (response.statusCode == 200) {
  //     GetDesignationResponseModel getDesignationResponseModel = getDesignationResponseModelFromJson(response.data);
  //     designationList.value = getDesignationResponseModel.data;
  //   } else {
  //     debugPrint("Not Added");
  //     debugPrint("${response.statusCode}");
  //     if (isLoading) {
  //       isLoading = true;
  //     }
  //   }
  // }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void addEmail(String value) {
    if (value.contains(';')) {
      List<String> emails = value.split(';').map((e) => e.trim()).toList();
      String lastEmail = emails.first;

      if (lastEmail.isNotEmpty && isValidEmail(lastEmail)) {
        if (!emailIdList.contains(lastEmail)) {
          emailIdList.add(lastEmail);
          escalationEmailIds.add(lastEmail);
          escEmailIDController.value.clear();
          custEmailIDController.value.clear();
          errorMessage.value = '';
        } else {
          errorMessage.value = "Email already added.";
          escEmailIDController.value.clear();
        }
      } else {
        errorMessage.value = "Enter a valid email.";
        escEmailIDController.value.clear();
      }
    }
  }

  void removeEmail(String email) {
    emailIdList.remove(email);
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

  Future<void> getLeadSource({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getLeadSource);

    if (response.statusCode == 200) {
      GetLeadSourceResponseModel getLeadSourceResponseModel = getLeadSourceResponseModelFromJson(response.data);
      leadSourceList.value = getLeadSourceResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getComplaintType({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getComplaintType);

    if (response.statusCode == 200) {
      ComplaintTypeResponseModel complaintTypeResponseModel = complaintTypeResponseModelFromJson(response.data);
      complaintTypeList.value = complaintTypeResponseModel.complaintTypeData;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getComplaintSubType({bool isLoading = false, Map<String, dynamic>? data, String? id}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getComplaintSubType}?codeId=$id");

    if (response.statusCode == 200) {
      ComplaintSubTypeResponseModel complaintTypeResponseModel = complaintSubTypeResponseModelFromJson(response.data);
      complaintSubTypeList.value = complaintTypeResponseModel.complaintSubTypeData;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getBranch({bool isLoading = false, Map<String, dynamic>? data, AddMeetingController? addMeetingController}) async {
    var response = await ApiHandler.getRequest(ApiEndPoint.getBranch);

    if (response.statusCode == 200) {
      GetBranchResponseModel getBranchResponseModel = getBranchResponseModelFromJson(response.data);
      branchList.value = getBranchResponseModel.data;
      branchList.refresh();
      if (addMeetingController != null) {
        addMeetingController.branchList.value = getBranchResponseModel.data;
        addMeetingController.branchList.refresh();
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getTicketAddressTo({bool isLoading = false, Map<String, dynamic>? data, AddMeetingController? addMeetingController}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getTicketAddressTo);

    if (response.statusCode == 200) {
      GetTicketAddressToResponseModel getTicketAddressToResponseModel = getTicketAddressToResponseModelFromJson(response.data);
      ticketAddressToList.value = getTicketAddressToResponseModel.data;
      branchList.refresh();
      if (addMeetingController != null) {
        addMeetingController.ticketAddressToList.value = getTicketAddressToResponseModel.data;
        addMeetingController.ticketAddressToList.refresh();
      }
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

  Future<void> getAssignTo({required String branchCode}) async {
    var response = await ApiHandler.getRequest("${ApiEndPoint.assignTo}$branchCode");
    if (response.statusCode == 200) {
      GetAssignResponse getAssignResponse = getAssignResponseFromJson(response.data);
      assignList.value = getAssignResponse.data;
      if (assignList.value!.isEmpty) {
        assignList.value = null;
      }
      debugPrint("DaTATA === ${assignList.value}");
      debugPrint("DaTATA === ${assignList.value!.length}");
    } else {
      assignList.value = null;
      debugPrint("Not Added");
    }
  }

  Future<void> getUser({bool isLoading = false, Map<String, dynamic>? data, AddMeetingController? addMeetingController}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest(ApiEndPoint.getUser);

    if (response.statusCode == 200) {
      GetUserResponseModel getUserResponseModel = getUserResponseModelFromJson(response.data);
      userList.value = getUserResponseModel.data;
      userList.refresh();
      if (addMeetingController != null) {
        // addMeetingController.callUserList.value = getUserResponseModel.data;
        // addMeetingController.callUserList.refresh();
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

  Future<void> getDocketData({bool loading = false, Map<String, dynamic>? data, required String docId, bool? isDocket = false}) async {
    if (loading) {
      isLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getDocData}$docId");

    if (response.statusCode == 200) {
      GetDocDataResponseModel getDocDataResponseModel = getDocDataResponseModelFromJson(response.data);
      getDocData = getDocDataResponseModel.getDocData;

      debugPrint("fjhgsjdgjsg === ${getDocData!.customerEmail}");
      if (isDocket!) {
        if (getDocData!.customerEmail != "") {
          if (getDocData!.customerEmail.split(";").length == 1) {
            emailIdList.add(getDocData!.customerEmail);
            debugPrint("length === $emailIdList");
          } else {
            emailIdList.value = getDocData!.customerEmail.split(";");
          }
        } else {
          emailIdList.value = [];
        }
      }

      isSearch.value = false;
      isGetData.value = true;
      billingPartyController.value.text = getDocData!.customerName;
      originController.value.text = getDocData!.origin;
      destinationController.value.text = getDocData!.destination;
      currentLocationController.value.text = getDocData!.currentLocation;
      currentController.value.text = getDocData!.currentStatus;
      eDDController.value.text = convertDateFormat(getDocData!.edd);
      docDateController.value.text = convertDateFormat(getDocData!.documentDate);

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

  Future<void> getUserData({bool loading = false, Map<String, dynamic>? data, required String userId}) async {
    if (loading) {
      isLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getUserData}$userId");

    if (response.statusCode == 200) {
      GetUserDataResponseModel getUserDataResponseModel = getUserDataResponseModelFromJson(response.data);
      userData = getUserDataResponseModel.userData;
      userIDController.value.text = userData!.userId;
      usernameController.value.text = userData!.userName;
      managerIDController.value.text = userData!.complaintManagerId == "0" ? "" : userData!.complaintManagerId;
      managerNameController.value.text = userData!.complaintManagerName == "0" ? "" : userData!.complaintManagerName;
      closeByController.value.text = userData!.userId;
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

  Future<void> addTicket({bool loading = false, bool isUpdate = false, bool isAdd = false, bool isAddEscTkt = false, String? complaintId}) async {
    String responseComplaintId = "";

    dio.Response response;

    if (loading) {
      isLoading.value = true;
    }
    if (isAddEscTkt) {
      response = await ApiHandler.postRequest(url: ApiEndPoint.addEscTkt, body: {
        "complaintID": complaintIDController.value.text,
        "escalatedTo": selectedEscalateTo.map((e) => e!.userId).join(",").toString(),
        "escalatedEmail": emailIdList.join(';'),
        "escalatedDate": escDateController.value.text,
        "escalatedRemarks": remarksController.value.text,
        "documents": "",
        "userId": Pref.getUserId().toString(),
      });
    } else if (isUpdate) {
      response = await ApiHandler.postRequest(url: "${ApiEndPoint.updateComplaint}$complaintId", body: {
        "userID": userIDController.value.text,
        "ticketAddressTo": selectedTicketAddressTo.value!.locCode,
        "description": descriptionController.value.text,
        "customerEmail": emailIdList.isNotEmpty ? emailIdList.join(";") : "",
        "updateDate": updateDateController.value.text,
        "updateRemarks": updateRemarksController.value.text,
        "assignedToId": selectedAssign.value!.userId,
        "complaintId": complaintIDController.value.text,
        "remarks": remarksController.value.text,
        "documentNo": docketNoController.value.text,
        "document": "",
      });
    } else if (isAdd) {
      response = await ApiHandler.postRequest(url: ApiEndPoint.addComplaint, body: {
        "userID": Pref.getUserId().toString(),
        "documentNo": docketNoController.value.text,
        "ticketAddressTo": selectedTicketAddressTo.value!.locCode,
        "currentStatus": currentController.value.text,
        "source": selectedSource.value!.codeId,
        // "complaintDate": ticketDateController.value.text,
        "complaintDate": DateFormat("dd/MM/yyyy").parse(ticketDateController.value.text).toUtc().toIso8601String(),
        "type": selectedComplaintType.value!.codeId,
        "subType": selectedComplaintSubType.value!.codeId,
        "priority": selectedPriority.value!.codeId,
        "description": descriptionController.value.text,
        "customerEmail": emailIdList.isNotEmpty ? emailIdList.join(";") : "",
        "assignedTo": assignToId.value,
        "document": "",
        "currentLocation": currentLocationController.value.text
      });
    } else {
      response = await ApiHandler.postRequest(url: ApiEndPoint.closeComplaint, body: {
        "complaintID": complaintIDController.value.text,
        "closeBy": Pref.getUserId(),
        "closeRemark": closeRemarksController.value.text,
      });
    }
    if (response.statusCode == 200) {
      debugPrint("Added");

      if (response.data["success"] == true) {
        responseComplaintId = response.data['data']?['id'] ?? "";
        if (loading) {
          isLoading.value = false;
        }
        showDialog(
          context: Get.context!,
          builder: (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ✅ Title
                  Text(
                    "Success",
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ✅ Message
                  Text(
                    isAdd
                        ? "Complaint added successfully"
                        : isUpdate
                        ? "Complaint updated successfully"
                        : "Escalation added successfully",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.blackColor,
                      height: 1.4,
                    ),
                  ),
                    const SizedBox(height: 10),
                    Text(
                      isAddEscTkt ? "Escalation ID:  $responseComplaintId" :  "Complaint ID:  $responseComplaintId",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                ],
              ),

              // ✅ Button
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      await clear();
                      isSearch.value = false;
                      Get.back();
                      Get.back();
                    },
                    child: const Text(
                      "Okay",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          ),
          barrierDismissible: false,
        );

      } else {
        if (loading) isLoading.value = false;
        toastMessage(isTop: false, color: AppColors.redColor, text: response.data['message'] ?? "Something went wrong");
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  RxList<String> escalationEmailIds = <String>[].obs;

  Future<void> getComplaintData(
      {bool isLoading = false,
      Map<String, dynamic>? data,
      MultiSelectController? multiAssignToController,
      MultiSelectController? escalateToController,
      String? id,
      bool isFromEscalation = false,
      bool isFromUpdateTicket = false}) async {
    if (isLoading) {
      isEscalationLoader.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getComplaintData}$id?UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      GetEscalationDetailResponseModel getEscalationDetailResponseModel = getEscalationDetailResponseModelFromJson(response.data);
      escalationDetail.value = getEscalationDetailResponseModel.data;
      emailIdList.clear();
      if (isFromUpdateTicket) {
        // escalationDetail.value!.escEmailId.isNotEmpty ? emailIdList.add(escalationDetail.value!.escEmailId) : '';
        /*debugPrint("length111 === ${escalationDetail.value!.escEmailId.split(";").length}");
        debugPrint("length111 === ${escalationDetail.value!.escEmailId}");

        if (escalationDetail.value!.customerEmail != "") {
          if (escalationDetail.value!.customerEmail.split(";").length == 1) {
            emailIdList.add(escalationDetail.value!.customerEmail);
            debugPrint("length === ${emailIdList}");
          } else {
            emailIdList.value = escalationDetail.value!.customerEmail.split(";");
          }
        } else {
          emailIdList.value = [];
        }*/
        // custEmailIDController.value.text = escalationDetail.value!.customerEmail;
        selectedTicketAddressTo.value = TicketAddressTo(locCode: escalationDetail.value!.ticketAddressToId, locName: escalationDetail.value!.ticketAddressTo);
        // selectTicketAddress.value = Branch(locCode: escalationDetail.value!.ticketAddressToId, locName: escalationDetail.value!.ticketAddressTo);
        getAssignTo(branchCode: escalationDetail.value!.ticketAddressToId);
        selectedAssign.value = Assign(userId: escalationDetail.value!.assignToId, userName: escalationDetail.value!.assignedTo);
        if (escalationDetail.value!.customerEmail != "") {
          if (escalationDetail.value!.customerEmail.split(";").length == 1) {
            emailIdList.add(escalationDetail.value!.customerEmail);
            debugPrint("length === $emailIdList");
          } else {
            // emailIdList.value = escalationDetail.value!.escEmailId.split(";");
            emailIdList.assignAll(escalationDetail.value!.customerEmail.split(";"));
            debugPrint("Emal Id List === $emailIdList");
          }
        } else {
          emailIdList.value = [];
        }
      } else {
        debugPrint("length111 === ${escalationDetail.value!.escEmailId.split(";").length}");
        debugPrint("length111 === ${escalationDetail.value!.escEmailId}");
        if (escalationDetail.value!.escEmailId != "") {
          if (escalationDetail.value!.escEmailId.split(";").length == 1) {
            emailIdList.add(escalationDetail.value!.escEmailId);
            debugPrint("length === $emailIdList");
          } else {
            // emailIdList.value = escalationDetail.value!.escEmailId.split(";");
            emailIdList.assignAll(escalationDetail.value!.escEmailId.split(";"));
            debugPrint("Emal Id List === $emailIdList");
          }
        } else {
          emailIdList.value = [];
        }

        List<String> idList = escalationDetail.value!.escEmailId.split(";");

        List aaa = assignList.value!
            .where((user) => idList.contains(user.emailId)) // Filter users
            .map((user) => user.emailId) // Extract email IDs
            .toList();

        escalationEmailIds.value = emailIdList.where((email) => !aaa.contains(email)).toList();

        complaintIDController.value.text = escalationDetail.value!.complaintId;
        docketNoController.value.text = escalationDetail.value!.documentNo;
        escalationDetail.value!.documentNo.isEmpty ? isSearch.value = false : isSearch.value = true;
        isGetData.value = false;
        selectedComplaintType.value = ComplaintTypeDatum(codeDesc: escalationDetail.value!.ticketType, codeId: escalationDetail.value!.type.toString(), codeType: "");
        selectedComplaintSubType.value = ComplaintSubTypeDatum(codeDesc: escalationDetail.value!.ticketSubType, codeId: escalationDetail.value!.subType.toString(), codeType: "");
        selectedPriority.value = LeadSource(codeDesc: escalationDetail.value!.ticketPriority, codeId: escalationDetail.value!.priority.toString(), codeType: "");
        selectedSource.value = LeadSource(codeDesc: escalationDetail.value!.ticketSource, codeId: escalationDetail.value!.source.toString(), codeType: "");
        selectedUser.value = User(userId: escalationDetail.value!.assignToId, name: escalationDetail.value!.assignedTo);
        selectTicketAddress.value = Branch(locCode: escalationDetail.value!.ticketAddressToId, locName: escalationDetail.value!.ticketAddressTo);
        descriptionController.value.text = escalationDetail.value!.description;
        ticketStatusController.value.text = escalationDetail.value!.compaintStatus;
        // ticketDateController.value.text = escalationDetail.value!.ticketDate;
        ticketDateController.value.text = DateTime.now().toUtc().toIso8601String();
        closeByController.value.text = escalationDetail.value!.complaintId;
        updateDateController.value.text = escalationDetail.value!.updateDate;
        // escDateController.value.text = escalationDetail.value!.escalationDate;
        escDateController.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        // updateRemarksController.value.text = escalationDetail.value!.updateRemark;
        updateRemarksController.value.text = "";

        assignToController.value.clearAll();
        selectedEscalateTo.clear();
        final attendeeIds = escalationDetail.value!.assignToId.split(",");
        final attendeeNamesList = escalationDetail.value!.assignedTo.split(",");
        if (attendeeIds.length == attendeeNamesList.length) {
          selectedEscalateTo.value = List<Assign>.generate(attendeeNamesList.length, (index) => Assign(userId: attendeeIds[index], userName: attendeeNamesList[index], emailId: ""));
          // addComplaintController.selectedEscalateTo.value = services;
        }

        multiAssignToController!.selectWhere((item) {
          return selectedEscalateTo.map((assign) => assign!.userId).toList().contains(item.value.userId);
        });
        final escalationTo = escalationDetail.value!.escalationTo.split(",");
        selectedEscalateTo.value = List<Assign>.generate(attendeeNamesList.length, (index) => Assign(userId: escalationTo[index], userName: "", emailId: ""));
        escalateToController!.selectWhere((item) {
          return selectedEscalateTo.map((assign) => assign!.userId).toList().contains(item.value.userId);
        });

        assignToController.refresh();
        pageCount.value++;
      }
      if (isLoading) {
        isEscalationLoader.value = false;
      }
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isEscalationLoader.value = false;
      }
    }
  }
}

GetEscalationDetailResponseModel getEscalationDetailResponseModelFromJson(String str) => GetEscalationDetailResponseModel.fromJson(json.decode(str));

String getEscalationDetailResponseModelToJson(GetEscalationDetailResponseModel data) => json.encode(data.toJson());

class GetEscalationDetailResponseModel {
  final bool success;
  final Escalation data;
  final int totalCount;

  GetEscalationDetailResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetEscalationDetailResponseModel.fromJson(Map<String, dynamic> json) => GetEscalationDetailResponseModel(
        success: json["success"],
        data: Escalation.fromJson(json["data"]),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "totalCount": totalCount,
      };
}

class Escalation {
  final String complaintId;
  final String documentNo;
  final String edd;
  final String documentDate;
  final String origin;
  final String destination;
  final String customerName;
  final String compalaintDate;
  final String compaintStatus;
  final String resolutionDate;
  final String slaInHr;
  final String raisedBy;
  final String assignedTo;
  final String assignToId;
  final bool isEscalated;
  final bool isClosed;
  final bool isUpdated;
  final String ticketAddressTo;
  final String ticketAddressToId;
  final String ticketSource;
  final String ticketDate;
  final String ticketType;
  final String ticketSubType;
  final String ticketPriority;
  final int source;
  final int type;
  final int subType;
  final int priority;
  final String description;
  final String customerEmail;
  final String document;
  final String escalationId;
  final String escalationTo;
  final String escalationDate;
  final String escalationHistory;
  final String escEmailId;
  final String updateDate;
  final String updateRemark;
  final String updateHistory;
  final String closeBy;
  final String closeDate;
  final int totalCount;
  final String escalated;
  final String closed;
  final String updated;

  Escalation({
    required this.complaintId,
    required this.documentNo,
    required this.edd,
    required this.documentDate,
    required this.origin,
    required this.destination,
    required this.customerName,
    required this.compalaintDate,
    required this.compaintStatus,
    required this.resolutionDate,
    required this.slaInHr,
    required this.raisedBy,
    required this.assignedTo,
    required this.assignToId,
    required this.isEscalated,
    required this.isClosed,
    required this.isUpdated,
    required this.ticketAddressTo,
    required this.ticketAddressToId,
    required this.ticketSource,
    required this.ticketDate,
    required this.ticketType,
    required this.ticketSubType,
    required this.ticketPriority,
    required this.source,
    required this.type,
    required this.subType,
    required this.priority,
    required this.description,
    required this.customerEmail,
    required this.document,
    required this.escalationId,
    required this.escalationTo,
    required this.escalationDate,
    required this.escalationHistory,
    required this.escEmailId,
    required this.updateDate,
    required this.updateRemark,
    required this.updateHistory,
    required this.closeBy,
    required this.closeDate,
    required this.totalCount,
    required this.escalated,
    required this.closed,
    required this.updated,
  });

  factory Escalation.fromJson(Map<String, dynamic> json) => Escalation(
        complaintId: json["complaintID"],
        documentNo: json["documentNo"],
        edd: json["edd"],
        documentDate: json["documentDate"],
        origin: json["origin"],
        destination: json["destination"],
        customerName: json["customerName"],
        compalaintDate: json["compalaintDate"],
        compaintStatus: json["compaintStatus"],
        resolutionDate: json["resolutionDate"],
        slaInHr: json["slaInHr"],
        raisedBy: json["raisedBy"],
        assignedTo: json["assignedTo"],
        assignToId: json["assignToId"],
        isEscalated: json["isEscalated"],
        isClosed: json["isClosed"],
        isUpdated: json["isUpdated"],
        ticketAddressTo: json["ticketAddressTo"],
        ticketAddressToId: json["ticketAddressToId"],
        ticketSource: json["ticketSource"],
        ticketDate: json["ticketDate"],
        ticketType: json["ticketType"],
        ticketSubType: json["ticketSubType"],
        ticketPriority: json["ticketPriority"],
        source: json["source"],
        type: json["type"],
        subType: json["subType"],
        priority: json["priority"],
        description: json["description"],
        customerEmail: json["customerEmail"],
        document: json["document"],
        escalationId: json["escalationId"],
        escalationTo: json["escalationTo"],
        escalationDate: json["escalationDate"],
        escalationHistory: json["escalationHistory"],
        escEmailId: json["escEmailId"],
        updateDate: json["updateDate"],
        updateRemark: json["updateRemark"],
        updateHistory: json["updateHistory"],
        closeBy: json["closeBy"],
        closeDate: json["closeDate"],
        totalCount: json["totalCount"] ?? 0,
        escalated: json["escalated"],
        closed: json["closed"],
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "complaintID": complaintId,
        "documentNo": documentNo,
        "edd": edd,
        "documentDate": documentDate,
        "origin": origin,
        "destination": destination,
        "customerName": customerName,
        "compalaintDate": compalaintDate,
        "compaintStatus": compaintStatus,
        "resolutionDate": resolutionDate,
        "slaInHr": slaInHr,
        "raisedBy": raisedBy,
        "assignedTo": assignedTo,
        "assignToId": assignToId,
        "isEscalated": isEscalated,
        "isClosed": isClosed,
        "isUpdated": isUpdated,
        "ticketAddressTo": ticketAddressTo,
        "ticketAddressToId": ticketAddressToId,
        "ticketSource": ticketSource,
        "ticketDate": ticketDate,
        "ticketType": ticketType,
        "ticketSubType": ticketSubType,
        "ticketPriority": ticketPriority,
        "source": source,
        "type": type,
        "subType": subType,
        "priority": priority,
        "description": description,
        "customerEmail": customerEmail,
        "document": document,
        "escalationId": escalationId,
        "escalationTo": escalationTo,
        "escalationDate": escalationDate,
        "escalationHistory": escalationHistory,
        "escEmailId": escEmailId,
        "updateDate": updateDate,
        "updateRemark": updateRemark,
        "updateHistory": updateHistory,
        "closeBy": closeBy,
        "closeDate": closeDate,
        "totalCount": totalCount,
        "escalated": escalated,
        "closed": closed,
        "updated": updated,
      };
}
