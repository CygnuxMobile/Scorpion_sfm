import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/config/app_shared_key.dart';
import 'package:scorpforce/data/local/dropdown_local_db.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_branch_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_category_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_city_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_designation_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_industry_type_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_lead_source_responce_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_user_response_model.dart' show AssignedUser, getAssignedResponseModelFromJson;
import 'package:scorpforce/modules/lead/add_lead/model/lead_request_model.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/add_meeting_controller.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/get_customer_list_model.dart' show CustomerData;
import '../../../../config/app_colors.dart';
import '../../../../config/app_url.dart';
import '../../../../data/local/mapper/assigned_user_mapper.dart';
import '../../../../data/local/mapper/category_mapper.dart';
import '../../../../data/local/mapper/city_mapper.dart';
import '../../../../data/local/mapper/industry_mapper.dart';
import '../../../../data/local/mapper/lead_source_mapper.dart';
import '../../../../data/local/mapper/service_integrated_mapper.dart';
import '../../../../main.dart';
import '../../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import '../model/edit_lead_response_model.dart';
import '../model/get_service_integrated_responce_model.dart';

class AddLeadController extends GetxController {
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> contactNameController = TextEditingController().obs;
  Rx<TextEditingController> contactNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> customerSearchController = TextEditingController().obs;

  Rx<MultiSelectController<Service>> controller = MultiSelectController<Service>().obs;
  RxBool isActive = true.obs;
  RxBool isDropLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCustomerDialogLoading = false.obs;

  RxList<Categories> categoryList = <Categories>[].obs;
  Rx<Categories?> selectedCategory = Rx<Categories?>(null);
  Rx<int?> categoryId = Rx<int?>(null);
  RxBool isCategoryLoading = false.obs;
  RxBool isCategoryError = false.obs;

  RxList<CustomerData> customerList = <CustomerData>[].obs;
  Rx<String?> customerId = Rx<String?>(null);
  Rx<CustomerData?> selectedCustomer = Rx<CustomerData?>(null);

  RxList<City> cityList = <City>[].obs;
  Rx<City?> selectedCity = Rx<City?>(null);
  Rx<int?> cityId = Rx<int?>(null);
  RxBool isCityLoading = false.obs;
  RxBool isCityError = false.obs;

  RxList<Branch> branchList = <Branch>[].obs;
  Rx<String?> branchId = Rx<String?>(null);
  Rx<Branch?> selectedBranch = Rx<Branch?>(null);
  RxBool isBranchLoading = false.obs;
  RxBool isBranchError = false.obs;

  Rx<String?> regionId = Rx<String?>(null);
  Rx<Branch?> selectedRegion = Rx<Branch?>(null);

  RxList<AssignedUser> userList = <AssignedUser>[].obs;
  Rx<String?> assignedToId = Rx<String?>(null);
  Rx<AssignedUser?> selectedUser = Rx<AssignedUser?>(null);
  Rx<List<Service>?> selectedService = Rx<List<Service>?>(null);
  RxBool isUserLoading = false.obs;
  RxBool isUserError = false.obs;

  Rx<List<Service>> serviceList = Rx<List<Service>>([]);
  RxBool isServiceLoading = false.obs;
  RxBool isServiceError = false.obs;

  RxList<IndustryType> industryTypeList = <IndustryType>[].obs;
  Rx<String?> industryTypeId = Rx<String?>(null);
  Rx<IndustryType?> selectedIndustryType = Rx<IndustryType?>(null);
  RxBool isIndustryLoading = false.obs;
  RxBool isIndustryError = false.obs;

  RxList<LeadSource> leadSourceList = <LeadSource>[].obs;
  Rx<String?> leadSourceId = Rx<String?>(null);
  Rx<LeadSource?> selectedSource = Rx<LeadSource?>(null);
  RxBool isLeadSourceLoading = false.obs;
  RxBool isLeadSourceError = false.obs;

  RxList<Designation> designationList = <Designation>[].obs;
  Rx<String?> designationId = Rx<String?>(null);
  Rx<Designation?> selectedDesignation = Rx<Designation?>(null);

  final DropdownLocalDB dropdownLocalDB = DropdownLocalDB(objectBox.store);

