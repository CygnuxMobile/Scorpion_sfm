import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/meeting_mom/meeting_mom_controller.dart';
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
                            closeOnBackButton: true,
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
                      }else{
                        var data = {
                          "meetingId": item.meetingId,
                          "meetingMOM": item.selectedMOM.map((e)=>e.moM).toList().join(","),
                          "remarks": item.remarksController.value.text
                        };
                        // debugPrint("data === $data");
                        item.isLoading.value = true;
                        meetingMomController.meetingMomList.refresh();
                        // await Future.delayed(Duration(seconds: 5));
                        await meetingMomController.submitMeetingMom(data);
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
