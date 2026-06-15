import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/complaint/add_complaint/add_complaint_controller.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_complaint_type_response_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../lead/add_lead/model/get_assign_response.dart';
import '../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../lead/add_lead/model/get_user_response_model.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../complaint_screen/model/complaint_list_response.dart';

class EscalationTicketScreen extends StatefulWidget {
  final ComplaintListDatum? data;

  const EscalationTicketScreen({super.key, this.data});

  @override
  State<EscalationTicketScreen> createState() => _EscalationTicketScreenState();
}

class _EscalationTicketScreenState extends State<EscalationTicketScreen> {
  AddComplaintController addComplaintController = Get.find<AddComplaintController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // ()async{
    //   await addComplaintController.getComplaintData(isLoading: true, multiAssignToController: addComplaintController.assignToController.value, id: widget.data!.complaintId, escalateToController: addComplaintController.escalateToController.value);
    // }();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await addComplaintController.getAssignTo(branchCode: "");
       await addComplaintController
          .getComplaintData(
              isLoading: true,
              multiAssignToController: addComplaintController.assignToController.value,
              id: widget.data!.complaintId,
              escalateToController: addComplaintController.escalateToController.value)
          .whenComplete(() {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${addComplaintController.assignToController.value}");
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Escalation Ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return !addComplaintController.isEscalationLoader.value
                ? SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     Obx(() {
                          //       return CustomDropdown<TransportMode>(
                          //         // prefixImage AppImages.transportMode,
                          //         hintText: 'Transport Mode*',
                          //         items: addExpenseController.transportModeList,
                          //         itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                          //         // Display the user's name
                          //         selectedItem: addExpenseController.selectedTransportMode.value,
                          //         onChanged: (TransportMode? transportMode) {
                          //
                          //         },
                          //         validator: (value) => value == null ? 'Please select a Transport Mode' : null,
                          //         showSearchBox: true,
                          //       );
                          //     }),
                          //   ],
                          // ),
                          // const SizedBox(height: 16),
                          commonTextField(
                              enable: false,
                              // prefixImage AppImages.complaintId,
                              enabledBorder: AppColors.black,
                              labelText: "Complaint ID",
                              controller: addComplaintController.complaintIDController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black),
                          commonTextField(
                              enable: false,
                              // prefixImage AppImages.docketNo,
                              enabledBorder: AppColors.black,
                              labelText: "Docket No",
                              controller: addComplaintController.docketNoController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black),
                          Row(
                            children: [
                              CustomDropdown<ComplaintTypeDatum>(
                                enabled: false,
                                // prefixImage AppImages.complaintType,
                                hintText: 'Ticket Type*',
                                items: addComplaintController.complaintTypeList,
                                selectedItem: addComplaintController.selectedComplaintType.value,
                                itemAsString: (ComplaintTypeDatum complaintTypeDatum) => complaintTypeDatum.codeDesc,
                                onChanged: (ComplaintTypeDatum? complaintTypeDatum) {
                                  if (complaintTypeDatum != null) {
                                    addComplaintController.complaintType.value = complaintTypeDatum.codeDesc;
                                    addComplaintController.selectedComplaintType.value = complaintTypeDatum;
                                    addComplaintController.complaintType.refresh();
                                    addComplaintController.selectedComplaintType.refresh();
                                  }
                                },
                                showSearchBox: addComplaintController.complaintTypeList.length > 4 ? true : false,
                              ),
                            ],
                          ),
                          commonTextField(
                              enable: false,
                              // prefixImage AppImages.taskDescription,
                              enabledBorder: AppColors.black,
                              labelText: "Ticket Description",
                              controller: addComplaintController.descriptionController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black),
                          Row(
                            children: [
                              CustomDropdown<User>(
                                enabled: false,
                                // prefixImage AppImages.assignedTO,
                                hintText: 'Assigned To',
                                items: addComplaintController.userList,
                                selectedItem: addComplaintController.selectedUser.value,
                                itemAsString: (User user) => "${user.userId}:${user.name}",
                                onChanged: (User? user) {
                                  if (user != null) {
                                    addComplaintController.assignedTo.value = user.name;
                                    addComplaintController.selectedUser.value = user;
                                    addComplaintController.assignedTo.refresh();
                                    addComplaintController.selectedUser.refresh();
                                  }
                                },
                                showSearchBox: addComplaintController.branchList.length > 4 ? true : false,
                              ),
                            ],
                          ),

                          commonTextField(
                              enable: false,
                              // prefixImage AppImages.docketStatus,
                              enabledBorder: AppColors.black,
                              labelText: "Ticket Status",
                              controller: addComplaintController.ticketStatusController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black),
                          Row(
                            children: [
                              CustomDropdown<LeadSource>(
                                enabled: false,
                                // prefixImage AppImages.priority,
                                hintText: 'Priority*',
                                items: addComplaintController.priorityList,
                                selectedItem: addComplaintController.selectedPriority.value,
                                itemAsString: (LeadSource leadSource) => leadSource.codeDesc,
                                onChanged: (LeadSource? leadSource) {
                                  if (leadSource != null) {
                                    addComplaintController.priorityId.value = leadSource.codeId;
                                    addComplaintController.selectedPriority.value = leadSource;
                                    addComplaintController.priorityId.refresh();
                                    addComplaintController.selectedPriority.refresh();
                                  }
                                },
                                showSearchBox: addComplaintController.priorityList.length > 4 ? true : false,
                              ),
                            ],
                          ),
                          Obx(() {
                            return addComplaintController.assignList.value != null && addComplaintController.assignList.value!.isNotEmpty
                                ? MultiDropdown<Assign>(
                                    closeOnBackButton: true,
                                    items: addComplaintController.assignList.value!.map((e) {
                                      return DropdownItem(label: "${e.userId} : ${e.userName}", value: e);
                                    }).toList(),
                                    controller: addComplaintController.escalateToController.value,
                                    enabled: true,
                                    searchEnabled: true,
                                    chipDecoration: const ChipDecoration(
                                      backgroundColor: AppColors.grey,
                                      wrap: true,
                                      runSpacing: 5,
                                      spacing: 5,
                                    ),
                                    fieldDecoration: FieldDecoration(
                                      hintText: 'Escalate To*',
                                      labelText: "Escalate To*",
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
                                      /*prefixIcon: Image.asset(
                                        AppImages.servicesInterested,
                                        scale: 15,
                                      )*/
                                    ),
                                    dropdownDecoration: const DropdownDecoration(
                                        marginTop: 6,
                                        maxHeight: 500,
                                        header: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Select escalate to',
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
                                        return 'Please select a escalate to';
                                      }
                                      return null;
                                    },
                                    onSelectionChange: (List<Assign> selectedItems) {
                                      if (addComplaintController.pageCount.value != 1) {
                                        final selectedEmailIds = selectedItems.map((e) => e.emailId).toSet();

                                        addComplaintController.emailIdList.retainWhere((email) => selectedEmailIds.contains(email));

                                        for (var email in selectedEmailIds) {
                                          if (!addComplaintController.emailIdList.contains(email)) {
                                            addComplaintController.emailIdList.add(email!);
                                          }
                                        }
                                        addComplaintController.emailIdList.addAll(addComplaintController.escalationEmailIds);

                                        String emailString = selectedItems
                                            .map((e) => e.emailId)
                                            .where((email) => email != null && email.isNotEmpty)
                                            .join(";");

                                        List aaa = addComplaintController.assignList.value!
                                            .where((user) => emailString.contains(user.emailId!)) // Filter users
                                            .map((user) => user.emailId) // Extract email IDs
                                            .toList();

                                        addComplaintController.escalationEmailIds.value = addComplaintController.emailIdList.where((email) => !aaa.contains(email)).toList();
                                        // addComplaintController.emailIdList.addAll(addComplaintController.escalationEmailIds);
                                        debugPrint("emaiooo === ${addComplaintController.escalationEmailIds}");
                                      }
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

                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.boderColor, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  right: 8.0,
                                  left: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => addComplaintController.emailIdList.isNotEmpty
                                        ? Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: addComplaintController.emailIdList.map((email) {
                                              return Chip(
                                                label: Text(email, style: const TextStyle(color: Colors.black)),
                                                backgroundColor: Colors.grey[300],
                                                deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                                                onDeleted: () {
                                                  addComplaintController.escalationEmailIds.removeWhere((ema) => ema == email);
                                                  addComplaintController.removeEmail(email);
                                                },
                                              );
                                            }).toList(),
                                          )
                                        : const SizedBox()),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Obx(() {
                                      if (addComplaintController.emailIdList.isNotEmpty) {
                                        return const SizedBox(height: 8);
                                      }
                                      return const SizedBox();
                                    }),
                                    Obx(() => commonTextField(
                                      enable: false,
                                          // prefixImage AppImages.email,
                                          padding: 8.0,
                                          controller: addComplaintController.escEmailIDController.value,
                                          textInputType: TextInputType.emailAddress,
                                          labelText: 'Enter emails separated by semicolon',
                                          onChange: (value) {
                                            addComplaintController.addEmail(value);
                                          },
                                          errorText: addComplaintController.errorMessage.value.isNotEmpty ? addComplaintController.errorMessage.value : null,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          commonTextField(
                            enable: false,
                            // prefixImage AppImages.date,
                            needValidation: true,
                            validationMessage: "Esc. Date",
                            enabledBorder: AppColors.black,
                            labelText: "Esc. Date",
                            controller: addComplaintController.escDateController.value,
                            textInputType: TextInputType.phone,
                            horizontalPadding: null,
                            readOnly: true,
                            textColor: AppColors.black,
                            suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                addComplaintController.escDateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                              }
                            },
                          ),
                          commonTextField(
                              // prefixImage AppImages.remark,
                              needValidation: true,
                              validationMessage: "Remarks",
                              enabledBorder: AppColors.black,
                              labelText: "Remarks",
                              controller: addComplaintController.remarksController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black),
                          GestureDetector(
                              onTap: () async {
                                ImagePicker image = ImagePicker();

                                XFile? file = await image.pickImage(source: ImageSource.gallery);
                                if (file != null) {
                                  addComplaintController.image.value = File(file.path);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.boderColor, width: 1)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 30,
                                      color: AppColors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${addComplaintController.image.value != null && addComplaintController.image.value!.path != "" ? "Change " : "Add "}Document",
                                      style: const TextStyle(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 16,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      addComplaintController.addTicket(
                                        loading: true,
                                        isAddEscTkt: true,
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
                                  child: addComplaintController.isLoading.value
                                      ? loader(loaderColor: AppColors.whiteColor)
                                      : const Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {},
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: AppColors.whiteColor,
                                //     minimumSize: const Size(150, 50),
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: const BorderSide(color: AppColors.primaryColor, width: 1)),
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
                  )
                : Center(
                    child: loader(),
                  );
          })),
    );
  }
}
