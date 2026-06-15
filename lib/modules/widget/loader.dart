import 'package:flutter/material.dart';
import 'package:scorpforce/config/app_colors.dart';

Widget loader({Color? loaderColor})=> CircularProgressIndicator(
    color: loaderColor ?? AppColors.primaryColor,
    strokeWidth: 3,
    constraints: BoxConstraints(maxHeight: 25, maxWidth: 25, minWidth: 25, minHeight: 25),
  );

class Loader {
  static Widget loader({Color? loaderColor}){
    return CircularProgressIndicator(
      color: loaderColor ?? AppColors.primaryColor,
      strokeWidth: 3,
      constraints: BoxConstraints(maxHeight: 25, maxWidth: 25, minWidth: 25, minHeight: 25),
    );
  }
}