import 'package:intl/intl.dart';

abstract final class MoneyHelper {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');

  static String format(num value) => '${_formatter.format(value)} EGP';

  static String formatWithCurrency(num value, {String currency = 'EGP'}) =>
      '${_formatter.format(value)} $currency';

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
