import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/myTask/view_task/view_task_controller.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';

class ViewTaskScreen extends StatefulWidget {
  final String taskId;
  final String? taskName;

  const ViewTaskScreen({super.key, required this.taskId, this.taskName});

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  ViewTaskController viewTaskController = Get.find<ViewTaskController>();

  @override
  void initState() {
    viewTaskController.getTaskData(id: widget.taskId);
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
          widget.taskName!.capitalizeFirst!,
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
      body: Obx(() => viewTaskController.isLoading.value
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
                        // _buildCard("Lead Category", viewTaskController.taskDetail.value.taskId,AppImages.leadCategory),
                        _buildCard("Task Name", viewTaskController.taskDetail.value.taskName,AppImages.taskName),
                        _buildCard("Task Desc.", viewTaskController.taskDetail.value.taskDescription,AppImages.taskDescription),
                        _buildCard("Task Date", viewTaskController.taskDetail.value.taskDate,AppImages.date),
                        _buildCard("Priority", viewTaskController.taskDetail.value.priority,AppImages.priority),
                        _buildCard("Lead Category Name", viewTaskController.taskDetail.value.leadCategoryName,AppImages.companyName),
                        _buildCard("Customer Name", viewTaskController.taskDetail.value.customerName,AppImages.companyName),
                        _buildCard("Start Time", viewTaskController.taskDetail.value.startTime,AppImages.time),
                        _buildCard("End Time", viewTaskController.taskDetail.value.endTime,AppImages.time),
                        _buildCard("Task Status", viewTaskController.taskDetail.value.taskStatus,AppImages.taskStatus),
                      ],
                    )),
              ),
            )),
    );
  }

  Widget _buildCard(String name, String desc,String image,) {
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
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyle.regular.copyWith(fontSize: 14,color: AppColors.grey)),
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
          color:AppColors.grey,
        )
      ],
    );
  }}
