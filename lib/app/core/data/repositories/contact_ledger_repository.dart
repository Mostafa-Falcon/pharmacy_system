import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

/// 📖 المستودع الموحد لدفتر الأستاذ وكشوف الحسابات لجميع جهات التعامل (عملاء، موردين، جهات مزدوجة)
class ContactLedgerRepository {
  ContactsDao get _dao => sl<ContactsDao>();
  ContactLedgerRepository();

  static final Map<String, List<ContactLedgerModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<ContactLedgerModel> _cached(String contactId) =>
      List<ContactLedgerModel>.from(_cache[contactId] ?? []);

  void _updateCache(String contactId, List<ContactLedgerModel> items) {
    _cache[contactId] = items;
    _cacheTimers[contactId]?.cancel();
    _cacheTimers[contactId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(contactId);
    });
  }

  ContactLedgerModel _toModel(ContactLedgersTableData d) {
    return ContactLedgerModel(
      id: d.id,
      contactId: d.contactId,
      transactionDate: d.entryDate,
      referenceNumber: d.referenceNumber,
      transactionType: LedgerTransactionType.values.firstWhere(
        (e) => e.name == d.entryType,
        orElse: () => LedgerTransactionType.adjustment,
      ),
      debitAmount: d.debit,
      creditAmount: d.credit,
      runningBalance: d.balanceAfter,
      description: d.description,
      branchId: d.branchId,
      accountId: d.accountId,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  ContactLedgersTableCompanion _toCompanion(ContactLedgerModel m) {
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
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  Future<List<ContactLedgerModel>> getByContact(String contactId) async {
    final items = await _dao.getLedgerByContact(contactId);
    final data = items.map(_toModel).toList();
    _updateCache(contactId, data);
    return data;
  }

  List<ContactLedgerModel> getByContactSync(String contactId) {
    return _cached(contactId);
  }

  Future<List<ContactLedgerModel>> getAllLedgers() async {
    final items = await _dao.getAllContactLedgers();
    return items.map(_toModel).toList();
  }

  Future<ContactLedgerModel?> getByIdAsync(String id) async {
    final data = await _dao.getLedgerById(id);
    return data != null ? _toModel(data) : null;
  }

  Future<void> upsert(ContactLedgerModel entry) async {
    await _dao.insertLedgerEntry(_toCompanion(entry));
    SyncService.notifyTableUpdated('contact_ledger', entry.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'contact_ledger',
        data: entry.toJson(),
        branchId: entry.branchId,
      ),
    );
  }

  Future<void> softDelete(String id) async {
    await _dao.softDeleteLedger(id);
    SyncService.notifyTableUpdated('contact_ledger', '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'contact_ledger',
        data: {'id': id, 'is_deleted': true},
        branchId: '',
      ),
    );
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

// ─── Backward Compatibility Typedefs ───
typedef CustomerLedgerRepository = ContactLedgerRepository;
typedef SupplierLedgerRepository = ContactLedgerRepository;
