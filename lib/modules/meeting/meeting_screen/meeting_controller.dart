import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/meeting/meeting_screen/meeting_response_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_url.dart';
import '../../../main.dart';
import '../../../utils/api_handler.dart';
import '../../attendance/attendance_model.dart';
import '../../widget/toast_message.dart';
import '../add_meeting_screen/model/get_penindia_customer.dart';

enum ApiStatus { none, loading, success, error }

class MeetingController extends GetxController {
  RxList<MeetingDatum> meetingData = <MeetingDatum>[].obs;
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isCheckInOutLoading = false.obs;
  RxBool isShowAll = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  Rx<String?> dateController = Rx<String?>(DateFormat('dd/MM/yyyy').format(DateTime.now()));
  Rx<TextEditingController> customerNameSearch = TextEditingController().obs;
  Rx<String?> customerName = Rx<String?>(null);
  Rx<PanIndiaCustomer?> selectedCustomer = Rx<PanIndiaCustomer?>(null);

  Rx<ApiStatus> attendanceApiStatus = ApiStatus.none.obs;

  Rx<TextEditingController> meetingStartDate = TextEditingController().obs;
  Rx<TextEditingController> meetingEndDate = TextEditingController().obs;
  RxBool isSearchOnTap = false.obs;
  Timer? _debounce;
  String lastQuery = "";

