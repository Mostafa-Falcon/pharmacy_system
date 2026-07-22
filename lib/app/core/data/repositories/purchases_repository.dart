
import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/purchases_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class PurchasesRepository {
  PurchasesDao get _dao => sl<PurchasesDao>();
  PurchasesRepository();

  static final Map<String, List<PurchaseModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<PurchaseModel> _cached(String branchId) =>
      List<PurchaseModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<PurchaseModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  PurchaseModel _toModel(PurchasesTableData d) {
    return PurchaseModel(
      id: d.id,
      branchId: d.branchId,
      supplierName: d.supplierName,
      supplierPhone: d.supplierPhone,
      items: (jsonDecode(d.items) as List)
          .map((e) => PurchaseItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: d.totalAmount,
      discount: d.discount,
      tax: d.tax,
      finalAmount: d.finalAmount,
      paymentMethod: d.paymentMethod,
      paidAmount: d.paidAmount,
      notes: d.notes,
      createdBy: d.createdBy,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      status: d.status,
      supplierId: d.supplierId,
      sourceType: d.sourceType,
      receiptNumber: d.receiptNumber,
      shippingAmount: d.shippingAmount,
      deliveryAmount: d.deliveryAmount,
      supplierPartyType: d.supplierPartyType,
      invoiceDiscountType: d.invoiceDiscountType,
      invoiceDiscountValue: d.invoiceDiscountValue,
      invoiceDiscountAmount: d.invoiceDiscountAmount,
      invoiceTaxType: d.invoiceTaxType,
      invoiceTaxValue: d.invoiceTaxValue,
      invoiceTaxAmount: d.invoiceTaxAmount,
      paymentAccountId: d.paymentAccountId,
      paymentAccountName: d.paymentAccountName,
    );
  }

  PurchasesTableCompanion _toCompanion(PurchaseModel m) {
    return PurchasesTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      supplierName: Value(m.supplierName),
      supplierPhone: Value(m.supplierPhone),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      totalAmount: Value(m.totalAmount),
      discount: Value(m.discount),
      tax: Value(m.tax),
      finalAmount: Value(m.finalAmount),
      paymentMethod: Value(m.paymentMethod),
      paidAmount: Value(m.paidAmount),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      status: Value(m.status),
      supplierId: Value(m.supplierId),
      sourceType: Value(m.sourceType),
      receiptNumber: Value(m.receiptNumber),
      shippingAmount: Value(m.shippingAmount),
      deliveryAmount: Value(m.deliveryAmount),
      supplierPartyType: Value(m.supplierPartyType),
      invoiceDiscountType: Value(m.invoiceDiscountType),
      invoiceDiscountValue: Value(m.invoiceDiscountValue),
      invoiceDiscountAmount: Value(m.invoiceDiscountAmount),
      invoiceTaxType: Value(m.invoiceTaxType),
      invoiceTaxValue: Value(m.invoiceTaxValue),
      invoiceTaxAmount: Value(m.invoiceTaxAmount),
      paymentAccountId: Value(m.paymentAccountId),
      paymentAccountName: Value(m.paymentAccountName),
    );
  }

  Future<List<PurchaseModel>> getPurchases({
    required String branchId,
    String? searchQuery,
    String? filter,
    bool includeDeleted = false,
  }) async {
    var items = await _dao.getByBranch(branchId);
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (filter == 'today') {
      final now = DateTime.now();
      data.removeWhere((p) =>
          p.createdAt.day != now.day ||
          p.createdAt.month != now.month ||
          p.createdAt.year != now.year);
    } else if (filter == 'this_month') {
      final now = DateTime.now();
      data.removeWhere((p) =>
          p.createdAt.month != now.month || p.createdAt.year != now.year);
    } else if (filter == 'completed') {
      data.removeWhere((p) => p.status != 'completed');
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((p) => !_matchesSearch(p, q));
    }

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data;
  }

  List<PurchaseModel> getPurchasesSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<PurchaseModel>> watchPurchases(String branchId) {
    return _dao.db.select(_dao.db.purchasesTable).watch().map((rows) {
      final filtered =
          rows.where((r) => r.branchId == branchId && !r.isDeleted);
      final result = filtered.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  bool _matchesSearch(PurchaseModel purchase, String query) {
    return purchase.id.toLowerCase().contains(query) ||
        purchase.supplierName.toLowerCase().contains(query) ||
        (purchase.supplierPhone?.contains(query) ?? false) ||
        purchase.items.any((i) => i.medicineName.toLowerCase().contains(query));
  }

  Future<PurchaseModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  PurchaseModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((p) => p.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(PurchaseModel purchase) async {
    await _dao.upsert(_toCompanion(purchase));
    SyncService.onTableUpdated?.call('purchases', purchase.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'purchases',
        data: purchase.toJson(),
        branchId: purchase.branchId,
      ),
    );
  }

  Future<void> update(PurchaseModel purchase) async {
    await _dao.upsert(_toCompanion(purchase));
    SyncService.onTableUpdated?.call('purchases', purchase.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'purchases',
        data: purchase.toJson(),
        branchId: purchase.branchId,
      ),
    );
  }

  Future<void> voidPurchase(
    String purchaseId, {
    required String branchId,
  }) async {
    final purchase = await getByIdAsync(purchaseId);
    if (purchase == null) throw Exception('الفاتورة غير موجودة');

    if (purchase.status == 'completed') {
      for (final item in purchase.items) {
        await StockMutationService.adjustStock(
          medicineId: item.medicineId,
          delta: -item.quantity,
          branchId: branchId,
        );
      }
    }

    final dueAmount = purchase.remainingAmount;
    if (purchase.supplierId != null && dueAmount > 0.0001) {
      await SupplierLedgerService.recordPurchaseVoid(
        supplierId: purchase.supplierId!,
        branchId: branchId,
        purchaseId: purchaseId,
        invoiceNumber: purchaseId,
        dueAmount: double.parse(dueAmount.toStringAsFixed(2)),
        createdBy: purchase.createdBy,
      );
    }

    await ArchiveService.record(
      entityType: 'purchase',
      entityId: purchase.id,
      entityName: 'فاتورة #${purchase.id.substring(0, 8)}',
      entityData: purchase.toJson(),
      branchId: branchId,
    );

    await _dao.softDelete(purchaseId);
    SyncService.onTableUpdated?.call('purchases', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'purchases',
        data: purchase.toJson()..['is_deleted'] = true,
        branchId: branchId,
      ),
    );
  }

  Map<String, dynamic> calculateStats(List<PurchaseModel> purchases) {
    final now = DateTime.now();

    return {
      'totalCount': purchases.length,
      'totalAmount': purchases.fold(0.0, (sum, p) => sum + p.finalAmount),
      'todayCount': purchases
          .where((p) =>
              p.createdAt.day == now.day &&
              p.createdAt.month == now.month &&
              p.createdAt.year == now.year)
          .length,
      'todayAmount': purchases
          .where((p) =>
              p.createdAt.day == now.day &&
              p.createdAt.month == now.month &&
              p.createdAt.year == now.year)
          .fold(0.0, (sum, p) => sum + p.finalAmount),
      'monthCount': purchases
          .where((p) =>
              p.createdAt.month == now.month && p.createdAt.year == now.year)
          .length,
      'monthAmount': purchases
          .where((p) =>
              p.createdAt.month == now.month && p.createdAt.year == now.year)
          .fold(0.0, (sum, p) => sum + p.finalAmount),
    };
  }

  List<String> getSuppliers(String branchId) {
    final cached = _cached(branchId);
    if (cached.isNotEmpty) {
      return cached.map((p) => p.supplierName).toSet().toList()..sort();
    }
    return [];
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

