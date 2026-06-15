import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting/view_meeting_screen/view_meeting_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_text_style.dart';
import '../../widget/loader.dart';


class ViewMeetingScreen extends StatefulWidget {

  final String attendeeCode;
  const ViewMeetingScreen({super.key, required this.attendeeCode});

  @override
  State<ViewMeetingScreen> createState() => _ViewMeetingScreenState();
}

class _ViewMeetingScreenState extends State<ViewMeetingScreen> {
  ViewMeetingController viewMeetingController = Get.find<ViewMeetingController>();
  @override
  void initState() {
    viewMeetingController.getMeetingViewData(id: "${widget.attendeeCode}?UserId=${Pref.getUserId()}");
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
        title: const Text(
          "Meeting Details",
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
      body: Obx(()=>viewMeetingController.isLoading.value
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
                  _buildCard("Customer Name", viewMeetingController.meetingViewData.value.customerName,AppImages.companyName),
                  _buildCard("Contact Person", viewMeetingController.meetingViewData.value.contactName,AppImages.contactName),
                  _buildCard("Contact No", viewMeetingController.meetingViewData.value.contactNo,AppImages.contactNo),
                  _buildCard("Email", viewMeetingController.meetingViewData.value.email,AppImages.email),
                  _buildCard("Lead Source", viewMeetingController.meetingViewData.value.meetingDate,AppImages.leadSource),
                  _buildCard("Add Day Event", viewMeetingController.meetingViewData.value.location,AppImages.check),
                  _buildCard("Meeting Date", viewMeetingController.meetingViewData.value.meetingDate,AppImages.meetingTime),
                  _buildCard("Meeting Type", viewMeetingController.meetingViewData.value.meetingType,AppImages.meetingType),
                  _buildCard("Start Time", viewMeetingController.meetingViewData.value.startTime,AppImages.time),
                  _buildCard("End Time", viewMeetingController.meetingViewData.value.endTime,AppImages.time),
                  _buildCard("Meeting Mom", viewMeetingController.meetingViewData.value.meetingMom,AppImages.meeting),
                  _buildCard("Attendee", viewMeetingController.meetingViewData.value.attendeeNames,AppImages.attendance),
                  _buildCard("Meeting Added By", viewMeetingController.meetingViewData.value.createdBy,AppImages.addUser),
                  _buildCard("Meeting Edited By", viewMeetingController.meetingViewData.value.modifiedBy,AppImages.modifiedBy),
                  _buildCard("Meeting Added Date", viewMeetingController.meetingViewData.value.meetingDate,AppImages.addDate),
                  _buildCard("Meeting Edit Date", viewMeetingController.meetingViewData.value.modifiedDate,AppImages.editedDate),
                  _buildCard("Meeting Address", viewMeetingController.meetingViewData.value.meetingAddress,AppImages.origin),
                  _buildCard("Check In Location", viewMeetingController.meetingViewData.value.checkInLocation,AppImages.origin),
                  _buildCard("Check Out Location", viewMeetingController.meetingViewData.value.checkOutLocation,AppImages.origin),
                  _buildCard("Check In Date", "${viewMeetingController.meetingViewData.value.meetingDate} ${viewMeetingController.meetingViewData.value.checkIn}",AppImages.date),
                  _buildCard("Check Out Date",  "${viewMeetingController.meetingViewData.value.meetingDate} ${viewMeetingController.meetingViewData.value.checkOut}",AppImages.date),
                  _buildCard("CheckIn Latitude", viewMeetingController.meetingViewData.value.latitude.toString(),AppImages.checkInMeeting),
                  _buildCard("CheckIn Longitude", viewMeetingController.meetingViewData.value.longitude.toString(),AppImages.checkInMeeting),
                  _buildCard("CheckOut Latitude", viewMeetingController.meetingViewData.value.checkOutLatitude.toString(),AppImages.checkInMeeting),
                  _buildCard("CheckOut Longitude", viewMeetingController.meetingViewData.value.checkOutLongitude.toString(),AppImages.checkInMeeting),
                  // _buildCard("Remark", viewMeetingController.meetingViewData.value.latitude.toString(),AppImages.remark),
                ],
              )),
        ),
      )),
    );
  }

  Widget _buildCard(String name, String desc,String image,) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: IntrinsicHeight(
            child: Row(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyle.regular.copyWith(fontSize: 14,color: AppColors.grey)),
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
}
