import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/lead/view_lead/view_lead_controller.dart';
import 'package:scorpforce/modules/widget/loader.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';

class ViewLeadScreen extends StatefulWidget {
  final String leadName;
  final String leadId;

  const ViewLeadScreen({super.key, required this.leadId, required this.leadName});

  @override
  State<ViewLeadScreen> createState() => _ViewLeadScreenState();
}

class _ViewLeadScreenState extends State<ViewLeadScreen> {
  ViewLeadController viewLeadController = Get.find<ViewLeadController>();

  @override
  void initState() {
    viewLeadController.getLeadData(id: widget.leadId);
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
        title: Text(
          widget.leadName,
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      body: Obx(() => viewLeadController.isLoading.value
          ? Center(
              child: loader(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildCard("Lead Category", viewLeadController.leadetail.value.leadCategory, AppImages.leadCategory),
                    _buildCard("Lead Date", viewLeadController.leadetail.value.leadDate, AppImages.date),
                    _buildCard("Customer Name", viewLeadController.leadetail.value.customerName, AppImages.companyName),
                    _buildCard("Contact Person", viewLeadController.leadetail.value.contactName, AppImages.contactName),
                    _buildCard("Contact Email", viewLeadController.leadetail.value.email, AppImages.email),
                    _buildCard("Contract No.", viewLeadController.leadetail.value.contactNo, AppImages.contactNo),
                    _buildCard("Active", viewLeadController.leadetail.value.isActive == true ? "Yes" : "No", viewLeadController.leadetail.value.isActive == true ? AppImages.check : AppImages.cross),
                    _buildCard("Designation", viewLeadController.leadetail.value.designation, AppImages.designation),
                    _buildCard("Assign To", viewLeadController.leadetail.value.assignedTo, AppImages.assignedTO),
                    _buildCard("Lead Source", viewLeadController.leadetail.value.leadSource, AppImages.leadSource),
                    _buildCard("City", viewLeadController.leadetail.value.city, AppImages.city),
                    _buildCard("Region", viewLeadController.leadetail.value.region, AppImages.region),
                    _buildCard("Industry Type", viewLeadController.leadetail.value.industryType, AppImages.industryType),
                    _buildCard("Services Interested", viewLeadController.leadetail.value.serviceInterestedNames, AppImages.servicesInterested),
                    _buildCard("Lead Created By", viewLeadController.leadetail.value.createdBy, AppImages.createdBy),
                    _buildCard("Lead Modified By", viewLeadController.leadetail.value.modifiedBy, AppImages.modifiedBy),
                    _buildCard("Branch Name", viewLeadController.leadetail.value.branch, AppImages.branchName),
                  ],
                ),
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
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Image.asset(
                  image,
                  scale: 15,
                ),*/
               /* Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.grey,
                    ),
                  ),
                ),*/
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
