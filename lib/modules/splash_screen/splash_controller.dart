import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_shared_key.dart';
import '../../main.dart';
import '../dashbord/dashbord_screen.dart';
import '../login/login_binding.dart';
import '../login/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      final String token = pref!.getString(LocalStorageKey.token) ?? "";

      debugPrint("Token === $token");
      if (token != "") {
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => const LoginScreen(), binding: LoginBinding());
      }
    });
  }
}
