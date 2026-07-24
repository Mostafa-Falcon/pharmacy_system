import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/modules/admin/models/permission_catalog.dart';
import 'package:pharmacy_system/app/modules/admin/models/role_definition_model.dart';
import 'package:pharmacy_system/app/modules/admin/models/pharmacy_member_model.dart';
import 'package:pharmacy_system/app/modules/admin/models/audit_log_model.dart';
import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/admin_roles_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/admin_members_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/audit_logs_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../../../core/injection.dart'
import '../../../core/models/auth/branch_model.dart';;

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  static AdminService get to => GetIt.instance<AdminService>();
  final _uuid = const Uuid();

  // ─── Converters ───

  BranchesTableCompanion _branchToCompanion(BranchModel m) {
    return BranchesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      address: Value(m.address),
      phone: Value(m.phone),
      isActive: Value(m.isActive),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  BranchModel _branchFromTable(BranchesTableData d) {
    return BranchModel(
      id: d.id,
      name: d.name,
      address: d.address,
      phone: d.phone,
      isActive: d.isActive,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  AdminRolesTableCompanion _roleToCompanion(RoleDefinitionModel m) {
    return AdminRolesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      permissions: Value(jsonEncode(m.permissions.toList())),
      branchId: Value(AuthService.currentBranchId ?? ''),
      isActive: Value(m.isActive),
      isDeleted: const Value(false),
      lastModified: Value(DateTime.now()),
    );
  }

  RoleDefinitionModel _roleFromTable(AdminRolesTableData d) {
    final perms = (jsonDecode(d.permissions) as List)
        .map((e) => e as String)
        .toSet();
    return RoleDefinitionModel(
      id: d.id,
      name: d.name,
      permissions: perms,
      isActive: d.isActive,
      createdAt: d.lastModified,
      updatedAt: d.lastModified,
    );
  }

  AdminMembersTableCompanion _memberToCompanion(PharmacyMemberModel m) {
    return AdminMembersTableCompanion(
      id: Value(m.id),
      userId: Value(m.userId ?? m.id),
      roleId: Value(m.roleId),
      branchId: Value(m.branchIds.firstOrNull ?? ''),
      isActive: Value(m.isActive),
      isDeleted: const Value(false),
      lastModified: Value(DateTime.now()),
    );
  }

  AuditLogsTableCompanion _auditLogToCompanion(AuditLogModel m) {
    return AuditLogsTableCompanion(
      id: Value(m.id),
      userId: Value(m.actorId),
      action: Value(m.action),
      entityType: Value(m.entityType),
      entityId: Value(m.entityId),
      details: Value(m.summary != null ? jsonEncode(m.summary) : null),
      branchId: Value(m.branchId ?? ''),
      createdAt: Value(m.occurredAt),
    );
  }

  // ─── Branches ───

  Future<List<BranchModel>> getBranches() async {
    final list = await sl<BranchesDao>().getAll();
    return list.map(_branchFromTable).toList();
  }

  Future<BranchModel> createBranch({
    required String name,
    String? address,
    String? phone,
  }) async {
    final branch = BranchModel(
      id: _uuid.v4(),
      name: name.trim(),
      address: address?.trim(),
      phone: phone?.trim(),
      createdAt: DateTime.now(),
    );
    await sl<BranchesDao>().upsert(_branchToCompanion(branch));
    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'branches',
      data: branch.toJson(),
      branchId: branch.id,
    );
    return branch;
  }

  Future<void> updateBranch(String id,
      {String? name, String? address, String? phone}) async {
    final existing = await sl<BranchesDao>().getById(id);
    if (existing == null) return;
    final branch = _branchFromTable(existing);
    final updated = BranchModel(
      id: branch.id,
      name: name?.trim() ?? branch.name,
      address: address?.trim() ?? branch.address,
      phone: phone?.trim() ?? branch.phone,
      isActive: branch.isActive,
      createdAt: branch.createdAt,
      syncVersion: branch.syncVersion,
      lastModified: DateTime.now(),
      isDeleted: branch.isDeleted,
    );
    await sl<BranchesDao>().upsert(_branchToCompanion(updated));
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'branches',
      data: updated.toJson(),
      branchId: id,
    );
  }

  Future<void> deleteBranch(String id) async {
    await sl<BranchesDao>().softDelete(id);
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'branches',
      data: {'id': id, 'is_deleted': true},
      branchId: id,
    );
  }

  Future<void> toggleBranch(String id) async {
    final existing = await sl<BranchesDao>().getById(id);
    if (existing == null) return;
    final branch = _branchFromTable(existing);
    final updated = BranchModel(
      id: branch.id,
      name: branch.name,
      address: branch.address,
      phone: branch.phone,
      isActive: !branch.isActive,
      createdAt: branch.createdAt,
      syncVersion: branch.syncVersion,
      lastModified: DateTime.now(),
      isDeleted: branch.isDeleted,
    );
    await sl<BranchesDao>().upsert(_branchToCompanion(updated));
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'branches',
      data: updated.toJson(),
      branchId: id,
    );
  }

  // ─── Members ───

  Future<List<PharmacyMemberModel>> getMembers() async {
    final list = await sl<AdminMembersDao>().getAll();
    // AdminMembersTableData only stores minimal fields; we keep using member models
    // through the existing PharmacyMemberModel flow
    return list.map((d) => PharmacyMemberModel(
      id: d.id,
      userId: d.userId,
      name: '',
      email: '',
      roleId: d.roleId,
      branchIds: {d.branchId},
      permissions: {PermissionCatalog.dashboardRead},
      isActive: d.isActive,
      createdAt: d.lastModified,
      updatedAt: d.lastModified,
    )).toList();
  }

  Future<PharmacyMemberModel> createMember({
    required String name,
    required String email,
    required String roleId,
    required Set<String> branchIds,
    String? phone,
  }) async {
    final role = await getRole(roleId);
    final member = PharmacyMemberModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone?.trim(),
      roleId: roleId,
      branchIds: branchIds,
      permissions: role?.permissions ?? {PermissionCatalog.dashboardRead},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await sl<AdminMembersDao>().upsert(_memberToCompanion(member));
    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'users',
      data: member.toJson(),
      branchId: member.branchIds.firstOrNull ?? 'admin',
    );
    return member;
  }

  Future<void> updateMember(String id,
      {String? name, String? email, String? roleId, Set<String>? branchIds}) async {
    final existing = await sl<AdminMembersDao>().getById(id);
    if (existing == null) return;
    Set<String> perms = {PermissionCatalog.dashboardRead};
    if (roleId != null) {
      final role = await getRole(roleId);
      perms = role?.permissions ?? perms;
    }
    final member = PharmacyMemberModel(
      id: existing.id,
      userId: existing.userId,
      name: name ?? '',
      email: email ?? '',
      roleId: roleId ?? existing.roleId,
      branchIds: branchIds ?? {existing.branchId},
      permissions: perms,
      createdAt: existing.lastModified,
      updatedAt: DateTime.now(),
    );
    await sl<AdminMembersDao>().upsert(_memberToCompanion(member));
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'users',
      data: member.toJson(),
      branchId: member.branchIds.firstOrNull ?? 'admin',
    );
  }

  Future<void> toggleMemberActive(String id) async {
    final existing = await sl<AdminMembersDao>().getById(id);
    if (existing == null) return;
    final updated = _memberToCompanion(PharmacyMemberModel(
      id: existing.id,
      userId: existing.userId,
      name: '',
      email: '',
      roleId: existing.roleId,
      branchIds: {existing.branchId},
      permissions: {PermissionCatalog.dashboardRead},
      isActive: !existing.isActive,
      createdAt: existing.lastModified,
      updatedAt: DateTime.now(),
    ));
    await sl<AdminMembersDao>().upsert(updated);
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'users',
      data: {'id': existing.id, 'is_active': !existing.isActive},
      branchId: existing.branchId,
    );
  }

  // ─── Roles ───

  Future<List<RoleDefinitionModel>> getRoles() async {
    final rolesDao = sl<AdminRolesDao>();
    final dbRoles = await rolesDao.getAll();
    final roles = dbRoles.map(_roleFromTable).toList();
    final existingIds = roles.map((r) => r.id).toSet();
    for (final systemRole in _systemRoles()) {
      if (!existingIds.contains(systemRole.id)) {
        roles.add(systemRole);
      }
    }
    roles.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return roles;
  }

  Future<RoleDefinitionModel?> getRole(String id) async {
    final role = await sl<AdminRolesDao>().getById(id);
    if (role != null) return _roleFromTable(role);
    for (final sr in _systemRoles()) {
      if (sr.id == id) return sr;
    }
    return null;
  }

  Future<RoleDefinitionModel> createRole({
    required String name,
    String? description,
    required Set<String> permissions,
  }) async {
    final now = DateTime.now();
    final role = RoleDefinitionModel(
      id: _uuid.v4(),
      name: name.trim(),
      description: description?.trim(),
      permissions: permissions,
      isSystem: false,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    await sl<AdminRolesDao>().upsert(_roleToCompanion(role));
    return role;
  }

  Future<void> updateRole(String id,
      {String? name, String? description, Set<String>? permissions, bool? isActive}) async {
    final existing = await sl<AdminRolesDao>().getById(id);
    if (existing == null) return;
    final role = _roleFromTable(existing);
    if (role.isSystem) return;
    final updated = role.copyWith(
      name: name ?? role.name,
      description: description ?? role.description,
      permissions: permissions ?? role.permissions,
      isActive: isActive ?? role.isActive,
      updatedAt: DateTime.now(),
    );
    await sl<AdminRolesDao>().upsert(_roleToCompanion(updated));
  }

  // ─── Audit Log ───

  Future<List<AuditLogModel>> getAuditLogs() async {
    final list = await sl<AuditLogsDao>().getAll();
    final logs = list.map((d) => AuditLogModel(
      id: d.id,
      action: d.action,
      entityType: d.entityType,
      entityId: d.entityId,
      actorId: d.userId,
      branchId: d.branchId,
      summary: d.details != null ? Map<String, dynamic>.from(jsonDecode(d.details!)) : null,
      occurredAt: d.createdAt,
    )).toList();
    logs.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return logs;
  }

  Future<void> addAuditLog(AuditLogModel log) async {
    await sl<AuditLogsDao>().upsert(_auditLogToCompanion(log));
    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'audit_logs',
      data: log.toJson(),
      branchId: log.branchId ?? AuthService.currentBranchId ?? '',
    );
  }

  // ─── Private ───

  List<RoleDefinitionModel> _systemRoles() {
    final now = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return [
      RoleDefinitionModel(
        id: 'owner',
        name: 'Ù…Ø§Ù„Ùƒ Ø§Ù„ØµÙŠØ¯Ù„ÙŠØ©',
        permissions: {PermissionCatalog.wildcard},
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      RoleDefinitionModel(
        id: 'manager',
        name: 'Ù…Ø¯ÙŠØ±',
        permissions: {...PermissionCatalog.all},
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      RoleDefinitionModel(
        id: 'pharmacist',
        name: 'ØµÙŠØ¯Ù„ÙŠ',
        permissions: PermissionCatalog.defaultsForRole('pharmacist'),
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      RoleDefinitionModel(
        id: 'accountant',
        name: 'Ù…Ø­Ø§Ø³Ø¨',
        permissions: PermissionCatalog.defaultsForRole('accountant'),
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
      RoleDefinitionModel(
        id: 'cashier',
        name: 'ÙƒØ§Ø´ÙŠØ±',
        permissions: PermissionCatalog.defaultsForRole('cashier'),
        isSystem: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}






