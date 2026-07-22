import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/quotes_dao.dart';
import 'package:pharmacy_system/app/modules/sales/models/quote_model.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class QuoteService {
  static QuotesDao get _dao => sl<QuotesDao>();
  static const _uuid = Uuid();

  static List<QuoteModel>? _cachedList;
  static Timer? _cacheTimer;

  static List<QuoteModel> _cached() =>
      List<QuoteModel>.from(_cachedList ?? []);

  static void _updateCache(List<QuoteModel> items) {
    _cachedList = items;
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(seconds: 5), () {
      _cachedList = null;
    });
  }

  static QuoteModel _toModel(QuotesTableData d) {
    return QuoteModel(
      id: d.id,
      branchId: d.branchId,
      number: d.number,
      customerName: d.customerName,
      notes: d.notes,
      items: d.items is List ? (d.items as List).cast<Map<String, dynamic>>() : [],
      subtotal: d.subtotal,
      discount: d.discount,
      total: d.total,
      status: QuoteStatus.values.firstWhere(
        (e) => e.name == d.status,
        orElse: () => QuoteStatus.draft,
      ),
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static QuotesTableCompanion _toCompanion(QuoteModel m) {
    return QuotesTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      number: Value(m.number),
      customerName: Value(m.customerName),
      notes: Value(m.notes),
      items: Value(jsonEncode(m.items)), // تحويل القائمة لنص JSON
      subtotal: Value(m.subtotal),
      discount: Value(m.discount),
      total: Value(m.total),
      status: Value(m.status.name),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  static Future<void> init() async {
    final items = await _dao.getAll();
    _updateCache(items.map(_toModel).toList());
  }

  static List<QuoteModel> getAll({String? branchId}) {
    final bid = branchId ?? AuthService.currentBranchId ?? '';
    return _cached()
        .where((q) => q.branchId == bid && !q.isDeleted)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static QuoteModel? getById(String id) {
    final q = _cached().firstWhereOrNull((q) => q.id == id);
    return (q != null && !q.isDeleted) ? q : null;
  }

  static int _nextNumber(String branchId) {
    final existing = getAll(branchId: branchId);
    if (existing.isEmpty) return 1;
    return existing.map((q) => q.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  static Future<QuoteModel> create({
    required String customerName,
    String? notes,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    double discount = 0,
    required double total,
    String? branchId,
  }) async {
    try {
      final bid = branchId ?? AuthService.currentBranchId ?? '';
      final quote = QuoteModel(
        id: _uuid.v4(),
        branchId: bid,
        number: _nextNumber(bid),
        customerName: customerName,
        notes: notes,
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        createdAt: DateTime.now(),
      );
      await _dao.upsert(_toCompanion(quote));
      return quote;
    } catch (e, s) {
      safeDebugPrint('QuoteService.create failed: $e\n$s');
      rethrow;
    }
  }

  static Future<QuoteModel> updateStatus(String id, QuoteStatus status) async {
    try {
      final quote = _cached().firstWhereOrNull((q) => q.id == id);
      if (quote == null) throw Exception('عرض السعر غير موجود');
      final updated = quote.copyWith(status: status);
      await _dao.upsert(_toCompanion(updated));
      return updated;
    } catch (e, s) {
      safeDebugPrint('QuoteService.updateStatus failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> softDelete(String id) async {
    try {
      final quote = _cached().firstWhereOrNull((q) => q.id == id);
      if (quote == null) return;
      await _dao.softDelete(id);
    } catch (e, s) {
      safeDebugPrint('QuoteService.softDelete failed: $e\n$s');
      rethrow;
    }
  }
}

