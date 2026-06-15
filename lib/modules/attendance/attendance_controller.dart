import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scorpforce/modules/attendance/attendance_model.dart';
import '../../config/app_colors.dart';
import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../widget/toast_message.dart';

enum ApiStatus { none, loading, success, error }

class AttendanceController extends GetxController {
  RxString punchInTime = '--:--:--'.obs;
  RxString punchOutTime = '--:--:--'.obs;
  RxString totalTime = '--:--:--'.obs;

  RxBool isPunchedIn = false.obs;
  RxBool isPunchedOut = false.obs;
  RxBool isLoading = false.obs;

  double previousLatitude = 0.0;
  double previousLongitude = 0.0;

  Rx<ApiStatus> attendanceApiStatus = ApiStatus.none.obs;

  clear() {
    isPunchedIn.value = false;
    isPunchedOut.value = false;
    isLoading.value = false;
  }

  Future<void> attendanceStatus({bool loading = false}) async {
    if (loading) {
      attendanceApiStatus.value = ApiStatus.loading;
    }

    DateTime? punchInDateTime;
    DateTime? punchOutDateTime;
    var response = await ApiHandler.getRequest("${ApiEndPoint.attendanceStatus}${Pref.getUserId()}");

    if (response.statusCode == 200) {
      AttendanceResponse attendanceResponse = attendanceResponseFromJson(response.data);
      if (attendanceResponse.success) {
        if (loading) {
          attendanceApiStatus.value = ApiStatus.success;
        }

        // Parse punch-in time
        if (attendanceResponse.data.isPunchIn) {
          punchInDateTime = DateFormat('MM/dd/yyyy HH:mm:ss').parse(attendanceResponse.data.punchIn);
          punchInTime.value = DateFormat('hh:mm:ss a').format(punchInDateTime);
          previousLatitude = attendanceResponse.data.previousLatitude;
          previousLongitude = attendanceResponse.data.previousLongitude;
          isPunchedIn.value = true;
          await pref!.setBool(LocalStorageKey.isPunchIn, attendanceResponse.data.isPunchIn);
          await pref!.setBool(LocalStorageKey.isPunchOut, attendanceResponse.data.isPunchOut);
          print(">>>>>>>>>>>in");
        }

        // Parse punch-out time
        if (attendanceResponse.data.isPunchOut) {
          punchOutDateTime = DateFormat('MM/dd/yyyy HH:mm:ss').parse(attendanceResponse.data.punchOut);
          punchOutTime.value = DateFormat('hh:mm:ss a').format(punchOutDateTime);
          isPunchedOut.value = true;
          await pref!.setBool(LocalStorageKey.isPunchIn, attendanceResponse.data.isPunchIn);
          await pref!.setBool(LocalStorageKey.isPunchOut, attendanceResponse.data.isPunchOut);
        }

        // Calculate total time
        if (punchInDateTime != null && punchOutDateTime != null) {
          Duration duration = punchOutDateTime.difference(punchInDateTime);
          totalTime.value =
              "${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
        }
      }
    } else {
      if (loading) {
        attendanceApiStatus.value = ApiStatus.error;
      }
    }
  }

  Future<void> attendanceApi({bool loading = false, bool isPunchIn = false, required Map<String, dynamic> data}) async {
    if (loading) {
      isLoading.value = true;
    }

    try {
      var response = await ApiHandler.postRequest(url: ApiEndPoint.attendance, body: data);

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData["success"] == true) {
          // ✅ Success case
          if (isPunchIn) {
            toastMessage(text: "Punch-in successful!", color: AppColors.greenColor);
            isPunchedIn.value = true;
          } else {
            toastMessage(text: "Punch-out successful!", color: AppColors.greenColor);
            isPunchedOut.value = true;
          }

          attendanceStatus(loading: false);
        } else {
          // ❌ API says failed → show API message
          final errorMessage = responseData["error"]?["message"] ?? "Failed to record attendance. Please try again.";
          toastMessage(text: errorMessage, color: AppColors.redColor);
        }
      } else {
        toastMessage(text: "Server error: ${response.statusCode}", color: AppColors.redColor);
      }
    } catch (e) {
      toastMessage(text: "Something went wrong: $e", color: AppColors.redColor);
    } finally {
      if (loading) {
        isLoading.value = false;
      }
    }
  }

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
          return distanceMeters / 1000; // KM માં return
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
}
