import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/expense_general_master_screen/expense_general_master_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../add_expense_general_master/add_expense_general_master_binding.dart';
import '../add_expense_general_master/add_expense_general_master_controller.dart';
import '../add_expense_general_master/add_expense_general_master_screen.dart';
import '../view_expense_general_master/view_expense_general_master_screen.dart';

class ExpenseGeneralMasterScreen extends StatefulWidget {
  const ExpenseGeneralMasterScreen({super.key});

  @override
  State<ExpenseGeneralMasterScreen> createState() => _ExpenseGeneralMasterScreenState();
}

class _ExpenseGeneralMasterScreenState extends State<ExpenseGeneralMasterScreen> {
  ExpenseGeneralMasterController expenseGeneralMasterController = Get.find<ExpenseGeneralMasterController>();
  AddExpenseGeneralMasterController addExpenseGeneralMasterController = Get.find<AddExpenseGeneralMasterController>();
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (expenseGeneralMasterController.totalCount.value != expenseGeneralMasterController.expensesGeneralMasterList.length) {
        expenseGeneralMasterController.pageCount.value++;
        expenseGeneralMasterController.getExpenseData(
          page: expenseGeneralMasterController.pageCount.value,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    expenseGeneralMasterController.pageCount.value = 1;
    scrollController.addListener(_scrollListener);
    expenseGeneralMasterController.getExpenseData(
      loading: true,
      page: expenseGeneralMasterController.pageCount.value,
    );
    addExpenseGeneralMasterController.getTransportMode(isLoading: false);
    addExpenseGeneralMasterController.getDesignationMode(isLoading: false);
    super.initState();
  }

  _bottomSheet(BuildContext context, {required ExpenseGeneralMasterController expenseGeneralMasterController, required AddExpenseGeneralMasterController? addExpenseGeneralMasterController}) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (_, setState) {
              return Container(
                height: 300,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                                expenseGeneralMasterController.pageCount.value = 1;
                                expenseGeneralMasterController.dateController.value = null;
                                addExpenseGeneralMasterController!.selectedDesignation.value = null;
                                addExpenseGeneralMasterController.selectedTransportMode.value = null;
                                addExpenseGeneralMasterController.filterTransport.value = '';
                                addExpenseGeneralMasterController.filterDesignation.value = '';

                                expenseGeneralMasterController.getExpenseData(
                                  loading: true,
                                  page: expenseGeneralMasterController.pageCount.value,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return CustomDropdown<TransportMode>(
                              hintText: 'Designation',
                              items: addExpenseGeneralMasterController!.designationList,
                              itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                              selectedItem: addExpenseGeneralMasterController.selectedDesignation.value,
                              onClearTap: () {
                                addExpenseGeneralMasterController.selectedDesignation.value = null;
                                addExpenseGeneralMasterController.filterDesignation.value = '';
                              },
                              onChanged: (TransportMode? transportMode) {
                                if (transportMode != null) {
                                  addExpenseGeneralMasterController.filterDesignation.value = transportMode.codeDesc;
                                  addExpenseGeneralMasterController.selectedDesignation.value = transportMode;
                                  addExpenseGeneralMasterController.filterDesignation.refresh();
                                  addExpenseGeneralMasterController.selectedDesignation.refresh();
                                }
                              },
                              validator: (value) => value == null ? 'Please select a Designation Mode' : null,
                              showSearchBox: true,
                            );
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return CustomDropdown<TransportMode>(
                              hintText: 'Transport Mode',
                              items: addExpenseGeneralMasterController!.transportModeList,
                              itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                              selectedItem: addExpenseGeneralMasterController.selectedTransportMode.value,
                              onClearTap: () {
                                addExpenseGeneralMasterController.selectedTransportMode.value = null;
                                addExpenseGeneralMasterController.filterTransport.value = '';
                              },
                              onChanged: (TransportMode? transportMode) {
                                if (transportMode != null) {
                                  addExpenseGeneralMasterController.filterTransport.value = transportMode.codeDesc;
                                  addExpenseGeneralMasterController.selectedTransportMode.value = transportMode;
                                  addExpenseGeneralMasterController.filterTransport.refresh();
                                  addExpenseGeneralMasterController.selectedTransportMode.refresh();
                                }
                              },
                              validator: (value) => value == null ? 'Please select a Transport Mode' : null,
                              showSearchBox: true,
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                        onPressed: () {
                          expenseGeneralMasterController.pageCount.value = 1;
                          expenseGeneralMasterController.getExpenseData(
                            loading: true,
                            page: expenseGeneralMasterController.pageCount.value,
                            dataClear: true,
                            designation: addExpenseGeneralMasterController!.filterDesignation.value,
                            transportMode: addExpenseGeneralMasterController.filterTransport.value,
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Get.back();
                          });
                        },
                        child: const Text("Apply Filter"))
                  ],
                ),
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
            'Expenses General Master',
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
                  _bottomSheet(context, expenseGeneralMasterController: expenseGeneralMasterController, addExpenseGeneralMasterController: addExpenseGeneralMasterController);
                },
                child: Image.asset(
                  AppImages.filter,
                  scale: 22,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                  onTap: () {
                    Get.to(
                            () => AddExpenseGeneralMasterScreen(
                                  createdBy: "",
                                ),
                            binding: AddExpenseGeneralMasterBinding())!
                        .whenComplete(() {
                      expenseGeneralMasterController.pageCount.value = 1;
                      expenseGeneralMasterController.expensesGeneralMasterList.clear();
                      expenseGeneralMasterController.getExpenseData(
                        page: expenseGeneralMasterController.pageCount.value,
                        dataClear: true,
                        loading: true,
                      );
                    });
                    ;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return expenseGeneralMasterController.expensesGeneralMasterList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: expenseGeneralMasterController.expensesGeneralMasterList.length + 1,
                          itemBuilder: (context, index) {
                            var data = index != expenseGeneralMasterController.expensesGeneralMasterList.length ? expenseGeneralMasterController.expensesGeneralMasterList[index] : null;
                            if (index < expenseGeneralMasterController.expensesGeneralMasterList.length) {
                              return Container(
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
                                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow("Designation:", data!.designation, Colors.black87),
                                      _buildInfoRow("Transport Mode:", data.transportMode, Colors.black87),
                                      _buildInfoRow("Rate Per Km:", data.ratePerKm.toString(), Colors.black87),
                                      const Divider(
                                        color: AppColors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            data.isActive ? AppImages.check : AppImages.cross,
                                            scale: data.isActive ? 18 : 21,
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => AddExpenseGeneralMasterScreen(
                                                  isEdit: true,
                                                  id: data.id.toString(),
                                                  transport: TransportMode(
                                                    codeType: '',
                                                    codeId: data.transportModeId.toString(),
                                                    codeDesc: data.transportMode,
                                                  ),
                                                  designation: TransportMode(
                                                    codeType: '',
                                                    codeId: data.designationId.toString(),
                                                    codeDesc: data.designation,
                                                  ),
                                                  ratePerKm: data.ratePerKm.toString(),
                                                  modifiedBy: data.modifiedBy,
                                                  createdBy: data.createdBy,
                                                  isActive: data.isActive,
                                                ),
                                                binding: AddExpenseGeneralMasterBinding(),
                                              )!
                                                  .whenComplete(() {
                                                expenseGeneralMasterController.pageCount.value = 1;
                                                expenseGeneralMasterController.expensesGeneralMasterList.clear();
                                                expenseGeneralMasterController.getExpenseData(
                                                  page: expenseGeneralMasterController.pageCount.value,
                                                  dataClear: true,
                                                  loading: true,
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
                                                () => ViewExpenseGeneralMasterScreen(
                                                  ratePerKm: data.ratePerKm.toString(),
                                                  transportMode: data.transportMode,
                                                  createdBy: data.createdBy,
                                                  createdDate: data.createdDate,
                                                  modifiedBy: data.modifiedBy,
                                                  modifiedDate: data.modifiedDate,
                                                    designation:data.designation,
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              AppImages.eye,
                                              scale: 18,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (expenseGeneralMasterController.totalCount.value != expenseGeneralMasterController.expensesGeneralMasterList.length) {
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
                        ),
                      )
                    : expenseGeneralMasterController.expensesGeneralMasterList.isEmpty && expenseGeneralMasterController.isLoading.value == false
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
            ],
          ),
        )));
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
