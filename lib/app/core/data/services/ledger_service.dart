import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';

class LedgerService {
  static final ContactsDao _contactsDao = sl<ContactsDao>();

  static Future<void> insertEntry(ContactLedgerModel entry) async {
    await _contactsDao.insertLedgerEntry(ContactLedgersTableCompanion(
      id: Value(entry.id),
      contactId: Value(entry.contactId),
      entryDate: Value(entry.transactionDate),
      referenceNumber: Value(entry.referenceNumber),
      entryType: Value(entry.transactionType.name),
      debit: Value(entry.debitAmount),
      credit: Value(entry.creditAmount),
      balanceAfter: Value(entry.runningBalance),
      description: Value(entry.description),
      branchId: Value(entry.branchId),
      accountId: Value(entry.accountId),
      syncVersion: Value(entry.syncVersion),
      lastModified: Value(entry.lastModified),
      isDeleted: Value(entry.isDeleted),
    ));

    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'contact_ledger',
      data: entry.toJson(),
      branchId: entry.branchId,
      recordId: entry.id,
    );
  }

  static Future<List<ContactLedgerModel>> getEntriesForContact(String contactId) async {
    final rows = await _contactsDao.getLedgerByContact(contactId);
    return rows.map((r) => ContactLedgerModel(
      id: r.id,
      contactId: r.contactId,
      transactionDate: r.entryDate,
      referenceNumber: r.referenceNumber,
      transactionType: LedgerTransactionType.values.firstWhere(
        (e) => e.name == r.entryType,
        orElse: () => LedgerTransactionType.adjustment,
      ),
      debitAmount: r.debit,
      creditAmount: r.credit,
      runningBalance: r.balanceAfter,
      description: r.description,
      branchId: r.branchId,
      accountId: r.accountId,
      syncVersion: r.syncVersion,
      lastModified: r.lastModified,
      isDeleted: r.isDeleted,
    )).toList();
  }

  static Future<double> getContactBalance(String contactId, String branchId) async {
    final entries = await getEntriesForContact(contactId);
    if (entries.isEmpty) return 0.0;
    return entries.first.runningBalance;
  }

  // --- Backward compatibility aliases ---
  static Future<void> insertCustomerEntry(dynamic entry) async {
    if (entry is ContactLedgerModel) await insertEntry(entry);
  }

  static Future<void> insertSupplierEntry(dynamic entry) async {
    if (entry is ContactLedgerModel) await insertEntry(entry);
  }

  static Future<double> getCustomerBalance(String customerId, String branchId) =>
      getContactBalance(customerId, branchId);

  static Future<double> getSupplierBalance(String supplierId, String branchId) =>
      getContactBalance(supplierId, branchId);

  static Future<List<ContactLedgerModel>> getCustomerEntries(String customerId, String branchId) =>
      getEntriesForContact(customerId);

  static Future<List<ContactLedgerModel>> getSupplierEntries(String supplierId, String branchId) =>
      getEntriesForContact(supplierId);
}
