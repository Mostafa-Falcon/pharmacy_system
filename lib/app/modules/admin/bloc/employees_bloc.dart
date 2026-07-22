import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/database/daos/users_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/modules/auth/models/user_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/permission_service.dart';
import '../../../core/utils/app_utils.dart';
import '../../admin/services/access_control_service.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final AccessControlService _access = AccessControlService.to;
  final UsersDao _dao = sl<UsersDao>();

  EmployeesBloc() : super(const EmployeesState()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<SelectEmployee>(_onSelectEmployee);
    on<LoadEmployeePermissions>(_onLoadEmployeePermissions);
  }

  Future<void> _onLoadEmployees(LoadEmployees event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(status: EmployeesStatus.loading));
    try {
      final users = await _dao.getAll();
      final employees = users
          .where((u) => u.role == 'employee' && !u.isDeleted)
          .map(_toUserModel)
          .toList();
      emit(state.copyWith(
        status: EmployeesStatus.loaded,
        employees: employees,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EmployeesStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAddEmployee(AddEmployee event, Emitter<EmployeesState> emit) async {
    _access.require('users.write');
    emit(state.copyWith(status: EmployeesStatus.loading));
    try {
      final result = await AuthService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        role: UserRole.employee,
        assignedBranchId: event.assignedBranchId,
      );
      if (result['success'] == true) {
        add(const LoadEmployees());
      } else {
        emit(state.copyWith(
          status: EmployeesStatus.error,
          error: result['message'] as String? ?? 'Ã™ÂÃ˜Â´Ã™â€ž Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EmployeesStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeesState> emit) async {
    _access.require('users.write');
    final user = await _dao.getById(event.id);
    if (user == null) return;

    await _dao.upsert(UsersTableCompanion(
      id: Value(event.id),
      name: Value(event.name ?? user.name),
      email: Value(event.email ?? user.email),
      passwordHash: Value(user.passwordHash),
      role: Value(user.role),
      assignedBranchId: Value(user.assignedBranchId),
      isActive: Value(user.isActive),
      createdAt: Value(user.createdAt),
      lastLogin: Value(user.lastLogin),
      syncVersion: Value(user.syncVersion + 1),
      lastModified: Value(DateTime.now()),
      isDeleted: Value(user.isDeleted),
      activeDeviceId: Value(user.activeDeviceId),
    ));

    emit(state.copyWith(status: EmployeesStatus.loading));
    add(const LoadEmployees());

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'users',
        data: {
          'id': event.id,
          'name': event.name ?? user.name,
          'email': event.email ?? user.email,
        },
        branchId: user.assignedBranchId ?? '',
      );
    } catch (e, st) {
      safeDebugPrint('EmployeesBloc: Ã™ÂÃ˜Â´Ã™â€ž Ã™â€¦Ã˜Â²Ã˜Â§Ã™â€¦Ã™â€ Ã˜Â© Ã˜ÂªÃ˜Â­Ã˜Â¯Ã™Å Ã˜Â« Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â ${user.id}: $e\n$st');
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeesState> emit) async {
    _access.require('users.write');
    final user = await _dao.getById(event.id);
    if (user == null) return;

    await _dao.upsert(UsersTableCompanion(
      id: Value(event.id),
      name: Value(user.name),
      email: Value(user.email),
      passwordHash: Value(user.passwordHash),
      role: Value(user.role),
      assignedBranchId: Value(user.assignedBranchId),
      isActive: const Value(false),
      createdAt: Value(user.createdAt),
      lastLogin: Value(user.lastLogin),
      syncVersion: Value(user.syncVersion + 1),
      lastModified: Value(DateTime.now()),
      isDeleted: const Value(true),
      activeDeviceId: Value(user.activeDeviceId),
    ));

    emit(state.copyWith(status: EmployeesStatus.loading));
    add(const LoadEmployees());

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'users',
        data: {
          'id': event.id,
          'is_active': false,
          'is_deleted': true,
        },
        branchId: user.assignedBranchId ?? '',
      );
    } catch (e, st) {
      safeDebugPrint('EmployeesBloc: Ã™ÂÃ˜Â´Ã™â€ž Ã™â€¦Ã˜Â²Ã˜Â§Ã™â€¦Ã™â€ Ã˜Â© Ã˜Â­Ã˜Â°Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â ${user.id}: $e\n$st');
    }
  }

  void _onSelectEmployee(SelectEmployee event, Emitter<EmployeesState> emit) async {
    final user = await _dao.getById(event.id);
    emit(state.copyWith(
      selectedEmployee: user != null ? _toUserModel(user) : null,
    ));
  }

  void _onLoadEmployeePermissions(LoadEmployeePermissions event, Emitter<EmployeesState> emit) {
    final permissions = PermissionService.getPermissionsForUser(event.userId);
    emit(state.copyWith(selectedEmployeePermissions: permissions));
  }

  UserModel _toUserModel(UsersTableData d) => UserModel(
    id: d.id,
    name: d.name,
    email: d.email,
    passwordHash: d.passwordHash,
    role: d.role == 'owner' ? UserRole.owner : UserRole.employee,
    assignedBranchId: d.assignedBranchId,
    isActive: d.isActive,
    createdAt: d.createdAt,
    lastLogin: d.lastLogin,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    activeDeviceId: d.activeDeviceId,
  );
}

