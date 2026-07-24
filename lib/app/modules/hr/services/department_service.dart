import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/departments_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';

class DepartmentService {
  static final DepartmentsDao _dao = sl<DepartmentsDao>();
  static List<DepartmentsTableData> _cached = [];
  static bool _ready = false;

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<DepartmentModel>> getAll() async {
    await _ensureReady();
    final departments = _cached
        .where((e) => !e.isDeleted && e.isActive)
        .map(_toModel)
        .toList();
    departments.sort((a, b) => a.name.compareTo(b.name));
    return departments;
  }

  static Future<DepartmentModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<String> create({
    required String name,
    String? managerId,
    String? managerName,
    String? description,
  }) async {
    await _ensureReady();
    final id = const Uuid().v4();
    final now = DateTime.now();

    await _dao.upsert(DepartmentsTableCompanion(
      id: Value(id),
      name: Value(name),
      branchId: Value(AuthService.currentBranchId ?? ''),
      isActive: const Value(true),
      isDeleted: const Value(false),
      createdAt: Value(now),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'departments',
        data: {
          'id': id,
          'name': name,
          'branch_id': AuthService.currentBranchId ?? '',
        },
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}

    return id;
  }

  static Future<void> update(String id, {
    String? name,
    String? managerId,
    String? managerName,
    String? description,
    int? employeeCount,
  }) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;

    await _dao.upsert(DepartmentsTableCompanion(
      id: Value(id),
      name: Value(name ?? existing.name),
      branchId: Value(existing.branchId),
      isActive: Value(existing.isActive),
      isDeleted: Value(existing.isDeleted),
      createdAt: Value(existing.createdAt),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) {
      final idx = _cached.indexWhere((e) => e.id == id);
      if (idx >= 0) _cached[idx] = saved;
    }

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'departments',
        data: {
          'id': id,
          'name': name ?? existing.name,
        },
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}
  }

  static Future<void> delete(String id) async {
    await _ensureReady();
    await _dao.softDelete(id);
    _cached.removeWhere((e) => e.id == id);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'departments',
        data: {'id': id, 'is_deleted': true},
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}
  }

  static Future<void> incrementEmployeeCount(String id) async {}
  static Future<void> decrementEmployeeCount(String id) async {}

  static DepartmentModel _toModel(DepartmentsTableData d) => DepartmentModel(
    id: d.id,
    name: d.name,
    managerId: null,
    managerName: null,
    description: null,
    employeeCount: 0,
    createdAt: d.createdAt,
    updatedAt: d.createdAt,
  );
}




