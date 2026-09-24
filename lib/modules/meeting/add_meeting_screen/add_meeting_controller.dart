import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/config/app_colors.dart';
import 'package:scorpforce/config/app_shared_key.dart';
import 'package:scorpforce/config/app_url.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_transportmode_responce_model.dart';
import 'package:scorpforce/data/local/dropdown_local_db.dart';
import 'package:scorpforce/data/local/mapper/assigned_user_mapper.dart';
import 'package:scorpforce/data/local/mapper/branch_mapper.dart';
import 'package:scorpforce/data/local/mapper/meeting_type_mapper.dart';
import 'package:scorpforce/main.dart';
import 'package:scorpforce/modules/complaint/complaint_screen/model/get_ticket_address_to_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_branch_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_user_response_model.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/edit_meeting_response_model.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/model/get_penindia_customer.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/model/momList_response_model.dart';
import 'package:scorpforce/modules/my_call/add_my_call_screen/add_call_controller.dart';
import 'package:scorpforce/modules/widget/toast_message.dart';
import 'package:scorpforce/utils/api_handler.dart';

import '../../my_call/add_my_call_screen/call_module_response_model.dart';

class AddMeetingController extends GetxController {
  Rx<TextEditingController> customerNameController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> contactPersonController = TextEditingController().obs;
  Rx<TextEditingController> contactNoController = TextEditingController().obs;
  Rx<TextEditingController> emailIdController = TextEditingController().obs;
  Rx<TextEditingController> meetingPurposeController = TextEditingController().obs;
  Rx<TextEditingController> meetingMomController = TextEditingController().obs;
  Rx<TextEditingController> meetingTypeController = TextEditingController().obs;
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> remarksController = TextEditingController().obs;
  Rx<TextEditingController> startTimeController = TextEditingController().obs;
  Rx<TextEditingController> endTimeController = TextEditingController().obs;
  Rx<TextEditingController> meetingLocationController = TextEditingController().obs;
  Rx<TextEditingController> createByController = TextEditingController().obs;

  Rx<MultiSelectController<AssignedUser>> controller = MultiSelectController<AssignedUser>().obs;
  Rx<MultiSelectController<MomListDatum>> momController = MultiSelectController<MomListDatum>().obs;

  /*  RxList<Customer> customerList = <Customer>[].obs;
  Rx<String?> customerId = Rx<String?>(null);
  Rx<Customer?> selectedCustomer = Rx<Customer?>(null);*/

  RxList<PanIndiaCustomer> customerList = <PanIndiaCustomer>[].obs;
  Rx<String?> customerId = Rx<String?>(null);
  Rx<PanIndiaCustomer?> selectedCustomer = Rx<PanIndiaCustomer?>(null);
  RxBool isUserLoading = false.obs;
  RxBool isUserError = false.obs;

  RxList<CallType> meetingTypeList = <CallType>[].obs;
  Rx<String?> meetingTypeId = Rx<String?>(null);
  Rx<CallType?> selectedMeetingType = Rx<CallType?>(null);
  RxBool isMeetingTypeLoading = false.obs;
  RxBool isMeetingTypeError = false.obs;

  RxList<Branch> branchList = <Branch>[].obs;
  Rx<String?> branchId = Rx<String?>(null);
  Rx<Branch?> selectedBranch = Rx<Branch?>(null);
  RxBool isBranchLoading = false.obs;
  RxBool isBranchError = false.obs;

  RxList<TicketAddressTo> ticketAddressToList = <TicketAddressTo>[].obs;
  Rx<String?> ticketAddressToId = Rx<String?>(null);
  Rx<TicketAddressTo?> selectedTicketAddressTo = Rx<TicketAddressTo?>(null);

  Rx<List<MomListDatum>?> momList = Rx<List<MomListDatum>?>(null);
  Rx<String?> momId = Rx<String?>(null);
  RxBool isMomLoading = false.obs;
  RxBool isMomError = false.obs;

