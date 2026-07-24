class AppRegex {
  AppRegex._();
  static final RegExp email = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp phone = RegExp(r'^01[0125]\d{8}$');
  static final RegExp digitsOnly = RegExp(r'\D');
  static final RegExp whitespace = RegExp(r'\s+');
  static final RegExp arabicDiacritics = RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]');
}

class AppDurations {
  AppDurations._();
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration syncInterval = Duration(seconds: 90);
}