  Future<void> addLead({bool loading = false, Map<String, dynamic>? data, bool isUpdate = false, String? id, MultiSelectController? a}) async {
    debugPrint("isUpdate === $isUpdate");
    d.Response? response;
    if (loading) {
      isLoading.value = true;
    }

    AddLeadRequestModel addLeadRequestModel = AddLeadRequestModel(
        address: addressController.value.text,
        assignedToId: assignedToId.value!,
        branchId: selectedBranch.value!.locCode,
        cityId: cityId.value!,
        companyName: companyNameController.value.text,
        contactName: contactNameController.value.text,
        contactNo: contactNumberController.value.text,
        designationId: designationId.value ?? '',
        email: emailController.value.text,
        industryTypeId: industryTypeId.value!,
        isActive: isActive.value,
        leadCategoryId: categoryId.value!,
        leadDate: DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(dateController.value.text)),
        leadSourceId: leadSourceId.value!,
        regionId: selectedRegion.value!.locCode,
        serviceInterestedIDs: selectedService.value!.map((e) => e.codeId).join(",").toString(),
        createdBy: Pref.getUserId()!);
    debugPrint("Lead data === ${addLeadRequestModel.toJson()}");

    if (isUpdate) {
      response = await ApiHandler.postRequest(url: "${ApiEndPoint.addLead}/$id", body: addLeadRequestModel.toJson());
    } else {
      response = await ApiHandler.postRequest(url: ApiEndPoint.addLead, body: addLeadRequestModel.toJson());
    }
    if (response.statusCode == 200) {
      if (isUpdate) {
        toastMessage(text: "Lead update Successfully", color: AppColors.greenColor, isTop: false);
      } else {
        toastMessage(text: "Lead added Successfully", color: AppColors.greenColor, isTop: false);
      }

      clear(a: a);
      if (loading) {
        isLoading.value = false;
      }

      Get.back();
    } else {
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> editLead({bool loading = false, String? id, MultiSelectController? a}) async {
    if (loading) {
      isLoading.value = true;
    }

    var response = await ApiHandler.getRequest("${ApiEndPoint.getLead}/$id?UserId=${Pref.getUserId()}");

    if (response.statusCode == 200) {
      EditLeadResponseModel editLeadResponseModel = editLeadResponseModelFromJson(response.data);

      dateController.value.text = editLeadResponseModel.data.leadDate.toString();
      companyNameController.value.text = editLeadResponseModel.data.companyName.toString();
      contactNameController.value.text = editLeadResponseModel.data.contactName.toString();
      contactNumberController.value.text = editLeadResponseModel.data.contactNo.toString();
      addressController.value.text = editLeadResponseModel.data.address.toString();
      emailController.value.text = editLeadResponseModel.data.email.toString();
      isActive.value = editLeadResponseModel.data.isActive;

      selectedCategory.value =
          Categories(codeType: "", codeId: editLeadResponseModel.data.leadCategoryId.toString(), codeDesc: editLeadResponseModel.data.leadCategory);
      categoryId.value = editLeadResponseModel.data.leadCategoryId;

      selectedCity.value = City(location: editLeadResponseModel.data.city, cityCode: editLeadResponseModel.data.cityId);
      cityId.value = editLeadResponseModel.data.cityId;

      selectedBranch.value = Branch(locName: editLeadResponseModel.data.branch, locCode: editLeadResponseModel.data.branchId);
      branchId.value = editLeadResponseModel.data.branchId;

      selectedRegion.value = Branch(locName: editLeadResponseModel.data.region, locCode: editLeadResponseModel.data.regionId);
      regionId.value = editLeadResponseModel.data.regionId;

      selectedDesignation.value =
          Designation(codeType: "", codeId: editLeadResponseModel.data.designationId, codeDesc: editLeadResponseModel.data.designation);
      designationId.value = editLeadResponseModel.data.designationId;

      selectedSource.value =
          LeadSource(codeId: editLeadResponseModel.data.leadSourceId, codeType: "", codeDesc: editLeadResponseModel.data.leadSource);
      leadSourceId.value = editLeadResponseModel.data.leadSourceId;

      selectedUser.value = AssignedUser(userId: editLeadResponseModel.data.assignedToId, name: editLeadResponseModel.data.assignedTo);
      assignedToId.value = editLeadResponseModel.data.assignedToId;

      selectedIndustryType.value =
          IndustryType(codeType: "", codeId: editLeadResponseModel.data.industryTypeId, codeDesc: editLeadResponseModel.data.industryType);
      industryTypeId.value = editLeadResponseModel.data.industryTypeId;

      final serviceInterestids = editLeadResponseModel.data.serviceInteresteds;
      final serviceInterestedNames = editLeadResponseModel.data.serviceInterestedNames;
      final attendeeIds = serviceInterestids.split(",");
      final attendeeNamesList = serviceInterestedNames.split(",");

      if (attendeeIds.length == attendeeNamesList.length) {
        final services = List<Service>.generate(
            attendeeIds.length, (index) => Service(codeId: attendeeIds[index], codeType: "", codeDesc: attendeeNamesList[index]));
        selectedService.value = services;
      }

      a!.selectWhere((item) {
        return selectedService.value!.map((user) => user.codeId).toList().contains(item.value.codeId);
      });

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

  void clear({MultiSelectController? a}) {
    companyNameController.value.clear();
    dateController.value.clear();
    contactNameController.value.clear();
    contactNumberController.value.clear();
    addressController.value.clear();
    emailController.value.clear();
    isActive.value = true;
    isLoading.value = false;

    branchId.value = null;
    selectedBranch.value = null;

    regionId.value = null;
    selectedRegion.value = null;

    selectedDesignation.value = null;
    designationId.value = null;

    selectedSource.value = null;
    leadSourceId.value = null;

    selectedUser.value = null;
    assignedToId.value = null;

    selectedIndustryType.value = null;
    industryTypeId.value = null;

    selectedService.value = null;

    cityId.value = null;
    selectedCity.value = null;

    selectedCategory.value = null;
    categoryId.value = null;

    a!.clearAll();
    update();
  }

  Future<void> getCity({bool showLoader = false}) async {
    try {
      final localData = dropdownLocalDB.get("CITY");

      if (localData.isNotEmpty) {
        cityList.assignAll(
          localData.map(
            (e) => City(
              location: e.label,
              cityCode: int.tryParse(e.value) ?? 0,
            ),
          ),
        );
      }

      final response = await ApiHandler.getRequest('${ApiEndPoint.lead}CityList');

      if (response.statusCode == 200) {
        final model = getCityResponseModelFromJson(response.data);

        if (response.data != null && model.data.isNotEmpty) {
          cityList.assignAll(model.data);

          dropdownLocalDB.save(
            "CITY",
            model.data.map((e) => e.toDropdown()).toList(),
          );
        }
      }
    } catch (e) {
      final localData = dropdownLocalDB.get("CITY");

      if (localData.isNotEmpty) {
        cityList.assignAll(
          localData.map(
            (e) => City(
              location: e.label,
              cityCode: int.tryParse(e.value) ?? 0,
            ),
          ),
        );
      }
    }
  }

  Future<void> getCategory({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("CATEGORY");
    if (localData.isNotEmpty) {
      categoryList.assignAll(
        localData.map(
          (e) => Categories(
            codeType: e.type,
            codeId: e.value,
            codeDesc: e.label,
          ),
        ),
      );
    }
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.genralmaster}LEADCAT",
      );

      if (response.statusCode == 200) {
        final model = getCategoryResponseModelFromJson(response.data);

        if (response.data != null && model.data.isNotEmpty) {
          categoryList.assignAll(model.data);

          final localList = model.data.map((e) => e.toDropdown()).toList();

          dropdownLocalDB.save(
            "CATEGORY",
            localList,
          );
        }
      }
    } catch (e) {
      debugPrint("Category API Error: $e");
      final localData = dropdownLocalDB.get("CATEGORY");
      if (localData.isNotEmpty) {
        categoryList.assignAll(
          localData.map(
            (e) => Categories(
              codeType: e.type,
              codeId: e.value,
              codeDesc: e.label,
            ),
          ),
        );
      }
    }
  }

  Future<void> getBranch({bool showLoader = false, AddMeetingController? addMeetingController}) async {
    try {
      final response = await ApiHandler.getRequest('${ApiEndPoint.lead}LocationList');

      if (response.statusCode == 200) {
        final model = getBranchResponseModelFromJson(response.data);

        branchList.assignAll(model.data);

        if (addMeetingController != null) {
          addMeetingController.branchList.assignAll(model.data);
        }
      } else {
        throw Exception("Branch API failed");
      }
    } catch (e) {
      debugPrint("Branch API Error: $e");
    }
  }

  Future<void> getUser({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("ASSIGNED_USER");

    if (localData.isNotEmpty) {
      userList.assignAll(
        localData.map(
              (e) => AssignedUser(
            userId: e.value.toString(),
            name: e.label,
          ),
        ).toList(),
      );
    }

    try {
      final response = await ApiHandler.getRequest(ApiEndPoint.getAssignTo);

      if (response.statusCode == 200) {
        final model = getAssignedResponseModelFromJson(response.data);

        if (model.data.isNotEmpty) {
          userList.assignAll(model.data);

          dropdownLocalDB.save(
            "ASSIGNED_USER",
            model.data.map((e) => e.toDropdown()).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint("User API failed, using local cache");
    }
  }

  Future<void> getServiceIntegrated({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("SERVICE_INTEGRATED");

    if (localData.isNotEmpty) {
      serviceList.value.assignAll(
        localData.map(
          (e) => Service(
            codeId: e.value,
            codeDesc: e.label,
            codeType: e.type,
          ),
        ),
      );
    }
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.genralmaster}fltprod",
      );

      if (response.statusCode == 200) {
        final model = getServiceIntegratedResponseModelFromJson(response.data);

        if (model.data.isNotEmpty) {
          serviceList.value = model.data;

          final localList = model.data.map((e) => e.toDropdown()).toList();

          dropdownLocalDB.save(
            "SERVICE_INTEGRATED",
            localList,
          );
        }
      } else {
        throw Exception("Service Integrated API failed");
      }
    } catch (e) {
      final localData = dropdownLocalDB.get("SERVICE_INTEGRATED");

      if (localData.isNotEmpty) {
        serviceList.value.assignAll(
          localData.map(
            (e) => Service(
              codeId: e.value,
              codeDesc: e.label,
              codeType: e.type,
            ),
          ),
        );
      }
    }
  }

  Future<void> getIndustry({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("INDUSTRY");

    industryTypeList.assignAll(
      localData.map(
        (e) => IndustryType(
          codeType: e.type,
          codeId: e.value,
          codeDesc: e.label,
        ),
      ),
    );
    try {
      final response = await ApiHandler.getRequest('${ApiEndPoint.genralmaster}ind');

      if (response.statusCode == 200) {
        final model = getIndustryTypeResponseModelFromJson(response.data);

        if (response.data != null && model.data.isNotEmpty) {
          industryTypeList.assignAll(model.data);

          final localList = model.data.map((e) => e.toDropdown()).toList();

          dropdownLocalDB.save(
            "INDUSTRY",
            localList,
          );
        }
      }
    } catch (e) {
      final localData = dropdownLocalDB.get("INDUSTRY");

      industryTypeList.assignAll(
        localData.map(
          (e) => IndustryType(
            codeType: e.type,
            codeId: e.value,
            codeDesc: e.label,
          ),
        ),
      );
    }
  }

  Future<void> getLeadSource({bool showLoader = false}) async {
    final localData = dropdownLocalDB.get("LEADSRC");

    if (localData.isNotEmpty) {
      leadSourceList.assignAll(
        localData.map(
          (e) => LeadSource(
            codeType: e.type,
            codeId: e.value,
            codeDesc: e.label,
          ),
        ),
      );
    }

    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.genralmaster}leadsrc",
      );

      if (response.statusCode == 200) {
        final model = getLeadSourceResponseModelFromJson(response.data);

        if (model.data.isNotEmpty) {
          leadSourceList.assignAll(model.data);
          final localList = model.data.map((e) => e.toDropdown()).toList();

          dropdownLocalDB.save(
            "LEADSRC",
            localList,
          );
        }
      } else {
        throw Exception("Lead Source API failed");
      }
    } catch (e) {
      debugPrint("Lead Source Error: $e");

      final localData = dropdownLocalDB.get("LEADSRC");

      if (localData.isNotEmpty) {
        leadSourceList.assignAll(
          localData.map(
            (e) => LeadSource(
              codeType: e.type,
              codeId: e.value,
              codeDesc: e.label,
            ),
          ),
        );
      }
    }
  }

  Future<void> getDesignation({bool isLoading = false, Map<String, dynamic>? data}) async {
    if (isLoading) {
      isLoading = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.genralmaster}desig");

    if (response.statusCode == 200) {
      GetDesignationResponseModel getDesignationResponseModel = getDesignationResponseModelFromJson(response.data);
      designationList.value = getDesignationResponseModel.data;
    } else {
      debugPrint("Not Added");
      debugPrint("${response.statusCode}");
      if (isLoading) {
        isLoading = true;
      }
    }
  }

// String
}
