import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/cashier_shifts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/returns_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/sales/models/cashier_shift_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class CashierShiftService {
  static CashierShiftsDao get _dao => sl<CashierShiftsDao>();
  static SalesDao get _salesDao => sl<SalesDao>();
  static ReturnsDao get _returnsDao => sl<ReturnsDao>();
  static const _uuid = Uuid();

  static List<CashierShiftModel> _cache = [];

  static List<CashierShiftModel> _cached(String branchId) {
    return _cache
        .where((s) => s.branchId == branchId && !s.isDeleted)
        .toList()
      ..sort((a, b) => b.openedAt.compareTo(a.openedAt));
  }

  static void _updateCache(List<CashierShiftModel> items) {
    _cache = items;
  }

  static Future<void> _refreshCache() async {
    final all = await _dao.getAll();
    _updateCache(all.map(_toModel).toList());
  }

  static Future<void> refresh() async {
    await _refreshCache();
  }

  static List<CashierShiftModel> getAll({String? branchId}) {
    final bid = branchId ?? AuthService.currentBranchId ?? '';
    return _cached(bid);
  }

  static Future<List<CashierShiftModel>> getAllAsync({String? branchId}) async {
    await _refreshCache();
    return getAll(branchId: branchId);
  }

  static CashierShiftModel? findOpenShift({
    String? cashierId,
    String? deviceId,
    String? branchId,
  }) {
    final bid = branchId ?? AuthService.currentBranchId ?? '';
    final cid = cashierId ?? AuthService.currentUser?.id ?? '';
    try {
      return _cache.firstWhere(
        (s) =>
            (bid.isEmpty || s.branchId == bid) &&
            (cid.isEmpty || s.cashierId == cid) &&
            (deviceId == null || deviceId.isEmpty || s.deviceId == deviceId || s.deviceId.isEmpty) &&
            s.status == CashierShiftStatus.open &&
            !s.isDeleted,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<CashierShiftModel?> findOpenShiftAsync({
    String? cashierId,
    String? deviceId,
    String? branchId,
  }) async {
    await _refreshCache();
    return findOpenShift(cashierId: cashierId, deviceId: deviceId, branchId: branchId);
  }

  static int _nextShiftNumber(String branchId) {
    final existing = getAll(branchId: branchId);
    if (existing.isEmpty) return 1;
    return existing.map((s) => s.shiftNumber).reduce((a, b) => a > b ? a : b) +
        1;
  }

  static Future<CashierShiftModel> openShift({
    double openingCash = 0,
    String? branchId,
  }) async {
    final bid = branchId ?? AuthService.currentBranchId ?? '';
    final cashier = AuthService.currentUser;
    if (cashier == null) throw StateError('لم يتم تسجيل الدخول');

    await _refreshCache();

    final existing = findOpenShift(cashierId: cashier.id, branchId: bid);
    if (existing != null) {
      throw StateError('وردية مفتوحة موجودة');
    }

    final shift = CashierShiftModel(
      id: _uuid.v4(),
      branchId: bid,
      shiftNumber: _nextShiftNumber(bid),
      cashierId: cashier.id,
      cashierName: cashier.name,
      deviceId: AuthService.currentDeviceId ?? '',
      openedAt: DateTime.now(),
      openingCash: openingCash,
    );
    await _dao.upsert(_toCompanion(shift));
    _cache.add(shift);
    return shift;
  }

  static Future<CashierShiftModel> closeShift({
    required String shiftId,
    required double countedCash,
    String? notes,
  }) async {
    final data = await _dao.getById(shiftId);
    if (data == null) throw StateError('الوردية غير موجودة');
    final shift = _toModel(data);
    if (shift.status == CashierShiftStatus.closed) {
      throw StateError('الوردية مغلقة بالفعل');
    }

    final expectedCash = await _calculateExpectedCash(shift);
    final difference = countedCash - expectedCash;

    final updated = shift.copyWith(
      status: CashierShiftStatus.closed,
      closedAt: DateTime.now(),
      expectedCash: expectedCash,
      countedCash: countedCash,
      difference: double.parse(difference.toStringAsFixed(2)),
      notes: notes,
    );
    await _dao.upsert(_toCompanion(updated));
    final idx = _cache.indexWhere((s) => s.id == shift.id);
    if (idx != -1) {
      _cache[idx] = updated;
    } else {
      _cache.add(updated);
    }
    return updated;
  }

  static Future<double> _calculateExpectedCash(CashierShiftModel shift) async {
    final bid = shift.branchId;
    double cashSales = 0;
    try {
      final sales = await _salesDao.getByDateRange(
        bid,
        shift.openedAt,
        shift.closedAt ?? DateTime.now(),
      );
      cashSales = sales
          .map(_toSaleModel)
          .where(
            (s) => s.paymentMethod == 'cash' || s.paymentMethod == 'mixed',
          )
          .fold(0.0, (sum, s) => sum + s.finalAmount);
    } catch (e, s) {
      safeDebugPrint('CashierShiftService._calculateExpectedCash failed: $e\n$s');
    }
    return double.parse((shift.openingCash + cashSales).toStringAsFixed(2));
  }

  static Future<Map<String, dynamic>> getShiftSummary(String shiftId) async {
    final data = await _dao.getById(shiftId);
    if (data == null) return {};
    final shift = _toModel(data);
    final sales = (await _salesDao.getByDateRange(
      shift.branchId,
      shift.openedAt,
      shift.closedAt ?? DateTime.now(),
    )).map(_toSaleModel).toList();

    return {
      'shift': shift,
      'sales_count': sales.length,
      'cash_sales': sales
          .where((s) => s.paymentMethod == 'cash' || s.paymentMethod == 'mixed')
          .fold(0.0, (sum, s) => sum + s.finalAmount),
      'card_sales': sales
          .where((s) => s.paymentMethod == 'card')
          .fold(0.0, (sum, s) => sum + s.finalAmount),
      'credit_sales': sales
          .where((s) => s.paymentMethod == 'credit')
          .fold(0.0, (sum, s) => sum + s.finalAmount),
      'total_sales': sales.fold(0.0, (sum, s) => sum + s.finalAmount),
    };
  }

  static Future<List<SaleModel>> getShiftInvoices(String shiftId) async {
    final data = await _dao.getById(shiftId);
    if (data == null) return [];
    final shift = _toModel(data);
    final sales = (await _salesDao.getByDateRange(
      shift.branchId,
      shift.openedAt,
      shift.closedAt ?? DateTime.now(),
    )).map(_toSaleModel).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sales;
  }

  static Future<List<dynamic>> getShiftTransactions(String shiftId) async {
    final data = await _dao.getById(shiftId);
    if (data == null) return [];
    final shift = _toModel(data);

    final sales = (await _salesDao.getByDateRange(
      shift.branchId,
      shift.openedAt,
      shift.closedAt ?? DateTime.now(),
    )).map(_toSaleModel).toList();

    final returns = (await _returnsDao.getByBranch(shift.branchId))
        .map(_toReturnModel)
        .where(
          (r) =>
              r.saleId != null &&
              r.createdAt.isAfter(shift.openedAt) &&
              (shift.closedAt == null || r.createdAt.isBefore(shift.closedAt!)),
        )
        .toList();

    final all = <dynamic>[...sales, ...returns];
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }

  static CashierShiftModel _toModel(CashierShiftsTableData d) {
    return CashierShiftModel(
      id: d.id,
      branchId: d.branchId,
      shiftNumber: d.shiftNumber,
      cashierId: d.cashierId,
      cashierName: d.cashierName,
      deviceId: d.deviceId,
      openedAt: d.openedAt,
      openingCash: d.openingCash,
      status: CashierShiftStatus.values.firstWhere(
        (e) => e.name == d.status,
        orElse: () => CashierShiftStatus.open,
      ),
      closedAt: d.closedAt,
      expectedCash: d.expectedCash,
      countedCash: d.countedCash,
      difference: d.difference,
      notes: d.notes,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static CashierShiftsTableCompanion _toCompanion(CashierShiftModel m) {
    return CashierShiftsTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      shiftNumber: Value(m.shiftNumber),
      cashierId: Value(m.cashierId),
      cashierName: Value(m.cashierName),
      deviceId: Value(m.deviceId),
      openedAt: Value(m.openedAt),
      openingCash: Value(m.openingCash),
      status: Value(m.status.name),
      closedAt: Value(m.closedAt),
      expectedCash: Value(m.expectedCash),
      countedCash: Value(m.countedCash),
      difference: Value(m.difference),
      notes: Value(m.notes),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  static SaleModel _toSaleModel(SalesTableData d) {
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

  static ReturnModel _toReturnModel(ReturnsTableData d) {
    return ReturnModel(
      id: d.id,
      branchId: d.branchId,
      returnType: 'sales',
      items: (jsonDecode(d.items) as List)
          .map((e) => ReturnItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: d.totalAmount,
      finalAmount: d.totalAmount,
      reason: ReturnReason.values.firstWhere(
        (r) => r.name == d.reason,
        orElse: () => ReturnReason.other,
      ),
      saleId: d.saleId,
      purchaseId: d.purchaseId,
      notes: d.notes,
      createdBy: d.createdBy,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }
}

