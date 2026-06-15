import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/my_call/view_expense/call_view_controller.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';

class CallViewScreen extends StatefulWidget {
  final String callId;

  const CallViewScreen({super.key, required this.callId});

  @override
  State<CallViewScreen> createState() => _CallViewScreenState();
}

class _CallViewScreenState extends State<CallViewScreen> {
  CallViewController callViewController = Get.find<CallViewController>();

  @override
  void initState() {
    callViewController.getCallViewData(id: widget.callId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Call View",
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
      body: Obx(() => callViewController.isLoading.value
          ? Center(
              child: loader(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildCard("Call Category", callViewController.callViewData.value.callCategoryName,AppImages.callCategory),
                        _buildCard("Call Date", callViewController.callViewData.value.callDate,AppImages.date),
                        _buildCard("Call Purpose", callViewController.callViewData.value.purpose,AppImages.callPurpose),
                        _buildCard("Start Time", callViewController.callViewData.value.startTime,AppImages.time),
                        _buildCard("End Time", callViewController.callViewData.value.endTime,AppImages.time),
                        _buildCard("Customer Name", callViewController.callViewData.value.customerName,AppImages.companyName),
                        _buildCard("Call Status", callViewController.callViewData.value.callStatus,AppImages.callStatus),
                        _buildCard("Call Created By", callViewController.callViewData.value.createdBy,AppImages.createdBy),
                        _buildCard("Call Created Date", formatDate(callViewController.callViewData.value.createdDate),AppImages.date),
                        _buildCard("Call Edit By", callViewController.callViewData.value.modifiedBy,AppImages.expenseEditedBy),
                        _buildCard("Call Edit Date", formatDate(callViewController.callViewData.value.modifiedDate),AppImages.editedDate),
                        _buildCard("Remarks", callViewController.callViewData.value.remarks,AppImages.remark),
                      ],
                    )),
              ),
            )),
    );
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) {
      return "-";
    }
    DateTime parsedDate = DateTime.parse(dateString).toLocal();
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  Widget _buildCard(String name, String desc,String image,) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  scale: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyle.regular.copyWith(fontSize: 14,color: AppColors.grey)),
                      Text(
                        desc.isEmpty ? '-' : desc,
                        style: AppTextStyle.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.grey,
        )
      ],
    );
  }
}
