import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/login/login_model.dart';

import '../../config/app_colors.dart';
import '../../config/app_shared_key.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../../utils/device_fingerprint_service.dart';
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
    _prefetchFingerprint();
    super.onInit();
  }

  /// Pre-fetch and cache the fingerprint on controller init so login() is fast.
  Future<void> _prefetchFingerprint() async {
    final fp = await DeviceFingerprintService.getStableFingerprint();
    deviceId.value = fp;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      // ── Step 1: Emulator check ─────────────────────────────────────────
      final onEmulator = await DeviceFingerprintService.isEmulator();
      if (onEmulator) {
        isLoading.value = false;
        _showBlockDialog(
          title: '🚫 Emulator Detected',
          message:
              'This app cannot be used on an emulator.\nPlease use a real device to login.',
        );
        ApiHandler.logger.w('[SECURITY] Login blocked — emulator detected');
        return;
      }

      // ── Step 2: Root / Jailbreak check ────────────────────────────────
      final isRooted = await DeviceFingerprintService.isRootedOrJailbroken();
      if (isRooted) {
        ApiHandler.logger.w('[SECURITY] Rooted / jailbroken device detected');
        // Show warning but still allow login — admin can decide to block later
        toastMessage(
          text: '⚠️ Warning: Rooted device detected. Contact your administrator.',
          color: AppColors.redColor,
          isTop: true,
        );
      }

      // ── Step 3: Get stable hardware fingerprint ───────────────────────
      final fingerprint = await DeviceFingerprintService.getStableFingerprint();
      deviceId.value = fingerprint;
      ApiHandler.logger.i('[SECURITY] Device fingerprint: $fingerprint');

      // ── Step 4: Call login API ─────────────────────────────────────────
      final loginBody = {
        "username": emailController.value.text,
        "password": passwordController.value.text,
        "deviceId": fingerprint,
      };
      ApiHandler.logger.i('[SECURITY] Login API deviceId: ${loginBody['deviceId']}');

      final response = await ApiHandler.postRequest(
        url: ApiEndPoint.login,
        body: loginBody,
      );

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
            message =
                "Invalid Credentials or Device ID not registered.\nDevice ID: $fingerprint";
          }
          toastMessage(text: message, color: AppColors.redColor, isTop: false);
          ApiHandler.logger.w("Login failed: $message");
        }
      } else {
        isLoading.value = false;
        String message = "Invalid Credential";
        if (response.data != null && response.data is Map && response.data["message"] != null) {
          message = response.data["message"];
        }
        if (message == "User name or password incorrect") {
          message =
              "Invalid Credentials or Device ID not registered.\nDevice ID: $fingerprint";
        }
        toastMessage(text: message, color: AppColors.redColor, isTop: false);
        ApiHandler.logger.e("Login failed ${response.statusCode}: $message");
      }
    } catch (e, stackTrace) {
      isLoading.value = false;
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      ApiHandler.logger.e("Login Error: $e");
      ApiHandler.logger.e("STACK TRACE: $stackTrace");
    }
  }

  /// Shows a blocking dialog when login is not allowed (e.g. emulator).
  void _showBlockDialog({required String title, required String message}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
