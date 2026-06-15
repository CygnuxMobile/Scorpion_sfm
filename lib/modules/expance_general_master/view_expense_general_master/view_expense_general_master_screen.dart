import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';

class ViewExpenseGeneralMasterScreen extends StatelessWidget {
  const ViewExpenseGeneralMasterScreen({
    super.key,
    required this.designation,
    required this.ratePerKm,
    required this.transportMode,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
  });

  final String designation;
  final String ratePerKm;
  final String transportMode;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  AppColors.primaryColor,
        title: const Text(
          "Expense Detail",
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildCard("Designation", designation,AppImages.km),
                _buildCard("Transport Mode", transportMode,AppImages.transportMode),
                _buildCard("Rate Per KM", ratePerKm,AppImages.km),
                _buildCard("Expense Added By", createdBy,AppImages.username),
                _buildCard("Expense Added By Date", convertDateFormat(createdDate),AppImages.date),
                _buildCard("Expense Edited By", modifiedBy,AppImages.username),
                _buildCard("Expense Edited By Date", convertDateFormat(modifiedDate),AppImages.date),
              ],
            ),
          ),
        ),
      ),
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
                      Text(name, style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey)),
                      Text(
                        desc.isEmpty?"-":desc,
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

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime dateTime = inputFormat.parse(inputDate);

    DateFormat outputFormat = DateFormat("dd/MM/yyyy");
    return outputFormat.format(dateTime);
  }

}
