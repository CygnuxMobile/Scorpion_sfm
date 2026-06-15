import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scorpforce/modules/attendance/attendance_controller.dart';
import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../config/app_shared_key.dart';
import '../widget/loader.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController attendanceController = Get.find<AttendanceController>();

  @override
  void initState() {
    attendanceController.clear();
    attendanceController.attendanceStatus(loading: true);
    super.initState();
  }

  Widget buildTimeCard({
    required String label,
    required String time,
    required Color textColor,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image.asset(image, scale: 18),
          // const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }

  Future<void> checkGpsAndPermission(BuildContext context, Function onSuccess) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      attendanceController.isLoading.value = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gps_off, color: AppColors.primaryColor, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Enable GPS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
          content: const Text(
            "Please turn on GPS to use this feature.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              icon: const Icon(Icons.settings, size: 18, color: Colors.white),
              label: const Text("Go to Settings"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        attendanceController.isLoading.value = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: AppColors.primaryColor, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Permission Required",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Please enable location permissions in settings.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                icon: const Icon(Icons.settings, size: 18, color: Colors.white),
                label: const Text("Go to Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
        return;
      }
    }
    attendanceController.isLoading.value = false;
    onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (attendanceController.attendanceApiStatus.value == ApiStatus.success) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      buildTimeCard(
                        label: "Punch In Time",
                        time: attendanceController.punchInTime.value,
                        textColor: Colors.black,
                        image: AppImages.punchIn,
                      ),
                      const SizedBox(height: 10),
                      buildTimeCard(
                        label: "Punch Out Time",

                        time: attendanceController.punchOutTime.value,
                        textColor: Colors.black,
                        image: AppImages.punchOut,
                      ),
                      const SizedBox(height: 10),
                      buildTimeCard(
                        label: "Total Time",
                        time: attendanceController.totalTime.value,
                        textColor: Colors.black,
                        image: AppImages.time,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (attendanceController.isPunchedOut.isFalse) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Punch In Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: attendanceController.isLoading.value ||
                                      attendanceController.isPunchedIn.isTrue
                                  ? null
                                  : () {
                                      checkGpsAndPermission(context, () async {
                                        attendanceController.isLoading.value = true;

                                        Position position = await Geolocator.getCurrentPosition(
                                          desiredAccuracy: LocationAccuracy.high,
                                        );

                                        String address = await attendanceController.getFullAddressFromLatLng(latitude: position.latitude, longitude: position.longitude);


                                        attendanceController.attendanceApi(
                                          loading: true,
                                          data: {
                                            "userID": Pref.getUserId(),
                                            "punchInLat": position.latitude,
                                            "punchInLng": position.longitude,
                                            "punchInLocation": address,
                                          },
                                          isPunchIn: true,
                                        );
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: attendanceController.isLoading.value &&
                                      attendanceController.isPunchedIn.isFalse
                                  ? Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: loader(loaderColor: AppColors.whiteColor),
                                    )
                                  : const Text(
                                      "Punch In",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: attendanceController.isLoading.value ||
                                      attendanceController.isPunchedIn.isFalse
                                  ? null
                                  : () {
                                      var km = 0.0;
                                      checkGpsAndPermission(context, () async {
                                        attendanceController.isLoading.value = true;

                                        Position position = await Geolocator.getCurrentPosition(
                                          desiredAccuracy: LocationAccuracy.high,
                                        );

                                       km = await attendanceController.getDrivingDistance(
                                          origin:
                                              "${attendanceController.previousLatitude},${attendanceController.previousLongitude}",
                                          destination: "${position.latitude},${position.longitude}",
                                        );

                                        String address = await attendanceController.getFullAddressFromLatLng(latitude: position.latitude, longitude: position.longitude);


                                        attendanceController.attendanceApi(
                                          loading: true,
                                          data: {
                                            "userID": Pref.getUserId(),
                                            "punchOutLat": position.latitude,
                                            "punchOutLng": position.longitude,
                                            "punchOutLocation": address,
                                            "distanceInKM" : km
                                          },
                                          isPunchIn: false,
                                        );
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: attendanceController.isLoading.value &&
                                      attendanceController.isPunchedIn.isTrue
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: loader(loaderColor: AppColors.whiteColor))
                                  : const Text(
                                      "Punch Out",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              );
            } else if (attendanceController.attendanceApiStatus.value == ApiStatus.error) {
              return const Center(
                child: Text(
                  "Failed to record attendance.\n Please try again.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: loader()
              );
            }
          }),
        ),
      ),
    );
  }
}
