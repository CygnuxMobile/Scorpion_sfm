import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../attendance/attendance_model.dart';

class DashboardController extends GetxController {
  RxBool isGetMenu = false.obs;
  RxBool isAllMenu = false.obs;
  RxBool isComplainMenu = false.obs;
  RxBool isLoading = false.obs;
  RxString version = '1.1.8'.obs;

  Future<void> getMenu({bool loading = false, Map<String, dynamic>? data}) async {
    if (loading) {
      isLoading.value = true;
    }
    var response = await ApiHandler.getRequest("${ApiEndPoint.getMenu}${Pref.getUserId()}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);
      isGetMenu.value = data["data"][0]["ISSFMMASTER"];
      isAllMenu.value = data["data"][0]["SFM"] == "Y" ? true : false;
      isComplainMenu.value = data["data"][0]["COMPLAINT_MGNT"] == "Y" ? true : false;
      await pref!.setBool(LocalStorageKey.isGetMenu, data["data"][0]["ISSFMMASTER"]);
      await pref!.setBool(LocalStorageKey.isAllMenu, data["data"][0]["SFM"] == "Y" ? true : false);
      await pref!.setBool(LocalStorageKey.isComplainMenu, data["data"][0]["isComplainMenu"] == "Y" ? true : false);
      isLoading.value = false;
    } else {
      debugPrint("????????????????????????????????????Not Added");
      debugPrint("${response.statusCode}");
      isGetMenu.value = Pref.getIsMenu() ?? false;
      isAllMenu.value = Pref.getIsAllMenu() ?? false;
      isComplainMenu.value = Pref.getIsComplainMenu() ?? false;
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Pref${isGetMenu.value}");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Pref${isAllMenu.value}");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Pref${isComplainMenu.value}");
      isLoading.value = false;
    }
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

  void getVersion() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.getAppVersionData);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);
      if (Platform.isIOS) {
        Version apiVersion = Version.parse(data['data'][0]['iOS_Version']);
        Version appVersion = Version.parse(version.value);
        if (apiVersion > appVersion) {
          if (version.value != data["data"][0]["iOS_Version"]) {
            if (Pref.getToken.toString().isNotEmpty) {
              appUpdateDialog(iosUrl: data["data"][0]["iOS_Link"]);
            }
          }
        }
      } else {
        Version apiVersion = Version.parse(data['data'][0]['android_Version']);
        Version appVersion = Version.parse(version.value);
        if (apiVersion > appVersion) {
          if (version.value != data["data"][0]["android_Version"]) {
            if (Pref.getToken.toString().isNotEmpty) {
              appUpdateDialog(androidUrl: data["data"][0]["android_Link"]);
            }
          }
        }
      }
    }
  }

  void appUpdateDialog({String? iosUrl, String? androidUrl}) {
    Get.defaultDialog(
      title: 'App Update',
      backgroundColor: Colors.white,
      middleText: 'Please Update App',
      barrierDismissible: false,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: const Text('Update Now', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          pref!.clear();
          final Uri url = Uri.parse(Platform.isIOS ? iosUrl! : androidUrl!);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        },
      ),
    );
  }
}
