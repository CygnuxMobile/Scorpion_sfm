import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';
import '../../utils/validator.dart';

Widget commonTextField({
  String? title,
  String? labelText,
  String? newPassValue2,
  String? startTime,
  EdgeInsetsGeometry? horizontalPadding,
  TextEditingController? controller,
  ScrollController? scrollController,
  String? validationMessage,
  bool needValidation = false,
  bool isEmailValidator = false,
  bool isPasswordValidator = false,
  bool isCardValidator = false,
  bool isCVCValidator = false,
  bool isExpiryYearValidator = false,
  bool isExpiryMonthValidator = false,
  bool isPhoneNumberValidator = false,
  bool isSamePasswordValidator = false,
  bool isUpperCaseValidator = false,
  bool obscureText = false,
  String? prefixImage,

  String? errorText,
  Widget? suffixIcon,
  Color? focusedBorderColor,
  Color? enabledBorder,
  int? maxLine,
  int? minLine,
  int? maxLength,
  bool readOnly = false,
  bool expands = false,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatters,
  Function(String v)? onChange,
  Function()? onTap,
  Color? bgColor,
  Color? textColor,
  // BorderRadius? radius,
  double? padding,
  Color? hintColor,
  TextInputAction? action,
  FocusNode? focusNode,
  ContentInsertionConfiguration? configuration,
  bool? autoFocus,
  bool? enable,
  bool isShortTextField = false,
  bool isOnlyInputCharacter = false,
  bool isOnlyInputDigits = false,
  bool isNoLeadingZero = false,
  bool isMandatory = false,
  bool isOnlyDecimal = false,
  bool isNoSpaceAllow = false,
  bool isTimeValidator = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: padding ?? 16.0),
    child: TextFormField(
      enabled: enable ?? true,
      scrollController: scrollController,
      focusNode: focusNode,
      autofocus: false,
      obscureText: obscureText,
      contentInsertionConfiguration: configuration,
      textInputAction: action,
      controller: controller,
      style: AppTextStyle.regular.copyWith(fontSize: 16, color: hintColor ?? AppColors.black),
      maxLines: maxLine,
      minLines: minLine,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.top,
      onChanged: onChange,
      expands: expands,
      onTap: onTap,
      readOnly: readOnly,
      cursorColor: AppColors.grey,
      inputFormatters:
          inputFormatters ??
          [
            NoLeadingSpacesFormatter(),
            // if (isOnlyInputCharacter) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            if (isPhoneNumberValidator) LengthLimitingTextInputFormatter(10),
            if (isUpperCaseValidator) UpperCaseTextFormatter(),
            if (isOnlyInputCharacter) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
            if (isOnlyInputDigits) FilteringTextInputFormatter.digitsOnly,
            if (isNoLeadingZero) NoLeadingZeroFormatter(),
            if (isOnlyDecimal) FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?')),
            if (isNoSpaceAllow) FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText ?? "",
        counterText: "",
        hintText: labelText ?? "",
        errorText: errorText,
        hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
        labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
        filled: true,
        contentPadding: horizontalPadding,
        fillColor: bgColor ?? AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.boderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        prefixIcon: prefixImage != null ? Image.asset(prefixImage, scale: 15) : null,
        suffixIcon: suffixIcon,
      ),
      validator: needValidation
          ? (v) {
              return TextFieldValidation.validation(
                isEmailValidator: isEmailValidator,
                isPasswordValidator: isPasswordValidator,
                isPhoneNumberValidator: isPhoneNumberValidator,
                isCVCValidator: isCVCValidator,
                isExpiryMonthValidator: isExpiryMonthValidator,
                isCardValidator: isCardValidator,
                isExpiryYearValidator: isExpiryYearValidator,
                message: validationMessage,
                value: v!.trim(),
                newPassValue2: newPassValue2,
                isSamePasswordValidator: isSamePasswordValidator,
                isTimeValidator: isTimeValidator,
                startTime: startTime,
              );
            }
          : null,
    ),
  );
}

class NoLeadingSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Disallow leading spaces
    if (newValue.text.startsWith(' ')) {
      return oldValue;
    } else if (newValue.text.startsWith('.')) {
      return oldValue;
    } else if (newValue.text.startsWith(',')) {
      return oldValue;
    }

    return newValue;
  }
}

class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '0') {
      // Prevents entering '0' as the first character
      return oldValue;
    } else if (newValue.text.startsWith('0')) {
      // Removes leading zeros
      return newValue.copyWith(
        text: newValue.text.replaceFirst(RegExp('^0+'), ''),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    } else {
      return newValue;
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