  // Rx<MomListDatum?> selectedMom = Rx<MomListDatum?>(null);
  Rx<List<MomListDatum>?> selectedMom = Rx<List<MomListDatum>?>(null);

  RxString startTime = "".obs;
  RxString endTime = "".obs;

  RxString leadDate = "".obs;
  RxString attendeeCode = "".obs;

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  Rx<List<AssignedUser>?> selectedUser = Rx<List<AssignedUser>?>(null);
  Rx<List<AssignedUser>> callUserList = Rx<List<AssignedUser>>([]);
  final DropdownLocalDB dropdownLocalDB = DropdownLocalDB(objectBox.store);
  DateTime selectedDate = DateTime.now();
  RxBool isAllDayEvent = false.obs;
  RxBool isLoading = false.obs;
  RxList<TransportMode> transportModeList = <TransportMode>[].obs;
  Rx<String?> transportId = Rx<String?>(null);
  Rx<TransportMode?> selectedTransportMode = Rx<TransportMode?>(null);
  RxBool isTransportLoading = false.obs;

  RxList<CallType> otherExpensesList = <CallType>[].obs;
  Rx<String?> otherExpenseId = Rx<String?>(null);
  Rx<CallType?> selectedOtherExpense = Rx<CallType?>(null);
  RxBool isOtherExpenseLoading = false.obs;

  Rx<TextEditingController> expenseAmountController = TextEditingController().obs;
  Rx<File?> expenseDocumentFile = Rx<File?>(null);

  Future<void> getTransportMode({bool showLoader = false}) async {
    try {
      if (showLoader) isTransportLoading.value = true;
      var response = await ApiHandler.getRequest("${ApiEndPoint.generalMaster}?codeType=SERCAT");
      if (response.statusCode == 200) {
        GetTransportModeResponseModel getTransportModeResponseModel = getTransportModeResponseModelFromJson(response.data);
        transportModeList.value = getTransportModeResponseModel.data;
      }
    } catch (e) {
      debugPrint("Transport Mode API Error: $e");
    } finally {
      isTransportLoading.value = false;
    }
  }

  Future<void> getOtherExpensesList({bool showLoader = false}) async {
    try {
      if (showLoader) isOtherExpenseLoading.value = true;
      var response = await ApiHandler.getRequest("${ApiEndPoint.genralmaster}OTHEREXPENSES");
      if (response.statusCode == 200) {
        final model = callModuleResponseModelFromJson(response.data);
        otherExpensesList.assignAll(model.data);
      }
    } catch (e) {
      debugPrint("Other Expenses API Error: $e");
    } finally {
      isOtherExpenseLoading.value = false;
    }
  }

  RxBool isCustomerLoading = false.obs;
  RxBool isCustomerDetailLoading = false.obs;

  clear({MultiSelectController? a}) {
    dateController.value.clear();
    remarksController.value.clear();
    emailIdController.value.clear();
    customerNameController.value.clear();
    addressController.value.clear();
    contactPersonController.value.clear();
    contactNoController.value.clear();
    meetingPurposeController.value.clear();
    meetingTypeController.value.clear();
    meetingMomController.value.clear();
    endTimeController.value.clear();
    startTimeController.value.clear();
    meetingLocationController.value.clear();
    momController.value.clearAll();

    customerId.value = null;
    selectedCustomer.value = null;

    meetingTypeId.value = null;
    selectedMeetingType.value = null;

    branchId.value = null;
    selectedBranch.value = null;

    selectedUser.value = null;
    selectedTransportMode.value = null;
    transportId.value = null;
    selectedOtherExpense.value = null;
    otherExpenseId.value = null;
    expenseAmountController.value.clear();
    expenseDocumentFile.value = null;
    isLoading.value = false;
    startTime.value = "";
    endTime.value = "";
    longitude.value = 0.0;
    latitude.value = 0.0;
    selectedUser.value = null;
    isAllDayEvent.value = false;
    a!.clearAll();
  }

