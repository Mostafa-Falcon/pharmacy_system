import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';

import 'customer_excel_importer.dart';
import 'expense_excel_importer.dart';
import 'excel_import_helper.dart';
import 'medicine_excel_importer.dart';
import 'supplier_excel_importer.dart';

export 'customer_excel_importer.dart';
export 'expense_excel_importer.dart';
export 'excel_import_helper.dart';
export 'medicine_excel_importer.dart';
export 'supplier_excel_importer.dart';

/// Facade موحد لاستيراد بيانات الأكسيل بمختلف أنواعها في نظام الصيدلية
abstract class ExcelImportService {
  /// تفكيك وتفكيك صفوف جدول الأكسيل من المحتوى الخام
  static List<List<dynamic>> decodeExcelRows(Uint8List bytes) {
    return ExcelImportHelper.decodeExcelRows(bytes);
  }

  /// استيراد الأدوية والأصناف المخزنية
  static Future<int> importFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) {
    return MedicineExcelImporter.importFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }

  /// الاسم البديل لاستيراد الأصناف/الأدوية
  static Future<int> importProductsFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) {
    return importFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }

  /// استيراد بيانات العملاء وسجلاتهم الافتتاحية
  static Future<int> importCustomersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) {
    return CustomerExcelImporter.importCustomersFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }

  /// استيراد بيانات الموردين وسجلاتهم الافتتاحية
  static Future<int> importSuppliersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) {
    return SupplierExcelImporter.importSuppliersFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }

  /// استيراد المصروفات المالية السابقة
  static Future<int> importExpensesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) {
    return ExpenseExcelImporter.importExpensesFromExcel(
      filePath,
      fileBytes: fileBytes,
      onProgress: onProgress,
      onStep: onStep,
    );
  }

  /// استيراد المبيعات (مخطط للتطوير المستقبلي)
  static Future<int> importSalesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    return 0;
  }
}
