import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/users_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../bloc/employees_bloc.dart';

class EmployeesManagementView extends StatelessWidget {
  const EmployeesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      buildWhen: (prev, current) =>
          prev.employees.length != current.employees.length ||
          prev.status != current.status,
      builder: (context, state) {
        if (state.status == EmployeesStatus.loading && state.employees.isEmpty) {
          return const HomeShell(
            title: AdminStrings.empManagement,
            child: Center(child: LoadingIndicator()),
          );
        }

        return StandardModuleLayout(
          title: AdminStrings.empManagement,
          subtitle: AdminStrings.empManagementSubtitle,
          actions: [
            ReusableButton(
              text: AdminStrings.empAdd,
              prefixIcon: Icons.person_add_alt_1_rounded,
              type: ButtonType.primary,
              onPressed: () => _showAddEmployeeDialog(context),
            ),
          ],
          stats: [
            SummaryCard(
              label: '?????? ????????',
              value: '${state.employees.length}',
              icon: Icons.people_outline_rounded,
            ),
          ],
          content: _buildEmployeesList(context, state),
        );
      },
    );
  }

  Widget _buildEmployeesList(BuildContext context, EmployeesState state) {
    if (state.employees.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline_rounded,
        title: AdminStrings.empNoAccounts,
        subtitle: AdminStrings.empAddStartHint,
      );
    }

    return ListView.builder(
      itemCount: state.employees.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final emp = state.employees[index];
        return _EmployeeCard(
          employee: emp,
          onEdit: () => _showEditEmployeeDialog(context, emp),
          onDelete: () => _confirmDeleteEmployee(context, emp),
          onToggleActive: () => _toggleActiveStatus(context, emp),
        );
      },
    );
  }

  Future<void> _showAddEmployeeDialog(BuildContext context) async {
    final bloc = context.read<EmployeesBloc>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedBranchId;
    String selectedRole = 'employee';

    final branchesDao = sl<BranchesDao>();
    final branchRows = await branchesDao.getAll();
    if (!context.mounted) return;
    final branches = branchRows
        .where((b) => !b.isDeleted)
        .map((b) => _BranchInfo(id: b.id, name: b.name))
        .toList();
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => ReusableDialog(
          title: AdminStrings.empAddDialog,
          headerIcon: Icon(Icons.person_add_rounded, color: scheme.primary),
          children: [
            ReusableInput(
              controller: nameController,
              label: AdminStrings.empFullName,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput.email(
              controller: emailController,
              label: AdminStrings.empEmailLabel,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput.password(
              controller: passwordController,
              label: AdminStrings.empDefaultPassword,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String>(
              labelText: AdminStrings.empRole,
              hintText: AdminStrings.empRoleHint,
              prefixIcon: Icons.work_outline_rounded,
              value: selectedRole,
              items: const [
                'employee',
                'pharmacist',
                'cashier',
                'inventory_manager',
              ],
              itemAsString: (val) {
                switch (val) {
                  case 'pharmacist':
                    return AdminStrings.empRolePharmacist;
                  case 'cashier':
                    return AdminStrings.empRoleCashier;
                  case 'inventory_manager':
                    return AdminStrings.empRoleInventoryManager;
                  default:
                    return AdminStrings.empRoleGeneral;
                }
              },
              onChanged: (value) {
                setDialogState(() => selectedRole = value ?? 'employee');
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String?>(
              labelText: AdminStrings.empBranch,
              hintText: AdminStrings.empBranchHint,
              prefixIcon: Icons.storefront_rounded,
              value: selectedBranchId,
              items: [null, ...branches.map((b) => b.id)],
              itemAsString: (val) {
                if (val == null) return AdminStrings.empNoBranch;
                final target = branches.firstWhereOrNull((b) => b.id == val);
                return target?.name ?? AdminStrings.empUnknownBranch;
              },
              onChanged: (value) {
                setDialogState(() => selectedBranchId = value);
              },
            ),
            SizedBox(height: 16.h),
            DialogActions(
              cancelText: AdminStrings.empCancel,
              confirmText: AdminStrings.empConfirm,
              onCancel: () => Navigator.pop(context),
              onConfirm: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  AppSnackbar.error(
                    AdminStrings.empFieldsRequired,
                    title: AdminStrings.empSecurityAlert,
                  );
                  return;
                }
                bloc.add(
                  AddEmployee(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    assignedBranchId: selectedBranchId,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditEmployeeDialog(BuildContext context, UserModel emp) async {
    final bloc = context.read<EmployeesBloc>();
    final nameController = TextEditingController(text: emp.name);
    final emailController = TextEditingController(text: emp.email);
    String? selectedBranchId = emp.assignedBranchId;
    String selectedRole = emp.isEmployee ? 'employee' : 'owner';

    final branchesDao = sl<BranchesDao>();
    final branchRows = await branchesDao.getAll();
    if (!context.mounted) return;
    final branches = branchRows
        .where((b) => !b.isDeleted)
        .map((b) => _BranchInfo(id: b.id, name: b.name))
        .toList();
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => ReusableDialog(
          title: AdminStrings.empEdit,
          headerIcon: Icon(Icons.edit_note_rounded, color: scheme.primary),
          children: [
            ReusableInput(
              controller: nameController,
              label: AdminStrings.empEditName,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput.email(
              controller: emailController,
              label: AdminStrings.empEditEmail,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String>(
              labelText: AdminStrings.empEditRole,
              hintText: AdminStrings.empEditRoleHint,
              prefixIcon: Icons.work_outline_rounded,
              value: selectedRole,
              items: const [
                'employee',
                'pharmacist',
                'cashier',
                'inventory_manager',
              ],
              itemAsString: (val) {
                switch (val) {
                  case 'pharmacist':
                    return AdminStrings.empRolePharmacist;
                  case 'cashier':
                    return AdminStrings.empRoleCashier;
                  case 'inventory_manager':
                    return AdminStrings.empRoleInventoryManager;
                  default:
                    return AdminStrings.empRoleGeneral;
                }
              },
              onChanged: (value) {
                setDialogState(() => selectedRole = value ?? 'employee');
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String?>(
              labelText: AdminStrings.empBranch,
              hintText: AdminStrings.empEditBranchHint,
              prefixIcon: Icons.storefront_rounded,
              value: selectedBranchId,
              items: [null, ...branches.map((b) => b.id)],
              itemAsString: (val) {
                if (val == null) return AdminStrings.empNoBranch;
                final target = branches.where((b) => b.id == val).firstOrNull;
                return target?.name ?? AdminStrings.empUnknownBranch;
              },
              onChanged: (value) {
                setDialogState(() => selectedBranchId = value);
              },
            ),
            SizedBox(height: 16.h),
            DialogActions(
              cancelText: AdminStrings.empCancel,
              confirmText: AdminStrings.empSaveChanges,
              onCancel: () => Navigator.pop(context),
              onConfirm: () async {
                if (nameController.text.isEmpty || emailController.text.isEmpty) {
                  AppSnackbar.error(
                    AdminStrings.empFieldsError,
                    title: AdminStrings.empSecurityAlert,
                  );
                  return;
                }
                bloc.add(
                  UpdateEmployee(
                    id: emp.id,
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteEmployee(BuildContext context, UserModel emp) {
    final bloc = context.read<EmployeesBloc>();
    ConfirmDeleteDialog.show(
      context,
      title: AdminStrings.empDeactivateTitle,
      message: AdminStrings.empDeactivateConfirmFormat.replaceFirst('%s', emp.name),
      confirmText: AdminStrings.empDeactivateYes,
      onConfirm: () {
        bloc.add(DeleteEmployee(id: emp.id));
        SoundService.instance.play(SoundEffect.error);
      },
    );
  }

  Future<void> _toggleActiveStatus(BuildContext context, UserModel emp) async {
    final dao = sl<UsersDao>();
    final existing = await dao.getById(emp.id);
    if (existing == null) return;
    final isActive = !existing.isActive;
    await dao.upsert(UsersTableCompanion(
      id: Value(emp.id),
      name: Value(existing.name),
      email: Value(existing.email),
      passwordHash: Value(existing.passwordHash),
      role: Value(existing.role),
      assignedBranchId: Value(existing.assignedBranchId),
      isActive: Value(isActive),
      createdAt: Value(existing.createdAt),
      lastLogin: Value(existing.lastLogin),
      syncVersion: Value(existing.syncVersion + 1),
      lastModified: Value(DateTime.now()),
      isDeleted: Value(existing.isDeleted),
      activeDeviceId: Value(existing.activeDeviceId),
    ));
    if (!context.mounted) return;
    context.read<EmployeesBloc>().add(const LoadEmployees());

    if (isActive) {
      AppSnackbar.success(AdminStrings.empActivatedFormat.replaceFirst('%s', emp.name), title: AdminStrings.empStatusUpdate);
    } else {
      AppSnackbar.warning(AdminStrings.empDeactivatedFormat.replaceFirst('%s', emp.name), title: AdminStrings.empStatusUpdate);
    }
  }
}

class _BranchInfo {
  final String id;
  final String name;
  const _BranchInfo({required this.id, required this.name});
}

class _EmployeeCard extends StatelessWidget {
  final UserModel employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const _EmployeeCard({required this.employee, required this.onEdit, required this.onDelete, required this.onToggleActive});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 46.w, height: 46.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft,
                colors: [scheme.primary, scheme.primary.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Center(
              child: ReusableText(employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(employee.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
                SizedBox(height: 2.h),
                ReusableText(employee.email, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryOf(context))),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    StatusBadge(label: employee.role == UserRole.owner ? AdminStrings.empBadgeOwner : AdminStrings.empRoleGeneral, color: scheme.primary),
                    SizedBox(width: AppSpacing.xs.w),
                    StatusBadge(label: employee.isActive ? AdminStrings.empBadgeActive : AdminStrings.empBadgeFrozen, color: employee.isActive ? AppColors.success : AppColors.error),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            color: AppColors.surfaceOf(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md.r)),
            onSelected: (value) {
              switch (value) {
                case 'edit': onEdit(); break;
                case 'toggle': onToggleActive(); break;
                case 'delete': onDelete(); break;
              }
            },
            itemBuilder: (context) => [
              ReusableActionMenuItem(
                value: 'edit',
                icon: Icons.edit_note_rounded,
                label: AdminStrings.editData,
              ),
              ReusableActionMenuItem(
                value: 'toggle',
                icon: employee.isActive ? Icons.lock_person_rounded : Icons.lock_open_rounded,
                label: employee.isActive ? AdminStrings.empFreeze : AdminStrings.empActivate,
                color: employee.isActive ? AppColors.warning : AppColors.success,
              ),
              ReusableActionMenuItem(
                value: 'delete',
                icon: Icons.person_remove_alt_1_rounded,
                label: AdminStrings.deleteEmployee,
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}