  RxDouble distanceInKm = 0.0.obs;
  RxBool isDistanceLoading = false.obs;

  final String apiKey = 'AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA';

  Future<void> getCustomer({bool isLoading = false, String value = ''}) async {
    if (isLoading) {
      isCustomerLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerForAddMeeting}?userid=${Pref.getUserId()}&searchText=$value");

    if (response.statusCode == 200) {
      PanIndiaCustomerResponse panIndiaCustomerResponse = panIndiaCustomerResponseFromJson(response.data);
      customerList.value = panIndiaCustomerResponse.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isCustomerLoading.value = true;
      }
    }
    if (isLoading) {
      isCustomerLoading.value = false;
    }
  }

  Future<void> getCustomerDetail({String customerCode = ''}) async {
    isCustomerDetailLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerDetail}$customerCode");

    if (response.statusCode == 200) {
      final data = json.decode(response.data);

      if (data["data"] != null && data["data"].isNotEmpty) {
        addressController.value.text = data["data"][0]["Address"] ?? "";
        contactPersonController.value.text = data["data"][0]["ContactName"] ?? "";
        contactNoController.value.text = data["data"][0]["ContactNo"] ?? "";
        emailIdController.value.text = data["data"][0]["Email"] ?? "";
      }
      isCustomerDetailLoading.value = false;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      isCustomerDetailLoading.value = false;
    }
    isCustomerDetailLoading.value = false;
  }

  Future<void> getMeetingType({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("MEETING_TYPE");

    if (localData.isNotEmpty) {
      meetingTypeList.assignAll(localData.map((e) => CallType(codeId: e.value.toString(), codeDesc: e.label, codeType: '')).toList());
    }

    try {
      final response = await ApiHandler.getRequest('${ApiEndPoint.genralmaster}METNGTYPE');

      if (response.statusCode == 200) {
        final model = callModuleResponseModelFromJson(response.data);

        if (model.data.isNotEmpty) {
          meetingTypeList.assignAll(model.data);

          dropdownLocalDB.save("MEETING_TYPE", model.data.map((e) => e.toDropdown()).toList());
        }
      } else {
        throw Exception("Meeting Type API failed");
      }
    } catch (e) {
      debugPrint("Meeting Type Error: $e");
    }
  }

  Future<void> getUser({bool showLoader = false, Map<String, dynamic>? data, AddCallController? addCallController}) async {
    final localData = dropdownLocalDB.get("ASSIGNED_USER");

    if (localData.isNotEmpty) {
      callUserList.value.assignAll(localData.map((e) => AssignedUser(userId: e.value.toString(), name: e.label)).toList());
    }

    try {
      final response = await ApiHandler.getRequest(ApiEndPoint.getAssignTo);

      if (response.statusCode == 200) {
        final model = getAssignedResponseModelFromJson(response.data);
        if (model.data.isNotEmpty) {
          callUserList.value = model.data;

          dropdownLocalDB.save("ASSIGNED_USER", model.data.map((e) => e.toDropdown()).toList());
        }
      }
    } catch (e) {
      debugPrint("User API Error: $e");
    }
  }

  Future<void> getBranch({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("BRANCH");

    if (localData.isNotEmpty) {
      branchList.assignAll(localData.map((e) => Branch(locCode: e.value, locName: e.label)).toList());
    }
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.lead}LocationList");

      if (response.statusCode == 200) {
        final model = getBranchResponseModelFromJson(response.data);
        if (model.data.isNotEmpty) {
          branchList.assignAll(model.data);

          dropdownLocalDB.save("BRANCH", model.data.map((e) => e.toDropdown()).toList());
        }
      } else {
        throw Exception("Branch API failed");
      }
    } catch (e) {
      debugPrint("Branch API Error: $e");
    }
  }

  Future<void> getMomList({bool showLoader = false}) async {
    try {
      if (showLoader) isMomLoading.value = true;
      isMomError.value = false;

      final response = await ApiHandler.getRequest(ApiEndPoint.momList);

      if (response.statusCode == 200) {
        final model = momListResponseModelFromJson(response.data);
        momList.value = model.momListData;
      } else {
        throw Exception("MOM List API failed");
      }
    } catch (e) {
      isMomError.value = true;
      debugPrint("MOM List Error: $e");
    } finally {
      isMomLoading.value = false;
    }
  }

  Future<void> addMeeting({
    bool loading = false,
    required Map<String, dynamic> data,
    bool isUpdate = false,
    String? id,
    MultiSelectController? a,
    File? documentFile,
  }) async {
    debugPrint("Meeting data = $data");
    if (loading) {
      isLoading.value = true;
    }

    try {
      var dioClient = ApiHandler.createRequest();
      var formData = d.FormData();

      // Add all fields from data to formData
      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add the file if it exists
      if (documentFile != null && await documentFile.exists()) {
        formData.files.add(
          MapEntry(
            "OtherExpenseDocumentFile",
            await d.MultipartFile.fromFile(
              documentFile.path,
              filename: documentFile.path.split('/').last,
            ),
          ),
        );
        // Also add the filename to OtherExpenseDocument as per curl if not already there
        if (!data.containsKey("OtherExpenseDocument")) {
          formData.fields.add(MapEntry("OtherExpenseDocument", documentFile.path.split('/').last));
        }
      }

      String url = "${ApiEndPoint.meeting}/$id";
      debugPrint("Add/Edit Meeting URL: $url");
      debugPrint("FormData fields: ${formData.fields}");

      d.Response response = await dioClient.post(
        url,
        data: formData,
        options: d.Options(
          headers: {
            'accept': '*/*',
            'Authorization': "Bearer ${Pref.getToken()}",
          },
        ),
      );

      if (response.statusCode == 200) {
        var resData = response.data;
        if (resData is String) {
          resData = jsonDecode(resData);
        }
        if (resData["success"] == true) {
          if (isUpdate) {
            toastMessage(text: "Meeting Update Successfully", color: AppColors.greenColor, isTop: false);
          } else {
            toastMessage(text: "Meeting added Successfully", color: AppColors.greenColor, isTop: false);
          }
          clear(a: a);
          if (loading) {
            isLoading.value = false;
          }
          Get.back();
        } else {
          toastMessage(text: resData["error"]?["message"] ?? "Error occurred", color: AppColors.redColor, isTop: false);
          if (loading) {
            isLoading.value = false;
          }
        }
      } else {
        toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
        if (loading) {
          isLoading.value = false;
        }
      }
    } catch (e) {
      debugPrint("Add/Edit Meeting API Error: $e");
      toastMessage(text: "Error: $e", color: AppColors.redColor, isTop: false);
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> editMeeting({bool loading = false, String? id, MultiSelectController? attendeesController, MultiSelectController? addMomController}) async {
    if (loading) {
      isLoading.value = true;
    }

    var response = await ApiHandler.getRequest("${ApiEndPoint.meeting}/$id");

    if (response.statusCode == 200) {
      EditMeetingResponseModel editMeetingResponseModel = editMeetingResponseModelFromJson((response.data));

      // {address: 336, assignedToId: 0002, branchId: BLR, cityId: 744, companyName: qq, contactName: qq, contactNo: 9999999999, designationId: 10, email: qqqq@yopmail.com, industryTypeId: 10, isActive: true, leadCategoryId: 1, leadDate: 14/01/2025, leadSourceId: 25e4f73f-f65a-4231-8795-dd785fb3aa98, regionId: BLR, serviceInterestedIDs: 3,4}
      // {address: 336, assignedToId: 0002, branchId: BLR, cityId: 744, companyName: qq, contactName: qq, contactNo: 9999999999, designationId: 10, email: qqqq@yopmail.com, industryTypeId: 10, isActive: true, leadCategoryId: 1, leadDate: 14/01/2025, leadSourceId: 25e4f73f-f65a-4231-8795-dd785fb3aa98, regionId: BLR, serviceInterestedIDs: 3,4}
      // {address: 336, assignedToId: 0002, branchId: BLR, cityId: 744, companyName: qq, contactName: qq, contactNo: 9999999999, designationId: 10, email: qqqq@yopmail.com, industryTypeId: 10, isActive: true, leadCategoryId: 1, leadDate: 14/01/2025, leadSourceId: 2, regionId: BLR, serviceInterestedIDs: 3,4}
      dateController.value.text = editMeetingResponseModel.data.meetingDate;

      selectedMeetingType.value = CallType(codeType: "", codeId: editMeetingResponseModel.data.meetingTypeId.toString(), codeDesc: editMeetingResponseModel.data.meetingType);
      meetingTypeId.value = editMeetingResponseModel.data.meetingTypeId.toString();

      customerId.value = editMeetingResponseModel.data.leadId;
      selectedCustomer.value = PanIndiaCustomer(customerCode: editMeetingResponseModel.data.leadId, customerName: editMeetingResponseModel.data.customerName);

      emailIdController.value.text = editMeetingResponseModel.data.email;
      contactNoController.value.text = editMeetingResponseModel.data.contactNo;
      addressController.value.text = editMeetingResponseModel.data.address;
      contactPersonController.value.text = editMeetingResponseModel.data.contactName;
      meetingPurposeController.value.text = editMeetingResponseModel.data.meetingPurpose;

      // meetingLocationController.value.text = editMeetingResponseModel.data.meetingLocationName;
      meetingLocationController.value.text = editMeetingResponseModel.data.geoLocation;

      selectedBranch.value = Branch(locCode: editMeetingResponseModel.data.location, locName: editMeetingResponseModel.data.meetingLocation);
      selectedBranch.value = branchList.firstWhere(
        (branch) => branch.locCode == editMeetingResponseModel.data.meetingLocation,
        orElse: () => Branch(locCode: '', locName: 'Not Found'),
      );

      // selectedMom.value = MomListDatum(id:0, moM: editMeetingResponseModel.data.meetingMom);
      branchId.value = editMeetingResponseModel.data.location;
      startTime.value = editMeetingResponseModel.data.startTime;
      endTime.value = editMeetingResponseModel.data.endTime;
      startTimeController.value.text = editMeetingResponseModel.data.startTime;
      endTimeController.value.text = editMeetingResponseModel.data.endTime;
      latitude.value = editMeetingResponseModel.data.latitude;
      longitude.value = editMeetingResponseModel.data.longitude;
      createByController.value.text = editMeetingResponseModel.data.createdBy;
      attendeeCode.value = editMeetingResponseModel.data.attendeeCode;
      final attendees = editMeetingResponseModel.data.attendees;
      final attendeeNames = editMeetingResponseModel.data.attendeeNames;
      final attendeeIds = attendees.split(",");
      final attendeeNamesList = attendeeNames.split(",");

      if (attendeeIds.length == attendeeNamesList.length) {
        final users = List<AssignedUser>.generate(attendeeIds.length, (index) => AssignedUser(userId: attendeeIds[index], name: attendeeNamesList[index]));
        selectedUser.value = users;
      }
      attendeesController!.selectWhere((item) {
        return selectedUser.value!.map((user) => user.userId).toList().contains(item.value.userId);
      });

      final mom = editMeetingResponseModel.data.meetingMom;
      final momName = mom.split(",");

      List<MomListDatum>? momUsers = momName.isEmpty ? [] : List<MomListDatum>.generate(momName.length, (index) => MomListDatum(moM: momName[index], id: index + 1));

      selectedMom.value = momUsers;

      addMomController!.selectWhere((item) {
        return selectedMom.value!.map((user) => user.moM).toList().contains(item.value.moM);
      });

      debugPrint("selected -=-=--- === ${selectedUser.value!.map((e) => e.name)}");
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
}
