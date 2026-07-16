import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/login/login_model.dart';

import '../../config/app_colors.dart';
import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../dashbord/dashbord_screen.dart';
import '../widget/toast_message.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isLoading = false.obs;
  RxBool obSecure = true.obs;
  RxString deviceId = "".obs;

  @override
  void onInit() {
    getDeviceId();
    super.onInit();
  }

  Future<String> getDeviceId() async {
    ApiHandler.logger.i("[DEVICE_ID_DEBUG] Starting device ID fetch");
    String? finalId;
    try {
      if (Platform.isAndroid) {
        // android_id package specifically retrieves Settings.Secure.ANDROID_ID
        final androidIdResult = await const AndroidId().getId();
        ApiHandler.logger.i("[DEVICE_ID_DEBUG] android_id result: $androidIdResult");

        // device_info_plus androidInfo.id is Build.ID (NOT ANDROID_ID)
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        ApiHandler.logger.i("[DEVICE_ID_DEBUG] device_info_plus id (Build.ID): ${androidInfo.id}");

        finalId = androidIdResult;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
        finalId = iosInfo.identifierForVendor;
        ApiHandler.logger.i("[DEVICE_ID_DEBUG] device_info_plus identifierForVendor: $finalId");
      }
    } catch (e, stackTrace) {
      ApiHandler.logger.e("[DEVICE_ID_DEBUG] ERROR during fetch: $e");
      ApiHandler.logger.e("[DEVICE_ID_DEBUG] STACK TRACE: $stackTrace");
      finalId = "";
    }

    finalId ??= "";
    deviceId.value = finalId;
    ApiHandler.logger.i("[DEVICE_ID_DEBUG] Final selected device ID: $finalId");
    return finalId;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      String deviceId = await getDeviceId();
      ApiHandler.logger.i("[DEVICE_ID_DEBUG] Device ID before login API: $deviceId");

      var loginBody = {
        "username": emailController.value.text,
        "password": passwordController.value.text,
        "deviceId": deviceId,
      };
      ApiHandler.logger.i("[DEVICE_ID_DEBUG] Device ID sent in API request: ${loginBody['deviceId']}");

      var response = await ApiHandler.postRequest(url: ApiEndPoint.login, body: loginBody);

      if (response.statusCode == 200) {
        if (response.data["isSuccess"] == true) {
          LoginModel loginModel = loginModelFromJson(json.encode(response.data));
          ApiHandler.logger.d("loginModel.data.designationId === ${loginModel.data.designationId}");
          await pref!.setString(LocalStorageKey.token, loginModel.data.token);
          await pref!.setString(LocalStorageKey.brcd, loginModel.data.branchCode);
          await pref!.setString(LocalStorageKey.userId, loginModel.data.userId.toLowerCase());
          ApiHandler.logger.d("UserId === ${Pref.getUserId()}");
          await pref!.setString(LocalStorageKey.userName, loginModel.data.name);
          await pref!.setString(LocalStorageKey.branchName, loginModel.data.branchName);
          await pref!.setString(LocalStorageKey.branchCode, loginModel.data.branchCode);
          await pref!.setString(LocalStorageKey.regionName, loginModel.data.reportLocName);
          await pref!.setString(LocalStorageKey.designation, loginModel.data.designation);
          await pref!.setString(LocalStorageKey.designationId, loginModel.data.designationId);
          await pref!.setString(LocalStorageKey.regionCode, loginModel.data.reportingLoc);

          isLoading.value = false;
          toastMessage(text: "Login Successfully", color: AppColors.greenColor, isTop: false);
          Get.offAll(() => DashboardScreen());
        } else {
          isLoading.value = false;
          String message = response.data["message"] ?? "Invalid Credential";
          if (message == "User name or password incorrect") {
            message = "Invalid Credentials or Device ID not registered.\nDevice ID: $deviceId";
          }
          toastMessage(text: message, color: AppColors.redColor, isTop: false);
          ApiHandler.logger.w("not done: $message");
        }
      } else {
        isLoading.value = false;
        String message = "Invalid Credential";
        if (response.data != null && response.data is Map && response.data["message"] != null) {
          message = response.data["message"];
        }
        if (message == "User name or password incorrect") {
          message = "Invalid Credentials or Device ID not registered.\nDevice ID: $deviceId";
        }
        toastMessage(text: message, color: AppColors.redColor, isTop: false);
        ApiHandler.logger.e("not done ${response.statusCode}: $message");
      }
    } catch (e, stackTrace) {
      isLoading.value = false;
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      ApiHandler.logger.e("Login Error: $e");
      ApiHandler.logger.e("STACK TRACE: $stackTrace");
    }
  }
}
