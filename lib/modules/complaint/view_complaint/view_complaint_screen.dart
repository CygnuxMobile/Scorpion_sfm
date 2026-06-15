import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/complaint/view_complaint/view_complaint_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';
import '../complaint_screen/model/complaint_list_response.dart';

class ViewComplaintScreen extends StatefulWidget {
  final String expenseId;
  final String docId;
  final ComplaintListDatum complaint;

  const ViewComplaintScreen({super.key, required this.expenseId, required this.docId,required  this.complaint});

  @override
  State<ViewComplaintScreen> createState() => _ViewComplaintScreenState();
}

class _ViewComplaintScreenState extends State<ViewComplaintScreen> {
  ViewComplaintController viewComplaintController = Get.find<ViewComplaintController>();

  @override
  void initState() {
    // viewComplaintController.getComplaintViewData(id: widget.expenseId);
    viewComplaintController.getDocketData( docId: widget.docId,loading: true);
    viewComplaintController.getUpdateHistoryData(id: widget.expenseId);
    viewComplaintController.getEscalatedHistoryData(id: widget.expenseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'View Complaint',
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
        ),
        body: Obx(
          () => viewComplaintController.isLoading.value
              ? Center(
                  child: loader()
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            _buildCard("Complaint ID", widget.complaint.complaintId, AppImages.complaintId),
                            _buildCard("Complaint Date", widget.complaint.compalaintDate, AppImages.date),
                            _buildCard("Ticket Addressed To", widget.complaint.ticketAddressTo, AppImages.ticketLocation),
                            _buildCard("Ticket Source", widget.complaint.ticketSource, AppImages.ticketSource),
                            _buildCard("Ticket Type", widget.complaint.ticketType, AppImages.ticketType),
                            _buildCard("Ticket Sub Type", widget.complaint.ticketSubType, AppImages.ticketSubType),
                            _buildCard("Ticket Priority", widget.complaint.ticketPriority, AppImages.priority),
                            _buildCard("Ticket Description", widget.complaint.description, AppImages.taskDescription),
                            _buildCard("Closure By", widget.complaint.closeBy, AppImages.createdBy),
                            _buildCard("Closure Date", widget.complaint.closeDate, AppImages.date),
                            _buildCard("Last Update Date",  widget.complaint.updateDate, AppImages.addDate),
                            _buildCard("Last Update Remarks", widget.complaint.updateRemark, AppImages.remark),
                            _buildCard("Docket No", widget.complaint.documentNo, AppImages.docketNo),
                            _buildCard("Doc Date", viewComplaintController.docDate.value, AppImages.editedDate),
                            _buildCard("EDD", viewComplaintController.eDD.value, AppImages.edd),
                            _buildCard("Billing Party", widget.complaint.customerName, AppImages.billingPartyName),
                            _buildCard("Origin",viewComplaintController.origin.value, AppImages.origin),
                            _buildCard("Destination", viewComplaintController.destination.value, AppImages.destination),
                            _buildCard("Current Location", viewComplaintController.currentLocation.value, AppImages.geoLocation),
                            _buildCard("Assigned To", widget.complaint.assignedTo, AppImages.assignedTO),
                            _buildCard("Current Status", viewComplaintController.currentStatus.value, AppImages.taskStatus),
                            // _buildCard("Assign To", widget.complaint.assignedTo, AppImages.assignedTO),
                            // _buildCard("Escalation ID", widget.complaint.escalationId, AppImages.username),
                            // _buildCard("Escalated To/ Date", widget.complaint.escalationDate, AppImages.escalatedToDate),
                            // // _buildCard("Escalation History", viewComplaintController.expenseDetail.value.escalationHistory, AppImages.escalationHistory),
                            // _buildCard("Last Update Remarks", widget.complaint.updateRemark, AppImages.remark),
                            // _buildCard("Update History", viewComplaintController.expenseDetail.value.updateHistory, AppImages.updateHistory),
                            ExpansionTile(
                              title: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    /*Image.asset(
                                      AppImages.updateHistory,
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
                                    ),*/
                                    Text("Update History", style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              tilePadding: EdgeInsets.zero,
                              children: [
                                Table(
                                  border: TableBorder.all(color: AppColors.grey),
                                  children: [
                                    const TableRow(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            'Update By',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            'Update Date',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            'Update Remark',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ],
                                    ),
                                    ...List.generate(viewComplaintController.updateHistoryData.length, (index) {
                                      return TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.updateHistoryData[index].updateBy),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.updateHistoryData[index].updateDate),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.updateHistoryData[index].updateRemark),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                              color: AppColors.grey,
                            ),
                            ExpansionTile(
                              title: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    /*Image.asset(
                                      AppImages.escalationHistory,
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
                                    ),*/
                                    Text("Escalation History", style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              tilePadding: EdgeInsets.zero,
                              children: [
                                Table(
                                  border: TableBorder.all(color: AppColors.grey),
                                  children: [
                                    const TableRow(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                                'Escalated To',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                                'Escalated Email',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                                'Escalated Date',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ],
                                    ),
                                    ...List.generate(viewComplaintController.escalatedHistoryData.length, (index) {
                                      return TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.escalatedHistoryData[index].escalatedTo),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.escalatedHistoryData[index].escalatedEmail),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(viewComplaintController.escalatedHistoryData[index].escalatedTo),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),


                            /*  Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: Text("Update History", style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.black)),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(color:  AppColors.grey),
                              children: [
                                const TableRow(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Update By',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Update Date',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Update Remark',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                  ],
                                ),
                                ...List.generate(viewComplaintController.updateHistoryData.length, (index) {
                                  return TableRow(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.updateHistoryData[index].updateBy),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.updateHistoryData[index].updateDate),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.updateHistoryData[index].updateRemark),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: Text("Escalation History", style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.black)),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(color:  AppColors.grey),
                              children: [
                                const TableRow(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Escalated To',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Escalated Email',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Escalated Date',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    ),
                                  ],
                                ),
                                ...List.generate(viewComplaintController.escalatedHistoryData.length, (index) {
                                  return TableRow(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.escalatedHistoryData[index].escalatedTo),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.escalatedHistoryData[index].escalatedEmail),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(viewComplaintController.escalatedHistoryData[index].escalatedTo),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),*/
                          ],
                        )),
                  ),
                ),
        ));
  }

  Widget _buildCard(
    String name,
    String desc,
    String image,
  ) {
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
               /* Image.asset(
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
                )),
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
