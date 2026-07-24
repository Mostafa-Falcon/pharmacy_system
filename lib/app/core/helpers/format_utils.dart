import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// 🛠️ أدوات تنسيق موحّدة للمنظومة (فلوس + تواريخ + طباعة آمنة)
abstract final class FormatUtils {
  static final NumberFormat _moneyFormatter = NumberFormat('#,##0.00', 'en_US');

  // ─── تنسيق العملة ───

  /// تنسيق العملة الافتراضي: 1,250.00 ج.م
  static String currency(num value, {String currency = 'ج.م'}) =>
      '${_moneyFormatter.format(value)} $currency';

  /// تحويل النص المالي إلى رقم دقيق
  static double parseMoney(String value) {
    if (value.isEmpty) return 0;
    final normalized = value
        .replaceAll('ج.م', '')
        .replaceAll('EGP', '')
        .replaceAll('egp', '')
        .replaceAll('L.E', '')
        .replaceAll('LE', '')
        .replaceAll('٬', '')
        .replaceAll(',', '')
        .replaceAll('٫', '.')
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
    return double.tryParse(normalized) ?? 0;
  }

  // ─── تنسيق التواريخ ───

  /// تنسيق التاريخ والوقت: ٢٠٢٦-٠٧-١٥ ١٤:٣٠
  static String dateTime(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  /// تنسيق التاريخ فقط: ٢٠٢٦-٠٧-١٥
  static String date(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// مدة الوردية: "منذ ٣ س و ١٥ د"
  static String shiftDuration(DateTime openedAt) {
    final diff = DateTime.now().difference(openedAt);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) return 'منذ $hours س و $minutes د';
    return 'منذ $minutes د';
  }

  // ─── أدوات عامة ───

  /// استبدال متسلسل لـ %s في القالب
  static String template(String pattern, List<dynamic> args) {
    var result = pattern;
    for (final arg in args) {
      result = result.replaceFirst('%s', arg.toString());
    }
    return result;
  }
}

/// طباعة في الكونسول فقط في وضع التطوير
void safeDebugPrint(Object? object) {
  if (!kReleaseMode) debugPrint(object?.toString());
}

// ─── دوال مساعدة سريعة (Global Shortcuts) ───
String formatMoney(num amount) => FormatUtils.currency(amount);
String formatDateTime(DateTime date) => FormatUtils.dateTime(date);
String formatDate(DateTime date) => FormatUtils.date(date);
