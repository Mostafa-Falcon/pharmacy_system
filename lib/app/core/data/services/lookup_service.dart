import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/models/base/lookup_model.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class LookupService {
  LookupService._();
  static final LookupService instance = LookupService._();

  final List<LookupModel> _cache = [];
  bool _loaded = false;

  static List<LookupModel> getAll({required LookupType type}) {
    if (!instance._loaded) return [];
    return instance._cache.where((l) => l.type == type.name && !l.isDeleted).toList();
  }

  static List<LookupModel> getItemTypes() => getAll(type: LookupType.itemType);

  static Future<LookupModel> addByName({
    required String name,
    required LookupType type,
  }) async {
    final branchId = '';
    final model = LookupModel.create(name: name, lookupType: type, branchId: branchId);
    try {
      final db = appDatabase;
      await db.into(db.lookupsTable).insertOnConflictUpdate(LookupsTableCompanion(
        id: Value(model.id),
        name: Value(model.name),
        type: Value(model.type),
        isActive: Value(model.isActive),
        branchId: Value(model.branchId),
        syncVersion: Value(model.syncVersion),
        lastModified: Value(model.lastModified),
        isDeleted: Value(model.isDeleted),
      ));
      instance._cache.add(model);
    } catch (e, s) {
      safeDebugPrint('LookupService.addByName error: $e\n$s');
    }
    return model;
  }

  Future<void> loadCache() async {
    if (_loaded) return;
    try {
      final db = appDatabase;
      final rows = await (db.select(db.lookupsTable)
            ..where((t) => t.isDeleted.equals(false)))
          .get();
      _cache.clear();
      for (final r in rows) {
        _cache.add(LookupModel(
          id: r.id,
          name: r.name,
          type: r.type,
          isActive: r.isActive,
          branchId: r.branchId,
          syncVersion: r.syncVersion,
          lastModified: r.lastModified,
          isDeleted: r.isDeleted,
        ));
      }
      _loaded = true;
    } catch (e, s) {
      safeDebugPrint('LookupService.loadCache error: $e\n$s');
    }
  }
}
