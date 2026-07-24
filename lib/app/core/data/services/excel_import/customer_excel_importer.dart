import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/import_step_info.dart';
import 'package:pharmacy_system/app/core/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:uuid/uuid.dart';

import 'excel_import_helper.dart';

class CustomerImportColumns {
  final int name,
      contactId,
      phone,
      email,
      address,
      company,
      taxId,
      creditLimit,
      discount,
      kind,
      totalDue;
  const CustomerImportColumns({
    this.name = -1,
    this.contactId = -1,
    this.phone = -1,
    this.email = -1,
    this.address = -1,
    this.company = -1,
    this.taxId = -1,
    this.creditLimit = -1,
    this.discount = -1,
    this.kind = -1,
    this.totalDue = -1,
  });
}

/// خدمة استيراد بيانات العملاء وأكوادهم وحساباتهم الافتتاحية من أكسيل
abstract class CustomerExcelImporter {
  static CustomerImportColumns _resolveColumnIndexes(List<dynamic> headerRow) {
    final names = headerRow.map((c) {
      if (c is Data) return (c.value?.toString() ?? '').toLowerCase();
      return c?.toString().toLowerCase() ?? '';
    }).toList();

    int idx(List<String> keys) {
      for (final k in keys) {
        final i = names.indexWhere((n) => n.contains(k.toLowerCase()));
        if (i >= 0) return i;
      }
      return -1;
    }

    return CustomerImportColumns(
      name: idx(ExcelStrings.colName),
      contactId: idx(ExcelStrings.colContactId),
      phone: idx(ExcelStrings.colPhone),
      email: idx(ExcelStrings.colEmail),
      address: idx(ExcelStrings.colAddress),
      company: idx(ExcelStrings.colCompany),
      taxId: idx(ExcelStrings.colTaxId),
      creditLimit: idx(ExcelStrings.colCreditLimit),
      discount: idx(ExcelStrings.colDiscount),
      kind: idx(ExcelStrings.colType),
      totalDue: idx(ExcelStrings.colTotalDue),
    );
  }

  static Future<int> importCustomersFromExcel(
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
    if (rows.isEmpty) return 0;

    int headerIndex = -1;
    for (int i = 0; i < rows.length && i < 20; i++) {
      final row = rows[i];
      final rowStr = row
          .map((e) {
            if (e is Data) return e.value?.toString().toLowerCase() ?? '';
            return e?.toString().toLowerCase() ?? '';
          })
          .join(' ');

      if (rowStr.contains('الاسم') ||
          rowStr.contains('name') ||
          rowStr.contains('الإسم') ||
          rowStr.contains('المستحق')) {
        headerIndex = i;
        break;
      }
    }

    if (headerIndex == -1) {
      safeDebugPrint('ExcelImport: Header row not found in first 20 rows');
      return 0;
    }

    final col = _resolveColumnIndexes(rows[headerIndex]);
    final customers = <CustomerModel>[];
    final ledgerEntries = <ContactLedgerModel>[];

    for (var i = headerIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final name = ExcelImportHelper.cell(row, col.name);
      if (name == null ||
          name.isEmpty ||
          name.contains(ExcelStrings.totalRowKey)) {
        continue;
      }

      final company = ExcelImportHelper.cell(row, col.company);
      final customer = CustomerModel(
        id: const Uuid().v4(),
        name: name,
        phone: ExcelImportHelper.cell(row, col.phone),
        email: ExcelImportHelper.cell(row, col.email),
        address: ExcelImportHelper.cell(row, col.address),
        notes: company != null ? 'Company: $company' : null,
        branchId: branchId,
      );
      customers.add(customer);

      double openBal = 0;
      if (col.totalDue != -1) {
        openBal = ExcelImportHelper.parseMoney(ExcelImportHelper.cell(row, col.totalDue));
      } else {
        final opIdx = rows[headerIndex].indexWhere(
          (c) => (c?.toString() ?? '').contains('افتتاحي'),
        );
        if (opIdx != -1) {
          openBal = ExcelImportHelper.parseMoney(ExcelImportHelper.cell(row, opIdx));
        }
      }

      if (openBal > 0) {
        ledgerEntries.add(
          ContactLedgerModel(
            id: const Uuid().v4(),
            contactId: customer.id,
            branchId: branchId,
            referenceNumber: 'OPN-${customer.id.substring(0, 4)}',
            transactionType: LedgerTransactionType.adjustment,
            debitAmount: openBal,
            creditAmount: 0,
            runningBalance: openBal,
            transactionDate: DateTime.now(),
          ),
        );
      }
    }

    if (customers.isNotEmpty) {
      final customersRepo = sl<CustomersRepository>();
      for (var c in customers) {
        await customersRepo.create(c);
      }

      if (ledgerEntries.isNotEmpty) {
        final dao = sl<ContactsDao>();
        final syncDao = GetIt.instance<SyncDao>();
        for (var e in ledgerEntries) {
          final companion = customerLedgerToCompanion(e);
          await dao.insertLedgerEntry(companion);
          await syncDao.enqueue(
            operation: SyncOperationType.create.name,
            tableName: 'contact_ledgers',
            recordId: e.id,
            data: json.encode(e.toJson()),
            branchId: branchId,
          );
        }
      }
      await sl<SyncEngine>().updatePendingCount();
    }
    if (SyncService.isOnline) unawaited(SyncService.syncAll());
    return customers.length;
  }
}

ContactLedgersTableCompanion customerLedgerToCompanion(ContactLedgerModel m) {
  return ContactLedgersTableCompanion(
    id: Value(m.id),
    contactId: Value(m.contactId),
    entryDate: Value(m.transactionDate),
    referenceNumber: Value(m.referenceNumber),
    entryType: Value(m.transactionType.name),
    debit: Value(m.debitAmount),
    credit: Value(m.creditAmount),
    balanceAfter: Value(m.runningBalance),
    description: Value(m.description),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );
}
