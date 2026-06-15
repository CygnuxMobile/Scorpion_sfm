import 'dart:convert';

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

  Future<void> login() async {
    try {
      isLoading.value = true;
      var response = await ApiHandler.postRequest(url: ApiEndPoint.login, body: {
        "username": emailController.value.text,
        "password": passwordController.value.text,
      });

      if (response.statusCode == 200) {
        LoginModel loginModel = loginModelFromJson(json.encode(response.data));

        if (loginModel.isSuccess == true) {
          debugPrint("loginModel.data.designationId === ${loginModel.data.designationId}");
          await pref!.setString(LocalStorageKey.token, loginModel.data.token);
          await pref!.setString(LocalStorageKey.brcd, loginModel.data.branchCode);
          await pref!.setString(LocalStorageKey.userId, loginModel.data.userId.toLowerCase());
          debugPrint("UserId === ${Pref.getUserId()}");
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
        }else{
          isLoading.value = false;
          toastMessage(text: "Invalid Credential", color: AppColors.redColor, isTop: false);
          debugPrint("not done ${response.statusCode}");
        }
      } else {
        isLoading.value = false;
        toastMessage(text: "Invalid Credential", color: AppColors.redColor, isTop: false);
        debugPrint("not done ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
    }
  }
}
