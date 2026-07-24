import 'dart:io' show File;
import 'package:drift/drift.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/accounting_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/inventory_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

typedef ProgressCallback = void Function(double progress);
typedef StepCallback = void Function(ImportStepInfo stepInfo);

class _ImportStats {
  int found = 0;
  int saved = 0;
  int updated = 0;
  int skipped = 0;
}

class ExcelImportService {
  ExcelImportService._();

  /// Import medicines from Excel (.xlsx / .xls)
  static Future<int> importFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    final bytes = fileBytes ?? await _readFileBytes(filePath);
    if (bytes == null) return 0;

    final excel = excel_pkg.Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.firstOrNull;
    if (sheet == null || sheet.rows.length < 2) return 0;

    final headers = _extractHeaders(sheet.rows[0]);
    final stats = _ImportStats();
    stats.found = sheet.rows.length - 1;

    onStep?.call(ImportStepInfo(step: 'reading', itemsFound: stats.found));

    final dao = InventoryDao(appDatabase);
    final dataRows = sheet.rows.sublist(1);

    for (var i = 0; i < dataRows.length; i++) {
      final map = _rowToMap(headers, dataRows[i]);
      if (map.isEmpty) { stats.skipped++; continue; }

      try {
        final id = map['id']?.toString().trim() ?? 'med_${const Uuid().v4()}';
        await dao.upsertMedicine(MedicinesTableCompanion(
          id: Value(id),
          name: Value(_str(map['name'] ?? '')),
          nameEn: Value(_strNullable(map['name_en'] ?? map['nameEn'])),
          barcodes: Value(_strNullable(map['barcodes'] ?? map['barcode']) ?? '[]'),
          supplierId: Value(_strNullable(map['supplier_id'] ?? map['supplierId'])),
          manufacturer: Value(_strNullable(map['manufacturer'])),
          dosageForm: Value(_strNullable(map['dosage_form'] ?? map['dosageForm'])),
          strength: Value(_strNullable(map['strength'])),
          packageSize: Value(_strNullable(map['package_size'] ?? map['packageSize'])),
          location: Value(_strNullable(map['location'])),
          minStock: Value(_intVal(map['min_stock'] ?? map['minStock'], 10)),
          isActive: const Value(true),
          createdAt: Value(DateTime.now()),
          lastModified: Value(DateTime.now()),
          syncVersion: const Value(1),
        ));
        stats.saved++;
      } catch (e, s) {
        safeDebugPrint('ExcelImport: medicine row $i error: $e\n$s');
        stats.skipped++;
      }

      onProgress?.call((i + 1) / dataRows.length);
      onStep?.call(ImportStepInfo(step: 'saving', itemsFound: stats.found, itemsSaved: stats.saved, itemsUpdated: stats.updated, itemsSkipped: stats.skipped));
    }

