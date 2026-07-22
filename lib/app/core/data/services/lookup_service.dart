import 'package:drift/drift.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/database/daos/lookups_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/domain/models/base/lookup_model.dart';

class LookupService {
  static final List<LookupModel> _cache = [];

  static String get _branchId => AuthService.currentBranchId ?? '';

  static LookupModel _toModel(LookupsTableData d) {
    return LookupModel(
      id: d.id,
      name: d.name,
      type: d.type,
      isActive: d.isActive,
      branchId: d.branchId,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static LookupsTableCompanion _toCompanion(LookupModel m) {
    return LookupsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      type: Value(m.type),
      isActive: Value(m.isActive),
      branchId: Value(m.branchId),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  static Future<void> init() async {
    try {
      final dao = sl<LookupsDao>();
      final all = await dao.getAll();
      _cache
        ..clear()
        ..addAll(all.map(_toModel));
    } catch (e, s) {
      safeDebugPrint('LookupService.init failed: $e\n$s');
    }
  }

  static List<LookupModel> getAll({LookupType? type}) {
    try {
      final list = _cache.where((l) => !l.isDeleted && l.branchId == _branchId);
      if (type == null) return list.toList();
      return list.where((l) => l.type == type.name).toList();
    } catch (e, s) {
      safeDebugPrint('LookupService.getAll failed: $e\n$s');
      return [];
    }
  }

  static List<LookupModel> getItemTypes() => getAll(type: LookupType.itemType);

  static List<LookupModel> getGroups() => getAll(type: LookupType.group);

  static LookupModel? getById(String id) {
    try {
      final item = _cache.where((l) => l.id == id && !l.isDeleted);
      return item.isNotEmpty ? item.first : null;
    } catch (e, s) {
      safeDebugPrint('LookupService.getById failed: $e\n$s');
      return null;
    }
  }

  static String? getNameById(String? id) {
    if (id == null || id.isEmpty) return null;
    return getById(id)?.name;
  }

  static Future<void> add(LookupModel lookup) async {
    try {
      lookup.lastModified = DateTime.now();
      await sl<LookupsDao>().upsert(_toCompanion(lookup));
      _cache.add(lookup);
    } catch (e, s) {
      safeDebugPrint('LookupService.add failed: $e\n$s');
      rethrow;
    }
  }

  static Future<LookupModel> addByName({
    required String name,
    required LookupType type,
  }) async {
    try {
      final lookup = LookupModel.create(
        name: name,
        lookupType: type,
        branchId: _branchId,
      );
      lookup.lastModified = DateTime.now();
      await sl<LookupsDao>().upsert(_toCompanion(lookup));
      _cache.add(lookup);
      return lookup;
    } catch (e, s) {
      safeDebugPrint('LookupService.addByName failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> update(LookupModel lookup) async {
    try {
      lookup.lastModified = DateTime.now();
      await sl<LookupsDao>().upsert(_toCompanion(lookup));
      final index = _cache.indexWhere((l) => l.id == lookup.id);
      if (index >= 0) {
        _cache[index] = lookup;
      }
    } catch (e, s) {
      safeDebugPrint('LookupService.update failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> remove(String id) async {
    try {
      final existing = getById(id);
      if (existing == null) return;

      final updated = existing.copyWith(isDeleted: true);
      updated.lastModified = DateTime.now();
      await sl<LookupsDao>().softDelete(id);
      final index = _cache.indexWhere((l) => l.id == id);
      if (index >= 0) {
        _cache[index] = updated;
      }
    } catch (e, s) {
      safeDebugPrint('LookupService.remove failed: $e\n$s');
      rethrow;
    }
  }

  static List<LookupModel> search(String query, {required LookupType type}) {
    try {
      final q = query.trim().toLowerCase();
      if (q.isEmpty) return getAll(type: type);
      return getAll(type: type).where((l) => l.name.toLowerCase().contains(q)).toList();
    } catch (e, s) {
      safeDebugPrint('LookupService.search failed: $e\n$s');
      return [];
    }
  }

  static bool nameExists(String name, {required LookupType type}) {
    try {
      return getAll(type: type).any(
            (l) => l.name.trim().toLowerCase() == name.trim().toLowerCase(),
      );
    } catch (e, s) {
      safeDebugPrint('LookupService.nameExists failed: $e\n$s');
      return false;
    }
  }
}