  void onSearchChanged(String query) {
    if (query == lastQuery) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      lastQuery = query;
      pageCount.value = 1;
      getMeetingData(page: pageCount.value, dataClear: true, loading: true, customerName: lastQuery);
    });
  }

  void clearSearch() {
    customerNameSearch.value.clear();
    lastQuery = "";

    pageCount.value = 1;
    getMeetingData(page: pageCount.value, dataClear: true, loading: true);
  }

  void getMeetingData({
    required int page,
    bool loading = false,
    String? meetingDate,
    String? customerName,
    String? searchCustomer,
    bool dataClear = false,
    bool showAll = false,
  }) async {
    if (loading) {
      isLoading.value = true;
    }

    if (dataClear) {
      meetingData.clear();
    }

    var response = await ApiHandler.getRequest(
      "${ApiEndPoint.meeting}/ForMobile_ShowAllData?userid=${Pref.getUserId()}&Page=$page&PageSize=5&SearchCustomer=${customerName ?? ""}&showall=$showAll",
    );

    if (response.statusCode == 200) {
      MeetingResponseModel meetingResponseModel = meetingResponseModelFromJson(response.data);
      meetingData.addAll(meetingResponseModel.meetingData);
      meetingData.sort((a, b) => a.startTime.compareTo(b.startTime));
      meetingData.sort((a, b) {
        DateTime dateA = DateTime.parse(a.meetingDate.split("/").reversed.join("-"));
        DateTime dateB = DateTime.parse(b.meetingDate.split("/").reversed.join("-"));
        int dateComparison = dateB.compareTo(dateA);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return a.startTime.compareTo(b.startTime);
      });
      totalCount.value = meetingResponseModel.totalCount;
      if (loading) {
        isLoading.value = false;
      }
    } else {
      if (loading) {
        isLoading.value = false;
      }
    }
  }

  Future<void> checkIn({required Map data}) async {
    var response = await ApiHandler.postRequest(url: ApiEndPoint.meetingCheckIn, body: data);

    if (response.statusCode == 200) {
      toastMessage(color: AppColors.greenColor, text: "You checkedIn Successfully");
    } else {
      toastMessage(color: AppColors.redColor, text: "Something went wrong!!!");
    }
  }

  Future<void> checkInOut({required Map data, required loading, required index}) async {
    debugPrint("Data ==== ${data}");
    try {
      if (loading) {
        isCheckInOutLoading.value = true;
      }

      var response = await ApiHandler.postRequest(url: ApiEndPoint.meetingCheckInOut, body: data);

      if (response.statusCode == 200) {
        if (response.data["success"] == true) {
          if (meetingData[index].meeting.value == AttendanceStatus.checkIn) {
            meetingData[index].meeting.value = AttendanceStatus.checkOut;
            meetingData[index].checkIn.value = DateFormat('HH:mm').format(DateTime.now());

            toastMessage(color: AppColors.greenColor, text: "You checkedIn Successfully");
          } else {
            meetingData[index].meeting.value = AttendanceStatus.completed;
            meetingData[index].checkOut.value = DateFormat('HH:mm').format(DateTime.now());

            toastMessage(color: AppColors.greenColor, text: "You checkedOut Successfully");
            getMeetingData(page: 1, dataClear: true, showAll: isShowAll.value);
          }
        } else {
          toastMessage(color: AppColors.redColor, text: response.data["error"]["message"]);
        }
        if (loading) {
          // meetingData[index].isLoading.value = false;
          isCheckInOutLoading.value = false;
        }
      } else {
        toastMessage(color: AppColors.redColor, text: "Something went wrong!!!");
        if (loading) {
          // meetingData[index].isLoading.value = false;
          isCheckInOutLoading.value = false;
        }
      }
    } catch (e) {
      if (loading) {
        meetingData[index].isLoading.value = false;
      }
    }
  }

  // Future<double> getDrivingDistance({
  //   required String origin,
  //   required String destination,
  // }) async {
  //   print("0000000000000: Enter $origin : $destination");
  //
  //   final url =
  //       'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&avoid=ferries&mode=driving&key=AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA';
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       if (data['status'] == 'OK' &&
  //           data['rows'] != null &&
  //           data['rows'].isNotEmpty &&
  //           data['rows'][0]['elements'] != null &&
  //           data['rows'][0]['elements'].isNotEmpty &&
  //           data['rows'][0]['elements'][0]['status'] == 'OK') {
  //
  //         final distanceMeters = data['rows'][0]['elements'][0]['distance']['value'];
  //         return distanceMeters / 1000; // KM માં return
  //       } else {
  //         print("Distance data not found or status not OK");
  //       }
  //     } else {
  //       print("HTTP Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Failed to fetch data: $e");
  //   }
  //
  //   return 0.0;
  // }
  Future<double> getDrivingDistance({required String origin, required String destination}) async {
    ApiHandler.logger.i("Driving Distance API Enter: $origin to $destination");

    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&avoid=ferries&mode=driving&key=AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ApiHandler.logger.i("Driving Distance Response: ${response.body}");

        if (data['status'] == 'OK' &&
            data['rows'] != null &&
            data['rows'].isNotEmpty &&
            data['rows'][0]['elements'] != null &&
            data['rows'][0]['elements'].isNotEmpty &&
            data['rows'][0]['elements'][0]['status'] == 'OK') {
          final distanceMeters = data['rows'][0]['elements'][0]['distance']['value'];

          final distanceKm = distanceMeters / 1000;

          // ✅ rounding rule
          return distanceKm.round().toDouble();
        } else {
          ApiHandler.logger.e("Distance data not found or status not OK: ${data['status']}");
        }
      } else {
        ApiHandler.logger.e("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      ApiHandler.logger.e("Failed to fetch distance data: $e");
    }

    return 0.0;
  }

  Future<String> getFullAddressFromLatLng({required double latitude, required double longitude}) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json"
        "?latlng=$latitude,$longitude"
        "&key=AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA";

    final response = await ApiHandler.getRequest(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.data);

      if (data["results"] != null && data["results"].isNotEmpty) {
        return data["results"][0]["formatted_address"];
      }
    }

    return "Address not found";
  }

  Future<void> attendanceStatus() async {
    var response = await ApiHandler.getRequest("${ApiEndPoint.attendanceStatus}${Pref.getUserId()}");

    if (response.statusCode == 200) {
      AttendanceResponse attendanceResponse = attendanceResponseFromJson(response.data);
      if (attendanceResponse.success) {
        await pref!.setBool(LocalStorageKey.isPunchIn, attendanceResponse.data.isPunchIn);
        await pref!.setBool(LocalStorageKey.isPunchOut, attendanceResponse.data.isPunchOut);
      }
    }
  }
}
