import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/expance/add_expense_screen/get_transportmode_responce_model.dart';
import 'package:scorpforce/modules/meeting_mom/meeting_mom_controller.dart';
import 'package:scorpforce/modules/my_call/add_my_call_screen/call_module_response_model.dart';
import 'package:scorpforce/modules/widget/button_view.dart';
import 'package:scorpforce/modules/widget/toast_message.dart';

import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../config/app_text_style.dart';
import '../widget/TextField.dart';
import '../widget/dropdown.dart';
import 'model/meeting_mom_response.dart';

class MeetingMomScreen extends StatefulWidget {
  const MeetingMomScreen({super.key});

  @override
  State<MeetingMomScreen> createState() => _MeetingMomScreenState();
}

class _MeetingMomScreenState extends State<MeetingMomScreen> {
  final MeetingMomController meetingMomController = Get.put(MeetingMomController());

  @override
  void initState() {
    super.initState();
    getData();

  }
  Future<void> getData() async{
    meetingMomController.getTransportMode();
    meetingMomController.getOtherExpensesList();
    meetingMomController.getMomList();
    await meetingMomController.meetingMomApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meeting MOM",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (meetingMomController.isLoading.value ) {
          return const Center(child: CircularProgressIndicator());
        }

        if (meetingMomController.isLoading.value == false && meetingMomController.momList.value == null) {
          return const Center(child: Text("No MOM list found"));
        }

