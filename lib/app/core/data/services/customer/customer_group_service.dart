import 'dart:async';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customer_groups_dao.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_group_model.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class CustomerGroupService {
  static CustomerGroupsDao get _dao => sl<CustomerGroupsDao>();
  static const _uuid = Uuid();

  static List<CustomerGroupModel>? _cachedList;
  static Timer? _cacheTimer;

  static List<CustomerGroupModel> _cached() =>
      List<CustomerGroupModel>.from(_cachedList ?? []);

  static void _updateCache(List<CustomerGroupModel> items) {
    _cachedList = items;
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(seconds: 5), () {
      _cachedList = null;
    });
  }

  static CustomerGroupModel _toModel(CustomerGroupsTableData d) {
    return CustomerGroupModel(
      id: d.id,
      name: d.name,
      discountPercent: d.discountPercent,
      priceGroupId: d.priceGroupId,
      description: d.description,
      isActive: d.isActive,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static CustomerGroupsTableCompanion _toCompanion(CustomerGroupModel m) {
    return CustomerGroupsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      discountPercent: Value(m.discountPercent),
      priceGroupId: Value(m.priceGroupId),
      description: Value(m.description),
      isActive: Value(m.isActive),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  static Future<void> init() async {
    final items = await _dao.getAll();
    _updateCache(items.map(_toModel).toList());
  }

  static List<CustomerGroupModel> getAll({bool activeOnly = true, bool includeDeleted = false}) {
    try {
      var items = _cached();
      if (!includeDeleted) {
        items = items.where((g) => !g.isDeleted).toList();
      }
      if (activeOnly) {
        items = items.where((g) => g.isActive).toList();
      }
      return items;
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.getAll failed: $e\n$s');
      return [];
    }
  }

  static CustomerGroupModel? getById(String? id) {
    try {
      if (id == null) return null;
      return _cached().firstWhereOrNull((g) => g.id == id);
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.getById failed: $e\n$s');
      return null;
    }
  }

  static Future<CustomerGroupModel> add({
    required String name,
    double discountPercent = 0,
    String? priceGroupId,
    String? description,
  }) async {
    try {
      final group = CustomerGroupModel(
        id: _uuid.v4(),
        name: name,
        discountPercent: discountPercent,
        priceGroupId: priceGroupId,
        description: description,
      );
      group.lastModified = DateTime.now();
      await _dao.upsert(_toCompanion(group));
      return group;
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.add failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> update(CustomerGroupModel group) async {
    try {
      group.lastModified = DateTime.now();
      await _dao.upsert(_toCompanion(group));
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.update failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> deactivate(String id) async {
    try {
      final group = getById(id);
      if (group != null) {
        group.isActive = false;
        group.lastModified = DateTime.now();
        await _dao.upsert(_toCompanion(group));
      }
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.deactivate failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final group = getById(id);
      if (group != null) {
        await ArchiveService.record(
          entityType: 'customer_group',
          entityId: group.id,
          entityName: group.name,
          entityData: group.toJson(),
          branchId: AuthService.currentBranchId ?? '',
        );
        group.isDeleted = true;
        await _dao.upsert(_toCompanion(group));
      }
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.delete failed: $e\n$s');
      rethrow;
    }
  }

  static bool nameExists(String name, {String? excludeId}) {
    try {
      return _cached().any((g) =>
          g.name.toLowerCase() == name.toLowerCase().trim() &&
          g.id != excludeId
      );
    } catch (e, s) {
      safeDebugPrint('CustomerGroupService.nameExists failed: $e\n$s');
      return false;
    }
  }
}




