import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/expance/view_expense/view_expense_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';

class ViewExpenseScreen extends StatefulWidget {
  final String expenseId;

  const ViewExpenseScreen({super.key, required this.expenseId});

  @override
  State<ViewExpenseScreen> createState() => _ViewExpenseScreenState();
}

class _ViewExpenseScreenState extends State<ViewExpenseScreen> {
  ViewExpenseController viewExpenseController = Get.find<ViewExpenseController>();

  @override
  void initState() {
    viewExpenseController.getExpenseViewData(id: widget.expenseId);
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
          "Expense",
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
        actions: [],
      ),
      body: Obx(() => viewExpenseController.isLoading.value
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
                        _buildCard("Expense Code", viewExpenseController.expenseDetail.value.expenseId,AppImages.expenseCode),
                        _buildCard("Customer Name", viewExpenseController.expenseDetail.value.companyName,AppImages.customerName),
                        _buildCard("Request ID", viewExpenseController.expenseDetail.value.requestId,AppImages.requestId),
                        _buildCard("Meeting Date", viewExpenseController.expenseDetail.value.expenseDate,AppImages.meetingTime),
                        _buildCard("Req. ID Date", viewExpenseController.expenseDetail.value.requestDate.isEmpty ?"":DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(viewExpenseController.expenseDetail.value.requestDate)),AppImages.date),
                        _buildCard("RTGS No.","",AppImages.rtgsNo),
                        _buildCard("Expense Date", viewExpenseController.expenseDetail.value.expenseDate,AppImages.expenseDate),
                        _buildCard("Transport Mode", viewExpenseController.expenseDetail.value.transportMode,AppImages.transportMode),
                        _buildCard("Checked Out Location", viewExpenseController.expenseDetail.value.checkedInLocation,AppImages.checkInMeeting),
                        _buildCard("Checked In Location", viewExpenseController.expenseDetail.value.checkedInLocation,AppImages.checkInMeeting),
                        _buildCard("Distance In Km", viewExpenseController.expenseDetail.value.distanceTravelled.toString(),AppImages.km),
                        _buildCard("Amount", viewExpenseController.expenseDetail.value.amount.toString(),AppImages.amount),
                        _buildCard("Supporting Document", viewExpenseController.expenseDetail.value.supportingDocument,AppImages.supportingDocument),
                        _buildCard("Remarks", viewExpenseController.expenseDetail.value.remarks,AppImages.remark),
                        _buildCard("Expense Added By", viewExpenseController.expenseDetail.value.expenseAddedBy,AppImages.expenseAddBy),
                        _buildCard("Expense Added Date & Time", viewExpenseController.expenseDetail.value.expenseAddedDate,AppImages.addDate),
                        _buildCard("Expense Edited By", viewExpenseController.expenseDetail.value.expenseEditedBy,AppImages.expenseEditedBy),
                        _buildCard("Expense Edited Date", viewExpenseController.expenseDetail.value.expensEditDate,AppImages.editedDate),
                        _buildCard("Approved By Manager", viewExpenseController.expenseDetail.value.approveByManagerName,AppImages.approvedByManager),
                        _buildCard("Manager Approved Date", viewExpenseController.expenseDetail.value.approvedManagerDate,AppImages.managerApprovedDate),
                        _buildCard("Approved By Auditor", viewExpenseController.expenseDetail.value.approvedByAuditorName,AppImages.approvedByAuditor),
                        _buildCard("Auditor Approved Date", viewExpenseController.expenseDetail.value.approvedByAuditDate,AppImages.approveDate),
                        _buildCard("Auditor Remarks", viewExpenseController.expenseDetail.value.auditRemark,AppImages.remark),
                        _buildCard("Manager Remarks", viewExpenseController.expenseDetail.value.managerRemark,AppImages.remark),
                        _buildCard("Status", viewExpenseController.expenseDetail.value.status,AppImages.expenseStatus),
                      ],
                    )),
              ),
            )),
    );
  }

  Widget _buildCard(
    String name,
    String desc,
    String image,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey)),
                    Text(
                      desc.isEmpty ? "-" : desc,
                      style: AppTextStyle.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                    ),
                  ],
                )),
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