        if (meetingMomController.isLoading.value == false && meetingMomController.meetingMomList.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        return ListView.builder(
          itemCount: meetingMomController.meetingMomList.length,
          itemBuilder: (context, index) {
            final item = meetingMomController.meetingMomList[index];

            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Column(
                  children: [
                    _buildInfoRow("Meeting Id : ", item.meetingId, Colors.black87),
                    _buildInfoRow("Customer Name : ", item.custnm, Colors.black87),
                    _buildInfoRow("Check In : ", item.checkIn, Colors.black87),
                    _buildInfoRow("Check Out : ", item.checkOut, Colors.black87),
                    _buildInfoRow("Created By : ", item.createdBy, Colors.black87),
                    _buildInfoRow("Meeting Date : ", item.meetingDate, Colors.black87),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: MultiDropdown(
                            closeOnBackButton: false,
                            items: meetingMomController.momList.value!.map((e) {
                              return DropdownItem(label: e.moM!, value: e);
                            }).toList(),
                            controller: item.controller,
                            searchEnabled: true,
                            fieldDecoration: FieldDecoration(
                              animateSuffixIcon: true,
                              hintText: 'Add MOM*',
                              labelText: "Add MOM*",
                              hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                              labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                              showClearIcon: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                              ),
                            ),
                            chipDecoration: const ChipDecoration(backgroundColor: AppColors.grey, wrap: false, runSpacing: 5, spacing: 5),
                            dropdownDecoration: const DropdownDecoration(
                              marginTop: 6,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Select MOM from the list',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              backgroundColor: AppColors.green100,
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                              disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                            ),
                            onSelectionChange: (selectedItems) {
                              item.selectedMOM.value = selectedItems;
                              meetingMomController.meetingMomList.refresh();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Obx(() {
                              return CustomDropdown<TransportMode>(
                                enabled: true,
                                hintText: 'Transport Mode*',
                                items: meetingMomController.transportModeList,
                                selectedItem: item.selectedTransportMode.value,
                                itemAsString: (TransportMode data) => data.codeDesc,
                                onChanged: (TransportMode? data) {
                                  if (data != null) {
                                    item.selectedTransportMode.value = data;
                                    item.transportId.value = data.codeId;
                                    meetingMomController.meetingMomList.refresh();
                                  }
                                },
                                validator: (value) => value == null ? 'Please select Transport Mode' : null,
                                showSearchBox: true,
                              );
                            }),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(() {
                              return CustomDropdown<CallType>(
                                enabled: true,
                                hintText: 'Other Expenses',
                                items: meetingMomController.otherExpensesList,
                                selectedItem: item.selectedOtherExpense.value,
                                itemAsString: (CallType data) => data.codeDesc,
                                onChanged: (CallType? data) {
                                  if (data != null) {
                                    item.selectedOtherExpense.value = data;
                                    item.otherExpenseId.value = data.codeId;
                                    meetingMomController.meetingMomList.refresh();
                                  }
                                },
                                showSearchBox: true,
                              );
                            }),
                          ],
                        ),
                        Obx(() {
                          final selectedExp = item.selectedOtherExpense.value;
                          if (selectedExp == null) return const SizedBox();

                          final descLower = selectedExp.codeDesc.toLowerCase();
                          final isToll = descLower.contains("toll");
                          final isFood = descLower.contains("food");

                          String amountLabel = isToll
                              ? "Toll Amount"
                              : (isFood ? "Foody Expenses" : "${selectedExp.codeDesc} Amount");
                          String uploadLabel = isToll
                              ? "Upload Toll Slip"
                              : (isFood ? "Bill upload" : "Upload Supporting Document");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonTextField(
                                needValidation: true,
                                validationMessage: "Please Enter Amount",
                                enabledBorder: AppColors.black,
                                labelText: amountLabel,
                                controller: item.expenseAmountController.value,
                                textInputType: TextInputType.number,
                                horizontalPadding: null,
                                textColor: AppColors.black,
                                onChange: (v) {
                                  meetingMomController.meetingMomList.refresh();
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        ImagePicker picker = ImagePicker();
                                        XFile? file = await picker.pickImage(source: ImageSource.gallery);
                                        if (file != null) {
                                          item.expenseDocumentFile.value = File(file.path);
                                          meetingMomController.meetingMomList.refresh();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.boderColor, width: 1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 28,
                                              color: AppColors.grey,
                                            ),
                                            const SizedBox(height: 5),
                                            Obx(() => Text(
                                              "${item.expenseDocumentFile.value != null ? "Change " : "Add "}$uploadLabel",
                                              style: const TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    return item.expenseDocumentFile.value != null
                                        ? Row(
                                            children: [
                                              const SizedBox(width: 12),
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: AppColors.boderColor),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(11),
                                                      child: Image.file(
                                                        File(item.expenseDocumentFile.value!.path),
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const Center(
                                                            child: Icon(Icons.insert_drive_file, size: 40, color: AppColors.grey),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 4,
                                                      right: 4,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          item.expenseDocumentFile.value = null;
                                                          meetingMomController.meetingMomList.refresh();
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.all(4),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.red,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox();
                                  }),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    commonTextField(
                      needValidation:true,
                      validationMessage: "Remarks",
                      enabledBorder: AppColors.black,
                      labelText: "Remarks",
                      controller: item.remarksController.value,
                      textInputType: TextInputType.streetAddress,
                      horizontalPadding: null,
                      textColor: AppColors.black,
                      onChange: (v){
                        meetingMomController.meetingMomList.refresh();
                      }
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if(item.controller.selectedItems.isNotEmpty)
                    commonButton(name: "Submit", bgColor: AppColors.primaryColor, onTap: () async {
                      if (item.isLoading.value) return;
                      if(item.remarksController.value.text.isEmpty){
                        toastMessage(text: "Please enter remarks", color: AppColors.redColor);
                      }else if(item.controller.selectedItems.isEmpty){
                        toastMessage(text: "Please select MOM", color: AppColors.redColor);
                      }else if(item.selectedTransportMode.value == null){
                        toastMessage(text: "Please select Transport Mode", color: AppColors.redColor);
                      }else if(item.selectedOtherExpense.value != null && item.expenseAmountController.value.text.trim().isEmpty){
                        toastMessage(text: "Please enter expense amount", color: AppColors.redColor);
                      }else if(item.selectedOtherExpense.value != null && item.expenseDocumentFile.value == null){
                        toastMessage(text: "Supporting document / slip upload is mandatory", color: AppColors.redColor);
                      }else{
                        item.isLoading.value = true;
                        meetingMomController.meetingMomList.refresh();
                        await meetingMomController.submitMeetingMom(
                          meetingId: item.meetingId,
                          meetingMom: item.selectedMOM.map((e) => e.moM).toList().join(","),
                          attendeeCode: item.attendeeCode,
                          remarks: item.remarksController.value.text,
                          transportMode: item.transportId.value ?? "",
                          otherExpenses: item.otherExpenseId.value ?? "",
                          otherExpenseAmt: item.expenseAmountController.value.text,
                          documentFile: item.expenseDocumentFile.value,
                        );
                        item.isLoading.value = false;
                        meetingMomController.meetingMomList.refresh();
                      }

                    }, width: 100, isLoader: item.isLoading.value, loaderColorWhite: true)
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
