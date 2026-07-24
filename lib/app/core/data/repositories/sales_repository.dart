import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

class SalesRepository {
  SalesDao get _dao => sl<SalesDao>();
  SalesRepository();

  static final Map<String, List<SaleInvoiceModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<SaleInvoiceModel> _cached(String branchId) => List<SaleInvoiceModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<SaleInvoiceModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  SaleInvoiceModel _toModel(SaleInvoicesTableData d) {
    return SaleInvoiceModel.fromJson({
      'id': d.id,
      'invoice_number': d.invoiceNumber,
      'customer_name': d.customerName,
      'customer_id': d.customerId,
      'cash_register_id': d.cashRegisterId,
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

  SaleInvoicesTableCompanion _toCompanion(SaleInvoiceModel m) {
    return SaleInvoicesTableCompanion(
      id: Value(m.id),
      invoiceNumber: Value(m.invoiceNumber),
      customerName: Value(m.customerName),
      customerId: Value(m.customerId),
      cashRegisterId: Value(m.cashRegisterId),
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

  Future<List<SaleInvoiceModel>> getSales({
    required String branchId,
    String? searchQuery,
    String? filter,
    bool includeDeleted = false,
  }) async {
    var items = await _dao.getInvoicesByBranch(branchId);
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (filter == 'today') {
      final now = DateTime.now();
      data = data.where((s) =>
          s.createdAt.day == now.day &&
          s.createdAt.month == now.month &&
          s.createdAt.year == now.year).toList();
    } else if (filter == 'this_month') {
      final now = DateTime.now();
      data = data.where((s) =>
          s.createdAt.month == now.month && s.createdAt.year == now.year).toList();
    } else if (filter == 'credit') {
      data = data.where((s) => s.paymentMethod == 'credit').toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data = data.where((s) => _matchesSearch(s, q)).toList();
    }

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data;
  }

  List<SaleInvoiceModel> getSalesSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<SaleInvoiceModel>> watchSales(String branchId) {
    return _dao.watchInvoicesByBranch(branchId).map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<SaleInvoiceModel?> getByIdAsync(String id) async {
    final data = await _dao.getInvoiceById(id);
    return data != null ? _toModel(data) : null;
  }

  SaleInvoiceModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((s) => s.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(SaleInvoiceModel sale) async {
    await _dao.upsertInvoice(_toCompanion(sale));
    SyncService.notifyTableUpdated('sale_invoices', sale.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'sale_invoices',
        data: sale.toJson(),
        branchId: sale.branchId,
      ),
    );
  }

  Future<void> update(SaleInvoiceModel sale) async {
    await _dao.upsertInvoice(_toCompanion(sale));
    SyncService.notifyTableUpdated('sale_invoices', sale.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'sale_invoices',
        data: sale.toJson(),
        branchId: sale.branchId,
      ),
    );
  }

  bool _matchesSearch(SaleInvoiceModel sale, String query) {
    return sale.invoiceNumber.toLowerCase().contains(query) ||
        sale.customerName.toLowerCase().contains(query) ||
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
