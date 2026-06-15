import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/lead/add_lead/controller/add_lead_controller.dart' show AddLeadController;
import 'package:scorpforce/modules/lead/add_lead/model/get_branch_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_city_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_designation_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_industry_type_response_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_lead_source_responce_model.dart';
import 'package:scorpforce/modules/lead/add_lead/model/get_user_response_model.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_images.dart';
import '../../../../config/app_shared_key.dart';
import '../../../../config/app_text_style.dart';
import '../../../../utils/api_handler.dart';
import '../../../widget/TextField.dart';
import '../../../widget/dropdown.dart';
import '../../../widget/loader.dart';
import '../../../widget/toast_message.dart';
import '../model/get_category_response_model.dart';


class AddLeadScreen extends StatefulWidget {
  final bool isEdit;
  final String? id;

  const AddLeadScreen({super.key, this.isEdit = false, this.id});

  @override
  AddLeadScreenState createState() => AddLeadScreenState();
}

class AddLeadScreenState extends State<AddLeadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddLeadController addLeadController = Get.put(AddLeadController());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      addLeadController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isEdit) {
        addLeadController.editLead(id: widget.id, a: addLeadController.controller.value);
      } else {
        addLeadController.selectedBranch.value = Branch(locCode: Pref.getBranchCode().toString(), locName: Pref.getBranchName().toString());
        addLeadController.selectedRegion.value = Branch(locCode: Pref.getRegionCode().toString(), locName: Pref.getRegionName().toString());
        addLeadController.selectedDesignation.value =
            Designation(codeType: "", codeId: Pref.getDesignationId()!, codeDesc: Pref.getDesignationName()!);
        addLeadController.designationId.value = Pref.getDesignationId()!;
        addLeadController.selectedUser.value = AssignedUser(userId: Pref.getUserId()!, name: Pref.getUserName()!);
        addLeadController.assignedToId.value = Pref.getUserId();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.isEdit ? "Update Lead" : 'Add Lead',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 16, right: 16, top: 16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(widget.isEdit ? "Update Lead" : 'Add Lead', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // const SizedBox(height: 16),
                  Row(
                    children: [
                      CustomDropdown<Categories>(
                        // prefixImage: AppImages.leadCategory,
                        hintText: 'Lead Category*',
                        items: addLeadController.categoryList,
                        selectedItem: addLeadController.selectedCategory.value,
                        itemAsString: (Categories category) => category.codeDesc,
                        onChanged: (Categories? category) {
                          if (category != null) {
                            addLeadController.categoryId.value = int.parse(category.codeId);
                            addLeadController.selectedCategory.value = category;
                            addLeadController.categoryId.refresh();
                            addLeadController.selectedCategory.refresh();
                          }
                        },
                        validator: (value) => value == null ? 'Please select a Branch' : null,
                        showSearchBox: addLeadController.branchList.length > 4 ? true : false,
                      ),
                    ],
                  ),
                  commonTextField(
                    // prefixImage: AppImages.date,
                    needValidation: true,
                    validationMessage: "Lead Date",
                    enabledBorder: AppColors.black,
                    labelText: "Lead Date*",
                    controller: addLeadController.dateController.value,
                    textInputType: TextInputType.phone,
                    horizontalPadding: null,
                    readOnly: true,
                    textColor: AppColors.black,
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onTap: () => _selectDate(context),
                  ),

                  /* commonTextField(
                      prefixImage: AppImages.companyName,
                      needValidation: true,
                      readOnly: true,
                      onTap: () {
                        Get.defaultDialog(
                          title: "Customer",
                          content: SizedBox(
                            height: Get.height / 1.50,
                            width: Get.width - 50,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: TextField(
                                    controller: addLeadController.customerSearchController.value,
                                    decoration: const InputDecoration(
                                      labelText: "Search",
                                    ),
                                    onChanged: (value) {
                                      Future.delayed(const Duration(seconds: 1), () async {
                                        await addLeadController.getCustomer(text: value, isLoading: true);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible( // Add Expanded to prevent overflow
                                  child: Obx(() {
                                    if (addLeadController.isCustomerDialogLoading.value) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (addLeadController.customerList.isEmpty) {
                                      return const Center(child: Text("No Data Found"));
                                    } else {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: addLeadController.customerList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(addLeadController.customerList[index].customerName),
                                            onTap: () {
                                              addLeadController.companyNameController.value.text =
                                                  addLeadController.customerList[index].customerName;
                                              Get.back(); // Close the dialog
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                      validationMessage: "Company Name",
                      enabledBorder: AppColors.black,
                      labelText: "Company Name*",
                      controller: addLeadController.companyNameController.value,
                      textInputType: TextInputType.text,
                      horizontalPadding: null,
                      textColor: AppColors.black),*/
                  commonTextField(
                      // prefixImage: AppImages.companyName,
                      needValidation: true,
                      validationMessage: "Company Name",
                      enabledBorder: AppColors.black,
                      labelText: "Company Name*",
                      controller: addLeadController.companyNameController.value,
                      textInputType: TextInputType.name,
                      isUpperCaseValidator: true,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                      // prefixImage: AppImages.contactName,
                      needValidation: true,
                      validationMessage: "Contact Name",
                      enabledBorder: AppColors.black,
                      labelText: "Contact Name*",
                      controller: addLeadController.contactNameController.value,
                      textInputType: TextInputType.name,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                      // prefixImage: AppImages.contactNo,
                      needValidation: true,
                      validationMessage: "Contact No",
                      isPhoneNumberValidator: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      enabledBorder: AppColors.black,
                      labelText: "Contact No*",
                      controller: addLeadController.contactNumberController.value,
                      textInputType: TextInputType.phone,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                      // prefixImage: AppImages.address,
                      needValidation: true,
                      validationMessage: "Address",
                      enabledBorder: AppColors.black,
                      labelText: "Address*",
                      controller: addLeadController.addressController.value,
                      textInputType: TextInputType.text,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                      // prefixImage: AppImages.email,
                      needValidation: true,
                      validationMessage: "Email",
                      isEmailValidator: true,
                      enabledBorder: AppColors.black,
                      labelText: "Email*",
                      controller: addLeadController.emailController.value,
                      textInputType: TextInputType.emailAddress,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<City>(
                          // prefixImage: AppImages.city,
                          hintText: 'City*',
                          items: addLeadController.cityList,
                          itemAsString: (City city) => "${city.cityCode} : ${city.location}",
                          selectedItem: addLeadController.selectedCity.value,
                          onChanged: (City? city) {
                            FocusScope.of(context).unfocus();
                            if (city != null) {
                              addLeadController.cityId.value = city.cityCode;
                              addLeadController.selectedCity.value = city;
                              addLeadController.cityId.refresh();
                              addLeadController.selectedCity.refresh();
                            }
                          },
                          validator: (value) => value == null ? 'Please select a City' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     CustomDropdown<Branch>(
                  //       enabled: widget.isEdit ? true : false,
                  //       // prefixImage: AppImages.branchName,
                  //       hintText: 'Branch Name*',
                  //       items: addLeadController.branchList,
                  //       selectedItem: addLeadController.selectedBranch.value,
                  //       itemAsString: (Branch branch) => "${branch.locCode} : ${branch.locName}",
                  //       // Display the user's name
                  //       onChanged: (Branch? branch) {
                  //         if (branch != null) {
                  //           addLeadController.branchId.value = branch.locCode;
                  //           addLeadController.selectedBranch.value = branch;
                  //           addLeadController.branchId.refresh();
                  //           addLeadController.selectedBranch.refresh();
                  //         }
                  //       },
                  //       // validator: (value) => value == null ? 'Please select a Branch' : null,
                  //       showSearchBox: addLeadController.branchList.length > 4 ? true : false,
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     CustomDropdown<Branch>(
                  //       enabled: widget.isEdit ? true : false,
                  //       // prefixImage: AppImages.region,
                  //       hintText: 'Region*',
                  //       items: addLeadController.branchList,
                  //       selectedItem: addLeadController.selectedRegion.value,
                  //       itemAsString: (Branch branch) => "${branch.locCode} : ${branch.locName}",
                  //       // Display the user's name
                  //       onChanged: (Branch? region) {
                  //         if (region != null) {
                  //           addLeadController.regionId.value = region.locCode;
                  //           addLeadController.selectedRegion.value = region;
                  //           addLeadController.regionId.refresh();
                  //           addLeadController.selectedRegion.refresh();
                  //         }
                  //       },
                  //       // validator: (value) => value == null ? 'Please select a Region' : null,
                  //       showSearchBox: addLeadController.branchList.length > 4 ? true : false,
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Obx(() {
                  //       return CustomDropdown<Designation>(
                  //         enabled: widget.isEdit ? true : false,
                  //         // prefixImage: AppImages.designation,
                  //         hintText: 'Designation*',
                  //         items: addLeadController.designationList,
                  //         selectedItem: addLeadController.selectedDesignation.value,
                  //         itemAsString: (Designation designation) => designation.codeDesc,
                  //         // Display the user's name
                  //         onChanged: (Designation? designation) {
                  //           if (designation != null) {
                  //             addLeadController.designationId.value = designation.codeId;
                  //             addLeadController.selectedDesignation.value = designation;
                  //             addLeadController.designationId.refresh();
                  //             addLeadController.selectedDesignation.refresh();
                  //             debugPrint('Selected User ID: ');
                  //           }
                  //         },
                  //         // validator: (value) => value == null ? 'Please select a Designation' : null,
                  //         showSearchBox: true,
                  //       );
                  //     }),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<LeadSource>(
                          // prefixImage: AppImages.leadSource,
                          hintText: 'Lead Source*',
                          selectedItem: addLeadController.selectedSource.value,
                          items: addLeadController.leadSourceList,
                          itemAsString: (LeadSource leadSource) => "${leadSource.codeId} : ${leadSource.codeDesc}",
                          onChanged: (LeadSource? leadSource) {
                            if (leadSource != null) {
                              addLeadController.leadSourceId.value = leadSource.codeId;
                              addLeadController.selectedSource.value = leadSource;
                              addLeadController.leadSourceId.refresh();
                              addLeadController.selectedSource.refresh();
                              print("source id === ${addLeadController.leadSourceId}");
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Lead source' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      CustomDropdown<AssignedUser>(
                        // prefixImage: AppImages.assignedTO,
                        hintText: 'Assigned To*',
                        items: addLeadController.userList,
                        selectedItem: addLeadController.selectedUser.value,
                        itemAsString: (AssignedUser user) => "${user.userId} : ${user.name}",
                        onChanged: (AssignedUser? user) {
                          if (user != null) {
                            addLeadController.assignedToId.value = user.userId;
                            addLeadController.selectedUser.value = user;
                            addLeadController.assignedToId.refresh();
                            addLeadController.selectedUser.refresh();
                            debugPrint('Selected User ID: ${user.userId}');
                          }
                        },
                        validator: (value) => value == null ? 'Please select a User' : null,
                        showSearchBox: true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<IndustryType>(
                          // prefixImage: AppImages.industryType,
                          hintText: 'Industry type*',
                          items: addLeadController.industryTypeList,
                          selectedItem: addLeadController.selectedIndustryType.value,
                          itemAsString: (IndustryType industryType) => industryType.codeDesc,
                          onChanged: (IndustryType? industryType) {
                            if (industryType != null) {
                              addLeadController.industryTypeId.value = industryType.codeId;
                              addLeadController.selectedIndustryType.value = industryType;
                              addLeadController.industryTypeId.refresh();
                              addLeadController.selectedIndustryType.refresh();
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Industry' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  Obx(() {
                      return MultiDropdown(
                        closeOnBackButton: true,
                        items: addLeadController.serviceList.value!.map((e) {
                          return DropdownItem(label: e.codeDesc, value: e);
                        }).toList(),
                        controller: addLeadController.controller.value,
                        enabled: true,
                        searchEnabled: true,
                        chipDecoration: const ChipDecoration(
                          backgroundColor: AppColors.grey,
                          wrap: false,
                          runSpacing: 5,
                          spacing: 5,
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Services Interested*',
                          labelText: "Services Interested*",
                          showClearIcon: false,
                          backgroundColor: AppColors.whiteColor,
                          hintStyle: AppTextStyle.regular.copyWith(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                          labelStyle: AppTextStyle.regular.copyWith(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.boderColor,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.boderColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.boderColor,
                              width: 1,
                            ),
                          ),
                         /* prefixIcon: Image.asset(
                            AppImages.servicesInterested,
                            scale: 15,
                          ),*/
                        ),
                        dropdownDecoration: const DropdownDecoration(
                            marginTop: 6,
                            maxHeight: 500,
                            header: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Select user from the list',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            backgroundColor: AppColors.green100),
                        dropdownItemDecoration: DropdownItemDecoration(
                          selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          addLeadController.selectedService.value = selectedItems;
                          debugPrint("OnSelectionChange: ${selectedItems.map((e) => e)}");
                        },
                      );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: addLeadController.isActive.value,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value) {
                              addLeadController.isActive.value = value!;
                            });
                      }),
                      const Text("Active"),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return ElevatedButton(
                            onPressed: () async {
                              if (!await ApiHandler.hasInternet()) {
                                toastMessage(text: "No internet connection", color: AppColors.redColor);
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                await addLeadController.addLead(
                                  loading: true,
                                  id: widget.id,
                                  isUpdate: widget.isEdit,
                                  a: addLeadController.controller.value,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: addLeadController.isLoading.value
                                ? Center(
                                    child: loader(loaderColor: AppColors.whiteColor),
                                  )
                                : Text(
                                    widget.isEdit ? "Update" : "Add",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          );
                        }),
                        /*if(!widget.isEdit)
                        ElevatedButton(
                          onPressed: () {
                            // Handle clear
                            addLeadController.clear();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.whiteColor,
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: const BorderSide(color: AppColors.primaryColor)),
                          ),
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
