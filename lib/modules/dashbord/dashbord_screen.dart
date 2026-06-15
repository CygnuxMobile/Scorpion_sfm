import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:scorpforce/modules/dashbord/dashbord_controller.dart';
import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../config/app_routes.dart';
import '../../config/app_shared_key.dart';
import '../../config/app_text_style.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../calender/my_calender_binding.dart';
import '../calender/my_calender_screen.dart';
import '../login/login_binding.dart';
import '../login/login_screen.dart';
import '../widget/button_view.dart';
import '../widget/loader.dart';
import '../widget/toast_message.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController controller = TextEditingController();
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    dashboardController.getMenu(loading: true);
    dashboardController.attendanceStatus();
    dashboardController.getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 50, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: 180,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
                      child: Center(child: Image.asset(AppImages.appLogo, scale: 8)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("${Pref.getUserName()}", style: AppTextStyle.bold.copyWith(color: AppColors.whiteColor, fontSize: 22)),
                  if (Pref.getUserId() == "CYGNUSTEAM")
                    Text("${Pref.getUserId()}", style: AppTextStyle.semiBold.copyWith(color: AppColors.whiteColor, fontSize: 15)),
                ],
              ),
            ),
            ListTile(
              onTap: () => showLogoutDialog(),
              leading: const Icon(Icons.logout, color: AppColors.primaryColor),
              title: const Text("Logout"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Version : ${dashboardController.version}", style: const TextStyle(color: Colors.grey)),
            ),
            const Spacer(),
            if (Pref.getUserId() == "CYGNUSTEAM")
              ListTile(
                onTap: () => showDeleteDialog(),
                leading: const Icon(Icons.delete, color: AppColors.primaryColor),
                title: const Text("Delete"),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        shadowColor: AppColors.whiteColor,
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: AppColors.grey, offset: Offset(0, 2), spreadRadius: 3, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: SizedBox(
                        height: 24,
                        child: Marquee(
                          text: "👋 Welcome to ScorpForce – Your smart business companion!",
                          style: AppTextStyle.bold.copyWith(fontSize: 20, color: Colors.white),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 80.0,
                          velocity: 50.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (Pref.getUserId() == "CYGNUSTEAM") Text("${Pref.getUserId()}", style: AppTextStyle.regular.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              dashboardController.isLoading.isTrue
                  ? Expanded(child: Center(child: loader()))
                  : dashboardController.isLoading.isFalse
                  ? Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: [
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Customer", "View and manage customers", Icons.person_pin_outlined, AppRoutes.customer),
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Lead", "Follow up your leads", Icons.person_add_alt, AppRoutes.myLead),
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Meeting", "Check your meeting", Icons.calendar_today_outlined, AppRoutes.myMeeting),
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Meeting MOM", "Add meeting MOM", Icons.calendar_today_outlined, AppRoutes.myMeetingMom),
                          // if (dashboardController.isAllMenu.isTrue) buildDashboardCard("Call", "Check your calls", AppImages.call, AppRoutes.call),
                          // if (dashboardController.isAllMenu.isTrue) buildDashboardCard("Expenses", "Add your expenses", AppImages.expense, AppRoutes.expense, argument: true),
                          // if (dashboardController.isGetMenu.isTrue) buildDashboardCard("Expenses GM", "Manage general expense master", AppImages.expense, AppRoutes.expenseGeneralMaster),
                          // if (dashboardController.isAllMenu.isTrue) buildDashboardCard("Approval", "Approve expense", AppImages.expense, AppRoutes.expense, argument: false),
                          if (dashboardController.isComplainMenu.isTrue)
                            buildDashboardCard("Complaint", "Manage complaint", Icons.description_outlined, AppRoutes.complaintScreen),
                          // if (dashboardController.isAllMenu.isTrue) buildDashboardCard("Task", "Track your tasks", AppImages.task, AppRoutes.myTask),
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Calendar", "View calendar", Icons.calendar_month_outlined, null, isWidget: true),
                          if (dashboardController.isAllMenu.isTrue)
                            buildDashboardCard("Attendance", "Mark and view attendance", Icons.access_time_rounded, AppRoutes.attendanceScreen),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }

  Widget buildDashboardCard(String title, String description, IconData icon, String? routeName, {bool isWidget = false, dynamic argument}) {
    return InkWell(
      onTap: () async {
        if (!await ApiHandler.hasInternet()) {
          toastMessage(text: "No internet connection", color: AppColors.redColor);
          return;
        }

        if (isWidget) {
          Get.to(() => const MyCalenderScreen(), binding: MyCalenderBinding());
        } else {
          Get.toNamed(routeName!, arguments: argument);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),*/
            // ,
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.bold.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyle.regular.copyWith(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: Get.context!,
      barrierColor: AppColors.greyColor.withOpacity(0.7),
      builder: (_) {
        return AlertDialog(
          surfaceTintColor: AppColors.mediumBlackColor,
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.appLogo, scale: 8),
              const Divider(),
              Text("Log out", style: AppTextStyle.bold.copyWith(fontSize: 20)),
              const SizedBox(height: 10),
              Text("Are you sure you want to log out?", textAlign: TextAlign.center, style: AppTextStyle.regular.copyWith(fontSize: 14)),
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
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: commonButton(
                    name: "Log out",
                    bgColor: AppColors.primaryColor,
                    onTap: () {
                      pref!.clear();
                      Get.back();
                      Get.offAll(() => const LoginScreen(), binding: LoginBinding());
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: Get.context!,
      barrierColor: AppColors.greyColor.withOpacity(0.7),
      builder: (_) {
        return AlertDialog(
          surfaceTintColor: AppColors.mediumBlackColor,
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.appLogo, scale: 8),
              const Divider(),
              Text("Delete Account?", style: AppTextStyle.bold.copyWith(fontSize: 20)),
              const SizedBox(height: 10),
              Text("Are you sure you want to delete the account?", textAlign: TextAlign.center, style: AppTextStyle.regular.copyWith(fontSize: 14)),
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
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: commonButton(
                    name: "Delete",
                    bgColor: AppColors.primaryColor,
                    onTap: () {
                      String userId = Pref.getUserId()!;
                      pref!.clear();
                      pref!.setString(LocalStorageKey.deletedUserId, userId);
                      Get.back();
                      Get.offAll(() => const LoginScreen(), binding: LoginBinding());
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
