import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/returns_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class SalesReturnRepository {
  ReturnsDao get _dao => sl<ReturnsDao>();
  SalesReturnRepository();

  static final Map<String, List<ReturnModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<ReturnModel> _cached(String branchId) =>
      List<ReturnModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<ReturnModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  ReturnModel _toModel(ReturnsTableData d) {
    return ReturnModel(
      id: d.id,
      branchId: d.branchId,
      saleId: d.saleId,
      purchaseId: d.purchaseId,
      items: (jsonDecode(d.items) as List)
          .map((e) => ReturnItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: d.totalAmount,
      reason: ReturnReason.values.firstWhere(
        (r) => r.name == d.reason,
        orElse: () => ReturnReason.other,
      ),
      notes: d.notes,
      createdBy: d.createdBy,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  ReturnsTableCompanion _toCompanion(ReturnModel m) {
    return ReturnsTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      saleId: Value(m.saleId),
      purchaseId: Value(m.purchaseId),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      totalAmount: Value(m.totalAmount),
      reason: Value(m.reason.name),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  Future<List<ReturnModel>> getSalesReturns({
    required String branchId,
    String? searchQuery,
    String? filter,
    bool includeDeleted = false,
  }) async {
    var items = await _dao.getByBranch(branchId);
    var data = items.map(_toModel).toList();

    // تصفية مرتجعات المبيعات فقط (saleId != null)
    data.removeWhere((r) => r.saleId == null);

    _updateCache(branchId, data);

    if (filter == 'today') {
      final now = DateTime.now();
      data.removeWhere((r) =>
          r.createdAt.day != now.day ||
          r.createdAt.month != now.month ||
          r.createdAt.year != now.year);
    } else if (filter == 'this_month') {
      final now = DateTime.now();
      data.removeWhere((r) =>
          r.createdAt.month != now.month || r.createdAt.year != now.year);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((r) => !_matchesSearch(r, q));
    }

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data;
  }

  List<ReturnModel> getSalesReturnsSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<ReturnModel>> watchSalesReturns(String branchId) {
    return _dao.db.select(_dao.db.returnsTable).watch().map((rows) {
      final filtered =
          rows.where((r) => r.branchId == branchId && !r.isDeleted);
      final result = filtered.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  bool _matchesSearch(ReturnModel returnModel, String query) {
    return returnModel.id.toLowerCase().contains(query) ||
        (returnModel.saleId?.toLowerCase().contains(query) ?? false) ||
        returnModel.items
            .any((i) => i.medicineName.toLowerCase().contains(query));
  }

  Future<ReturnModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  ReturnModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((r) => r.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(ReturnModel returnModel) async {
    await _dao.upsert(_toCompanion(returnModel));
    SyncService.onTableUpdated?.call('returns', returnModel.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'returns',
        data: returnModel.toJson(),
        branchId: returnModel.branchId,
      ),
    );
  }

  Future<void> update(ReturnModel returnModel) async {
    await _dao.upsert(_toCompanion(returnModel));
    SyncService.onTableUpdated?.call('returns', returnModel.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'returns',
        data: returnModel.toJson(),
        branchId: returnModel.branchId,
      ),
    );
  }

  Future<void> delete(
    ReturnModel returnModel, {
    required String branchId,
  }) async {
    await ArchiveService.record(
      entityType: 'return',
      entityId: returnModel.id,
      entityName: 'مرتجع #${returnModel.id.substring(0, 8)}',
      entityData: returnModel.toJson(),
      branchId: branchId,
    );

    await _dao.softDelete(returnModel.id);
    SyncService.onTableUpdated?.call('returns', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'returns',
        data: returnModel.toJson()..['is_deleted'] = true,
        branchId: branchId,
      ),
    );
  }

  Map<String, dynamic> calculateStats(List<ReturnModel> returns) {
    final now = DateTime.now();

    return {
      'totalCount': returns.length,
      'totalAmount': returns.fold(0.0, (sum, r) => sum + r.totalAmount),
      'todayCount': returns
          .where((r) =>
              r.createdAt.day == now.day &&
              r.createdAt.month == now.month &&
              r.createdAt.year == now.year)
          .length,
      'todayAmount': returns
          .where((r) =>
              r.createdAt.day == now.day &&
              r.createdAt.month == now.month &&
              r.createdAt.year == now.year)
          .fold(0.0, (sum, r) => sum + r.totalAmount),
      'monthCount': returns
          .where((r) =>
              r.createdAt.month == now.month && r.createdAt.year == now.year)
          .length,
    };
  }

  Future<void> returnStockToMedicine({
    required String medicineId,
    required int quantity,
    required String branchId,
  }) async {
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

