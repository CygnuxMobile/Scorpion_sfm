import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/config/app_colors.dart';
import 'package:scorpforce/config/app_images.dart';
import 'package:scorpforce/config/app_text_style.dart';
import 'package:scorpforce/modules/customer/customer_screen/customer_controller.dart';
import 'package:scorpforce/modules/lead/lead_screen/lead_screen.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/add_meeting_controller.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/add_meeting_screen.dart';
import 'package:scorpforce/modules/my_call/add_my_call_screen/add_call_controller.dart';
import 'package:scorpforce/modules/widget/TextField.dart';

import '../../widget/loader.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController customerController = Get.find<CustomerController>();

  final AddMeetingController addMeetingController = Get.find<AddMeetingController>();

  final AddCallController addCallController = Get.find<AddCallController>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    () async {
      scrollController.addListener(_scrollListener);
      customerController.getCustomerData(page: customerController.totalCount.value, loading: true);
      customerController.getCustomer(text: "");
      addMeetingController.getUser(showLoader: true, addCallController: addCallController);
      addMeetingController.getCustomer();
      addMeetingController.getMeetingType(showLoader: true);
      addMeetingController.getBranch(showLoader: true);
      addMeetingController.getMomList(showLoader: true);
      // addCallController.getUser();
      // addCallController.getCategory();
      // addCallController.getLead();
      // addCallController.getPurpose();
      // addCallController.getStatus();
    }();
    super.initState();
  }

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (customerController.totalCount.value != customerController.customerList.length) {
        customerController.pageCount.value++;
        customerController.getCustomerData(page: customerController.totalCount.value, loading: true);
      }
    }
  }

  _bottomSheet(BuildContext context, CustomerController customerController) {
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
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            customerController.pageCount.value = 1;
                            customerController.startDate.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 30)));
                            customerController.endDate.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                            customerController.getCustomerData(page: customerController.totalCount.value, loading: true);
                          },
                          child: const Text("Clear filter"),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text("Start Data")),
                  const SizedBox(height: 3),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Row(
                            children: [
                              Text(customerController.startDate.value.text.isNotEmpty ? customerController.startDate.value.text : "Select Start Date", style: AppTextStyle.regular.copyWith(fontSize: 16)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: customerController.startDate.value.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(customerController.startDate.value.text) : DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      customerController.startDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                    });

                                    customerController.pageCount.value = 1;
                                  }
                                },
                                child: const Icon(Icons.calendar_month),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    customerController.startDate.value.clear();
                                  });
                                },
                                child: const Icon(Icons.clear, color: AppColors.redColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text("End Data")),
                  const SizedBox(height: 3),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Row(
                            children: [
                              Text(customerController.endDate.value.text.isNotEmpty ? customerController.endDate.value.text : "Select End Date", style: AppTextStyle.regular.copyWith(fontSize: 16)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: customerController.endDate.value.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(customerController.endDate.value.text) : DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      customerController.endDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                    });

                                    debugPrint(">>>>>>>>>>>>>>>>>>>>>${customerController.endDate.value.text}");

                                    customerController.pageCount.value = 1;
                                  }
                                },
                                child: const Icon(Icons.calendar_month),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    customerController.endDate.value.clear();
                                  });
                                },
                                child: const Icon(Icons.clear, color: AppColors.redColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    child: Center(
                      child: FilledButton(
                        onPressed: () {
                          customerController.pageCount.value = 1;
                          customerController.customerList.clear();
                          customerController.getCustomerData(page: customerController.pageCount.value, loading: true);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Get.back();
                          });
                        },
                        child: const Text("Apply Filter"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Customer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              customerController.isLoading.value == false
                  ? customerController.isSearchOnTap.isTrue
                        ? customerController.isSearchOnTap.value = false
                        : customerController.isSearchOnTap.value = true
                  : null;
            },
            icon: const Icon(Icons.search, color: AppColors.whiteColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              customerController.isSearchOnTap.isTrue
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Column(
                        children: [
                          commonTextField(
                            suffixIcon: IconButton(
                              onPressed: () {
                                customerController.customerName.refresh();
                                if (customerController.customerName.value.text.isEmpty) {
                                  customerController.isSearchOnTap.value = false;
                                } else {
                                  customerController.customerName.value.clear();
                                  customerController.getCustomerData(page: customerController.pageCount.value, loading: true);
                                }
                              },
                              icon: const Icon(Icons.clear, color: AppColors.redColor),
                            ),
                            padding: 0,
                            enabledBorder: AppColors.black,
                            labelText: "Customer",
                            controller: customerController.customerName.value,
                            textColor: AppColors.black,
                            onChange: (value) {
                              customerController.customerName.refresh();
                              Future.delayed(Duration(seconds: 1), () {
                                customerController.getCustomerData(customerName: value, page: customerController.pageCount.value, loading: true);
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (customerController.customerList.isNotEmpty) {
                      return ListView.separated(
                        controller: scrollController,
                        itemCount: customerController.customerList.length + 1,
                        itemBuilder: (context, index) {
                          var data = index != customerController.customerList.length ? customerController.customerList[index] : null;

                          if (index < customerController.customerList.length) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow("Customer Name:", "${data!.customerCode} : ${data.customerName}", Colors.black87),
                                    _buildInfoRow("Contract ID:", data.contractId, Colors.black87),
                                    _buildInfoRow("Start Date:", data.startDate, Colors.black87),
                                    _buildInfoRow("End Date:", data.endDate, Colors.black87),
                                    _buildInfoRow("Sales:", "${data.salesMonth}", Colors.black87),
                                    _buildInfoRow("Sales YTD:", "${data.salesYear}", Colors.black87),
                                    _buildInfoRow("O/S as on Date:", "${data.oSonDate}", Colors.black87),
                                    const Divider(color: AppColors.grey),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     Get.to(
                                            //       () => AddCallScreen(
                                            //         isFromCustomerScreen: true,
                                            //         data: {
                                            //           "customerName": data.customerName,
                                            //           "leadId": data.customerCode,
                                            //         },
                                            //       ),
                                            //       binding: AddCallBinding(),
                                            //     );
                                            //   },
                                            //   child: Image.asset(AppImages.addCall, scale: 18),
                                            // ),
                                            // const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                addMeetingController.clear(a: addMeetingController.controller.value);
                                                Get.to(
                                                  () => AddMeetingScreen(
                                                    isFromCustomerScreen: true,
                                                    data: Data1(
                                                      customerName: data.customerName,
                                                      customerId: data.customerCode,
                                                      contactPerson: data.contactName,
                                                      address: data.address,
                                                      email: data.email,
                                                      mobile: data.contactNo,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.asset(AppImages.addUser, scale: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (customerController.customerList.length >= 5) {
                            return Center(child: SizedBox(height: 70, child: loader()));
                          } else {
                            return const SizedBox();
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      );
                    } else if (customerController.customerList.isEmpty && customerController.isLoading.isFalse) {
                      return Center(child: Image.asset(AppImages.noDataFound, scale: 6));
                    } else if (customerController.customerList.isEmpty && customerController.isLoading.isTrue) {
                      return Center(child: loader());
                    } else {
                      return customerController.customerList.length <= 5 ? Center(child: loader()) : const SizedBox();
                    }
                  }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
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
    );
  }
}
