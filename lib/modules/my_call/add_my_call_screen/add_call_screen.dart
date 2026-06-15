import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../meeting/add_meeting_screen/get_customer_list_model.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import 'add_call_controller.dart';
import 'call_module_response_model.dart';

class AddCallScreen extends StatefulWidget {
  final bool? isEdit;
  final bool? isFromMeetingScreen;
  final bool? isFromLeadScreen;
  final bool? isFromCustomerScreen;
  final String? callId;
  final Map? data;

  const AddCallScreen({super.key, this.isEdit = false, this.isFromMeetingScreen = false, this.isFromLeadScreen = false, this.isFromCustomerScreen = false, this.callId, this.data});

  @override
  State<AddCallScreen> createState() => _AddCallScreenState();
}

class _AddCallScreenState extends State<AddCallScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddCallController addCallController = Get.find<AddCallController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      addCallController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  void initState() {
    () async {
      if (widget.isEdit!) {
        await addCallController.editCall(id: widget.callId, a: addCallController.controller.value);
      } else if (widget.isFromMeetingScreen! || widget.isFromCustomerScreen!) {
        addCallController.selectedCallStatus.value = CallType(codeDesc: "In Progress", codeId: "2", codeType: "In Progress");
        addCallController.callStatusId.value = "2";
        addCallController.callLeadId.value = widget.data!["leadId"];
        addCallController.companyNameController.value.text = widget.data!['customerName'];
        addCallController.selectedCallLead.value = CustomerData(customerCode: widget.data!['leadId'], customerName: widget.data!['customerName']);
      } else if (widget.isFromLeadScreen!) {
        addCallController.selectedCallStatus.value = CallType(codeDesc: "In Progress", codeId: "2", codeType: "In Progress");
        addCallController.callStatusId.value = "2";
        addCallController.companyNameController.value.text = widget.data!['customerName'];
        addCallController.callLeadId.value = widget.data!["leadId"];
        addCallController.selectedCallLead.value = CustomerData(customerCode: widget.data!['leadId'], customerName: widget.data!['customerName']);
      }
      if (widget.isFromLeadScreen!) {
        await addCallController.getUser();
        addCallController.getCategory();
        addCallController.getLead();
        addCallController.getPurpose();
        addCallController.getStatus();
      }
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
          widget.isEdit! ? 'Edit Call' : 'Add Call',
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
                  Text(widget.isEdit! ? 'Edit Call' : 'Add Call', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<CallType>(
                          prefixImage: AppImages.callPurpose,
                          hintText: 'Call Purpose',
                          items: addCallController.callPurposeList,
                          selectedItem: addCallController.selectedCallPurpose.value,
                          itemAsString: (CallType data) => data.codeDesc,
                          // Display the user's name
                          onChanged: (CallType? data) {
                            if (data != null) {
                              addCallController.selectedCallPurpose.value = data;
                              addCallController.callPurposeId.value = data.codeId;
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Call purpose' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<CallType>(
                          prefixImage: AppImages.callCategory,
                          hintText: 'Call Category',
                          items: addCallController.callCategoryList,
                          selectedItem: addCallController.selectedCallCategory.value,
                          itemAsString: (CallType data) => data.codeDesc,
                          // Display the user's name
                          onChanged: (CallType? data) {
                            if (data != null) {
                              addCallController.selectedCallCategory.value = data;
                              addCallController.callCategoryId.value = data.codeId;
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Call category' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                  commonTextField(
                    prefixImage: AppImages.date,
                    needValidation: true,
                    validationMessage: "Call Date",
                    enabledBorder: AppColors.black,
                    labelText: "Call Date",
                    controller: addCallController.dateController.value,
                    textInputType: TextInputType.phone,
                    horizontalPadding: null,
                    readOnly: true,
                    textColor: AppColors.black,
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onTap: () => _selectDate(context),
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              addCallController.endTime.value = "";
                              final TimeOfDay? startTime = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                initialTime: const TimeOfDay(hour: 7, minute: 15),
                              );
                              if (startTime != null) {
                                addCallController.startTime.value = "${startTime.hour}:${startTime.minute}";

                                addCallController.update();
                              }

                              /* final TimeOfDay? startTime = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                initialTime: const TimeOfDay(hour: 7, minute: 15),
                              );
                              if (startTime != null) {
                                addCallController.startTime.value = "${startTime.hour}:${startTime.minute}";
                              }*/
                            },
                            child: AbsorbPointer(
                              child: commonTextField(
                                  prefixImage: AppImages.time,
                                  needValidation: true,
                                  readOnly: true,
                                  validationMessage: "Start Time",
                                  enabledBorder: AppColors.black,
                                  labelText: "Start Time*",
                                  controller: TextEditingController(text: addCallController.startTime.value),
                                  textInputType: TextInputType.text,
                                  horizontalPadding: null,
                                  textColor: AppColors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? startTime = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                initialTime: TimeOfDay(hour: int.parse(addCallController.startTime.value.split(":").first), minute: int.parse(addCallController.startTime.value.split(":").last)),
                              );
                              if (startTime != null) {
                                addCallController.endTime.value = "${startTime.hour}:${startTime.minute}";
                                addCallController.endTime.value = "${startTime.hour}:${startTime.minute}";
                                addCallController.update();
                              }

                              /*final TimeOfDay? startTime = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                initialTime: const TimeOfDay(hour: 7, minute: 15),
                              );
                              if (startTime != null) {
                                addCallController.endTime.value = "${startTime.hour}:${startTime.minute}";
                              }*/
                            },
                            child: AbsorbPointer(
                              child: commonTextField(
                                  prefixImage: AppImages.time,
                                  needValidation: true,
                                  readOnly: true,
                                  validationMessage: "End Time",
                                  enabledBorder: AppColors.black,
                                  labelText: "End Time*",
                                  controller: TextEditingController(text: addCallController.endTime.value),
                                  textInputType: TextInputType.text,
                                  horizontalPadding: null,
                                  startTime: addCallController.startTime.value,
                                  isTimeValidator: true,
                                  textColor: AppColors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  commonTextField(
                      enable: false,
                      prefixImage: AppImages.companyName,
                      needValidation: false,
                      /*readOnly: true,
                      onTap: () {
                        if (!widget.isEdit!) {
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
                                      controller: addCallController.customerSearchController.value,
                                      decoration: const InputDecoration(
                                        labelText: "Search",
                                      ),
                                      onChanged: (value) {
                                        Future.delayed(const Duration(seconds: 1), () async {
                                          await addCallController.getLead(text: value, isLoading: true);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Flexible(
                                    // Add Expanded to prevent overflow
                                    child: Obx(() {
                                      if (addCallController.isCustomerDialogLoading.value) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (addCallController.customerList.isEmpty) {
                                        return const Center(child: Text("No Data Found"));
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: addCallController.customerList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(addCallController.customerList[index].customerName),
                                              onTap: () {
                                                addCallController.companyNameController.value.text = addCallController.customerList[index].customerName;
                                                addCallController.selectedCallLead.value = addCallController.customerList[index];
                                                addCallController.callLeadId.value = addCallController.customerList[index].customerCode;
                                                Get.back();

                                                debugPrint("callId === ${addCallController.callLeadId.value}"); // Close the dialog
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
                        }
                      },*/
                      validationMessage: "Customer Name",
                      enabledBorder: AppColors.black,
                      labelText: "Customer Name*",
                      controller: addCallController.companyNameController.value,
                      textInputType: TextInputType.text,
                      horizontalPadding: null,
                      textColor: AppColors.black),

                  /*Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<CustomerData>(
                          prefixImage: AppImages.companyName,
                          hintText: 'Customer Name',
                          items: addCallController.customerList,
                          selectedItem: addCallController.selectedCallLead.value,
                          itemAsString: (CustomerData data) => data.customerName,
                          // Display the user's name
                          onChanged: (CustomerData? data) {
                            if (data != null) {
                              addCallController.selectedCallLead.value = data;
                              addCallController.callLeadId.value = data.contractId;
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Customer Name' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),*/
                  // Obx(() {
                  //   return addCallController.callUserList.value != null
                  //       ? MultiDropdown(
                  //           closeOnBackButton: true,
                  //           items: addCallController.callUserList.value!.map((e) {
                  //             return DropdownItem(label: "${e.userId} : ${e.name} : ${Pref.getBrcd()}", value: e);
                  //           }).toList(),
                  //           controller: addCallController.controller.value,
                  //           enabled: true,
                  //           searchEnabled: true,
                  //           chipDecoration: const ChipDecoration(
                  //             backgroundColor: AppColors.grey,
                  //             wrap: true,
                  //             runSpacing: 5,
                  //             spacing: 5,
                  //           ),
                  //           fieldDecoration: FieldDecoration(
                  //             hintText: 'Add Attendances',
                  //             labelText: "Add Attendances",
                  //             hintStyle: AppTextStyle.regular.copyWith(
                  //               fontSize: 14,
                  //               color: AppColors.grey,
                  //             ),
                  //             labelStyle: AppTextStyle.regular.copyWith(
                  //               fontSize: 14,
                  //               color: AppColors.grey,
                  //             ),
                  //             showClearIcon: false,
                  //             prefixIcon: Image.asset(
                  //               AppImages.attendance,
                  //               scale: 15,
                  //             ),
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //               borderSide: const BorderSide(
                  //                 color: AppColors.boderColor,
                  //                 width: 1,
                  //               ),
                  //             ),
                  //             disabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //               borderSide: const BorderSide(
                  //                 color: AppColors.boderColor,
                  //                 width: 1,
                  //               ),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //               borderSide: const BorderSide(
                  //                 color: AppColors.boderColor,
                  //                 width: 1,
                  //               ),
                  //             ),
                  //           ),
                  //           dropdownDecoration: const DropdownDecoration(
                  //               marginTop: 6,
                  //               maxHeight: 500,
                  //               header: Padding(
                  //                 padding: EdgeInsets.all(8),
                  //                 child: Text(
                  //                   'Select user from the list',
                  //                   textAlign: TextAlign.start,
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ),
                  //               backgroundColor: AppColors.green100),
                  //           dropdownItemDecoration: DropdownItemDecoration(
                  //             selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                  //             disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  //           ),
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return 'Please select a user';
                  //             }
                  //             return null;
                  //           },
                  //           onSelectionChange: (selectedItems) {
                  //             addCallController.selectedUser.value = selectedItems;
                  //             debugPrint("OnSelectionChange: ${selectedItems.map((e) => e)}");
                  //           },
                  //         )
                  //       : Container(
                  //           height: 48,
                  //           decoration: BoxDecoration(border: Border.all(color: AppColors.black), borderRadius: BorderRadius.circular(2)),
                  //           child: const Row(
                  //             children: [
                  //               SizedBox(
                  //                 width: 20,
                  //               ),
                  //               CircularProgressIndicator(
                  //                 color: AppColors.black,
                  //                 strokeWidth: 1,
                  //               )
                  //             ],
                  //           ),
                  //         );
                  // }),
                  // const SizedBox(height: 16),

                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<CallType>(
                          prefixImage: AppImages.callStatus,
                          hintText: 'Call Status',
                          items: addCallController.callStatusList,
                          selectedItem: addCallController.selectedCallStatus.value,
                          itemAsString: (CallType data) => data.codeDesc,
                          // Display the user's name
                          onChanged: (CallType? data) {
                            if (data != null) {
                              addCallController.selectedCallStatus.value = data;
                              addCallController.callStatusId.value = data.codeId;
                              debugPrint("status Id === ${data.codeId}");
                              debugPrint("status Id === ${data.codeDesc}");
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Call Status' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),

                  commonTextField(
                    prefixImage: AppImages.remark,
                    needValidation: true,
                    validationMessage: "Remark",
                    enabledBorder: AppColors.black,
                    labelText: "Remark",
                    controller: addCallController.remarksController.value,
                    textInputType: TextInputType.text,
                    horizontalPadding: null,
                    textColor: AppColors.black,
                    onTap: () => {},
                  ),
                  // commonTextField(
                  //   prefixImage: AppImages.addCall,
                  //   needValidation: true,
                  //   validationMessage: "Call MOM",
                  //   enabledBorder: AppColors.black,
                  //   labelText: "Call MOM",
                  //   controller: addCallController.addCallMOMController.value,
                  //   textInputType: TextInputType.text,
                  //   horizontalPadding: null,
                  //   textColor: AppColors.black,
                  //   onTap: () => {},
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await addCallController.addCall(
                                loading: true,
                                data: {
                                  "callDate": addCallController.dateController.value.text,
                                  "callPurpose": "${addCallController.callPurposeId.value}",
                                  if (widget.isFromCustomerScreen!) "customerCode": addCallController.callLeadId.value,
                                  "callCategoryId": "${addCallController.callCategoryId.value}",
                                  "leadId": widget.isFromLeadScreen! ? "${addCallController.callLeadId.value}" : "",
                                  "callStatusId": "${addCallController.callStatusId.value}",
                                  "startTime": addCallController.startTime.value,
                                  "endTime": addCallController.endTime.value,
                                  "remarks": addCallController.remarksController.value.text,
                                  // "customerCode": addCallController.callLeadId.value,
                                  "userid": Pref.getUserId()
                                  // "callMOM": addCallController.addCallMOMController.value.text,
                                  // "attendeeIDs": addCallController.selectedUser.value!.map((user) => user.userId.toString()).join(','),
                                },
                                isUpdate: widget.isEdit!,
                                a: addCallController.controller.value,
                                id: widget.callId);
                          }
                          // Handle submit
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: addCallController.isLoading.value
                            ? loader()
                            : Text(
                                widget.isEdit! ? "Update" : "Add",
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                      /*    ElevatedButton(
                        onPressed: () {
                          // Handle clear
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteColor,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                        ),
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),*/
                    ],
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

class Datas {
  final String customerName;
  final String customerId;

  Datas({
    required this.customerName,
    required this.customerId,
  });
}
