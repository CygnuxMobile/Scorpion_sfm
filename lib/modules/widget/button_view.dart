import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';

Widget commonButton({
  required String name,
  double? height,
  double? width,
  Color? textColor,
  Color? bgColor,
  Color? borderColor,
  double? size,
  VoidCallback? onTap,
  double? radius,
  List<Color>? gradientColor,
  isLoader = false,
  loaderColorWhite = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Center(
      child: SizedBox(
        height: Get.width > 767.00 ? height ?? 80 : height ?? 50,
        width: width ?? Get.width,
        child: Container(
          // decoration:
          //     // bgColor != null ?
          //     BoxDecoration(
          //   border: Border.all(
          //     color: borderColor ?? AppColors.transparentColor,
          //   ),
          //   borderRadius: BorderRadius.circular(radius ?? 12),
          //   // color: bgColor ?? AppColors.primaryColor,
          // ),
          decoration:BoxDecoration(
                  border: Border.all(
                    color: borderColor ?? AppColors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(radius ?? 6),
                  color: bgColor,
                ),

          child: Center(
            child: isLoader
                ? CupertinoActivityIndicator(
                    color: !loaderColorWhite ? AppColors.blackColor : AppColors.whiteColor,
                  )
                : Text(
                    name,
                    style: AppTextStyle.bold.copyWith(
                      fontSize: size ?? 16,
                      color: textColor ?? AppColors.whiteColor,
                    ),
                  ),
          ),
        ),
      ),
    ),
  );
}
