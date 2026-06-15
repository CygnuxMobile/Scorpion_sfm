import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/add_expense_controller.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_expense_generalMaster_response_model.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_text_style.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool isEdit;
  final bool showButton;
  final bool isExpenseApproval;
  final String? id;
  final String? meetingId;
  final String? attendeeCode;

  const AddExpenseScreen({
    super.key,
    this.isEdit = false,
    this.showButton = false,
    this.id,
    this.meetingId,
    this.attendeeCode,
    this.isExpenseApproval = false,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  AddExpenseController addExpenseController = Get.find<AddExpenseController>();

  @override
  void initState() {
    addExpenseController.editExpense(
        loading: true,
        id: widget.isExpenseApproval ? widget.id : widget.attendeeCode,
        isEdit: widget.isEdit,
        isExpenseApproval: widget.isExpenseApproval);
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
          widget.isEdit
              ? "Update Expense"
              : widget.isExpenseApproval
                  ? "Expense Approval"
                  : 'Add Expense',
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
                  widget.isEdit || widget.isExpenseApproval
                      ? commonTextField(
                          enable: false,
                          prefixImage: AppImages.expenseCode,
                          needValidation: true,
                          validationMessage: "Expense Code",
                          enabledBorder: AppColors.black,
                          labelText: "Expense Code",
                          controller: addExpenseController.expenseCodeController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black)
                      : const SizedBox(),
                  commonTextField(
                      enable: false,
                      prefixImage: AppImages.customerName,
                      needValidation: false,
                      validationMessage: "Customer Name",
                      enabledBorder: AppColors.black,
                      labelText: "Customer Name",
                      controller: addExpenseController.customerNameController.value,
                      textInputType: TextInputType.streetAddress,
                      horizontalPadding: null,
                      textColor: AppColors.black),

                  widget.isExpenseApproval
                      ? commonTextField(
                          enable: false,
                          prefixImage: AppImages.addDate,
                          needValidation: false,
                          validationMessage: "Req. ID /Date & Time",
                          enabledBorder: AppColors.black,
                          labelText: "Req. ID /Date & Time",
                          controller: addExpenseController.reqIDDateTimeController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black)
                      : const SizedBox(),

                  commonTextField(
                    enable: false,
                    prefixImage: AppImages.date,
                    needValidation: true,
                    validationMessage: "Meeting Date ",
                    enabledBorder: AppColors.black,
                    labelText: "Meeting Date*",
                    controller: addExpenseController.meetingDateController.value,
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
                        addExpenseController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                  ),
                  commonTextField(
                    enable: false,
                    prefixImage: AppImages.date,
                    needValidation: true,
                    validationMessage: "Expense Date ",
                    enabledBorder: AppColors.black,
                    labelText: "Expense Date*",
                    controller: addExpenseController.dateController.value,
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
                        addExpenseController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                  ),
                  // commonTextField(
                  //     prefixImage: AppImages.checkInMeeting,
                  //     needValidation: true,
                  //     validationMessage: "Punch In Location*",
                  //     enabledBorder: AppColors.black,
                  //     labelText: "Punch In Location*",
                  //     controller: addExpenseController.punchInLocationController.value,
                  //     textInputType: TextInputType.streetAddress,
                  //     horizontalPadding: null,
                  //     textColor: AppColors.black),
                  // const SizedBox(height: 16),
                  Column(
                    children: [
                      commonTextField(
                          enable: false,
                          prefixImage: AppImages.checkInMeeting,
                          needValidation: true,
                          validationMessage: "Checked Out Location",
                          enabledBorder: AppColors.black,
                          labelText: "Checked Out Location",
                          controller: addExpenseController.checkedOutLocationController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      commonTextField(
                          enable: false,
                          prefixImage: AppImages.checkInMeeting,
                          needValidation: true,
                          validationMessage: "Checked In Location",
                          enabledBorder: AppColors.black,
                          labelText: "Checked In Location",
                          controller: addExpenseController.checkedInLocationController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      Row(
                        children: [
                          Obx(() {
                            return CustomDropdown<TransportMode>(
                              enabled: widget.isExpenseApproval ? false : true,
                              prefixImage: AppImages.transportMode,
                              hintText: 'Transport Mode*',
                              items: addExpenseController.transportModeList,
                              itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                              selectedItem: addExpenseController.selectedTransportMode.value,
                              onChanged: (TransportMode? transportMode) {
                                if (transportMode != null) {
                                  debugPrint("this this");
                                  addExpenseController.transportId.value = transportMode.codeId;
                                  addExpenseController.selectedTransportMode.value = transportMode;
                                  addExpenseController.transportId.refresh();
                                  addExpenseController.selectedTransportMode.refresh();

                                  GetExpenseGeneralMasterDatum? matchingExpense =
                                      addExpenseController.getExpenseGeneralMasterData.firstWhere(
                                    (element) {
                                      return element.transportModeId == int.parse(transportMode.codeId) &&
                                          element.designationId == int.parse(Pref.getDesignationId().toString());
                                    },
                                    orElse: () {
                                      return GetExpenseGeneralMasterDatum(
                                          id: 0,
                                          designationId: -1,
                                          designation: "designation",
                                          transportModeId: -1,
                                          transportMode: "transportMode",
                                          ratePerKm: 0,
                                          createdBy: "createdBy",
                                          createdDate: "createdDate",
                                          modifiedBy: "modifiedBy",
                                          modifiedDate: "modifiedDate",
                                          isActive: false,
                                          totalCount: 0);
                                    }, // Use a default object
                                  );
                                  addExpenseController.expRateController.value.text =
                                      matchingExpense.ratePerKm.toInt().toString();
                                  debugPrint("${addExpenseController.expRateController.value.text}");
                                  debugPrint(matchingExpense.ratePerKm.toInt().toString());
                                  addExpenseController.amountController.value
                                      .text = ((double.tryParse(addExpenseController.expRateController.value.text) ??
                                              0) *
                                          (double.tryParse(addExpenseController.distanceInKmController.value.text) ??
                                              0))
                                      .toInt()
                                      .toString();
                                }
                              },
                              validator: (value) => value == null ? 'Please select a Transport Mode' : null,
                              showSearchBox: true,
                            );
                          }),
                        ],
                      ),
                      commonTextField(
                          enable: false,
                          prefixImage: AppImages.km,
                          needValidation: true,
                          validationMessage: "Distance In Km",
                          enabledBorder: AppColors.black,
                          labelText: "Distance In Km",
                          controller: addExpenseController.distanceInKmController.value,
                          textInputType: TextInputType.number,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      commonTextField(
                          enable: false,
                          prefixImage: AppImages.amount,
                          needValidation: true,
                          validationMessage: "Exp. Rate",
                          enabledBorder: AppColors.black,
                          labelText: "Exp. Rate",
                          controller: addExpenseController.expRateController.value,
                          textInputType: TextInputType.number,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      widget.isEdit == false || widget.isExpenseApproval == false
                          ? Pref.getDesignationId().toString() == ""
                              ? const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Text(
                                  "You do not have a designation. Please contact the admin.",
                                    // "Your designation is not attached please contact administrator",
                                    style: TextStyle(color: AppColors.redColor),
                                  ),
                              )
                              : const SizedBox()
                          : const SizedBox(),

                      commonTextField(
                          enable: false,
                          prefixImage: AppImages.amount,
                          needValidation: true,
                          validationMessage: "Amount",
                          enabledBorder: AppColors.black,
                          labelText: "Amount",
                          controller: addExpenseController.amountController.value,
                          textInputType: TextInputType.number,
                          horizontalPadding: null,
                          textColor: AppColors.black),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                if (!widget.isEdit) {
                                  ImagePicker image = ImagePicker();

                                  XFile? file = await image.pickImage(source: ImageSource.gallery);
                                  if (file != null) {
                                    addExpenseController.image.value = File(file.path);
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.boderColor, width: 1)),
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
                                      "${addExpenseController.image.value != null && addExpenseController.image.value!.path != "" ? "Change " : "Add "}Document",
                                      style: const TextStyle(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            return addExpenseController.image.value != null &&
                                    addExpenseController.image.value!.path != ""
                                ? Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    width: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(File(addExpenseController.image.value!.path))),
                                      ],
                                    ))
                                : addExpenseController.selectedImage.value != null
                                    ? Container(
                                        alignment: Alignment.center,
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          "https://uat-smfapi-scorpion.cygnux.in/${addExpenseController.selectedImage.value}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: AppColors.boderColor, width: 1)),
                                                child: const Icon(Icons.error, size: 30, color: Colors.red));
                                          },
                                        ),
                                      )
                                    : const SizedBox();
                          }),
                          const SizedBox(
                            width: 10,
                          ),
                          if (addExpenseController.image.value != null && addExpenseController.image.value!.path != "")
                            GestureDetector(
                              onTap: () {
                                addExpenseController.image.value = null;
                                addExpenseController.update();
                              },
                              child: Text(
                                "Remove",
                                style: AppTextStyle.regular.copyWith(color: AppColors.redColor),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),

                  commonTextField(
                      prefixImage: AppImages.remark,
                      needValidation: true,
                      validationMessage: "Remarks",
                      enabledBorder: AppColors.black,
                      labelText: "Remarks",
                      controller: addExpenseController.remarkController.value,
                      textInputType: TextInputType.streetAddress,
                      horizontalPadding: null,
                      textColor: AppColors.black),

                  widget.isExpenseApproval
                      ? widget.showButton
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: addExpenseController.isApproveLoading.value ||
                                            addExpenseController.isRejectLoading.value
                                        ? () {}
                                        : () async {
                                            showDialogs(isApprove: true, context: context);
                                            /* showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            title: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Approve?",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Form(
                                              key: formKey2,
                                              child: commonTextField(
                                                  prefixImage: AppImages.remark,
                                                  needValidation: true,
                                                  validationMessage: "Auditor/Manager Remarks",
                                                  enabledBorder: AppColors.black,
                                                  labelText: "Auditor/Manager Remarks",
                                                  controller: addExpenseController.auditorRemarksController.value,
                                                  textInputType: TextInputType.streetAddress,
                                                  horizontalPadding: null,
                                                  textColor: AppColors.black),
                                            ),
                                            actions: [
                                              Obx(() {
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    if (formKey2.currentState!.validate()) {
                                                      await addExpenseController.statesApproved(
                                                        expenseId: "${widget.id}",
                                                        loading: true,
                                                        isApproved: true,
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green,
                                                    minimumSize: const Size(110, 40),
                                                    maximumSize: const Size(110, 40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: addExpenseController.isApproveLoading.value
                                                      ? const Center(
                                                          child: CircularProgressIndicator(
                                                            color: AppColors.whiteColor,
                                                          ),
                                                        )
                                                      : const Text(
                                                          "Approve",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                );
                                              }),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  minimumSize: const Size(110, 40),
                                                  maximumSize: const Size(110, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    side: const BorderSide(color: Colors.green),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.green),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );*/
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Approve",
                                      style: AppTextStyle.regular.copyWith(fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: addExpenseController.isRejectLoading.value ||
                                            addExpenseController.isApproveLoading.value
                                        ? () {}
                                        : () async {
                                            showDialogs(isApprove: false, context: context);

                                            /*showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            title: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Reject?",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Form(
                                              key: formKey2,
                                              child: commonTextField(
                                                  prefixImage: AppImages.remark,
                                                  needValidation: true,
                                                  validationMessage: "Auditor/Manager Remarks",
                                                  enabledBorder: AppColors.black,
                                                  labelText: "Auditor/Manager Remarks",
                                                  controller: addExpenseController.auditorRemarksController.value,
                                                  textInputType: TextInputType.streetAddress,
                                                  horizontalPadding: null,
                                                  textColor: AppColors.black),
                                            ),
                                            actions: [
                                              Obx(() {
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    if (formKey2.currentState!.validate()) {
                                                      await addExpenseController.statesApproved(
                                                        expenseId: "${widget.id}",
                                                        loading: true,
                                                        isApproved: false,
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    minimumSize: const Size(110, 40),
                                                    maximumSize: const Size(110, 40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: addExpenseController.isRejectLoading.value
                                                      ? const Center(
                                                          child: CircularProgressIndicator(
                                                            color: AppColors.whiteColor,
                                                          ),
                                                        )
                                                      : const Text(
                                                          "Reject",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                );
                                              }),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  minimumSize: const Size(110, 40),
                                                  maximumSize: const Size(110, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    side: const BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );*/
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Reject",
                                      style: AppTextStyle.regular.copyWith(fontSize: 15, color: AppColors.whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              widget.isEdit == false || widget.isExpenseApproval == false
                                  ? Pref.getDesignationId().toString() == ""
                                  ?  const SizedBox():ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addExpenseController.addExpense(
                                      loading: true,
                                      isUpdate: widget.isEdit,
                                      id: widget.id,
                                      meetingID: widget.meetingId,
                                      attendeeCode: widget.attendeeCode,
                                      image: addExpenseController.image.value,
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
                                child: addExpenseController.isLoading.value
                                    ? loader()
                                    : Text(
                                  widget.isEdit ? "Update" : "Add",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ):const SizedBox(),

                              // ElevatedButton(
                              //   onPressed: () {
                              //     addExpenseController.isLoading.value = false;
                              //     addExpenseController.image.value = null;
                              //     addExpenseController.dateController.value.clear();
                              //     addExpenseController.punchInLocationController.value.clear();
                              //     addExpenseController.checkedInLocationController.value.clear();
                              //     addExpenseController.distanceInKmController.value.clear();
                              //     addExpenseController.amountController.value.clear();
                              //     addExpenseController.remarkController.value.clear();
                              //     addExpenseController.selectedTransportMode.value = null;
                              //   },
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
          );
        }),
      ),
    );
  }

  showDialogs({bool isApprove = false, BuildContext? context}) {
    return showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                isApprove ? "Approve?" : "Reject",
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey2,
          child: commonTextField(
              prefixImage: AppImages.remark,
              needValidation: true,
              validationMessage: "Auditor/Manager Remarks",
              enabledBorder: AppColors.black,
              labelText: "Auditor/Manager Remarks",
              controller: addExpenseController.auditorRemarksController.value,
              textInputType: TextInputType.streetAddress,
              horizontalPadding: null,
              textColor: AppColors.black),
        ),
        actions: [
          Obx(() {
            return ElevatedButton(
              onPressed: () async {
                if (formKey2.currentState!.validate()) {
                  await addExpenseController.statesApproved(
                    expenseId: "${widget.id}",
                    loading: true,
                    isApproved: isApprove,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApprove ? Colors.green : Colors.red,
                minimumSize: const Size(110, 40),
                maximumSize: const Size(110, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: (isApprove && addExpenseController.isApproveLoading.value) ||
                      (!isApprove && addExpenseController.isRejectLoading.value)
                  ? Center(
                      child: loader(),
                    )
                  : Text(
                      isApprove ? "Approve" : "Reject",
                      style: const TextStyle(color: Colors.white),
                    ),
            );
          }),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(110, 40),
              maximumSize: const Size(110, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isApprove ? Colors.green : Colors.red,
                ),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isApprove ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
