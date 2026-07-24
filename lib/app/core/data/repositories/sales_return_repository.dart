import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/sales/invoice_return_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

class SalesReturnRepository {
  SalesDao get _dao => sl<SalesDao>();
  SalesReturnRepository();

  static final Map<String, List<InvoiceReturnModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<InvoiceReturnModel> _cached(String branchId) =>
      List<InvoiceReturnModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<InvoiceReturnModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  InvoiceReturnModel _toModel(InvoiceReturnsTableData d) {
    return InvoiceReturnModel.fromJson({
      'id': d.id,
      'return_number': d.returnNumber,
      'original_invoice_number': d.originalInvoiceNumber,
      'original_invoice_id': d.originalInvoiceId,
      'customer_name': d.customerName,
      'customer_id': d.customerId,
      'items': jsonDecode(d.items),
      'return_discount': d.returnDiscount,
      'total_return_amount': d.totalReturnAmount,
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

  InvoiceReturnsTableCompanion _toCompanion(InvoiceReturnModel m) {
    return InvoiceReturnsTableCompanion(
      id: Value(m.id),
      returnNumber: Value(m.returnNumber),
      originalInvoiceNumber: Value(m.originalInvoiceNumber),
      originalInvoiceId: Value(m.originalInvoiceId),
      customerName: Value(m.customerName),
      customerId: Value(m.customerId),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      returnDiscount: Value(m.returnDiscount),
      totalReturnAmount: Value(m.totalReturnAmount),
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

  Future<List<InvoiceReturnModel>> getSalesReturns({
    required String branchId,
    String? searchQuery,
    String? filter,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getInvoiceReturns(branchId);
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (filter == 'today') {
      final now = DateTime.now();
      data = data
          .where(
            (r) =>
                r.createdAt.day == now.day &&
                r.createdAt.month == now.month &&
                r.createdAt.year == now.year,
          )
          .toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data = data.where((r) => _matchesSearch(r, q)).toList();
    }

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data;
  }

  List<InvoiceReturnModel> getSalesReturnsSync({required String branchId}) {
    return _cached(branchId);
  }

  bool _matchesSearch(InvoiceReturnModel returnModel, String query) {
    return returnModel.returnNumber.toLowerCase().contains(query) ||
        returnModel.originalInvoiceNumber.toLowerCase().contains(query) ||
        returnModel.customerName.toLowerCase().contains(query);
  }

  Future<InvoiceReturnModel?> getByIdAsync(String id) async {
    // SalesDao needs a getReturnById if needed
    return null;
  }

  Future<void> create(InvoiceReturnModel returnModel) async {
    final model = returnModel.copyWith(lastModified: DateTime.now());
    await _dao.upsertInvoiceReturn(_toCompanion(model));
    SyncService.notifyTableUpdated('invoice_returns', model.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'invoice_returns',
        data: model.toJson(),
        branchId: model.branchId,
      ),
    );
  }

  Future<void> update(InvoiceReturnModel returnModel) async {
    final model = returnModel.copyWith(lastModified: DateTime.now());
    await _dao.upsertInvoiceReturn(_toCompanion(model));
    SyncService.notifyTableUpdated('invoice_returns', model.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'invoice_returns',
        data: model.toJson(),
        branchId: model.branchId,
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
