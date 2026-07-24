import 'money_helper.dart';

/// أدوات تنسيق موحّدة (فلوس + تواريخ + مدد)
class FormatUtils {
  /// تنسيق العملة الموحد: ١٢٥٠.٠٠ ج.م
  static String currency(num amount, {String currencySymbol = 'ج.م'}) =>
      MoneyHelper.format(amount, currency: currencySymbol);

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

  /// استبدال متسلسل لـ %s في القالب
  static String template(String pattern, List<dynamic> args) {
    var result = pattern;
    for (final arg in args) {
      result = result.replaceFirst('%s', arg.toString());
    }
    return result;
  }
}

String formatMoney(num amount) => FormatUtils.currency(amount);
String formatDateTime(DateTime date) => FormatUtils.dateTime(date);
String formatDate(DateTime date) => FormatUtils.date(date);
