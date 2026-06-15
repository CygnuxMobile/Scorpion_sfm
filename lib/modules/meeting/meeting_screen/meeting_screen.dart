import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scorpforce/modules/meeting/meeting_screen/meeting_controller.dart';
import 'package:scorpforce/modules/meeting/meeting_screen/meeting_response_model.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_routes.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_text_style.dart';
import '../../my_call/add_my_call_screen/add_call_controller.dart';
import '../../widget/TextField.dart';
import '../../widget/button_view.dart';
import '../../widget/loader.dart';
import '../../widget/toast_message.dart';
import '../add_meeting_screen/add_meeting_binding.dart';
import '../add_meeting_screen/add_meeting_controller.dart';
import '../add_meeting_screen/add_meeting_screen.dart';
import '../add_meeting_screen/model/get_penindia_customer.dart';
import '../view_meeting_screen/view_meeting_binding.dart';
import '../view_meeting_screen/view_meeting_screen.dart';

class MyMeetingScreen extends StatefulWidget {
  const MyMeetingScreen({super.key});

  @override
  State<MyMeetingScreen> createState() => _MyMeetingScreenState();
}

class _MyMeetingScreenState extends State<MyMeetingScreen> {
  MeetingController meetingController = Get.find<MeetingController>();
  AddMeetingController addMeetingController = Get.find<AddMeetingController>();
  AddCallController addCallController = Get.find<AddCallController>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initApiCalls();
  }

  void initApiCalls() {
    meetingController.attendanceStatus();
    addMeetingController.getUser(addCallController: addCallController);
    addMeetingController.getCustomer();
    addMeetingController.getMeetingType(showLoader: true);
    addMeetingController.getBranch(showLoader: true);
    addMeetingController.getMomList(showLoader: true);

    meetingController.pageCount.value = 1;
    meetingController.meetingData.clear();

    scrollController.addListener(_scrollListener);

    loadMeetingData(isInitial: true);
  }

  Future<void> loadMeetingData({bool isInitial = false}) async {
    meetingController.getMeetingData(page: meetingController.pageCount.value, dataClear: true, loading: true, meetingDate: meetingController.dateController.value, customerName: meetingController.customerName.value);
  }

  _scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      debugPrint("Scroll end");
      if (meetingController.totalCount.value != meetingController.meetingData.length) {
        meetingController.pageCount.value++;
        meetingController.getMeetingData(page: meetingController.pageCount.value, meetingDate: meetingController.dateController.value, customerName: meetingController.customerName.value);
      }
    }
  }

  Future<void> checkGpsAndPermission(BuildContext context, Function onSuccess, int index) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      meetingController.meetingData[index].isLoading.value = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          content: const Text("Please turn on GPS to use this feature.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      meetingController.meetingData[index].isLoading.value = false;
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        meetingController.meetingData[index].isLoading.value = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            content: const Text("Please enable location permissions in settings.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );
        return;
      }
    }
    onSuccess();
  }

  @override
  void dispose() {
    addMeetingController.dispose();
    meetingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            onTap: (index) {
              if (index == 0) {
                meetingController.isShowAll.value = false;
              } else {
                meetingController.isShowAll.value = true;
              }

              meetingController.getMeetingData(page: 1, loading: true, dataClear: true, showAll: meetingController.isShowAll.value);
            },
            tabs: [
              Tab(text: "My Meetings"),
              Tab(text: "ALL Meetings"),
            ],
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'My Meeting',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  // meetingController.isSearchOnTap.isTrue
                  // meetingController.meetingData.isEmpty && meetingController.isLoading.value == false
                  meetingController.isLoading.value == false
                      ? meetingController.isSearchOnTap.isTrue
                            ? meetingController.isSearchOnTap.value = false
                            : meetingController.isSearchOnTap.value = true
                      : null;
                },
                child: const Icon(Icons.search, color: AppColors.whiteColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  addMeetingController.clear(a: addMeetingController.controller.value);
                  Get.to(const AddMeetingScreen(isMeetingScreenAdd: true))?.whenComplete(() async {
                    meetingController.pageCount.value = 1;
                    meetingController.meetingData.clear();
                    meetingController.getMeetingData(
                      page: meetingController.pageCount.value,
                      dataClear: true,
                      loading: true,
                      meetingDate: meetingController.dateController.value,
                      customerName: meetingController.customerName.value,
                    );
                  });
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                ) /*Image.asset(
                    AppImages.plus,
                    scale: 25,
                  )*/,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return Column(
                children: [
                  meetingController.isSearchOnTap.isTrue
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              commonTextField(
                                suffixIcon: meetingController.customerNameSearch.value.text.isEmpty
                                    ? SizedBox()
                                    : IconButton(
                                        onPressed: () {
                                          meetingController.customerNameSearch.refresh();
                                          if (meetingController.customerNameSearch.value.text.isEmpty) {
                                            meetingController.isSearchOnTap.value = false;
                                          } else {
                                            meetingController.customerNameSearch.value.clear();

                                            meetingController.clearSearch();
                                          }
                                        },
                                        icon: const Icon(Icons.clear, color: AppColors.redColor),
                                      ),
                                padding: 0,
                                enabledBorder: AppColors.black,
                                labelText: "Customer",
                                controller: meetingController.customerNameSearch.value,
                                textColor: AppColors.black,
                                onChange: (value) {
                                  meetingController.customerNameSearch.refresh();
                                  Future.delayed(Duration(seconds: 1), () {
                                    meetingController.onSearchChanged(value);
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Obx(() {
                      return meetingController.meetingData.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                              controller: scrollController,
                              itemCount: meetingController.meetingData.length + 1,
                              itemBuilder: (context, index) {
                                var data = index != meetingController.meetingData.length ? meetingController.meetingData[index] : null;
                                if (index < meetingController.meetingData.length) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                          child: Obx(() {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow("Customer Name : ", data!.customerName, Colors.black87),
                                                _buildInfoRow("Meeting Date : ", data.meetingDate, Colors.black87),
                                                _buildInfoRow("Start Time : ", data.startTime, Colors.black87),
                                                _buildInfoRow("End Time : ", data.endTime, Colors.black87),
                                                _buildInfoRow("Check In Time in Hrs : ", data.checkIn.value, Colors.black87),
                                                _buildInfoRow("Check Out Time in Hrs : ", data.checkOut.value, Colors.black87),
                                                _buildInfoRow("Meeting TAT in Hrs : ", data.taTinHrs.toString(), Colors.black87),
                                                _buildInfoRow("Meeting Status : ", data.meetingStatus, Colors.green),
                                                // if (DateFormat("dd/MM/yyyy").parse(data.meetingDate) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                                Obx(() {
                                                  bool isAnyCheckIn = meetingController.meetingData.any((value) => value.meeting.value == AttendanceStatus.checkOut);
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      if (data.meeting.value != AttendanceStatus.completed && meetingController.isShowAll.isFalse)
                                                        ElevatedButton(
                                                          onPressed: meetingController.meetingData[index].isLoading.isFalse
                                                              ? () async {
                                                                  bool isPunchedOut = Pref.getPunchOut() ?? false;
                                                                  if (data.meeting.value == AttendanceStatus.checkIn) {
                                                                    if (isPunchedOut) {
                                                                      toastMessage(text: "You have already checked out.");
                                                                      return;
                                                                    }
                                                                  }
                                                                  checkGpsAndPermission(context, () async {
                                                                    bool isPunchedIn = Pref.getPunchIn() ?? false;
                                                                    if (isPunchedIn) {
                                                                      meetingController.meetingData[index].isLoading.value = false;
                                                                      showDialog(
                                                                        context: Get.context!,
                                                                        barrierColor: AppColors.greyColor.withOpacity(0.7),
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            surfaceTintColor: AppColors.mediumBlackColor,
                                                                            backgroundColor: AppColors.whiteColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: const BorderSide(color: AppColors.transparentColor, width: 0.5),
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const SizedBox(height: 10),
                                                                                Image.asset(AppImages.appLogo, scale: 8),
                                                                                const SizedBox(height: 10),
                                                                                const Divider(color: AppColors.grey),
                                                                                Text(data.meeting.value == AttendanceStatus.checkIn ? "Check In" : "Check Out", style: AppTextStyle.bold.copyWith(fontSize: 20)),
                                                                                const SizedBox(height: 10),
                                                                                Text(
                                                                                  "Are you sure want to ${data.meeting.value == AttendanceStatus.checkIn ? "Check In" : "Check Out"}?",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: AppTextStyle.regular.copyWith(fontSize: 14),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            actions: [
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: commonButton(
                                                                                      name: "Cancel",
                                                                                      textColor: AppColors.primaryColor,
                                                                                      bgColor: AppColors.whiteColor,
                                                                                      borderColor: AppColors.primaryColor,
                                                                                      onTap: () {
                                                                                        meetingController.meetingData[index].isLoading.value = false;
                                                                                        Get.back();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(width: 20),
                                                                                  Obx(() {
                                                                                    return Expanded(
                                                                                      child: commonButton(
                                                                                        loaderColorWhite: true,
                                                                                        isLoader: meetingController.isCheckInOutLoading.isFalse ? false : true,
                                                                                        name: data.meeting.value == AttendanceStatus.checkIn ? "Check In" : "Check Out",
                                                                                        bgColor: AppColors.primaryColor,
                                                                                        onTap: () async {
                                                                                          double km = 0.0;
                                                                                          meetingController.isCheckInOutLoading.value = true;

                                                                                          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                                                                                          if (data.meeting.value == AttendanceStatus.checkIn) {
                                                                                            km = await meetingController.getDrivingDistance(
                                                                                              origin: "${data.previousLatitude},${data.previousLongitude}",
                                                                                              destination: "${position.latitude},${position.longitude}",
                                                                                            );

                                                                                            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$km");
                                                                                            meetingController.isCheckInOutLoading.value = false;
                                                                                          }

                                                                                          String address = await meetingController.getFullAddressFromLatLng(latitude: position.latitude, longitude: position.longitude);

                                                                                          debugPrint("========================= $address");
                                                                                          meetingController
                                                                                              .checkInOut(
                                                                                                data: {
                                                                                                  "meetingID": data.meetingId,
                                                                                                  "userID": Pref.getUserId(),
                                                                                                  "isAttendee": true,
                                                                                                  "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                                                                                  "checkIn": data.meeting.value == AttendanceStatus.checkIn ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()) : '',
                                                                                                  "checkOut": data.meeting.value == AttendanceStatus.checkOut ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()) : '',
                                                                                                  "lat": position.latitude,
                                                                                                  "lng": position.longitude,
                                                                                                  "GeoLocation": address,
                                                                                                  "attendeeCode": data.attendeeCode,
                                                                                                  "distanceInKM": km,
                                                                                                },
                                                                                                loading: true,
                                                                                                index: index,
                                                                                              )
                                                                                              .whenComplete(() {
                                                                                                meetingController.isCheckInOutLoading.value = false;
                                                                                                Get.back();
                                                                                              });
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                    /*: const Padding(
                                                                                            padding: EdgeInsets.all(8.0),
                                                                                            child: CircularProgressIndicator(
                                                                                              strokeAlign: 1,
                                                                                              color: AppColors.white,
                                                                                            ),
                                                                                          );*/
                                                                                  }),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    } else {
                                                                      meetingController.meetingData[index].isLoading.value = false;
                                                                      meetingController.isCheckInOutLoading.value = false;
                                                                      punchingDialog();
                                                                    }
                                                                  }, index);
                                                                }
                                                              : () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: AppColors.primaryColor,
                                                            minimumSize: const Size(130, 40),
                                                            maximumSize: const Size(130, 40),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                          ),
                                                          child: meetingController.meetingData[index].isLoading.isFalse
                                                              ? Text(
                                                                  data.meeting.value == AttendanceStatus.checkIn ? "Check In" : "Check Out",
                                                                  // data.isCheckInEnabled ? "Check In" : "Check Out",
                                                                  style: AppTextStyle.regular.copyWith(fontSize: 15, color: AppColors.whiteColor),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets.all(8.0),
                                                                  child: loader(loaderColor: AppColors.whiteColor),
                                                                ),
                                                        ),
                                                    ],
                                                  );
                                                }),
                                                const Divider(color: AppColors.grey),
                                                Row(
                                                  children: [
                                                    const Spacer(),
                                                    // Image.asset(
                                                    //   AppImages.check,
                                                    //   scale: 18,
                                                    // ),
                                                    const SizedBox(width: 10),
                                                    meetingController.isShowAll.isFalse
                                                        ? meetingController.meetingData[index].isExpired == false
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    addMeetingController.clear(a: addMeetingController.controller.value);
                                                                    Get.to(
                                                                      () => AddMeetingScreen(
                                                                        isEdit: true,
                                                                        isCheckInCheckOutCompleted: data.meeting.value,
                                                                        isCreator: data.meetingRole == "C" ? true : false,
                                                                        attendeeCode: data.attendeeCode,
                                                                        origin: "${data.previousLatitude},${data.previousLongitude}",
                                                                        destination: "${data.latitude},${data.longitude}",
                                                                      ),
                                                                      binding: AddMeetingBinding(),
                                                                    )?.whenComplete(() async {
                                                                      meetingController.pageCount.value = 1;
                                                                      meetingController.meetingData.clear();
                                                                      meetingController.getMeetingData(
                                                                        page: meetingController.pageCount.value,
                                                                        dataClear: true,
                                                                        loading: true,
                                                                        meetingDate: meetingController.dateController.value,
                                                                        customerName: meetingController.customerName.value,
                                                                      );
                                                                    });
                                                                  },
                                                                  child: Icon(Icons.edit, color: Colors.orange),
                                                                )
                                                              : const SizedBox()
                                                        : const SizedBox(),
                                                    const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() => ViewMeetingScreen(attendeeCode: data.attendeeCode), fullscreenDialog: true, popGesture: true, binding: ViewMeetingBinding());
                                                      },
                                                      child: Icon(Icons.remove_red_eye_outlined, color: AppColors.blueColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (meetingController.totalCount.value != meetingController.meetingData.length) {
                                  return Center(
                                    child: Container(height: 70, alignment: Alignment.center, child: loader()),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          : meetingController.meetingData.isEmpty && meetingController.isLoading.value == false
                          ? Center(child: Image.asset(AppImages.noDataFound, scale: 6))
                          : Center(child: loader());
                    }),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
    return "";
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  punchingDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                "Punching Required",
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: AppColors.grey),
            Text("You need to punch in before checking into the meeting.\nPlease do PunchIn first.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.attendanceScreen);
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 100,
              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(40)),
              child: Text("Ok", style: AppTextStyle.regular.copyWith(color: AppColors.whiteColor, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
