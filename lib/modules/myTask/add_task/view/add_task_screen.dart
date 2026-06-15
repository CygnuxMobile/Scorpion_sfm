import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/get_customer_list_model.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_images.dart';
import '../../../../config/app_text_style.dart';
import '../../../lead/add_lead/model/get_category_response_model.dart';
import '../../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../../widget/TextField.dart';
import '../../../widget/dropdown.dart';
import '../../../widget/loader.dart';
import '../controller/add_task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isEdit;
  final String? id;

  const AddTaskScreen({super.key, this.isEdit = false, this.id});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddTaskController addTaskController = Get.find<AddTaskController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      addTaskController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  void initState() {
    () async {
      // await addTaskController.getCategory();
      // await addTaskController.getUser();
      // await addTaskController.getPriority();
      // await addTaskController.getCustomer();

      if (widget.isEdit) {
        addTaskController.editTask(id: widget.id, a: addTaskController.controller.value);
      } else {}
    }();
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
          widget.isEdit ? "Update Task" : 'Add Task',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.isEdit ? "Update Task" : 'Add Task', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // {address: 336, assignedToId: 0002, branchId: BLR, cityId: 744, companyName: qq, contactName: qq, contactNo: 9999999999, designationId: 10, email: qqqq@yopmail.com, industryTypeId: 10, isActive: true, leadCategoryId: 1, leadDate: 14/01/2025, leadSourceId: 2, regionId: BLR, serviceInterestedIDs: 3,4}
                  commonTextField(
                      prefixImage: AppImages.taskName,
                      needValidation: true,
                      validationMessage: "Task Name",
                      enabledBorder: AppColors.black,
                      labelText: "Task Name*",
                      controller: addTaskController.taskNameController.value,
                      textInputType: TextInputType.text,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                      prefixImage: AppImages.taskDescription,
                      needValidation: true,
                      validationMessage: "Task Description",
                      enabledBorder: AppColors.black,
                      labelText: "Task Description*",
                      controller: addTaskController.taskDescriptionController.value,
                      textInputType: TextInputType.text,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                  commonTextField(
                    prefixImage: AppImages.date,
                    needValidation: true,
                    validationMessage: "Task Date",
                    enabledBorder: AppColors.black,
                    labelText: "Task Date*",
                    controller: addTaskController.dateController.value,
                    textInputType: TextInputType.datetime,
                    horizontalPadding: null,
                    readOnly: true,
                    textColor: AppColors.black,
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onTap: () => _selectDate(context),
                  ),
                  Row(
                    children: [
                      CustomDropdown<Categories>(
                        prefixImage: AppImages.leadCategory,
                        hintText: 'Lead Category*',
                        items: addTaskController.categoryList,
                        selectedItem: addTaskController.selectedCategory.value,
                        itemAsString: (Categories category) => category.codeDesc,
                        // Display the user's name
                        onChanged: (Categories? category) {
                          if (category != null) {
                            addTaskController.categoryId.value = category.codeId;
                            addTaskController.selectedCategory.value = category;
                            addTaskController.categoryId.refresh();
                            addTaskController.selectedCategory.refresh();
                          }
                        },
                        validator: (value) => value == null ? 'Please select a Branch' : null,
                        showSearchBox: addTaskController.categoryList.length > 4 ? true : false,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<CustomerData>(
                          prefixImage: AppImages.companyName,
                          hintText: 'Customer Name*',
                          items: addTaskController.customerList,
                          selectedItem: addTaskController.selectedCustomer.value,
                          itemAsString: (CustomerData data) => data.customerName,
                          // Display the user's name
                          onChanged: (CustomerData? data) {
                            if (data != null) {
                              addTaskController.selectedCustomer.value = data;
                              addTaskController.customerId.value = data.contractId;
                              debugPrint("meet id === ${data.contractId}");
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Customer Name' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      CustomDropdown<LeadSource>(
                        prefixImage: AppImages.priority,
                        hintText: 'Priority*',
                        items: addTaskController.priorityList,
                        selectedItem: addTaskController.selectedPriority.value,
                        itemAsString: (LeadSource leadSource) => leadSource.codeDesc,
                        // Display the user's name
                        onChanged: (LeadSource? leadSource) {
                          if (leadSource != null) {
                            addTaskController.priorityId.value = leadSource.codeId;
                            addTaskController.selectedPriority.value = leadSource;
                            addTaskController.priorityId.refresh();
                            addTaskController.selectedPriority.refresh();
                          }
                        },
                        validator: (value) => value == null ? 'Please select a Priority' : null,
                        showSearchBox: addTaskController.priorityList.length > 4 ? true : false,
                      ),
                    ],
                  ),
                  Obx(() {
                    return addTaskController.userList.isNotEmpty
                        ? MultiDropdown(
                            closeOnBackButton: true,
                            items: addTaskController.userList.map((e) {
                              return DropdownItem(label: "${e.userId} : ${e.name}", value: e);
                            }).toList(),
                            controller: addTaskController.controller.value,
                            enabled: true,
                            searchEnabled: true,
                      chipDecoration: const ChipDecoration(
                        backgroundColor: AppColors.grey,
                        wrap: false,
                        runSpacing: 5,
                        spacing: 5,
                      ),
                            /*selectedItemBuilder: (name) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff5a707a),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 3, bottom: 3),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name.value.name,
                                          style: AppTextStyle.regular.copyWith(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            addTaskController.controller.value.items.remove(name);
                                            addTaskController.controller.refresh();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: AppColors.whiteColor,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },*/
                            fieldDecoration: FieldDecoration(
                              hintText: 'Assigned to*',
                              labelText: "Assigned to*",
                              showClearIcon: false,
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
                              prefixIcon: Image.asset(
                                AppImages.assignedTO,
                                scale: 15,
                              ),
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
                              addTaskController.selectedUsers.value = selectedItems;
                              debugPrint("OnSelectionChange: ${selectedItems.map((e) => e)}");
                            },
                          )
                        : Container(
                            height: 48,
                            decoration: BoxDecoration(border: Border.all(color: AppColors.black), borderRadius: BorderRadius.circular(2)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                loader()
                              ],
                            ),
                          );
                  }),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var data = {
                                  "assignedToIDs": addTaskController.selectedUsers.value!.map((user) => user.userId.toString()).join(','),
                                  "leadCategoryId": "${addTaskController.categoryId.value}",
                                  "leadId": addTaskController.customerId.value,
                                  "priorityId": addTaskController.priorityId.value,
                                  "taskDate": addTaskController.dateController.value.text,
                                  "taskDescription": addTaskController.taskDescriptionController.value.text,
                                  "taskName": addTaskController.taskNameController.value.text,
                                };
                                print("datadatadat === $data");
                                await addTaskController.addTask(loading: true, id: widget.id, isUpdate: widget.isEdit, a: addTaskController.controller.value, data: data);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: addTaskController.isLoading.value
                                ? Center(
                                    child: loader(),
                                  )
                                : Text(
                                    widget.isEdit ? "Update" : "Add",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          );
                        }),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Handle clear
                        //     addTaskController.clear();
                        //     setState(() {});
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: AppColors.whiteColor,
                        //     minimumSize: const Size(150, 50),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(40),
                        //         side: BorderSide(color: AppColors.primaryColor)
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     "Clear",
                        //     style: TextStyle(color: AppColors.primaryColor),
                        //   ),
                        // ),
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
