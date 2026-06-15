import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/lead/lead_screen/lead_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_text_style.dart';
import '../../../utils/api_handler.dart';
import '../../meeting/add_meeting_screen/add_meeting_controller.dart';
import '../../meeting/add_meeting_screen/add_meeting_screen.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../../widget/toast_message.dart';
import '../add_lead/binding/add_lead_binding.dart';
import '../add_lead/controller/add_lead_controller.dart';
import '../add_lead/model/get_category_response_model.dart';
import '../add_lead/view/add_lead_screen.dart';
import '../view_lead/view_lead_binding.dart';
import '../view_lead/view_lead_screen.dart';

class MyLeadScreen extends StatefulWidget {
  const MyLeadScreen({super.key});

  @override
  State<MyLeadScreen> createState() => _MyLeadScreenState();
}

class _MyLeadScreenState extends State<MyLeadScreen> {
  LeadController leadController = Get.find<LeadController>();
  AddLeadController addLeadController = Get.find<AddLeadController>();
  AddMeetingController addMeetingController = Get.find<AddMeetingController>();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    leadController.dispose();
    addLeadController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    loadDropdownsInBackground();
    loadLeadScreenFast();
    super.initState();
  }

  void loadLeadScreenFast() async {
    leadController.isLoading.value = true;

    await leadController.getLeadData(
      loading: true,
      page: 1,
      dataClear: true,
      leadCategory: null,
    );

    leadController.isLoading.value = false;
  }

  Future<void> loadDropdownsInBackground() async {
    try {
      if (!await ApiHandler.hasInternet()) {
        toastMessage(text: "No internet connection", color: AppColors.redColor);
        return;
      }

      await Future.wait([
        addLeadController.getDesignation(),
        addLeadController.getCategory(showLoader: true),
        addLeadController.getCity(showLoader: true),
        addLeadController.getBranch(showLoader: true),
        addLeadController.getLeadSource(showLoader: true),
        addLeadController.getIndustry(showLoader: true),
        addLeadController.getServiceIntegrated(showLoader: true),
        addMeetingController.getMeetingType(showLoader: true),
        addMeetingController.getBranch(showLoader: true),
        addLeadController.getUser(showLoader: true),
        addMeetingController.getUser(showLoader: true),
      ]);
    } catch (e) {
      toastMessage(text: "Internet is slow. Please try again", color: AppColors.redColor);
      debugPrint("Dropdown Load Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'My Lead',
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
                leadController.isLoading.value == false ?
                leadController.isSearchOnTap.isTrue ? leadController.isSearchOnTap.value = false : leadController.isSearchOnTap.value = true : null;
              },
              child: const Icon(
                Icons.search,
                color: AppColors.whiteColor,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
                onTap: () {
                  addLeadController.clear(a: addLeadController.controller.value);
                  Get.toNamed(AppRoutes.addLand)!.whenComplete(() {
                    leadController.pageCount.value = 1;
                    leadController.getLeadData(
                      page: leadController.pageCount.value,
                      loading: true,
                      dataClear: true,
                      leadCategory: leadController.leadCategory.value,
                    );
                  });
                },
                child: Text("Add", style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),) /*Image.asset(
                  AppImages.plus,
                  scale: 25,
                )*/),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Column(
                children: [
                  leadController.isSearchOnTap.isTrue
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Obx(() {
                          return commonTextField(
                            suffixIcon: leadController.customerNameSearch.value.text.isEmpty ? SizedBox() : IconButton(
                              onPressed: () {
                                leadController.customerNameSearch.refresh();
                                if (leadController.customerNameSearch.value.text.isEmpty) {
                                  leadController.isSearchOnTap.value = false;
                                } else {

                                  leadController.clearSearch();
                                }
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.redColor,
                              ),
                            ),
                            padding: 0,
                            enabledBorder: AppColors.black,
                            labelText: "Customer",
                            controller: leadController.customerNameSearch.value,
                            textColor: AppColors.black,
                            onChange: (value) {
                              leadController.customerNameSearch.refresh();
                              Future.delayed(Duration(seconds: 1), (){
                                leadController.onSearchChanged(value);
                              });

                            },
                          );
                        }),
                      ],
                    ),
                  )
                      : const SizedBox(),
                  Expanded(
                    child: Obx(() {
                      return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification &&
                                notification.metrics.extentAfter == 0 &&
                                leadController.totalCount.value != leadController.leadData.length) {
                              leadController.pageCount.value++;
                              leadController.getLeadData(
                                page: leadController.pageCount.value,
                                leadCategory: leadController.leadCategory.value,
                              );
                            }
                            return false;
                          },
                          child: leadController.leadData.isNotEmpty
                              ? ListView.separated(
                            // controller: scrollController,
                            itemCount: leadController.leadData.length + 1,
                            itemBuilder: (context, index) {
                              var data = index != leadController.leadData.length ? leadController.leadData[index] : null;
                              if (index < leadController.leadData.length) {
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
                                            _buildInfoRow("Lead Category:", data!.leadCategory, Colors.black87),
                                            const SizedBox(height: 10),
                                            _buildInfoRow("Customer:", data.companyName, Colors.black87),
                                            const SizedBox(height: 10),
                                            _buildInfoRow("Assigned To:", data.assignedTo, Colors.black87),
                                            // const SizedBox(height: 20),
                                            const Divider(
                                              color: AppColors.grey,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  data.leadDate,
                                                  style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(data.isActive ? Icons.check : Icons.cancel_outlined,
                                                      color: data.isActive ? AppColors.greenColor : AppColors.redColor,),

                                                    if (data.leadCreated == true) ...[
                                                      const SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          addLeadController.clear(a: addLeadController.controller.value);
                                                          Get.to(
                                                                  () =>
                                                                  AddLeadScreen(
                                                                    isEdit: true,
                                                                    id: data.leadId,
                                                                  ),
                                                              binding: AddLeadBinding())!
                                                              .whenComplete(() async {
                                                            leadController.pageCount.value = 1;
                                                            leadController.dateController.value = null;
                                                            leadController.leadCategory.value = null;
                                                            await leadController.getLeadData(
                                                              loading: true,
                                                              page: leadController.pageCount.value,
                                                              dataClear: true,
                                                              leadCategory: leadController.leadCategory.value,
                                                            );
                                                          });
                                                        },
                                                        child: Icon(Icons.edit, color: Colors.orange,) /*Image.asset(
                                                                AppImages.edit,
                                                                scale: 18,
                                                              )*/,
                                                      ),
                                                    ],
                                                    const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                                () =>
                                                                ViewLeadScreen(
                                                                  leadId: data.leadId,
                                                                  leadName: data.contactName,
                                                                ),
                                                            fullscreenDialog: true,
                                                            popGesture: true,
                                                            binding: ViewLeadBinding());
                                                        // Get.toNamed(AppRoutes.viewLead,);
                                                      },
                                                      child: Icon(Icons.remove_red_eye_outlined, color: AppColors.blueColor,) /*Image.asset(
                                                              AppImages.eye,
                                                              scale: 18,
                                                            )*/,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     Get.to(
                                                    //         () => AddCallScreen(
                                                    //               isFromLeadScreen: true,
                                                    //               data: {"customerName": data.companyName, "leadId": data.leadId},
                                                    //             ),
                                                    //         binding: AddCallBinding());
                                                    //   },
                                                    //   child: Image.asset(
                                                    //     AppImages.addCall,
                                                    //     scale: 18,
                                                    //   ),
                                                    // ),
                                                    // const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        addMeetingController.clear(a: addMeetingController.controller.value);
                                                        /*
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => AddMeetingScreen(
                                                              isFromLeadScreen: true,
                                                              data: Data1(
                                                                customerName: data.companyName,
                                                                customerId: data.leadId,
                                                                contactPerson: data.contactName,
                                                                email: data.email,
                                                                mobile: data.contactNo,
                                                                address: data.address,
                                                              )),
                                                        ));*/
                                                        Get.to(
                                                              () =>
                                                              AddMeetingScreen(
                                                                  isFromLeadScreen: true,
                                                                  data: Data1(
                                                                    customerName: data.companyName,
                                                                    customerId: data.leadId,
                                                                    contactPerson: data.contactName,
                                                                    email: data.email,
                                                                    mobile: data.contactNo,
                                                                    address: data.address,
                                                                    leadDate: data.leadDate,
                                                                  )),
                                                        );
                                                      },
                                                      child: Icon(Icons.person_add_alt_outlined) /*Image.asset(
                                                              AppImages.addUser,
                                                              scale: 18,
                                                            )*/,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (leadController.totalCount.value != leadController.leadData.length) {
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
                              : leadController.leadData.isEmpty && leadController.isLoading.value == false
                              ? Center(
                            child: Image.asset(
                              AppImages.noDataFound,
                              scale: 6,
                            ),
                          )
                              : Center(
                            child: loader(),
                          ));
                    }),
                  ),
                ],
              );
            })),
      ),
    );
  }

  _bottomSheet(BuildContext context, LeadController leadController, AddLeadController? addLeadController) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (_, setState) {
              return Container(
                color: Colors.transparent, //could change this to Color(0xFF737373),
                //so you don't have to change MaterialApp canvasColor
                child: Obx(() {
                  return Column(
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
                                  leadController.pageCount.value = 1;
                                  leadController.startDate.value.text =
                                      DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 30)));
                                  leadController.endDate.value.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                                  leadController.leadCategory.value = null;
                                  leadController.selectedCategory.value = null;
                                  leadController.getLeadData(
                                    loading: true,
                                    page: leadController.pageCount.value,
                                    leadCategory: leadController.leadCategory.value,
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
                                  CustomDropdown<Categories>(
                                    hintText: 'Lead Category',
                                    onClearTap: () {
                                      leadController.leadCategory.value = null;
                                      leadController.selectedCategory.value = null;
                                      leadController.pageCount.value = 1;
                                      /* leadController.getLeadData(
                                            loading: true,
                                            page: leadController.pageCount.value,
                                            meetingDate: leadController.dateController.value ?? "",
                                            leadCategory: leadController.leadCategory.value,
                                            dataClear: true);*/
                                    },
                                    items: addLeadController!.categoryList,
                                    selectedItem: leadController.selectedCategory.value,
                                    itemAsString: (Categories category) => category.codeDesc,
                                    // Display the user's name
                                    onChanged: (Categories? category) {
                                      if (category != null) {
                                        leadController.leadCategory.value = category.codeDesc;
                                        leadController.selectedCategory.value = category;
                                        // leadController.pageCount.value = 1;
                                        // leadController.getLeadData(
                                        //     loading: true,
                                        //     page: leadController.pageCount.value,
                                        //     meetingDate: leadController.dateController.value ?? "",
                                        //     leadCategory: category.codeDesc,
                                        //     dataClear: true);
                                      }
                                    },

                                    showSearchBox: addLeadController.categoryList.length > 4 ? true : false,
                                  ),
                                ],
                              ),
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
                        return GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: leadController.startDate.value.text.isNotEmpty
                                    ? DateFormat('dd/MM/yyyy').parse(leadController.startDate.value.text)
                                    : DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(
                                      () {
                                    leadController.startDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                  },
                                );

                                leadController.pageCount.value = 1;
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
                                        leadController.startDate.value.text.isNotEmpty ? leadController.startDate.value.text : "Select Start Date",
                                        style: AppTextStyle.regular.copyWith(fontSize: 16),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.calendar_month)
                                    ],
                                  ),
                                ),
                              ),
                            ));
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
                        return GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: leadController.endDate.value.text.isNotEmpty
                                    ? DateFormat('dd/MM/yyyy').parse(leadController.endDate.value.text)
                                    : DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(
                                      () {
                                    leadController.endDate.value.text = DateFormat('dd/MM/yyyy').format(picked);
                                  },
                                );

                                debugPrint(">>>>>>>>>>>>>>>>>>>>>${leadController.endDate.value.text}");
                                ;

                                leadController.pageCount.value = 1;
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
                                        leadController.endDate.value.text.isNotEmpty ? leadController.endDate.value.text : "Select End Date",
                                        style: AppTextStyle.regular.copyWith(fontSize: 16),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.calendar_month)
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery
                              .of(context)
                              .padding
                              .bottom),
                          child: FilledButton(
                              onPressed: () {
                                leadController.pageCount.value = 1;
                                leadController.getLeadData(
                                    loading: true,
                                    page: leadController.pageCount.value,
                                    leadCategory: leadController.leadCategory.value,
                                    dataClear: true);
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  Get.back();
                                });
                              },
                              child: const Text("Apply Filter")),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                }),
              );
            },
          );
        });
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
  final String? contactPerson;
  final String? email;
  final String? mobile;
  final String? address;
  final String? leadDate;

  Data1({
    required this.customerName,
    required this.customerId,
    this.contactPerson,
    this.email,
    this.mobile,
    this.address,
    this.leadDate,
  });
}
