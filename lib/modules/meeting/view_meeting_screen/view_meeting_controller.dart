import 'dart:convert';
import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting/view_meeting_screen/view_meeting_response_model.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';

class ViewMeetingController extends GetxController {
  RxString checkInLocation = '--'.obs;
  RxString checkOutLocation = '--'.obs;

  Rx<MeetingViewData> meetingViewData = MeetingViewData(
    contactName: "contactName",
    address: "address",
    contactNo: "contactNo",
    email: "email",
    location: "location",
    meetingTypeId: 0,
    meetingType: "meetingType",
    leadSource: "leadSource",
    attendees: "attendees",
    attendeeNames: "attendeeNames",
    latitude: 0.0,
    longitude: 0.0,
    meetingPurpose: "meetingPurpose",
    leadId: "leadId",
    meetingId: "meetingId",
    customerName: "customerName",
    meetingDate: "meetingDate",
    geoLocation: "geoLocation",
    startTime: "startTime",
    endTime: "endTime",
    taTinHrs: 0,
    meetingStatus: "meetingStatus",
    meetingMom: "meetingMom",
    meetingLocation: "meetingLocation",
    createdBy: "createdBy",
    modifiedBy: "modifiedBy",
    createdDate: "createdDate",
    checkInLocation: 'checkInOutLocation',
    checkOutLocation: "checkOutLocation",
    meetingAddress: "meetingAddress",
    checkOutDateTime: 'checkOutDateTime',
    checkInDateTime: 'checkInDateTime',
    meetingLocationName: 'meetingLocationName',
    totalCount: 0,
    checkIn: 'checkIn',
    checkOut: 'checkOut',
    meetingTimeInMins: 0,
    isCheckInEnabled: false,
    isCheckOutEnabled: false,
    checkInReason: 'checkInReason',
    checkOutReason: 'checkOutReason',
    modifiedDate: 'modifiedDate',
    checkOutLatitude: "0.0",
    checkOutLongitude: "0.0",
  ).obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getMeetingViewData({required String id}) async {
    isLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.meeting}/$id");

    if (response.statusCode == 200) {
      ViewMeetingResponseModel callViewResponseModel =
      ViewMeetingResponseModel.fromJson(json.decode(response.data));

      meetingViewData.value = callViewResponseModel.meetingViewData;

      // Check-In
      if (callViewResponseModel.meetingViewData.latitude != 0.0 &&
          callViewResponseModel.meetingViewData.longitude != 0.0) {
        // getLatLngAddress(
        //   callViewResponseModel.meetingViewData.latitude,
        //   callViewResponseModel.meetingViewData.longitude,
        //   isCheckIn: true,
        // );
      }

// Check-Out
      if (callViewResponseModel.meetingViewData.checkOutLatitude != null &&
          callViewResponseModel.meetingViewData.checkOutLongitude != null) {
        double checkOutLat = double.tryParse(callViewResponseModel.meetingViewData.checkOutLatitude) ?? 0.0;
        double checkOutLng = double.tryParse(callViewResponseModel.meetingViewData.checkOutLongitude) ?? 0.0;

        if (checkOutLat != 0.0 && checkOutLng != 0.0) {
          // getLatLngAddress(
          //   checkOutLat,
          //   checkOutLng,
          //   isCheckIn: false,
          // );
        }
      }


      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  // void getLatLngAddress(double lat, double lng, {required bool isCheckIn}) async {
  //   try {
  //     final apiKey = "AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA";
  //     String url =
  //         "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";
  //     final response = await ApiHandler.getRequest(url);
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.data);
  //       if (data['status'] == 'OK' && data['results'].isNotEmpty) {
  //         final address = data['results'][0]['formatted_address'];
  //         print("📍 Address: $address");
  //
  //         // Assign to the right property
  //         if (isCheckIn) {
  //           checkInLocation.value = address;
  //         } else {
  //          checkOutLocation.value = address;
  //         }
  //       } else {
  //         print("⚠ No address found for the given coordinates.");
  //       }
  //     } else {
  //       print("❌ Failed to fetch location data. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("🚨 Error fetching location: $e");
  //   }
  // }

}
