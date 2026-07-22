import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/employees_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';

class EmployeeService {
  static final EmployeesDao _dao = sl<EmployeesDao>();
  static List<EmployeesTableData> _cached = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<EmployeeModel>> getAll({String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    final employees = _cached
        .where((e) => branchId == null || e.branchId == bid)
        .map(_toModel)
        .toList();
    employees.sort((a, b) => a.name.compareTo(b.name));
    return employees;
  }

  static Future<List<EmployeeModel>> getActive({String? branchId}) async {
    final all = await getAll(branchId: branchId);
    return all.where((e) => e.status == 'active').toList();
  }

  static Future<EmployeeModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<String> create({
    required String name,
    String phone = '',
    String email = '',
    String departmentId = '',
    String departmentName = '',
    String jobTitle = '',
    double salary = 0,
    String? notes,
  }) async {
    await _ensureReady();
    final id = const Uuid().v4();
    final now = DateTime.now();
    final employee = EmployeeModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      departmentId: departmentId,
      departmentName: departmentName,
      jobTitle: jobTitle,
      salary: salary,
      status: 'active',
      branchId: _currentBranchId,
      createdById: AuthService.currentUser?.id ?? '',
      createdByName: AuthService.currentUser?.name,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _dao.upsert(EmployeesTableCompanion(
      id: Value(id),
      code: Value(DateTime.now().millisecondsSinceEpoch.toString()),
      name: Value(name),
      phone: Value(phone.isEmpty ? null : phone),
      email: Value(email.isEmpty ? null : email),
      address: const Value(null),
      departmentId: Value(departmentId.isEmpty ? null : departmentId),
      position: Value(jobTitle.isEmpty ? null : jobTitle),
      baseSalary: Value(salary),
      bankAccount: const Value(null),
      nationalId: const Value(null),
      hireDate: Value(now),
      isActive: const Value(true),
      branchId: Value(_currentBranchId),
      isDeleted: const Value(false),
      lastModified: Value(now),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'employees',
        data: employee.toJson(),
        branchId: _currentBranchId,
      );
    } catch (_) {}

    return id;
  }

  static Future<void> update(String id, {
    String? name,
    String? phone,
    String? email,
    String? departmentId,
    String? departmentName,
    String? jobTitle,
    double? salary,
    String? status,
    String? notes,
  }) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;
    final model = _toModel(existing);
    final updated = model.copyWith(
      name: name ?? model.name,
      phone: phone ?? model.phone,
      email: email ?? model.email,
      departmentId: departmentId ?? model.departmentId,
      departmentName: departmentName ?? model.departmentName,
      jobTitle: jobTitle ?? model.jobTitle,
      salary: salary ?? model.salary,
      status: status ?? model.status,
      notes: notes ?? model.notes,
      updatedAt: DateTime.now(),
    );

    await _dao.upsert(EmployeesTableCompanion(
      id: Value(id),
      code: Value(existing.code),
      name: Value(updated.name),
      phone: Value(updated.phone.isEmpty ? null : updated.phone),
      email: Value(updated.email.isEmpty ? null : updated.email),
      address: const Value(null),
      departmentId: Value(updated.departmentId.isEmpty ? null : updated.departmentId),
      position: Value(updated.jobTitle.isEmpty ? null : updated.jobTitle),
      baseSalary: Value(updated.salary),
      bankAccount: const Value(null),
      nationalId: const Value(null),
      hireDate: Value(existing.hireDate),
      isActive: Value(updated.status == 'active'),
      branchId: Value(existing.branchId),
      isDeleted: const Value(false),
      lastModified: Value(DateTime.now()),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) {
      final idx = _cached.indexWhere((e) => e.id == id);
      if (idx >= 0) _cached[idx] = saved;
    }

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'employees',
        data: updated.toJson(),
        branchId: _currentBranchId,
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
        table: 'employees',
        data: {'id': id, 'is_deleted': true},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<void> deactivate(String id) async {
    await update(id, status: 'inactive');
  }

  static Future<int> nextNumber() async {
    final employees = await getAll();
    if (employees.isEmpty) return 1;
    return employees.length + 1;
  }

  static EmployeeModel _toModel(EmployeesTableData d) => EmployeeModel(
    id: d.id,
    name: d.name,
    phone: d.phone ?? '',
    email: d.email ?? '',
    departmentId: d.departmentId ?? '',
    departmentName: '',
    jobTitle: d.position ?? '',
    salary: d.baseSalary,
    status: d.isActive ? 'active' : 'inactive',
    branchId: d.branchId,
    createdById: '',
    createdByName: null,
    notes: null,
    createdAt: d.lastModified,
    updatedAt: d.lastModified,
  );
}

