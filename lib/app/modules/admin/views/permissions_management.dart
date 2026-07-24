import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/permission_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../bloc/employees_bloc.dart';

class PermissionsManagementView extends StatelessWidget {
  const PermissionsManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EmployeesBloc>(),
      child: const _PermissionsManagementBody(),
    );
  }
}

class _PermissionsManagementBody extends StatelessWidget {
  const _PermissionsManagementBody();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EmployeesBloc>(),
      child: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          return StandardModuleLayout(
            title: '????? ??????? ??????',
            subtitle: '????? ?????? ??????? ????? ???????? ??? ????? ???????',
            content: Column(
              children: [
                _buildEmployeeSelector(context, state),
                SizedBox(height: AppSpacing.md),
                Expanded(child: _buildPermissionsGrid(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeSelector(BuildContext context, EmployeesState state) {
    final bloc = context.read<EmployeesBloc>();
    final employees = state.employees;
    final selected = state.selectedEmployee;
    final employeeMap = <String, UserModel>{};
    for (final emp in employees) {
      employeeMap[emp.id] = emp;
    }

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(Icons.badge_rounded,
              color: Theme.of(context).colorScheme.primary, size: 20.sp),
          SizedBox(width: AppSpacing.sm),
          ReusableText(
            '???? ???? ????????:',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryOf(context)),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: ReusableDropdown<String?>(
              hintText: '???? ??? ??????? ??? ??????',
              value: selected?.id,
              items: employees.map((emp) => emp.id).toList(),
              itemAsString: (id) {
                final target = employeeMap[id];
                return target?.name ?? '??? ?????';
              },
              onChanged: (id) {
                if (id != null) {
                  bloc.add(SelectEmployee(id: id));
                  bloc.add(LoadEmployeePermissions(id));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsGrid(BuildContext context, EmployeesState state) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<EmployeesBloc>();
    final selected = state.selectedEmployee;

    if (selected == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security_rounded,
                size: 60.sp,
                color: AppColors.textMutedOf(context).withValues(alpha: 0.4)),
            SizedBox(height: AppSpacing.sm),
            ReusableText(
              '????? ?????? ???? ????? ???? ?????? ????????',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
      );
    }

    final allPermissions = PermissionService.defaultOwnerPermissions;
    final userPermissions = state.selectedEmployeePermissions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.shield_rounded, color: scheme.primary, size: 20.sp),
                SizedBox(width: AppSpacing.xs),
                ReusableText(
                  '???? ???????: ${selected.name}',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryOf(context)),
                ),
              ],
            ),
            _buildQuickActions(context, selected.id),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1100
                  ? 4
                  : (MediaQuery.of(context).size.width > 750 ? 3 : 2),
              childAspectRatio: 2.5,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: allPermissions.length,
            itemBuilder: (context, index) {
              final perm = allPermissions[index];
              final isAllowed = userPermissions.contains(perm);
              return AppCard(
                padding: EdgeInsets.zero,
                borderRadius: AppRadius.md.r,
                backgroundColor: isAllowed
                    ? AppColors.primarySoftOf(context)
                    : AppColors.inputFillOf(context).withValues(alpha: 0.3),
                child: CheckboxListTile(
                  value: isAllowed,
                  activeColor: scheme.primary,
                  checkColor: Colors.white,
                  onChanged: (value) async {
                    if (value == true) {
                      await PermissionService.grantPermission(selected.id, perm);
                    } else {
                      await PermissionService.revokePermission(selected.id, perm);
                    }
                    bloc.add(LoadEmployeePermissions(selected.id));
                  },
                  title: ReusableText(
                    _getPermissionLabel(perm),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isAllowed ? FontWeight.bold : FontWeight.w500,
                      color: isAllowed
                          ? scheme.primary
                          : AppColors.textPrimaryOf(context),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, String userId) {
    final bloc = context.read<EmployeesBloc>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableButton(
          text: '????? ????',
          prefixIcon: Icons.done_all_rounded,
          type: ButtonType.text,
          onPressed: () async {
            for (final perm in PermissionService.defaultOwnerPermissions) {
              await PermissionService.grantPermission(userId, perm);
            }
            bloc.add(LoadEmployeePermissions(userId));
          },
        ),
        SizedBox(width: AppSpacing.xs.w),
        ReusableButton(
          text: '??? ????',
          prefixIcon: Icons.block_rounded,
          type: ButtonType.text,
          onPressed: () async {
            for (final perm in PermissionService.defaultOwnerPermissions) {
              await PermissionService.revokePermission(userId, perm);
            }
            bloc.add(LoadEmployeePermissions(userId));
          },
        ),
      ],
    );
  }

  String _getPermissionLabel(String key) {
    const labels = {
      'dashboard': '???? ?????? ??????', 'pos': '???? ????? (???????)', 'inventory': '????? ???????',
      'medicines': '????? ?????? ???????', 'categories': '??????? ???????', 'stock': '??? ??????? ????????',
      'customers': '????? ???????', 'suppliers': '????? ????????', 'reports': '???????? ????????',
      'settings': '??????? ?????? ??????', 'admin_panel': '???? ??????? ???????', 'employees': '?????? ????????',
      'branches': '????? ???? ?????????', 'permissions': '????? ????????? ????????', 'create_invoice': '????? ?????? ????????',
      'cancel_invoice': '????? ???? ????????', 'refund': '????? ??????? ????????', 'adjust_stock': '????? ?????? ??????? ??????',
      'delete_medicine': '??? ???? ???? ???????', 'manage_users': '????? ??????? ??????', 'manage_branches': '????? ???? ??????',
      'view_reports': '??? ?????? ??????? ????????', 'export_data': '????? ??? ??????? ?????', 'manage_permissions': '????? ??? ????????',
    };
    return labels[key] ?? key;
  }
}





