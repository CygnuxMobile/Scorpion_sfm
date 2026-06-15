import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/myTask/task_screen/task_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_text_style.dart';
import '../../lead/add_lead/model/get_category_response_model.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../add_task/binding/add_task_binding.dart';
import '../add_task/controller/add_task_controller.dart';
import '../add_task/view/add_task_screen.dart';
import '../view_task/view_task_binding.dart';
import '../view_task/view_task_screen.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  TaskController taskController = Get.find<TaskController>();
  AddTaskController addTaskController = Get.find<AddTaskController>();
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (taskController.totalCount.value != taskController.taskData.length) {
        taskController.pageCount.value++;
        taskController.getTaskData(
          page: taskController.pageCount.value,
          leadCategory: taskController.leadCategory.value,
          taskDate: taskController.dateController.value,
        );
      }
    }
  }

  @override
  void dispose() {
    taskController.dispose();
    addTaskController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    () async {
      taskController.pageCount.value = 1;
      scrollController.addListener(_scrollListener);
      taskController.getTaskData(
        loading: true,
        page: taskController.pageCount.value,
        dataClear: true,
        leadCategory: taskController.leadCategory.value,
        taskDate: taskController.dateController.value,
      );

      await addTaskController.getCategory();
      await addTaskController.getUser();
      await addTaskController.getPriority();
      await addTaskController.getCustomer();
    }();
    // TODO: implement initState
    super.initState();
  }

  _bottomSheet(BuildContext context, TaskController? taskController, AddTaskController? addTaskController) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (_, setState) {
              return Container(
                height: 300,
                color: Colors.transparent, //could change this to Color(0xFF737373),
                //so you don't have to change MaterialApp canvasColor
                child: Obx(() {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  taskController!.pageCount.value = 1;
                                  taskController.dateController.value = null;
                                  taskController.leadCategory.value = null;
                                  taskController.selectedCategory.value = null;
                                  taskController.getTaskData(
                                    loading: true,
                                    page: taskController.pageCount.value,
                                    taskDate: taskController.dateController.value,
                                    leadCategory: taskController.leadCategory.value,
                                    dataClear: true,
                                  );
                                },
                                child: const Text("Clear filter")),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return Row(
                                  children: [
                                    CustomDropdown<Categories>(
                                      hintText: 'Lead Category',
                                      onClearTap: () {
                                        taskController.leadCategory.value = null;
                                        taskController.selectedCategory.value = null;
                                        taskController.pageCount.value = 1;
                                        /* leadController.getLeadData(
                                            loading: true,
                                            page: leadController.pageCount.value,
                                            meetingDate: leadController.dateController.value ?? "",
                                            leadCategory: leadController.leadCategory.value,
                                            dataClear: true);*/
                                      },
                                      items: addTaskController!.categoryList,
                                      selectedItem: taskController!.selectedCategory.value,
                                      itemAsString: (Categories category) => category.codeDesc,
                                      // Display the user's name
                                      onChanged: (Categories? category) {
                                        if (category != null) {
                                          taskController.leadCategory.value = category.codeDesc;
                                          taskController.selectedCategory.value = category;
                                        }
                                      },

                                      showSearchBox: addTaskController.categoryList.length > 4 ? true : false,
                                    ),
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              taskController.dateController.value = DateFormat('dd/MM/yyyy').format(picked);
                              taskController.pageCount.value = 1;
                              // leadController.getLeadData(
                              //   page: leadController.pageCount.value,
                              //   meetingDate: leadController.dateController.value,
                              //   leadCategory: leadController.leadCategory.value,
                              //   dataClear: true,
                              // );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      taskController!.dateController.value != null ? taskController.dateController.value.toString() : "Select Date",
                                      style: AppTextStyle.regular.copyWith(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    if (taskController.dateController.value != null)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 23.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              taskController.dateController.value = null;
                                              setState(
                                                () {},
                                              );
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )),
                                      ),
                                    const Icon(Icons.calendar_month)
                                  ],
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                          onPressed: () {
                            taskController.pageCount.value = 1;
                            taskController.getTaskData(
                                loading: true, page: taskController.pageCount.value, taskDate: taskController.dateController.value, leadCategory: taskController.leadCategory.value, dataClear: true);
                            Future.delayed(const Duration(milliseconds: 500), () {
                              Get.back();
                            });
                          },
                          child: const Text("Apply Filter"))
                    ],
                  );
                }),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'My Task',
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
        actions: [
          GestureDetector(
              onTap: () {
                _bottomSheet(context, taskController, addTaskController);
              },
              child: Image.asset(
                AppImages.filter,
                scale: 22,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
                onTap: () {
                  addTaskController.clear(a: addTaskController.controller.value);
                  Get.toNamed(AppRoutes.addTask, arguments: [false])!.whenComplete(() {
                    taskController.taskData.clear();
                    taskController.pageCount.value = 1;
                    taskController.getTaskData(
                      loading: true,
                      page: taskController.pageCount.value,
                      dataClear: true,
                      leadCategory: taskController.leadCategory.value,
                      taskDate: taskController.dateController.value,
                    );
                  });
                },
                child: Image.asset(
                  AppImages.plus,
                  scale: 25,
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return taskController.taskData.isNotEmpty
                ? ListView.separated(
                    controller: scrollController,
                    itemCount: taskController.taskData.length + 1,
                    itemBuilder: (context, index) {
                      var data = index != taskController.taskData.length ? taskController.taskData[index] : null;
                      if (index < taskController.taskData.length) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow("Lead Category : ", data!.leadCategoryName, Colors.black87),
                                    const SizedBox(height: 10),
                                    _buildInfoRow("Task Date : ", data.taskDate, Colors.black87),
                                    const SizedBox(height: 10),
                                    _buildInfoRow("Customer : ", data.customerName, Colors.black87),
                                    const SizedBox(height: 10),
                                    _buildInfoRow("Start Time : ", data.startTime, Colors.black87),
                                    const SizedBox(height: 10),
                                    _buildInfoRow("End Time : ", data.endTime, Colors.black87),
                                    const SizedBox(height: 10),
                                    _buildInfoRow("Task status : ", data.taskStatus, Colors.black87),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      color: AppColors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            addTaskController.clear(a: addTaskController.controller.value);
                                            Get.to(
                                              () => AddTaskScreen(
                                                id: data.taskId,
                                                isEdit: true,
                                              ),
                                              binding: AddTaskBinding(),
                                            )?.whenComplete(() async {
                                              taskController.taskData.clear();
                                              taskController.pageCount.value = 1;
                                              taskController.getTaskData(
                                                loading: true,
                                                page: taskController.pageCount.value,
                                                dataClear: true,
                                                leadCategory: taskController.leadCategory.value,
                                                taskDate: taskController.dateController.value,
                                              );
                                            });
                                          },
                                          child: Image.asset(
                                            AppImages.edit,
                                            scale: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => ViewTaskScreen(
                                                      taskId: data.taskId,
                                                      taskName: data.customerName,
                                                    ),
                                                binding: ViewTaskBinding());
                                          },
                                          child: Image.asset(
                                            AppImages.eye,
                                            scale: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (taskController.totalCount.value != taskController.taskData.length) {
                        return Center(
                          child: Container(height: 70, alignment: Alignment.center, child: loader()),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  )
                : taskController.taskData.isEmpty && taskController.isLoading.value == false
                    ? Center(
                        child: Image.asset(
                          AppImages.noDataFound,
                          scale: 6,
                        ),
                      )
                    : Center(
                        child: loader(),
                      );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class Data1 {
  final String customerName;
  final String customerId;
  final String contactPerson;
  final String email;
  final String mobile;
  final String address;

  Data1({
    required this.customerName,
    required this.customerId,
    required this.contactPerson,
    required this.email,
    required this.mobile,
    required this.address,
  });
}
