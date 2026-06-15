import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';

 toastMessage({text, color, isTop = false}) {
  if (text.toString().isNotEmpty) {
    Fluttertoast.showToast(
      gravity: isTop ? ToastGravity.TOP : ToastGravity.BOTTOM,
      msg: text,
      backgroundColor: AppColors.primaryColor,
      fontSize: 14,
      textColor: AppColors.whiteColor,
    );
  }
}

showSnackBar({text, color, isTop = false}) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor:  AppColors.primaryColor,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.up,
    duration: const Duration(milliseconds: 2000),
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  // return snackBar;
}
