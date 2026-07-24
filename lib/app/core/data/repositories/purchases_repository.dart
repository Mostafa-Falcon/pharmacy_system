import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/purchases_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class PurchasesRepository {
  PurchasesDao get _dao => sl<PurchasesDao>();
  PurchasesRepository();

  static final Map<String, List<PurchaseInvoiceModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<PurchaseInvoiceModel> _cached(String branchId) =>
      List<PurchaseInvoiceModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<PurchaseInvoiceModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  PurchaseInvoiceModel _toModel(PurchaseInvoicesTableData d) {
    return PurchaseInvoiceModel.fromJson({
      'id': d.id,
      'invoice_number': d.invoiceNumber,
      'supplier_id': d.supplierId,
      'supplier_name': d.supplierName,
      'items': jsonDecode(d.items),
      'subtotal_amount': d.subtotalAmount,
      'discount_amount': d.discountAmount,
      'final_amount': d.finalAmount,
      'paid_amount': d.paidAmount,
      'remaining_amount': d.remainingAmount,
      'payment_method': d.paymentMethod,
      'created_by': d.createdBy,
      'branch_id': d.branchId,
      'account_id': d.accountId,
      'notes': d.notes,
      'created_at': d.createdAt.toIso8601String(),
      'last_modified': d.lastModified.toIso8601String(),
      'is_deleted': d.isDeleted,
      'sync_version': d.syncVersion,
    });
  }

  PurchaseInvoicesTableCompanion _toCompanion(PurchaseInvoiceModel m) {
    return PurchaseInvoicesTableCompanion(
      id: Value(m.id),
      invoiceNumber: Value(m.invoiceNumber),
      supplierId: Value(m.supplierId),
      supplierName: Value(m.supplierName),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      subtotalAmount: Value(m.subtotalAmount),
      discountAmount: Value(m.discountAmount),
      finalAmount: Value(m.finalAmount),
      paidAmount: Value(m.paidAmount),
      remainingAmount: Value(m.remainingAmount),
      paymentMethod: Value(m.paymentMethod),
      createdBy: Value(m.createdBy),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      notes: Value(m.notes),
      createdAt: Value(m.createdAt),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  Future<List<PurchaseInvoiceModel>> getPurchases({
    required String branchId,
    String? searchQuery,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getInvoicesByBranch(branchId);
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data = data.where((p) => _matchesSearch(p, q)).toList();
    }

    return data;
  }

  List<PurchaseInvoiceModel> getPurchasesSync({required String branchId}) {
    return _cached(branchId);
  }

  bool _matchesSearch(PurchaseInvoiceModel purchase, String query) {
    return purchase.invoiceNumber.toLowerCase().contains(query) ||
        purchase.supplierName.toLowerCase().contains(query) ||
        purchase.items.any((i) => i.medicineName.toLowerCase().contains(query));
  }

  Future<PurchaseInvoiceModel?> getByIdAsync(String id) async {
    final data = await _dao.getInvoiceById(id);
    return data != null ? _toModel(data) : null;
  }

  PurchaseInvoiceModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((p) => p.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(PurchaseInvoiceModel purchase, {String? branchId}) async {
    final effectiveBranchId = branchId ?? purchase.branchId;
    final model = purchase.copyWith(branchId: effectiveBranchId, lastModified: DateTime.now());
    await _dao.upsertInvoice(_toCompanion(model));
    SyncService.notifyTableUpdated('purchase_invoices', effectiveBranchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'purchase_invoices',
        data: model.toJson(),
        branchId: effectiveBranchId,
      ),
    );
  }

  Future<void> update(PurchaseInvoiceModel purchase, {String? branchId}) async {
    final effectiveBranchId = branchId ?? purchase.branchId;
    final model = purchase.copyWith(branchId: effectiveBranchId, lastModified: DateTime.now());
    await _dao.upsertInvoice(_toCompanion(model));
    SyncService.notifyTableUpdated('purchase_invoices', effectiveBranchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'purchase_invoices',
        data: model.toJson(),
        branchId: effectiveBranchId,
      ),
    );
  }

  Future<void> voidPurchase(String purchaseId, {required String branchId}) async {
    final purchase = await getByIdAsync(purchaseId);
    if (purchase == null) return;

    await ArchiveService.archiveRecord(
      entityType: 'purchase',
      entityId: purchase.id,
      entityName: 'فاتورة مشتريات #${purchase.invoiceNumber}',
      entityData: purchase.toJson(),
      branchId: branchId,
    );

    await update(purchase.copyWith(isDeleted: true), branchId: branchId);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}
