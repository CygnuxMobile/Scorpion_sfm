class TextFieldValidation {
  TextFieldValidation._();

  static String? validation(
      {String? value,
      String? newPassValue2,
      String? startTime,
      String? message,
      bool isEmailValidator = false,
      bool isPasswordValidator = false,
      bool isTimeValidator = false,
      bool isPhoneNumberValidator = false,
      bool isCardValidator = false,
      bool isCVCValidator = false,
      bool isExpiryYearValidator = false,
      bool isExpiryMonthValidator = false,
      bool isSamePasswordValidator = false}) {
    if (value!.isEmpty) {
      return "$message is required!";
    }

    if (isTimeValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      }
      if (startTime == null || startTime.isEmpty) {
        return "Please select Start Time first";
      }
      try {
        int startTotalMinutes = (int.parse(startTime.split(":").first) * 60) + (int.parse(startTime.split(":").last));
        int endTotalMinutes = (int.parse(value.split(":").first) * 60) + (int.parse(value.split(":").last));

        if (endTotalMinutes < startTotalMinutes + 5) {
          return "End Time must be at least 5 minutes after Start Time";
        }
      } catch (e) {
        return "Invalid time format";
      }
    }

    if (isPhoneNumberValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 10 || value.length > 10) {
        return 'Phone number must be 10 character';
      }
    }
    if (isCardValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 16) {
        return 'Card number must be 16 digit';
      }
    }
    if (isCVCValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 3) {
        return 'Enter valid CVC';
      }
    }
    if (isExpiryYearValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (value.length < 4) {
        return 'Enter valid year';
      } else if (DateTime.now().year > int.parse(value)) {
        return 'Enter valid year';
      }
    }
    if (isExpiryMonthValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      }
    }
    if (isEmailValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return 'Enter Valid $message';
      }
    }
    if (isSamePasswordValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      }
      if (value != newPassValue2!.trim()) {
        return "Please enter same confirm password";
      }
    } else if (isPasswordValidator == true) {
      if (value.isEmpty) {
        return "$message is required!";
      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
        if (value.length < 8) {
          return 'Password must have at least 8 characters';
        } else if (!value.contains(RegExp(r'[A-Za-z]'))) {
          return 'Password must have at least one alphabet characters';
        } else if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Password must have at least one number characters';
        } else if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
          return 'Password must have at least one special characters';
        }
      }
    }
    return null;
  }
}
