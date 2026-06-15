import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/complaint/add_complaint/add_complaint_controller.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_complaint_subType_response_model.dart';
import 'package:scorpforce/modules/complaint/add_complaint/model/get_complaint_type_response_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../lead/add_lead/model/get_assign_response.dart';
import '../../lead/add_lead/model/get_branch_response_model.dart';
import '../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../complaint_screen/model/get_ticket_address_to_response_model.dart';
class AddComplaintScreen extends StatefulWidget {
  final bool isUpdateTicket;
  final bool isAddTicket;
  final bool isCloseTicket;
  final String? id;
  final String? docketNo;

  const AddComplaintScreen({super.key, this.isUpdateTicket = false, this.isCloseTicket = false, this.isAddTicket = false, this.id, this.docketNo});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  AddComplaintController addComplaintController = Get.find<AddComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await addComplaintController.getUserData(userId: Pref.getUserId().toString(), loading: true);
      if (widget.isAddTicket) {
        addComplaintController.complaintSubTypeList.clear();
        addComplaintController.ticketDateController.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        // addComplaintController.ticketDateController.value.text = DateFormat("dd/MM/yyyy").format(now)
        addComplaintController.emailIdList.clear();
        addComplaintController.selectTicketAddress.value = Branch(locCode: Pref.getBranchCode().toString(), locName: Pref.getBranchName().toString());
      }
      if (widget.isUpdateTicket || widget.isCloseTicket) {
        addComplaintController.updateDateController.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        addComplaintController.closerDateController.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        await addComplaintController.getComplaintData(id: widget.id, isFromUpdateTicket: true);
        addComplaintController.docketNoController.value.text = widget.docketNo!;
        await addComplaintController.getDocketData(docId: widget.docketNo!, loading: true, isDocket: false);
      }
    });

    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.isUpdateTicket
              ? "Update Ticket"
              : widget.isCloseTicket
                  ? "Close Ticket"
                  : 'Add Ticket',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      commonTextField(
                          enable: false,
                          // prefixImage: AppImages.username,
                          enabledBorder: AppColors.black,
                          labelText: "User ID",
                          controller: addComplaintController.userIDController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      commonTextField(
                          enable: false,
                          // prefixImage: AppImages.username,
                          enabledBorder: AppColors.black,
                          labelText: "User Name",
                          controller: addComplaintController.usernameController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      commonTextField(
                          enable: false,
                          // prefixImage: AppImages.managerID,
                          labelText: "Manager ID",
                          enabledBorder: AppColors.black,
                          controller: addComplaintController.managerIDController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      commonTextField(
                          enable: false,
                          // prefixImage: AppImages.managerID,
                          enabledBorder: AppColors.black,
                          labelText: "Manager Name",
                          controller: addComplaintController.managerNameController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                    ],
                  ),
                  commonTextField(
                      enable: widget.isUpdateTicket || widget.isCloseTicket ? false : true,
                      // prefixImage: AppImages.docketNo,
                      needValidation: true,
                      autoFocus: false,
                      validationMessage: "Docket No",
                      enabledBorder: AppColors.black,
                      labelText: "Docket No",
                      controller: addComplaintController.docketNoController.value,
                      textInputType: TextInputType.streetAddress,
                      horizontalPadding: null,
                      onChange: (value) {
                        addComplaintController.docketNoController.refresh();
                        addComplaintController.isSearch.value = value.isNotEmpty ? true : false;
                        addComplaintController.isGetData.value = false;
                        // addComplaintController.emailIdList.clear();
                      },
                      suffixIcon: addComplaintController.docketNoController.value.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                addComplaintController.isSearch.value = false;
                                addComplaintController.isGetData.value = false;
                                addComplaintController.docketNoController.value.clear();
                                addComplaintController.docketNoController.refresh();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ))
                          : const SizedBox(),
                      textColor: AppColors.black),
                  addComplaintController.isSearch.isTrue
                      ? Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              addComplaintController.getDocketData(docId: addComplaintController.docketNoController.value.text, loading: true, isDocket: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: addComplaintController.isLoading.value
                                ? loader(loaderColor: AppColors.whiteColor)
                                : const Text(
                                    "Get Docket Data",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        )
                      : const SizedBox(),
                  addComplaintController.isGetData.isTrue
                      ? Column(
                          children: [
                            commonTextField(
                              enable: false,
                              // prefixImage: AppImages.date,
                              enabledBorder: AppColors.black,
                              labelText: "Doc Date",
                              controller: addComplaintController.docDateController.value,
                              textInputType: TextInputType.phone,
                              horizontalPadding: null,
                              readOnly: true,
                              textColor: AppColors.black,
                              suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  addComplaintController.docDateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                }
                              },
                            ),
                            commonTextField(
                                enable: false,
                                // prefixImage AppImages.edd,
                                enabledBorder: AppColors.black,
                                labelText: "EDD",
                                controller: addComplaintController.eDDController.value,
                                textInputType: TextInputType.streetAddress,
                                horizontalPadding: null,
                                textColor: AppColors.black),
                            commonTextField(
                              enable: false,
                              // prefixImage AppImages.billingPartyName,
                              enabledBorder: AppColors.black,
                              labelText: "Billing Party Name",
                              controller: addComplaintController.billingPartyController.value,
                              textInputType: TextInputType.streetAddress,
                              horizontalPadding: null,
                              textColor: AppColors.black,
                            ),
                            commonTextField(
                                enable: false,
                                // prefixImage AppImages.origin,
                                enabledBorder: AppColors.black,
                                labelText: "Origin",
                                controller: addComplaintController.originController.value,
                                textInputType: TextInputType.streetAddress,
                                horizontalPadding: null,
                                textColor: AppColors.black),
                            commonTextField(
                                enable: false,
                                // prefixImage AppImages.destination,
                                enabledBorder: AppColors.black,
                                labelText: "Destination",
                                controller: addComplaintController.destinationController.value,
                                textInputType: TextInputType.streetAddress,
                                horizontalPadding: null,
                                textColor: AppColors.black),
                            commonTextField(
                                enable: false,
                                // prefixImage AppImages.destination,
                                enabledBorder: AppColors.black,
                                labelText: "Current Location",
                                controller: addComplaintController.currentLocationController.value,
                                textInputType: TextInputType.streetAddress,
                                horizontalPadding: null,
                                textColor: AppColors.black),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    CustomDropdown<TicketAddressTo>(
                                      enabled: true,
                                      // prefixImage AppImages.ticketLocation,
                                      hintText: 'Ticket Address To',
                                      items: addComplaintController.ticketAddressToList,
                                      selectedItem: addComplaintController.selectedTicketAddressTo.value,
                                      itemAsString: (TicketAddressTo branch) => "${branch.locCode} : ${branch.locName}",
                                      onChanged: (TicketAddressTo? branch) {
                                        if (branch != null) {
                                          addComplaintController.ticketAddressId.value = branch.locCode;
                                          addComplaintController.selectedTicketAddressTo.value = branch;
                                          addComplaintController.leadSourceId.refresh();
                                          addComplaintController.selectedSource.refresh();
                                          addComplaintController.assignList.value = null;
                                          addComplaintController.assignToId.value = null;
                                          addComplaintController.selectedAssign.value = null;
                                          addComplaintController.getAssignTo(branchCode: branch.locCode,);
                                          debugPrint("deb  deb -=-=-=-= == ${branch.locCode}");
                                          debugPrint("deb  deb -=-=-=-= == ${branch.locName}");
                                        }
                                      },
                                      showSearchBox: addComplaintController.complaintTypeList.length > 4 ? true : false,
                                      validator: (value) => value == null ? 'Please select a Ticket Address To' : null,
                                    ),
                                  ],
                                ),
                                addComplaintController.assignList.value == null
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: Text(
                                          "Assigned TO data does not found for ticket address to selected branch.",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    addComplaintController.assignList.value != null && addComplaintController.assignList.value!.isNotEmpty
                                        ? CustomDropdown<Assign>(
                                            enabled: true,
                                            // prefixImage AppImages.assignedTO,
                                            hintText: 'Assigned To',
                                            items: addComplaintController.assignList.value!,
                                            selectedItem: addComplaintController.selectedAssign.value,
                                            itemAsString: (Assign assign) => "${assign.userId} : ${assign.userName}",
                                            onChanged: (Assign? assign) {
                                              if (assign != null) {
                                                addComplaintController.assignToId.value = assign.userId;
                                                addComplaintController.selectedAssign.value = assign;
                                                addComplaintController.assignToId.refresh();
                                                addComplaintController.selectedAssign.refresh();
                                              }
                                            },
                                            validator: (value) => value == null ? 'Please select a Branch' : null,
                                            showSearchBox: addComplaintController.assignList.value!.length > 4 ? true : false,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  height: 150,
                                  child: commonTextField(
                                      enable: widget.isCloseTicket || widget.isUpdateTicket ? false : true,
                                      // prefixImage AppImages.destination,
                                      enabledBorder: AppColors.black,
                                      labelText: "Current",
                                      controller: addComplaintController.currentController.value,
                                      textInputType: TextInputType.multiline,
                                      horizontalPadding: null,
                                      expands: true,
                                      maxLine: null,
                                      minLine: null,
                                      textColor: AppColors.black),
                                ),
                                Row(
                                  children: [
                                    CustomDropdown<LeadSource>(
                                      enabled: widget.isCloseTicket || widget.isUpdateTicket ? false : true,
                                      // prefixImage AppImages.ticketSource,
                                      hintText: 'Ticket Source*',
                                      items: addComplaintController.leadSourceList,
                                      selectedItem: addComplaintController.selectedSource.value,
                                      itemAsString: (LeadSource leadSource) => leadSource.codeDesc,
                                      onChanged: (LeadSource? leadSource) {
                                        if (leadSource != null) {
                                          addComplaintController.leadSourceId.value = leadSource.codeDesc;
                                          addComplaintController.selectedSource.value = leadSource;
                                          addComplaintController.leadSourceId.refresh();
                                          addComplaintController.selectedSource.refresh();
                                        }
                                      },
                                      validator: (value) => value == null ? 'Please select a Complaint Type' : null,
                                      showSearchBox: addComplaintController.complaintTypeList.length > 4 ? true : false,
                                    ),
                                  ],
                                ),
                                commonTextField(
                                  enable: false,
                                  // prefixImage AppImages.date,
                                  needValidation: true,
                                  validationMessage: "Ticket Date*",
                                  enabledBorder: AppColors.black,
                                  labelText: "Ticket Date*",
                                  controller: addComplaintController.ticketDateController.value,
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
                                      debugPrint("date === ${picked}");
                                      addComplaintController.ticketDateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    CustomDropdown<ComplaintTypeDatum>(
                                      enabled: widget.isCloseTicket || widget.isUpdateTicket ? false : true,
                                      // prefixImage AppImages.complaintType,
                                      hintText: 'Ticket Type*',
                                      items: addComplaintController.complaintTypeList,
                                      selectedItem: addComplaintController.selectedComplaintType.value,
                                      itemAsString: (ComplaintTypeDatum complaintTypeDatum) => complaintTypeDatum.codeDesc,
                                      onChanged: (ComplaintTypeDatum? complaintTypeDatum) async {
                                        if (complaintTypeDatum != null) {
                                          addComplaintController.complaintType.value = complaintTypeDatum.codeDesc;
                                          addComplaintController.selectedComplaintType.value = complaintTypeDatum;
                                          addComplaintController.complaintType.refresh();
                                          addComplaintController.selectedComplaintType.refresh();
                                          addComplaintController.complaintSubTypeList.clear();
                                          addComplaintController.selectedComplaintSubType.value = null;
                                          await addComplaintController.getComplaintSubType(id: complaintTypeDatum.codeId);
                                        }
                                      },
                                      validator: (value) => value == null ? 'Please select a Complaint Type' : null,
                                      showSearchBox: addComplaintController.complaintTypeList.length > 4 ? true : false,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomDropdown<ComplaintSubTypeDatum>(
                                      enabled: widget.isCloseTicket || widget.isUpdateTicket ? false : true,
                                      // prefixImage AppImages.complaintSubType,
                                      hintText: 'Ticket Sub Type*',
                                      items: addComplaintController.complaintSubTypeList,
                                      selectedItem: addComplaintController.selectedComplaintSubType.value,
                                      itemAsString: (ComplaintSubTypeDatum complaintSubTypeDatum) => complaintSubTypeDatum.codeDesc,
                                      onChanged: (ComplaintSubTypeDatum? complaintSubTypeDatum) {
                                        if (complaintSubTypeDatum != null) {
                                          addComplaintController.complaintSubType.value = complaintSubTypeDatum.codeDesc;
                                          addComplaintController.selectedComplaintSubType.value = complaintSubTypeDatum;
                                          addComplaintController.complaintSubType.refresh();
                                          addComplaintController.selectedComplaintSubType.refresh();
                                        }
                                      },
                                      validator: (value) => value == null ? 'Please select a Complaint Sub Type' : null,
                                      showSearchBox: addComplaintController.complaintSubTypeList.length > 4 ? true : false,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomDropdown<LeadSource>(
                                      enabled: widget.isCloseTicket || widget.isUpdateTicket ? false : true,
                                      // prefixImage AppImages.priority,
                                      hintText: 'Ticket Priority*',
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
                                      validator: (value) => value == null ? 'Please select a Complaint Priority' : null,
                                      showSearchBox: addComplaintController.priorityList.length > 4 ? true : false,
                                    ),
                                  ],
                                ),
                                commonTextField(
                                    enable: widget.isUpdateTicket || widget.isCloseTicket ? false : true,
                                    // prefixImage AppImages.description,
                                    needValidation: true,
                                    validationMessage: "Description*",
                                    enabledBorder: AppColors.black,
                                    labelText: "Description*",
                                    controller: addComplaintController.descriptionController.value,
                                    textInputType: TextInputType.streetAddress,
                                    horizontalPadding: null,
                                    textColor: AppColors.black),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                          Obx(() {
                                            if (addComplaintController.emailIdList.isNotEmpty) {
                                              return Wrap(
                                                spacing: 8.0,
                                                runSpacing: 4.0,
                                                children: addComplaintController.emailIdList.map((email) {
                                                  debugPrint("email IDS === ${addComplaintController.emailIdList}");
                                                  return Chip(
                                                    label: Text(email, style: const TextStyle(color: Colors.black)),
                                                    backgroundColor: Colors.grey[300],
                                                    deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                                                    onDeleted: () => addComplaintController.removeEmail(email),
                                                  );
                                                }).toList(),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
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
                                                // prefixImage AppImages.email,
                                                padding: 8.0,
                                                controller: addComplaintController.custEmailIDController.value,
                                                textInputType: TextInputType.emailAddress,
                                                labelText: 'Cust. Email ID separated by semicolon',
                                                onChange: (value) => addComplaintController.addEmail(value),
                                                errorText: addComplaintController.errorMessage.value.isNotEmpty ? addComplaintController.errorMessage.value : null,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // commonTextField(
                                //     enable: widget.isCloseTicket ? false : true,
                                //     prefixImage: AppImages.email,
                                //     needValidation: true,
                                //     validationMessage: "Cust. Email ID",
                                //     enabledBorder: AppColors.black,
                                //     labelText: "Cust. Email ID",
                                //     controller: addComplaintController.custEmailIDController.value,
                                //     textInputType: TextInputType.streetAddress,
                                //     horizontalPadding: null,
                                //     textColor: AppColors.black),
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
                                widget.isCloseTicket
                                    ? Column(
                                        children: [
                                          commonTextField(
                                              // prefixImage: AppImages.remark,
                                              needValidation: true,
                                              validationMessage: "Close Remarks",
                                              enabledBorder: AppColors.black,
                                              labelText: "Close Remarks",
                                              controller: addComplaintController.closeRemarksController.value,
                                              textInputType: TextInputType.streetAddress,
                                              horizontalPadding: null,
                                              textColor: AppColors.black),
                                          commonTextField(
                                            enable: false,
                                            // prefixImage: AppImages.date,
                                            needValidation: true,
                                            validationMessage: "Closure Date",
                                            enabledBorder: AppColors.black,
                                            labelText: "Closure Date",
                                            controller: addComplaintController.closerDateController.value,
                                            textInputType: TextInputType.phone,
                                            horizontalPadding: null,
                                            readOnly: true,
                                            textColor: AppColors.black,
                                            suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                                            onTap: () async {
                                              DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );
                                              if (picked != null) {
                                                addComplaintController.closerDateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                              }
                                            },
                                          ),
                                          commonTextField(
                                              enable: false,
                                              // prefixImage: AppImages.complaintId,
                                              needValidation: true,
                                              validationMessage: "Closed By",
                                              enabledBorder: AppColors.black,
                                              labelText: "Closed By",
                                              controller: addComplaintController.closeByController.value,
                                              textInputType: TextInputType.streetAddress,
                                              horizontalPadding: null,
                                              textColor: AppColors.black),
                                        ],
                                      )
                                    : const SizedBox(),
                                widget.isUpdateTicket
                                    ? Column(
                                        children: [
                                          commonTextField(
                                            enable: false,
                                            // prefixImage: AppImages.editedDate,
                                            needValidation: true,
                                            validationMessage: "Update Date",
                                            enabledBorder: AppColors.black,
                                            labelText: "Update Date",
                                            controller: addComplaintController.updateDateController.value,
                                            textInputType: TextInputType.phone,
                                            horizontalPadding: null,
                                            readOnly: true,
                                            textColor: AppColors.black,
                                            suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                                            onTap: () async {
                                              DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );
                                              if (picked != null) {
                                                addComplaintController.updateDateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                              }
                                            },
                                          ),
                                          commonTextField(
                                              // prefixImage: AppImages.remark,
                                              needValidation: true,
                                              validationMessage: "Update Remarks",
                                              enabledBorder: AppColors.black,
                                              labelText: "Update Remarks",
                                              controller: addComplaintController.updateRemarksController.value,
                                              textInputType: TextInputType.streetAddress,
                                              horizontalPadding: null,
                                              textColor: AppColors.black),
                                        ],
                                      )
                                    : const SizedBox(),
                                // widget.isCloseTicket || widget.isUpdateTicket
                                //     ? commonTextField(
                                //         prefixImage: AppImages.remark,
                                //         needValidation: widget.isUpdateTicket ? true : false,
                                //         validationMessage: "Remarks",
                                //         enabledBorder: AppColors.black,
                                //         labelText: "Remarks",
                                //         controller: addComplaintController.remarksController.value,
                                //         textInputType: TextInputType.streetAddress,
                                //         horizontalPadding: null,
                                //         textColor: AppColors.black)
                                //     : const SizedBox(),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  addComplaintController.isGetData.isTrue
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (addComplaintController.selectedAssign.value == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please Select Assigned To",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 15.0);
                                    } else {
                                      if (widget.isCloseTicket) {
                                        addComplaintController.addTicket(loading: true);
                                      } else if (widget.isUpdateTicket) {
                                        addComplaintController.addTicket(loading: true, isUpdate: true, complaintId: addComplaintController.complaintIDController.value.text);
                                      } else {
                                        addComplaintController.addTicket(
                                          loading: true,
                                          isAdd: true,
                                        );
                                      }
                                    }
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
                                    : Text(
                                        widget.isCloseTicket
                                            ? "Close"
                                            : widget.isUpdateTicket
                                                ? "Update"
                                                : "Add",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
