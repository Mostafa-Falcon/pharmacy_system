import 'dart:async';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/mappers/mappers.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';

class LedgerService {
  static final ContactsDao _contactsDao = sl<ContactsDao>();

  static Future<void> insertEntry(ContactLedgerModel entry) async {
    await _contactsDao.insertLedgerEntry(ContactsMapper.contactLedgerToCompanion(entry));

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
    return rows.map(ContactsMapper.contactLedgerFromData).toList();
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
