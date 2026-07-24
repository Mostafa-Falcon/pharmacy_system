import 'package:pharmacy_system/app/shared/constants/strings/auth_strings.dart';

class AppValidators {
  AppValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AuthStrings.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthStrings.passwordRequired;
    }
    if (value.length < 8) {
      return AuthStrings.passwordMinLength;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return AuthStrings.passwordsNotMatch;
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthStrings.nameRequired;
    }
    if (value.trim().split(' ').length < 2) {
      return GeneralStrings.atLeastTwoNames;
    }
    return null;
  }
}
