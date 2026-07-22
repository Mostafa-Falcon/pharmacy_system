import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_reps_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sales_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/crm/models/sales_rep_model.dart';

class SalesRepService {
  static final _uuid = const Uuid();
  static final List<SalesRepModel> _cache = [];

  static SalesRepModel _toModel(SalesRepsTableData d) {
    return SalesRepModel(
      id: d.id,
      name: d.name,
      phone: d.phone,
      email: d.email,
      address: d.address,
      notes: d.notes,
      branchId: d.branchId,
      isActive: d.isActive,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static SalesRepsTableCompanion _toCompanion(SalesRepModel m) {
    return SalesRepsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      phone: Value(m.phone),
      email: Value(m.email),
      address: Value(m.address),
      notes: Value(m.notes),
      branchId: Value(m.branchId),
      isActive: Value(m.isActive),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  static Future<void> init() async {
    final dao = sl<SalesRepsDao>();
    final all = await dao.getAll();
    _cache
      ..clear()
      ..addAll(all.map(_toModel));
  }

  static List<SalesRepModel> getAll({String? branchId}) {
    var items = _cache.where((r) => !r.isDeleted);
    if (branchId != null) {
      items = items.where((r) => r.branchId == branchId);
    }
    return items.toList();
  }

  static SalesRepModel? getById(String id) {
    final matches = _cache.where((r) => r.id == id && !r.isDeleted);
    return matches.isNotEmpty ? matches.first : null;
  }

  static Future<SalesRepModel> create(SalesRepModel rep) async {
    final newRep = rep.copyWith(
      id: _uuid.v4(),
      lastModified: DateTime.now(),
    );
    await sl<SalesRepsDao>().upsert(_toCompanion(newRep));
    _cache.add(newRep);
    return newRep;
  }

  static Future<SalesRepModel> update(SalesRepModel rep) async {
    final updated = rep.copyWith(lastModified: DateTime.now());
    await sl<SalesRepsDao>().upsert(_toCompanion(updated));
    final index = _cache.indexWhere((r) => r.id == updated.id);
    if (index >= 0) {
      _cache[index] = updated;
    }
    return updated;
  }

  static Future<void> delete(String id) async {
    final rep = getById(id);
    if (rep != null) {
      await sl<SalesRepsDao>().softDelete(id);
      final index = _cache.indexWhere((r) => r.id == id);
      if (index >= 0) {
        _cache[index] = rep.copyWith(isDeleted: true, lastModified: DateTime.now());
      }
    }
  }

  static Future<void> toggleActive(String id, bool isActive) async {
    final rep = getById(id);
    if (rep != null) {
      await update(rep.copyWith(isActive: isActive));
    }
  }

  static List<SalesRepModel> getActive({String? branchId}) {
    final all = getAll(branchId: branchId);
    return all.where((r) => r.isActive).toList();
  }

  static Future<int> getCustomerCount(String repId, {String? branchId}) async {
    final dao = sl<CustomersDao>();
    return dao.countByRep(repId);
  }

  static Future<double> getTotalSales(String repId, DateTime fromDate, DateTime toDate, {String? branchId}) async {
    final dao = sl<SalesDao>();
    if (branchId != null) {
      final sales = await dao.getByRepAndBranchAndDateRange(repId, branchId, fromDate, toDate);
      return sales.fold<double>(0, (sum, s) => sum + s.finalAmount);
    }
    final sales = await dao.getByRepAndDateRange(repId, fromDate, toDate);
    return sales.fold<double>(0, (sum, s) => sum + s.finalAmount);
  }

  static Future<Map<String, dynamic>> getPerformanceReport(String repId, DateTime fromDate, DateTime toDate, {String? branchId}) async {
    final customers = await getCustomerCount(repId, branchId: branchId);
    final totalSales = await getTotalSales(repId, fromDate, toDate, branchId: branchId);
    return {
      'customers': customers,
      'total_sales': totalSales,
    };
  }
}

