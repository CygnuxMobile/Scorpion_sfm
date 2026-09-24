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
        debugPrint("CheckInOut API Response Body: ${response.data}");
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
          String errMsg = "Something went wrong!!!";
          if (response.data["error"] != null && response.data["error"]["message"] != null) {
            errMsg = response.data["error"]["message"];
          } else if (response.data["message"] != null) {
            errMsg = response.data["message"];
          }
          toastMessage(color: AppColors.redColor, text: errMsg);
        }
        if (loading) {
          isCheckInOutLoading.value = false;
        }
      } else {
        toastMessage(color: AppColors.redColor, text: "Something went wrong!!!");
        if (loading) {
          isCheckInOutLoading.value = false;
        }
      }
    } catch (e) {
      if (loading) {
        meetingData[index].isLoading.value = false;
        isCheckInOutLoading.value = false;
      }
    }
  }

  Future<double> getDrivingDistance({required String origin, required String destination}) async {
    ApiHandler.logger.i("Driving Distance API Enter: $origin to $destination");

    List<String> originParts = origin.split(',');
    List<String> destParts = destination.split(',');
    String originLat = originParts[0];
    String originLng = originParts[1];
    String destLat = destParts[0];
    String destLng = destParts[1];

    final url = 'https://scorpion.nextapi.in/api/get/distance?api_key=zck096ek4f43bza1rscb&origin_lat=$originLat&origin_lng=$originLng&dest_lat=$destLat&dest_lng=$destLng';
    ApiHandler.logger.i("Driving Distance URL: $url");

    try {
      final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
      ApiHandler.logger.i("Driving Distance Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // ApiHandler.logger.i("Driving Distance Response: ${response.body}");

        if (data['success'] == true && data['data'] != null) {
          final distanceKm = double.tryParse(data['data']['distance_km'].toString()) ?? 0.0;
          return distanceKm.round().toDouble();
        } else {
          ApiHandler.logger.e("Distance data not found or success is false");
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
    final String url = 'https://scorpion.nextapi.in/api/get/address?lat=$latitude&lng=$longitude&api_key=zck096ek4f43bza1rscb';
    ApiHandler.logger.i("Get Address URL: $url");


    try {
      final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
      ApiHandler.logger.i("Get Address Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true && data["data"] != null) {
          return data["data"]["address"] ?? "Address not found";
        }
      }
    } catch (e) {
      ApiHandler.logger.e("Failed to fetch address: $e");
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
