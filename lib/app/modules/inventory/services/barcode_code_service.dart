import 'package:pharmacy_system/app/core/constants/logic/app_logic.dart';

enum BarcodeGenerationFormat {
  shortCode128,
  ean13,
}

abstract final class BarcodeCodeService {
  static String digitsOnly(String value) => value.replaceAll(AppRegex.digitsOnly, '');

  static String normalizePrefix(
    String value, {
    int minLength = 1,
    int maxLength = 4,
    String fallback = '20',
  }) {
    final safeMin = minLength.clamp(1, 4).toInt();
    final safeMax = maxLength.clamp(safeMin, 4).toInt();
    final digits = digitsOnly(value);
    final fallbackDigits = digitsOnly(fallback);
    final source = digits.isNotEmpty
        ? digits
        : (fallbackDigits.isNotEmpty ? fallbackDigits : '20');
    final clipped = source.substring(0, source.length.clamp(1, safeMax).toInt());
    return clipped.length >= safeMin
        ? clipped
        : clipped.padRight(safeMin, '0');
  }

  static String pharmacySignaturePrefix(String pharmacyName) {
    final normalized = pharmacyName
        .trim()
        .toLowerCase()
        .replaceAll(AppRegex.whitespace, ' ');
    if (normalized.isEmpty) return '2000';

    var hash = 2166136261;
    for (final codeUnit in normalized.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 16777619) & 0x7fffffff;
    }
    return '2${(hash % 1000).toString().padLeft(3, '0')}';
  }

  static int maxSerial({
    required BarcodeGenerationFormat format,
    required String prefix,
    int shortCodeLength = 8,
  }) {
    final normalizedPrefix = normalizePrefix(prefix);
    final safeLength = shortCodeLength.clamp(6, 12).toInt();
    final serialDigits = switch (format) {
      BarcodeGenerationFormat.ean13 => 12 - normalizedPrefix.length,
      BarcodeGenerationFormat.shortCode128 =>
        safeLength - normalizedPrefix.length,
    };
    if (serialDigits < 1) return 0;
    return int.parse(List<String>.filled(serialDigits, '9').join());
  }

  static String fromSerial({
    required int serial,
    required BarcodeGenerationFormat format,
    required String prefix,
    int shortCodeLength = 8,
  }) {
    final normalizedPrefix = normalizePrefix(prefix);
    final safeLength = shortCodeLength.clamp(6, 12).toInt();
    final max = maxSerial(
      format: format,
      prefix: normalizedPrefix,
      shortCodeLength: safeLength,
    );
    if (serial < 1 || serial > max) {
      throw ArgumentError.value(serial, 'serial', 'Out of barcode serial range.');
    }

    switch (format) {
      case BarcodeGenerationFormat.shortCode128:
        final serialDigits = safeLength - normalizedPrefix.length;
        return '$normalizedPrefix${serial.toString().padLeft(serialDigits, '0')}';
      case BarcodeGenerationFormat.ean13:
        final serialDigits = 12 - normalizedPrefix.length;
        final body =
            '$normalizedPrefix${serial.toString().padLeft(serialDigits, '0')}';
        return '$body${ean13CheckDigit(body)}';
    }
  }

  static int? serialFromCode(
    String value, {
    required BarcodeGenerationFormat format,
    required String prefix,
    int shortCodeLength = 8,
  }) {
    final code = digitsOnly(value);
    final normalizedPrefix = normalizePrefix(prefix);
    if (!code.startsWith(normalizedPrefix)) return null;

    switch (format) {
      case BarcodeGenerationFormat.shortCode128:
        final safeLength = shortCodeLength.clamp(6, 12).toInt();
        if (code.length != safeLength) return null;
        return int.tryParse(code.substring(normalizedPrefix.length));
      case BarcodeGenerationFormat.ean13:
        if (!isValidEan13(code)) return null;
        return int.tryParse(
          code.substring(normalizedPrefix.length, code.length - 1),
        );
    }
  }

  static int ean13CheckDigit(String twelveDigits) {
    final body = digitsOnly(twelveDigits);
    if (body.length != 12) {
      throw ArgumentError.value(
        twelveDigits,
        'twelveDigits',
        'EAN-13 check digit requires exactly 12 digits.',
      );
    }
    var sum = 0;
    for (var index = 0; index < body.length; index++) {
      final digit = int.parse(body[index]);
      sum += digit * (index.isEven ? 1 : 3);
    }
    return (10 - (sum % 10)) % 10;
  }

  static bool isValidEan13(String value) {
    final digits = digitsOnly(value);
    if (digits.length != 13) return false;
    return ean13CheckDigit(digits.substring(0, 12)) ==
        int.parse(digits.substring(12));
  }
}

