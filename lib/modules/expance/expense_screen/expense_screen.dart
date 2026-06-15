import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/expance/expense_screen/expense_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';
import '../add_expense_screen/add_expense_binding.dart';
import '../add_expense_screen/add_expense_controller.dart';
import '../add_expense_screen/add_expense_screen.dart';
import '../view_expense/view_expense_binding.dart';
import '../view_expense/view_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  var isExpense = Get.arguments;
  ExpenseController expenseController = Get.find<ExpenseController>();
  AddExpenseController addExpenseController = Get.find<AddExpenseController>();
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (expenseController.totalCount.value != expenseController.expenseData.length) {
        expenseController.pageCount.value++;
        expenseController.getExpenseData(
          page: expenseController.pageCount.value,
          isExpense: isExpense,
          startDate: expenseController.startDate.value.text,
          endDate: expenseController.endDate.value.text,
        );
      }
      /*   if (addExpenseController.totalCount.value != addExpenseController.getExpenseGeneralMasterData.length) {
        addExpenseController.pageCount.value++;
        addExpenseController.getExpenseGeneralMaster(
          isLoading: false,
          page: expenseController.pageCount.value,
        );
      }*/
    }
  }

  @override
  void dispose() {
    expenseController.dispose();
    addExpenseController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    () async {
      expenseController.pageCount.value = 1;
      addExpenseController.pageCount.value = 1;
      scrollController.addListener(_scrollListener);
      expenseController.expenseData.clear();
      expenseController.getExpenseData(
        page: expenseController.pageCount.value,
        dataClear: true,
        loading: true,
        isExpense: isExpense,
        startDate: expenseController.startDate.value.text,
        endDate: expenseController.endDate.value.text,
      );
      addExpenseController.getExpenseGeneralMaster(
        isLoading: false,
        page: addExpenseController.pageCount.value,
      );
      addExpenseController.getTransportMode(isLoading: false);
    }();
    // TODO: implement initState
    super.initState();
  }

  _bottomSheet(BuildContext context, ExpenseController expenseController, AddExpenseController? addExpenseController) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (_, setState) {
              return Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                        ),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  expenseController.pageCount.value = 1;
                                  expenseController.startDate.value.clear();

                                  expenseController.getExpenseData(
                                    loading: true,
                                    page: expenseController.pageCount.value,
                                    startDate: expenseController.startDate.value.text,
                                    endDate: expenseController.endDate.value.text,
                                    isExpense: isExpense,
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Start Data"),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(() {
                        return Padding(
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
                                    expenseController.startDate.value.text.isNotEmpty ? expenseController.startDate.value.text : "Select Start Date",
                                    style: AppTextStyle.regular.copyWith(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () async {
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: expenseController.startDate.value.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(expenseController.startDate.value.text) : DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          setState(
                                            () {
                                              expenseController.startDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                            },
                                          );

                                          expenseController.pageCount.value = 1;
                                        }
                                      },
                                      child: const Icon(Icons.calendar_month)),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expenseController.startDate.value.clear();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: AppColors.redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("End Data"),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(() {
                        return Padding(
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
                                    expenseController.endDate.value.text.isNotEmpty ? expenseController.endDate.value.text : "Select End Date",
                                    style: AppTextStyle.regular.copyWith(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () async {
                                        final DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: expenseController.endDate.value.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(expenseController.endDate.value.text) : DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          setState(
                                            () {
                                              expenseController.endDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                            },
                                          );

                                          debugPrint(">>>>>>>>>>>>>>>>>>>>>${expenseController.endDate.value.text}");

                                          expenseController.pageCount.value = 1;
                                        }
                                      },
                                      child: const Icon(Icons.calendar_month)),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expenseController.endDate.value.clear();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: AppColors.redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                        child: Center(
                          child: FilledButton(
                              onPressed: () {
                                expenseController.pageCount.value = 1;
                                expenseController.getExpenseData(
                                  loading: true,
                                  page: expenseController.pageCount.value,
                                  startDate: expenseController.startDate.value.text,
                                  endDate: expenseController.endDate.value.text,
                                  isExpense: isExpense,
                                  dataClear: true,
                                );
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  Get.back();
                                });
                              },
                              child: const Text("Apply Filter")),
                        ),
                      ),
                    ],
                  ));
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
          title: Text(
            isExpense ? 'My Expenses' : "Expenses Approval",
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    _bottomSheet(context, expenseController, addExpenseController);
                  },
                  child: Image.asset(
                    AppImages.filter,
                    scale: 22,
                  )),
            ),
            // isExpense
            //     ? Padding(
            //         padding: const EdgeInsets.only(right: 20),
            //         child: GestureDetector(
            //             onTap: () {
            //               addExpenseController.clear();
            //               Get.to(() => const AddExpenseScreen(), binding: AddExpenseBinding())!.whenComplete(() {
            //                 expenseController.pageCount.value = 1;
            //                 expenseController.expenseData.clear();
            //                 expenseController.getExpenseData(
            //                   page: expenseController.pageCount.value,
            //                   dataClear: true,
            //                   loading: true,
            //                   expenseDate: expenseController.dateController.value,
            //                 );
            //               });
            //               // Get.toNamed(AppRoutes.addExpense, arguments: [false]);
            //             },
            //             child: Image.asset(
            //               AppImages.plus,
            //               scale: 25,
            //             )),
            //       )
            //     : const SizedBox(),
          ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return expenseController.expenseData.isNotEmpty
                ? ListView.separated(
                    controller: scrollController,
                    itemCount: expenseController.expenseData.length + 1,
                    itemBuilder: (context, index) {
                      var data = index != expenseController.expenseData.length ? expenseController.expenseData[index] : null;
                      if (index < expenseController.expenseData.length) {
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
                                    _buildInfoRow("Expense No. : ", isExpense ? data!.expenseId : data!.expenseCode, Colors.black87),
                                    _buildInfoRow("Expense Date : ", data.expenseDate, Colors.black87),
                                    _buildInfoRow("Cust Name : ", isExpense ? data.companyName : data.contactName, Colors.black87),
                                    _buildInfoRow("Meeting date : ", data.meetingDate, Colors.black87),
                                    _buildInfoRow("Meeting ID : ", data.meetingId, Colors.black87),
                                    isExpense == false ? _buildInfoRow("Amount : ", data.amount.toString(), Colors.black87) : const SizedBox(),
                                    isExpense == false ? _buildInfoRow("Status : ", data.status, data.status == "Approved" ? Colors.green : Colors.red) : const SizedBox(),
                                    isExpense == true ? _buildInfoRow("Check In Time : ", data.checkIn, Colors.black87) : const SizedBox(),
                                    isExpense == true ? _buildInfoRow("Check Out Time	: ", data.checkOut, Colors.black87) : const SizedBox(),
                                    isExpense == true ? _buildInfoRow("Dist. In KM : ", data.distanceTravelled.toString(), Colors.black87) : const SizedBox(),
                                    _buildInfoRow("Req. Id/Date : ", isExpense ? data.requestDate : data.reqId, Colors.black87),
                                    _buildInfoRow("RTGS No. : ", data.rtgsNo, Colors.black87),
                                    isExpense == true ? _buildInfoRow("Amount : ", data.amount.toString(), Colors.black87) : const SizedBox(),
                                    // isExpense == false ? _buildInfoRow("Generated By : ", data.createdBy, Colors.black87) : const SizedBox(),
                                    isExpense == true ? _buildInfoRow("Status : ", data.status, data.status == "Approved" ? Colors.green : Colors.red) : const SizedBox(),
                                    const Divider(
                                      color: AppColors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        isExpense
                                            ? data.expenseCreated == false
                                                ? InkWell(
                                                    onTap: () {
                                                      addExpenseController.clear();
                                                      Get.to(
                                                              () => AddExpenseScreen(
                                                                    isEdit: false,
                                                                    id: isExpense ? data.expenseId : data.expenseCode,
                                                                    meetingId: data.meetingId,
                                                                    attendeeCode: data.attendeeCode,
                                                                  ),
                                                              binding: AddExpenseBinding())!
                                                          .whenComplete(() {
                                                        expenseController.pageCount.value = 1;
                                                        expenseController.expenseData.clear();
                                                        expenseController.getExpenseData(
                                                          page: expenseController.pageCount.value,
                                                          dataClear: true,
                                                          loading: true,
                                                          isExpense: isExpense,
                                                          startDate: expenseController.startDate.value.text,
                                                          endDate: expenseController.endDate.value.text,
                                                        );
                                                      });
                                                    },
                                                    child: Image.asset(
                                                      AppImages.addExpense,
                                                      scale: 18,
                                                    ),
                                                  )
                                                : data.expStatus == 4 || data.expStatus == 6
                                                    ? InkWell(
                                                        onTap: () {
                                                          addExpenseController.clear();
                                                          Get.to(
                                                                  () => AddExpenseScreen(
                                                                        isEdit: true,
                                                                        id: isExpense ? data.expenseId : data.expenseCode,
                                                                        meetingId: data.meetingId,
                                                                        attendeeCode: data.attendeeCode,
                                                                      ),
                                                                  binding: AddExpenseBinding())!
                                                              .whenComplete(() {
                                                            expenseController.pageCount.value = 1;
                                                            expenseController.expenseData.clear();
                                                            expenseController.getExpenseData(
                                                              page: expenseController.pageCount.value,
                                                              dataClear: true,
                                                              loading: true,
                                                              isExpense: isExpense,
                                                              startDate: expenseController.startDate.value.text,
                                                              endDate: expenseController.endDate.value.text,
                                                            );
                                                          });
                                                        },
                                                        child: Image.asset(
                                                          AppImages.edit,
                                                          scale: 18,
                                                        ),
                                                      )
                                                    : const SizedBox()
                                            : const SizedBox(),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => ViewExpenseScreen(
                                                      expenseId: isExpense ? data.attendeeCode : data.expenseCode,
                                                    ),
                                                fullscreenDialog: true,
                                                popGesture: true,
                                                binding: ViewExpenseBinding());
                                            // Get.toNamed(AppRoutes.viewLead,);
                                          },
                                          child: Image.asset(
                                            AppImages.eye,
                                            scale: 18,
                                          ),
                                        ),
                                        !isExpense && data.isManager_AuditApproved == false
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    addExpenseController.clear();
                                                    Get.to(
                                                            () => AddExpenseScreen(
                                                                  id: isExpense ? data.expenseId : data.expenseCode,
                                                                  meetingId: data.meetingId,
                                                                  attendeeCode: data.attendeeCode,
                                                                  isExpenseApproval: true,
                                                                  showButton: data.isEdit == "N" ? true : false,
                                                                ),
                                                            binding: AddExpenseBinding())!
                                                        .whenComplete(() {
                                                      expenseController.pageCount.value = 1;
                                                      expenseController.expenseData.clear();
                                                      expenseController.getExpenseData(
                                                        page: expenseController.pageCount.value,
                                                        isExpense: isExpense,
                                                        dataClear: true,
                                                        loading: true,
                                                        startDate: expenseController.startDate.value.text,
                                                        endDate: expenseController.endDate.value.text,
                                                      );
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    AppImages.addExpense,
                                                    scale: 18,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    // isExpense == false
                                    //     ? Padding(
                                    //         padding: const EdgeInsets.only(top: 10.0),
                                    //         child: Row(
                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                    //           children: [
                                    //             if (data.status == "Rejected" || data.status == "")
                                    //               ElevatedButton(
                                    //                 onPressed: () async {
                                    //                   await expenseController
                                    //                       .statesApproved(data: {"expenseId": data.expenseId, "approvalStatus": "1", "status": "Approved"}, index: index, isApprove: true);
                                    //                 },
                                    //                 style: ElevatedButton.styleFrom(
                                    //                   backgroundColor: Colors.green,
                                    //                   minimumSize: const Size(100, 40),
                                    //                   shape: RoundedRectangleBorder(
                                    //                     borderRadius: BorderRadius.circular(40),
                                    //                   ),
                                    //                 ),
                                    //                 child: Text(
                                    //                   "Approve",
                                    //                   style: AppTextStyle.regular.copyWith(fontSize: 15, color: Colors.white),
                                    //                 ),
                                    //               ),
                                    //             if (data.status == "")
                                    //               const SizedBox(
                                    //                 width: 10,
                                    //               ),
                                    //             if (data.status == "Approved" || data.status == "")
                                    //               ElevatedButton(
                                    //                 onPressed: () async {
                                    //                   await expenseController.statesApproved(
                                    //                     data: {"expenseId": data.expenseId, "approvalStatus": "2", "status": "Rejected"},
                                    //                     index: index,
                                    //                   );
                                    //                 },
                                    //                 style: ElevatedButton.styleFrom(
                                    //                   backgroundColor: Colors.red,
                                    //                   minimumSize: const Size(100, 40),
                                    //                   shape: RoundedRectangleBorder(
                                    //                     borderRadius: BorderRadius.circular(40),
                                    //                   ),
                                    //                 ),
                                    //                 child: Text(
                                    //                   "Reject",
                                    //                   style: AppTextStyle.regular.copyWith(fontSize: 15, color: AppColors.whiteColor),
                                    //                 ),
                                    //               ),
                                    //           ],
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (expenseController.totalCount.value != expenseController.expenseData.length) {
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
                : expenseController.expenseData.isEmpty && expenseController.isLoading.value == false
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
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
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