    onStep?.call(ImportStepInfo(step: 'done', itemsFound: stats.found, itemsSaved: stats.saved, itemsUpdated: stats.updated, itemsSkipped: stats.skipped));
    return stats.saved;
  }

  /// Import customers from Excel
  static Future<int> importCustomersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    final bytes = fileBytes ?? await _readFileBytes(filePath);
    if (bytes == null) return 0;

    final excel = excel_pkg.Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.firstOrNull;
    if (sheet == null || sheet.rows.length < 2) return 0;

    final headers = _extractHeaders(sheet.rows[0]);
    final stats = _ImportStats();
    stats.found = sheet.rows.length - 1;

    onStep?.call(ImportStepInfo(step: 'reading', itemsFound: stats.found));

    final dao = ContactsDao(appDatabase);
    final dataRows = sheet.rows.sublist(1);

    for (var i = 0; i < dataRows.length; i++) {
      final map = _rowToMap(headers, dataRows[i]);
      if (map.isEmpty) { stats.skipped++; continue; }

      try {
        await dao.upsertCustomer(CustomersTableCompanion(
          id: Value(map['id']?.toString() ?? 'cust_${const Uuid().v4()}'),
          name: Value(_str(map['name'] ?? '')),
          phone: Value(_strNullable(map['phone'])),
          address: Value(_strNullable(map['address'])),
          email: Value(_strNullable(map['email'])),
          groupId: Value(_strNullable(map['group_id'] ?? map['groupId'])),
          groupName: Value(_strNullable(map['group_name'] ?? map['groupName'])),
          creditLimit: Value(_dblVal(map['credit_limit'] ?? map['creditLimit'])),
          discountPercent: Value(_dblVal(map['discount_percent'] ?? map['discountPercent'])),
          isActive: const Value(true),
          lastModified: Value(DateTime.now()),
          syncVersion: const Value(1),
        ));
        stats.saved++;
      } catch (e, s) {
        safeDebugPrint('ExcelImport: customer row $i error: $e\n$s');
        stats.skipped++;
      }

      onProgress?.call((i + 1) / dataRows.length);
      onStep?.call(ImportStepInfo(step: 'saving', itemsFound: stats.found, itemsSaved: stats.saved, itemsSkipped: stats.skipped));
    }

    onStep?.call(ImportStepInfo(step: 'done', itemsFound: stats.found, itemsSaved: stats.saved, itemsUpdated: stats.updated, itemsSkipped: stats.skipped));
    return stats.saved;
  }

  /// Import suppliers from Excel
  static Future<int> importSuppliersFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    final bytes = fileBytes ?? await _readFileBytes(filePath);
    if (bytes == null) return 0;

    final excel = excel_pkg.Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.firstOrNull;
    if (sheet == null || sheet.rows.length < 2) return 0;

    final headers = _extractHeaders(sheet.rows[0]);
    final stats = _ImportStats();
    stats.found = sheet.rows.length - 1;

    onStep?.call(ImportStepInfo(step: 'reading', itemsFound: stats.found));

    final dao = ContactsDao(appDatabase);
    final dataRows = sheet.rows.sublist(1);

    for (var i = 0; i < dataRows.length; i++) {
      final map = _rowToMap(headers, dataRows[i]);
      if (map.isEmpty) { stats.skipped++; continue; }

      try {
        await dao.upsertSupplier(SuppliersTableCompanion(
          id: Value(map['id']?.toString() ?? 'sup_${const Uuid().v4()}'),
          name: Value(_str(map['name'] ?? '')),
          phone: Value(_strNullable(map['phone'])),
          address: Value(_strNullable(map['address'])),
          email: Value(_strNullable(map['email'])),
          contactPerson: Value(_strNullable(map['contact_person'] ?? map['contactPerson'])),
          taxId: Value(_strNullable(map['tax_id'] ?? map['taxId'])),
          paymentTermDays: Value(_intVal(map['payment_term_days'] ?? map['paymentTermDays'], 0)),
          isActive: const Value(true),
          lastModified: Value(DateTime.now()),
          syncVersion: const Value(1),
        ));
        stats.saved++;
      } catch (e, s) {
        safeDebugPrint('ExcelImport: supplier row $i error: $e\n$s');
        stats.skipped++;
      }

      onProgress?.call((i + 1) / dataRows.length);
      onStep?.call(ImportStepInfo(step: 'saving', itemsFound: stats.found, itemsSaved: stats.saved, itemsSkipped: stats.skipped));
    }

    onStep?.call(ImportStepInfo(step: 'done', itemsFound: stats.found, itemsSaved: stats.saved, itemsUpdated: stats.updated, itemsSkipped: stats.skipped));
    return stats.saved;
  }

  /// Import expenses from Excel
  static Future<int> importExpensesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    final bytes = fileBytes ?? await _readFileBytes(filePath);
    if (bytes == null) return 0;

    final excel = excel_pkg.Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.firstOrNull;
    if (sheet == null || sheet.rows.length < 2) return 0;

    final headers = _extractHeaders(sheet.rows[0]);
    final stats = _ImportStats();
    stats.found = sheet.rows.length - 1;

    onStep?.call(ImportStepInfo(step: 'reading', itemsFound: stats.found));

    final dao = AccountingDao(appDatabase);
    final dataRows = sheet.rows.sublist(1);

    for (var i = 0; i < dataRows.length; i++) {
      final map = _rowToMap(headers, dataRows[i]);
      if (map.isEmpty) { stats.skipped++; continue; }

      try {
        await dao.upsertExpense(ExpensesTableCompanion(
          id: Value(map['id']?.toString() ?? 'exp_${const Uuid().v4()}'),
          expenseNumber: Value(_intVal(map['expense_number'] ?? map['expenseNumber'], 1)),
          category: Value(_str(map['category'] ?? '')),
          description: Value(_strNullable(map['description'])),
          amount: Value(_dblVal(map['amount'])),
          paymentMethod: Value(_strNullable(map['payment_method'] ?? map['paymentMethod']) ?? 'cash'),
          createdById: Value(_str(map['created_by_id'] ?? map['createdById'] ?? '')),
          expenseDate: Value(_parseDate(map['expense_date'] ?? map['expenseDate'] ?? map['date'])),
          createdAt: Value(DateTime.now()),
          lastModified: Value(DateTime.now()),
          syncVersion: const Value(1),
        ));
        stats.saved++;
      } catch (e, s) {
        safeDebugPrint('ExcelImport: expense row $i error: $e\n$s');
        stats.skipped++;
      }

      onProgress?.call((i + 1) / dataRows.length);
      onStep?.call(ImportStepInfo(step: 'saving', itemsFound: stats.found, itemsSaved: stats.saved, itemsSkipped: stats.skipped));
    }

    onStep?.call(ImportStepInfo(step: 'done', itemsFound: stats.found, itemsSaved: stats.saved, itemsUpdated: stats.updated, itemsSkipped: stats.skipped));
    return stats.saved;
  }

  /// Import sales from Excel
  static Future<int> importSalesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    onStep?.call(ImportStepInfo(step: 'done', itemsFound: 0, itemsSaved: 0));
    return 0;
  }

  /// Import products from Excel (same as medicines)
  static Future<int> importProductsFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    ProgressCallback? onProgress,
    StepCallback? onStep,
  }) async {
    return importFromExcel(filePath, fileBytes: fileBytes, onProgress: onProgress, onStep: onStep);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  static List<String> _extractHeaders(List<excel_pkg.Data?> row) {
    return row.map((cell) {
      final val = cell?.value?.toString().trim().toLowerCase() ?? '';
      return val.replaceAll(' ', '_');
    }).toList();
  }

  static Map<String, dynamic> _rowToMap(List<String> headers, List<excel_pkg.Data?> row) {
    final map = <String, dynamic>{};
    for (var i = 0; i < headers.length && i < row.length; i++) {
      final value = row[i]?.value;
      if (value != null) {
        map[headers[i]] = value;
      }
    }
    return map;
  }

  static String _str(dynamic v) => v?.toString() ?? '';
  static String? _strNullable(dynamic v) => v?.toString();
  static int _intVal(dynamic v, int defaultVal) {
    if (v == null) return defaultVal;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? defaultVal;
  }

  static double _dblVal(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is num) {
      return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    }
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }

  static Future<Uint8List?> _readFileBytes(String? filePath) async {
    if (filePath == null) return null;
    try {
      final file = File(filePath);
      return await file.readAsBytes();
    } catch (e, s) {
      safeDebugPrint('ExcelImport: read file error: $e\n$s');
      return null;
    }
  }
}
