import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy_system/app/modules/inventory/services/unit_normalizer.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// أدوات مساعدة لتحليل وتنسيق بيانات ملفات Excel
abstract class ExcelImportHelper {
  /// استخراج القيمة النصية من الخلية بحسب نوعها في مكتبة Excel
  static String? cell(List<dynamic> row, int i) {
    if (i >= row.length) return null;
    final c = row[i];
    if (c == null) return null;

    dynamic v;
    if (c is Data) {
      v = c.value;
    } else {
      v = c;
    }
    if (v == null) return null;

    if (v is TextCellValue) {
      final str = v.value.toString().trim();
      return str.isEmpty ? null : str;
    }
    if (v is IntCellValue) {
      return v.value.toString();
    }
    if (v is DoubleCellValue) {
      final d = v.value;
      if (d.isInfinite || d.isNaN) return null;
      if (d == d.toInt()) return d.toInt().toString();
      return d.toString();
    }
    if (v is DateCellValue) {
      return '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
    }
    if (v is double) {
      if (v.isInfinite || v.isNaN) return null;
      if (v == v.toInt()) return v.toInt().toString();
      return v.toString();
    }
    final str = v.toString().trim();
    if (str.isEmpty) return null;
    return str;
  }

  /// تنظيف وتنسيق الباركود
  static String normalizeBarcode(String? barcode) {
    if (barcode == null || barcode.isEmpty) return '';
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return '';
    final parsed = double.tryParse(trimmed);
    if (parsed != null && parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return trimmed;
  }

  /// تحويل النص إلى رقم مالي مزدوج (Double) بعد إزالة الرموز
  static double parseMoney(String? text) {
    if (text == null || text.isEmpty) return 0;
    final cleaned = text
        .replaceAll('ج.م', '')
        .replaceAll('EGP', '')
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^\d.]'), '')
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  /// تحويل النص إلى تاريخ DateTime
  static DateTime? parseDate(String? text) {
    if (text == null || text.isEmpty) return null;
    final cleaned = text.trim();
    try {
      return DateTime.parse(cleaned);
    } catch (_) {
      try {
        final parts = cleaned.split(RegExp(r'[-/ ]'));
        if (parts.length >= 3) {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2].substring(0, 4));
          int hour = 0, minute = 0;
          if (cleaned.toLowerCase().contains('pm') && parts.length >= 4) {
            hour = (int.tryParse(parts[3].split(':')[0]) ?? 0) + 12;
          }
          return DateTime(year, month, day, hour, minute);
        }
      } catch (_) {}
    }
    return null;
  }

  /// حساب الكمية الذكية بناءً على الكسر المئوي/العشري ووحدات الدواء (مثل: 10.1 = 10 علب و 1 شريط)
  static int parseSmartQuantity(String text, UnitParsedInfo? unit) {
    final cleaned = text.replaceAll(',', '').replaceAll(' ', '').trim();
    final d = double.tryParse(cleaned) ?? 0;
    if (unit == null || unit.levels.isEmpty) return d.toInt();

    final whole = d.toInt();
    final fraction = (d - whole);

    if (fraction.abs() < 0.0001) {
      return whole * unit.piecesPerUnit;
    }

    final piecesInMain = unit.piecesPerUnit;
    final piecesInSub = unit.levels.length > 1 ? unit.piecesPerSubUnit : 1;

    final fractionStr = cleaned.split('.').last;
    final subCount = int.tryParse(fractionStr) ?? 0;

    return (whole * piecesInMain) + (subCount * piecesInSub);
  }

  /// فك تجميع صفوف الأكسيل من محتوى الملف (Bytes)
  static List<List<dynamic>> decodeExcelRows(Uint8List bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.values) {
        if (table.rows.isNotEmpty) return table.rows;
      }
    } catch (e) {
      safeDebugPrint('Excel decode failed: $e');
    }
    return [];
  }
}
