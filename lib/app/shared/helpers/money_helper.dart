import 'package:intl/intl.dart';

abstract final class MoneyHelper {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');

  /// تنسيق العملة الافتراضي: 1,250.00 ج.م
  static String format(num value, {String currency = 'ج.م'}) =>
      '${_formatter.format(value)} $currency';

  /// تنسيق العملة المخصص
  static String formatWithCurrency(num value, {String currency = 'ج.م'}) =>
      format(value, currency: currency);

  /// تحويل النص المالي إلى رقم دقيق
  static double parse(String value) {
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
}
