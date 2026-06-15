import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/my_call/my_call_screen/my_call_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../add_my_call_screen/add_call_binding.dart';
import '../add_my_call_screen/add_call_controller.dart';
import '../add_my_call_screen/add_call_screen.dart';
import '../add_my_call_screen/call_module_response_model.dart';
import '../view_expense/call_view_binding.dart';
import '../view_expense/call_view_screen.dart';

class MyCallScreen extends StatefulWidget {
  const MyCallScreen({super.key});

  @override
  State<MyCallScreen> createState() => _MyCallScreenState();
}

class _MyCallScreenState extends State<MyCallScreen> {
  MyCallController myCallController = Get.find<MyCallController>();
  AddCallController addCallController = Get.find<AddCallController>();
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (myCallController.totalCount.value != myCallController.callData.length) {
        myCallController.pageCount.value++;
        myCallController.getCallData(
          page: myCallController.pageCount.value,
          callCategory: myCallController.callCategory.value,
          callDate: myCallController.dateController.value,
        );
      }
    }
  }

  @override
  void dispose() {
    addCallController.dispose();
    myCallController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    () async {
      myCallController.pageCount.value = 1;
      scrollController.addListener(_scrollListener);

      myCallController.getCallData(
        page: myCallController.pageCount.value,
        loading: true,
        dataClear: true,
        callCategory: myCallController.callCategory.value,
        callDate: myCallController.dateController.value,
      );
      await addCallController.getUser();
      addCallController.getCategory();
      addCallController.getLead();
      addCallController.getPurpose();
      addCallController.getStatus();
    }();
    // TODO: implement initState
    super.initState();
  }

  _bottomSheet(BuildContext context, MyCallController myCallController, AddCallController? addCallController) {
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
                                  myCallController.pageCount.value = 1;
                                  myCallController.dateController.value = null;
                                  myCallController.callCategory.value = null;
                                  myCallController.selectedCallCategory.value = null;
                                  myCallController.getCallData(
                                    loading: true,
                                    page: myCallController.pageCount.value,
                                    callDate: myCallController.dateController.value,
                                    callCategory: myCallController.callCategory.value,
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
                                child: Row(
                              children: [
                                Obx(() {
                                  return CustomDropdown<CallType>(
                                    onClearTap: (){
                                      myCallController.selectedCallCategory.value = null;
                                    },
                                    hintText: 'Call Category*',
                                    items: addCallController!.callCategoryList,
                                    selectedItem: myCallController.selectedCallCategory.value,
                                    itemAsString: (CallType data) => data.codeDesc,
                                    // Display the user's name
                                    onChanged: (CallType? data) {
                                      if (data != null) {
                                        myCallController.selectedCallCategory.value = data;
                                        myCallController.callCategory.value = data.codeDesc;
                                      }
                                    },
                                    validator: (value) => value == null ? 'Please select a Call category' : null,
                                    showSearchBox: true,
                                  );
                                }),
                              ],
                            ))
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
                              myCallController.dateController.value = DateFormat('dd/MM/yyyy').format(picked);
                              myCallController.pageCount.value = 1;
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
                                      myCallController.dateController.value != null ? myCallController.dateController.value.toString() : "Select Date",
                                      style: AppTextStyle.regular.copyWith(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    if (myCallController.dateController.value != null)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 23.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              myCallController.dateController.value = null;
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
                            myCallController.pageCount.value = 1;
                            myCallController.getCallData(
                                loading: true,
                                page: myCallController.pageCount.value,
                                callDate: myCallController.dateController.value,
                                callCategory: myCallController.callCategory.value,
                                dataClear: true);
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
          'My Call',
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
                onTap: () {
                  _bottomSheet(context, myCallController, addCallController);
                },
                child: Image.asset(
                  AppImages.filter,
                  scale: 22,
                )),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: GestureDetector(
          //       onTap: () {
          //         addCallController.clear(a: addCallController.controller.value);
          //         Get.to(() => const AddCallScreen(), binding: AddCallBinding())?.whenComplete(() async {
          //           myCallController.pageCount.value = 1;
          //           myCallController.callData.clear();
          //           myCallController.getCallData(
          //             page: myCallController.pageCount.value,
          //             loading: true,
          //             dataClear: true,
          //             callCategory: myCallController.callCategory.value,
          //             callDate: myCallController.dateController.value,
          //           );
          //         });
          //       },
          //       child: Image.asset(
          //         AppImages.plus,
          //         scale: 25,
          //       )),
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return myCallController.callData.isNotEmpty
                ? ListView.separated(
                    controller: scrollController,
                    itemCount: myCallController.callData.length + 1,
                    itemBuilder: (context, index) {
                      var data = index != myCallController.callData.length ? myCallController.callData[index] : null;
                      if (index < myCallController.callData.length) {
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
                                    _buildInfoRow("Call CategoryName:", data!.callCategoryName, Colors.black87),
                                    _buildInfoRow("Call Date:", data.callDate, Colors.black87),
                                    _buildInfoRow("Customer Name:", data.customerName.toString(), Colors.black87),
                                    _buildInfoRow("Start Time:", data.startTime, Colors.black87),
                                    _buildInfoRow("End Time:", data.endTime, Colors.black87),
                                    _buildInfoRow("Call Status:", data.callStatus, Colors.green),
                                    const Divider(
                                      color: AppColors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            addCallController.clear(a: addCallController.controller.value);
                                            Get.to(
                                              () => AddCallScreen(isEdit: true, callId: data.callId),
                                              binding: AddCallBinding(),
                                            )?.whenComplete(() async {
                                              myCallController.pageCount.value = 1;
                                              myCallController.callData.clear();
                                              myCallController.getCallData(
                                                page: myCallController.pageCount.value,
                                                loading: true,
                                                dataClear: true,
                                                callCategory: myCallController.callCategory.value,
                                                callDate: myCallController.dateController.value,
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
                                              () => CallViewScreen(
                                                callId: data.callId,
                                              ),
                                              fullscreenDialog: true,
                                              popGesture: true,
                                              binding: CallViewBinding(),
                                            );
                                            // Get.toNamed(AppRoutes.viewCall,);
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
                      } else if (myCallController.totalCount.value != myCallController.callData.length) {
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
                : myCallController.callData.isEmpty && myCallController.isLoading.value == false
                    ?  Center(
                        child:Image.asset(
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
