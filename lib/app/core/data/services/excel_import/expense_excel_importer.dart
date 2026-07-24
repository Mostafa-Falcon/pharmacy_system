import 'dart:async';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy_system/app/core/data/database/daos/accounting_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/shared/constants/strings/excel_strings.dart';
import 'package:uuid/uuid.dart';

import 'excel_import_helper.dart';

/// خدمة استيراد المصروفات السابقة والمالية من أكسيل
abstract class ExpenseExcelImporter {
  static Future<int> importExpensesFromExcel(
    String? filePath, {
    Uint8List? fileBytes,
    Function(double)? onProgress,
    Function(ImportStepInfo)? onStep,
  }) async {
    final branchId = AuthService.currentBranchId;
    if (branchId == null) throw Exception('No branch ID');

    final Uint8List bytes;
    if (fileBytes != null) {
      bytes = fileBytes;
    } else if (filePath != null && !kIsWeb) {
      bytes = await io.File(filePath).readAsBytes();
    } else {
      throw Exception('File path is not supported on Web');
    }
    final rows = ExcelImportHelper.decodeExcelRows(bytes);
    if (rows.length < 2) return 0;

    int headerIndex = 0;
    for (int i = 0; i < rows.length; i++) {
      final rowStr = rows[i].map((e) => e?.toString() ?? '').join(' ');
      if (rowStr.contains('تاريخ') ||
          rowStr.contains('مصروف') ||
          rowStr.contains('المبلغ')) {
        headerIndex = i;
        break;
      }
    }

    int count = 0;
    final accountingDao = sl<AccountingDao>();
    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final category = ExcelImportHelper.cell(row, 3);
      final amount = ExcelImportHelper.parseMoney(ExcelImportHelper.cell(row, 6));
      if (category == null ||
          amount <= 0 ||
          category.contains(ExcelStrings.totalRowKey)) {
        continue;
      }

      final id = const Uuid().v4();
      final expense = ExpenseModel(
        id: id,
        branchId: branchId,
        expenseNumber: i,
        expenseDate: ExcelImportHelper.parseDate(ExcelImportHelper.cell(row, 1)) ?? DateTime.now(),
        category: category,
        amount: amount,
        description: ExcelImportHelper.cell(row, 10) ?? category,
        paymentMethod: 'cash',
        createdById: AuthService.currentUser?.id ?? '',
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );
      final companion = expenseToCompanion(expense);
      await accountingDao.upsertExpense(companion);
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'expenses',
        data: expense.toJson(),
        branchId: branchId,
      );
      count++;
    }
    if (SyncService.isOnline) unawaited(SyncService.syncAll());
    return count;
  }
}

ExpensesTableCompanion expenseToCompanion(ExpenseModel m) {
  return ExpensesTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    expenseNumber: Value(m.expenseNumber),
    expenseDate: Value(m.expenseDate),
    category: Value(m.category),
    description: Value(m.description),
    amount: Value(m.amount),
    paymentMethod: Value(m.paymentMethod),
    createdById: Value(m.createdById),
    createdByName: Value(m.createdByName),
    notes: Value(m.notes),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: const Value(false),
  );
}
