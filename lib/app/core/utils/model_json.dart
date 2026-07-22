abstract final class ModelJson {
  ModelJson._();

  static String string(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static String? nullableString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  static double number(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double money(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value == null) return fallback;

    var normalized = _normalizeDigits(value.toString().trim())
        .replaceAll('ج.م', '')
        .replaceAll('EGP', '')
        .replaceAll('egp', '')
        .replaceAll('L.E', '')
        .replaceAll('LE', '')
        .replaceAll('٬', '')
        .replaceAll(',', '')
        .replaceAll('٫', '.')
        .replaceAll(RegExp(r'\s+'), '');

    var isNegative = false;
    if (normalized.startsWith('(') && normalized.endsWith(')')) {
      isNegative = true;
      normalized = normalized.substring(1, normalized.length - 1);
    }

    normalized = normalized.replaceAll(RegExp(r'[^0-9.\-]'), '');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return fallback;
    return isNegative ? -parsed.abs() : parsed;
  }

  static int integer(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int? integerFromText(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value == null) return null;

    final normalized = _normalizeDigits(value.toString());
    final match = RegExp(r'-?\d+').firstMatch(normalized);
    return match == null ? null : int.tryParse(match.group(0)!);
  }

  static String? phoneText(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toString();
    if (value is double &&
        value.isFinite &&
        value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return nullableString(value);
  }

  static String digitsOnly(dynamic value) {
    final text = phoneText(value);
    if (text == null) return '';
    return _normalizeDigits(text).replaceAll(RegExp(r'\D'), '');
  }

  static String? egyptianMobile(dynamic value) {
    var digits = digitsOnly(value);
    if (digits.startsWith('0020')) digits = digits.substring(4);
    if (digits.startsWith('20') && digits.length == 12) {
      digits = digits.substring(2);
    }
    if (digits.length == 10 && digits.startsWith('1')) digits = '0$digits';

    return RegExp(r'^01[0125]\d{8}$').hasMatch(digits) ? digits : null;
  }

  static bool boolean(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
    return fallback;
  }

  static DateTime? date(dynamic value) {
    if (value is DateTime) return value;
    if (value == null) return null;

    if (value is num) {
      final wholeDays = value.floor();
      final fraction = value - wholeDays;
      final milliseconds = (fraction * const Duration(days: 1).inMilliseconds)
          .round();
      return DateTime(
        1899,
        12,
        30,
      ).add(Duration(days: wholeDays, milliseconds: milliseconds));
    }

    final raw = _normalizeDigits(value.toString().trim());
    if (raw.isEmpty) return null;

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed;

    final dayFirstMatch = RegExp(
      r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})(?:\s+.*)?$',
    ).firstMatch(raw);
    if (dayFirstMatch != null) {
      return _safeDate(
        int.parse(dayFirstMatch.group(3)!),
        int.parse(dayFirstMatch.group(2)!),
        int.parse(dayFirstMatch.group(1)!),
      );
    }

    final yearFirstMatch = RegExp(
      r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})(?:\s+.*)?$',
    ).firstMatch(raw);
    if (yearFirstMatch != null) {
      return _safeDate(
        int.parse(yearFirstMatch.group(1)!),
        int.parse(yearFirstMatch.group(2)!),
        int.parse(yearFirstMatch.group(3)!),
      );
    }

    return null;
  }

  static List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  static DateTime? _safeDate(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final result = DateTime(year, month, day);
    if (result.year != year || result.month != month || result.day != day) {
      return null;
    }
    return result;
  }

  static String _normalizeDigits(String value) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const easternArabicIndic = '۰۱۲۳۴۵۶۷۸۹';
    var result = value;
    for (var index = 0; index < 10; index++) {
      result = result
          .replaceAll(arabicIndic[index], index.toString())
          .replaceAll(easternArabicIndic[index], index.toString());
    }
    return result;
  }
}
