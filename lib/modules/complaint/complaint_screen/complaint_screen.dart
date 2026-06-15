import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/complaint_screen/complaint_controller.dart';
import 'package:scorpforce/modules/complaint/complaint_screen/model/complaint_list_response.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_text_style.dart';
import '../../lead/add_lead/model/get_branch_response_model.dart';
import '../../lead/add_lead/model/get_lead_source_responce_model.dart';
import '../../lead/add_lead/model/get_user_response_model.dart';
import '../../meeting/add_meeting_screen/add_meeting_controller.dart';
import '../../widget/loader.dart';
import '../add_complaint/add_complaint_binding.dart';
import '../add_complaint/add_complaint_controller.dart';
import '../add_complaint/add_complaint_screen.dart';
import '../add_complaint/escalation_ticket_screen.dart';
import '../add_complaint/model/get_complaint_subType_response_model.dart';
import '../add_complaint/model/get_complaint_type_response_model.dart';
import '../view_complaint/view_complaint_binding.dart';
import '../view_complaint/view_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  ComplaintController complaintController = Get.find<ComplaintController>();
  AddComplaintController addComplaintController = Get.find<AddComplaintController>();
  AddMeetingController addMeetingController = Get.find<AddMeetingController>();
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (complaintController.totalCount.value != complaintController.complaintListData.length) {
        complaintController.pageCount.value++;
        complaintController.getComplaintList(
          page: complaintController.pageCount.value,
        );
      }
    }
  }

  @override
  void dispose() {
    complaintController.dispose();
    addComplaintController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    () async {
      addComplaintController.getTicketAddressTo(addMeetingController: addMeetingController);

      complaintController.pageCount.value = 1;
      scrollController.addListener(_scrollListener);
      complaintController.complaintListData.clear();
      addComplaintController.assignList.value?.clear();
      complaintController.getComplaintList(
        page: complaintController.pageCount.value,
        dataClear: true,
        loading: true,
      );
      await addComplaintController.getUserData(userId: Pref.getUserId().toString(), loading: true);
      await addComplaintController.getUser(addMeetingController: addMeetingController);
      addComplaintController.getBranch(addMeetingController: addMeetingController);
      addComplaintController.getLeadSource();
      addComplaintController.getComplaintType();

      addComplaintController.getPriority();
    }();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Complaint',
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
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  addComplaintController.clear();
                  addComplaintController.isGetData.value = false;
                  Get.to(
                          () => const AddComplaintScreen(
                                isAddTicket: true,
                              ),
                          binding: AddComplaintBinding())!
                      .whenComplete(() {
                    complaintController.pageCount.value = 1;
                    complaintController.complaintListData.clear();
                    complaintController.getComplaintList(
                      page: complaintController.pageCount.value,
                      dataClear: true,
                      loading: true,
                    );
                  });
                },
                child: Text("Add", style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.whiteColor
                ),)/*Image.asset(
                  AppImages.plus,
                  scale: 22,
                )*/),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            // Row(
            //   children: [
            //     Obx(() {
            //       return CustomDropdown(
            //         prefixImage: AppImages.transportMode,
            //         hintText: 'Transport Mode*',
            //         items: complaintController.filterList,
            //         selectedItem: complaintController.filterListController.value,
            //         onChanged: (value) {
            //           complaintController.filterListController.value.text = value.toString();
            //         },
            //         showSearchBox: true, itemAsString:(){},
            //       );
            //     }),
            //   ],
            // ),itemAsString

            return complaintController.complaintListData.isNotEmpty
                ? ListView.separated(
                    controller: scrollController,
                    itemCount: complaintController.complaintListData.length + 1,
                    itemBuilder: (context, index) {
                      var data = index != complaintController.complaintListData.length ? complaintController.complaintListData[index] : null;
                      if (index < complaintController.complaintListData.length) {
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
                                    _buildInfoRow("Comp. ID : ", data!.complaintId, Colors.black87),
                                    _buildInfoRow("Docket No : ", data.documentNo, Colors.black87),
                                    _buildInfoRow("Customer Name : ", data.customerName, Colors.black87),
                                    _buildInfoRow("Comp. Date : ", data.compalaintDate, Colors.black87),
                                    _buildInfoRow("Comp. Status : ", data.compaintStatus, Colors.black87),
                                    _buildInfoRow("Resolution Date	 : ", data.resolutionDate, Colors.black87),
                                    _buildInfoRow("SLA in Hrs	 : ", data.slaInHr, Colors.black87),
                                    _buildInfoRow("Raised By	 : ", data.raisedBy, Colors.black87),
                                    _buildInfoRow("Assigned To	 : ", data.assignedTo, Colors.black87),
                                    _buildInfoRow("EDD	 : ", data.edd.split(" ")[0], Colors.black87),
                                    _buildInfoRow("ADD	 : ", data.addDate.split(" ")[0], Colors.black87),
                                    _buildInfoRow("Auto Closure	 : ", data.autoClosure, Colors.black87),
                                    _buildInfoRow("Delivery Status	 : ", data.deliveryStatus, Colors.black87),
                                    _buildInfoRow("Esc. Status	 : ", data.isEscalated ? "Yes" : "-", Colors.black87),
                                    data.compaintStatus != "Closed"
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    dataFill(data);
                                                    addComplaintController.isGetData.value = true;
                                                    addComplaintController.isSearch.value = false;
                                                    Get.to(() => AddComplaintScreen(isCloseTicket: true, id: data.complaintId, docketNo: data.documentNo), binding: AddComplaintBinding())!
                                                        .whenComplete(() {
                                                      complaintController.pageCount.value = 1;
                                                      complaintController.complaintListData.clear();
                                                      complaintController.getComplaintList(
                                                        page: complaintController.pageCount.value,
                                                        dataClear: true,
                                                        loading: true,
                                                      );
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green,
                                                    minimumSize: const Size(100, 40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Close Ticket",
                                                    style: AppTextStyle.regular.copyWith(fontSize: 15, color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    // await dataFill(data);
                                                    addComplaintController.assignList.value?.clear();
                                                    complaintController.pageCount.value = 1;
                                                    Get.to(() => EscalationTicketScreen(
                                                              data: data,
                                                            ))!
                                                        .whenComplete(() {
                                                      complaintController.pageCount.value = 1;
                                                      complaintController.complaintListData.clear();
                                                      complaintController.getComplaintList(
                                                        page: complaintController.pageCount.value,
                                                        dataClear: true,
                                                        loading: true,
                                                      );
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    minimumSize: const Size(100, 40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Escalation",
                                                    style: AppTextStyle.regular.copyWith(fontSize: 15, color: AppColors.whiteColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    const Divider(
                                      color: AppColors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        data.compaintStatus != "Closed"
                                            ? InkWell(
                                                onTap: () {
                                                  dataFill(data);
                                                  addComplaintController.isGetData.value = true;
                                                  addComplaintController.isSearch.value = false;
                                                  Get.to(() => AddComplaintScreen(isUpdateTicket: true, id: data.complaintId, docketNo: data.documentNo), binding: AddComplaintBinding())!
                                                      .whenComplete(() {
                                                    complaintController.pageCount.value = 1;
                                                    complaintController.complaintListData.clear();
                                                    complaintController.getComplaintList(
                                                      page: complaintController.pageCount.value,
                                                      dataClear: true,
                                                      loading: true,
                                                    );
                                                  });
                                                },
                                                child: Icon(Icons.edit, color: Colors.orange,),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => ViewComplaintScreen(
                                                      expenseId: data.complaintId,
                                                      complaint: data,
                                                      docId: data.documentNo,
                                                    ),
                                                binding: ViewComplaintBinding());
                                          },
                                          child: Icon(Icons.remove_red_eye),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (complaintController.totalCount.value != complaintController.complaintListData.length) {
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
                : complaintController.complaintListData.isEmpty && complaintController.isLoading.value == false
                    ? Center(
                        child: Image.asset(
                          AppImages.noDataFound,
                          scale: 6,
                        ),
                      )
                    : Center(child: loader());
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

  Future<void> dataFill(ComplaintListDatum data) async {
    /*   addComplaintController.assignToController.value.clearAll();
    addComplaintController.selectedEscalateTo.clear();
    final attendeeIds = data.assignToId.split(",");
    final attendeeNamesList = data.assignedTo.split(",");

    // debugPrint("attendId === ${attendeeIds}");
    // debugPrint("attendName === ${attendeeNamesList}");

    if (attendeeIds.length == attendeeNamesList.length) {
      addComplaintController.selectedEscalateTo.value = List<Assign>.generate(attendeeNamesList.length, (index) => Assign(userId: attendeeIds[index], userName: attendeeNamesList[index], emailId: ""));
    }
    //
    addComplaintController.selectedEscalateTo.value = addComplaintController.assignList.value!
        .where((assign) => attendeeIds.contains(assign.userId))
        .map((assign) => Assign(userId: assign.userId, userName: assign.userName, emailId: assign.emailId))
        .toList();

    addComplaintController.assignToController.value.selectWhere((item) {
      return addComplaintController.selectedEscalateTo.map((assign) => assign!.userId).toList().contains(item.value.userId);
    });
    addComplaintController.assignToController.refresh();*/
    /* if (data.escEmailId != "") {
      if (data.escEmailId.split(";").length == 1) {
        addComplaintController.emailIdList.add(data.escEmailId);
        debugPrint("length === ${addComplaintController.emailIdList}");
      } else {
        addComplaintController.emailIdList.value = data.escEmailId.split(";");
      }
    } else {
      addComplaintController.emailIdList.value = [];
    }*/

    addComplaintController.complaintIDController.value.text = data.complaintId;
    addComplaintController.docketNoController.value.text = data.documentNo;
    data.documentNo.isEmpty ? addComplaintController.isSearch.value = false : addComplaintController.isSearch.value = true;
    addComplaintController.isGetData.value = false;

    addComplaintController.selectedComplaintType.value = ComplaintTypeDatum(codeDesc: data.ticketType, codeId: data.type.toString(), codeType: "");
    addComplaintController.selectedComplaintSubType.value = ComplaintSubTypeDatum(codeDesc: data.ticketSubType, codeId: data.subType.toString(), codeType: "");
    addComplaintController.selectedPriority.value = LeadSource(codeDesc: data.ticketPriority, codeId: data.priority.toString(), codeType: "");
    addComplaintController.selectedSource.value = LeadSource(codeDesc: data.ticketSource, codeId: data.source.toString(), codeType: "");
    addComplaintController.selectedUser.value = User(userId: '', name: data.assignedTo);
    // addComplaintController.ticketAddressToController.value.text = data.ticketAddressTo;
    addComplaintController.selectTicketAddress.value = Branch(locCode: "", locName: data.ticketAddressTo);

    addComplaintController.descriptionController.value.text = data.description;
    addComplaintController.ticketStatusController.value.text = data.compaintStatus;
    addComplaintController.ticketDateController.value.text = addComplaintController.convertDateFormat(data.ticketDate);
    addComplaintController.updateDateController.value.text = addComplaintController.convertDateFormat(data.updateDate);
    addComplaintController.updateRemarksController.value.text = "";
    addComplaintController.billingPartyController.value.text = data.customerName;
    addComplaintController.originController.value.text = data.origin;
    addComplaintController.destinationController.value.text = data.destination;
    addComplaintController.closeByController.value.text = data.closeBy;
    addComplaintController.docDateController.value.text = addComplaintController.convertDateFormat(data.documentDate);
    addComplaintController.eDDController.value.text = addComplaintController.convertDateFormat(data.edd);
  }
}
