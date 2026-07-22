import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';

class SalesRepository {
  SalesDao get _dao => sl<SalesDao>();
  SalesRepository();

  static final Map<String, List<SaleModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<SaleModel> _cached(String branchId) => List<SaleModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<SaleModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  SaleModel _toModel(SalesTableData d) {
    return SaleModel(
      id: d.id,
      branchId: d.branchId,
      customerId: d.customerId,
      customerName: d.customerName,
      items: (jsonDecode(d.items) as List)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: d.totalAmount,
      discount: d.discount,
      finalAmount: d.finalAmount,
      taxAmount: d.taxAmount,
      paymentMethod: d.paymentMethod,
      notes: d.notes,
      createdBy: d.createdBy,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      paidAmount: d.paidAmount,
      receiptNumber: d.receiptNumber,
      salesRepId: d.salesRepId,
    );
  }

  SalesTableCompanion _toCompanion(SaleModel m) {
    return SalesTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      customerId: Value(m.customerId),
      customerName: Value(m.customerName),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      totalAmount: Value(m.totalAmount),
      discount: Value(m.discount),
      finalAmount: Value(m.finalAmount),
      taxAmount: Value(m.taxAmount),
      paymentMethod: Value(m.paymentMethod),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      paidAmount: Value(m.paidAmount),
      receiptNumber: Value(m.receiptNumber),
      salesRepId: Value(m.salesRepId),
    );
  }

  Future<List<SaleModel>> getSales({
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
      data.removeWhere((s) =>
          s.createdAt.day != now.day ||
          s.createdAt.month != now.month ||
          s.createdAt.year != now.year);
    } else if (filter == 'this_month') {
      final now = DateTime.now();
      data.removeWhere((s) =>
          s.createdAt.month != now.month || s.createdAt.year != now.year);
    } else if (filter == 'credit') {
      data.removeWhere((s) => s.paymentMethod != 'credit');
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((s) => !_matchesSearch(s, q));
    }

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data;
  }

  List<SaleModel> getSalesSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<SaleModel>> watchSales(String branchId) {
    return _dao.watchByBranch(branchId).map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<SaleModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  SaleModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((s) => s.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(SaleModel sale) async {
    await _dao.upsert(_toCompanion(sale));
    SyncService.onTableUpdated?.call('sales', sale.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'sales',
        data: sale.toJson(),
        branchId: sale.branchId,
      ),
    );
  }

  Future<void> update(SaleModel sale) async {
    await _dao.upsert(_toCompanion(sale));
    SyncService.onTableUpdated?.call('sales', sale.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'sales',
        data: sale.toJson(),
        branchId: sale.branchId,
      ),
    );
  }

  bool _matchesSearch(SaleModel sale, String query) {
    return sale.id.toLowerCase().contains(query) ||
        (sale.customerName?.toLowerCase().contains(query) ?? false) ||
        sale.items.any((i) => i.medicineName.toLowerCase().contains(query));
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

