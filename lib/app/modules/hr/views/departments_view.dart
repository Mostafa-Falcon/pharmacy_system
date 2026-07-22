import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading && state.departments.isEmpty) {
          return const LoadingIndicator();
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          body: state.departments.isEmpty
              ? EmptyState(
                  icon: Icons.business_rounded,
                  title: 'Ã™â€žÃ˜Â§ Ã˜ÂªÃ™Ë†Ã˜Â¬Ã˜Â¯ Ã˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â§Ã˜Âª',
                  subtitle: 'Ã™â€žÃ™â€¦ Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â£Ã™Å  Ã˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â§Ã˜Âª Ã˜Â¨Ã˜Â¹Ã˜Â¯',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.departments.length,
                  itemBuilder: (context, index) {
                    final dept = state.departments[index];
                    return _DepartmentCard(department: dept);
                  },
                ),
          floatingActionButton: ReusableFab(
            icon: Icons.add_business_rounded,
            onPressed: () =>
                _showAddDepartmentDialog(context, state.employees),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _showAddDepartmentDialog(
    BuildContext context,
    List<EmployeeModel> employees,
  ) {
    final bloc = context.read<HrBloc>();
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? managerId;
    String? managerName;

    if (employees.isNotEmpty) {
      managerId = employees.first.id;
      managerName = employees.first.name;
    }

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => ReusableDialog(
                  title: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â© Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯Ã˜Â©',
                  headerIcon: Icon(
                    Icons.add_business_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  children: [
                    ReusableInput.text(
                      label: 'Ã˜Â§Ã˜Â³Ã™â€¦ Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
                      hint: 'Ã™â€¦Ã˜Â«Ã˜Â§Ã™â€ž: Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¨Ã™Å Ã˜Â¹Ã˜Â§Ã˜Âª',
                      controller: nameCtrl,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    ReusableInput.text(
                      label: 'Ã˜Â§Ã™â€žÃ™Ë†Ã˜ÂµÃ™Â',
                      hint: 'Ã™Ë†Ã˜ÂµÃ™Â Ã™â€¦Ã˜Â®Ã˜ÂªÃ˜ÂµÃ˜Â±',
                      controller: descCtrl,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    if (employees.isNotEmpty)
                      ReusableDropdown<String>(
                        labelText: 'Ã™â€¦Ã˜Â¯Ã™Å Ã˜Â± Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
                        hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                        items: employees.map((e) => e.name).toList(),
                        value: managerName,
                        itemAsString: (s) => s,
                        onChanged: (v) {
                          if (v != null) {
                            final emp = employees.firstWhere((e) => e.name == v);
                            setState(() {
                              managerId = emp.id;
                              managerName = emp.name;
                            });
                          }
                        },
                      ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â©',
                      onConfirm: () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        bloc.add(
                          AddDepartment(
                            name: name,
                            managerId: managerId,
                            managerName: managerName,
                            description:
                                descCtrl.text.trim().isEmpty
                                    ? null
                                    : descCtrl.text.trim(),
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
}

class _DepartmentCard extends StatelessWidget {
  final DepartmentModel department;
  const _DepartmentCard({required this.department});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HrBloc>();

    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: 4.h),
        leading: CircleAvatar(
          backgroundColor: AppColors.infoSoftOf(context),
          child: ReusableText(
            department.name.isNotEmpty ? department.name[0] : '?',
            style: TextStyle(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        title: ReusableText(
          department.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (department.managerName != null &&
                department.managerName!.isNotEmpty)
              ReusableText(
                'Ã™â€¦Ã˜Â¯Ã™Å Ã˜Â±: ${department.managerName}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            if (department.description != null &&
                department.description!.isNotEmpty)
              ReusableText(
                department.description!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMutedOf(context),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primarySoftOf(context),
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
              ),
              child: ReusableText(
                '${department.employeeCount} Ã™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditDialog(context, bloc, department);
                  case 'delete':
                    ConfirmDeleteDialog.show(
                      context,
                      title: 'Ã˜Â­Ã˜Â°Ã™Â Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
                      message: 'Ã™â€¡Ã™â€ž Ã˜Â£Ã™â€ Ã˜Âª Ã™â€¦Ã˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã˜Â­Ã˜Â°Ã™Â ${department.name}Ã˜Å¸',
                      onConfirm: () => bloc.add(DeleteDepartment(department.id)),
                    );
                }
              },
              itemBuilder: (context) => [
                ReusableActionMenuItem(
                  value: 'edit',
                  icon: Icons.edit_outlined,
                  label: AppStrings.edit,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: AppStrings.delete,
                  color: AppColors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    HrBloc bloc,
    DepartmentModel dept,
  ) {
    final nameCtrl = TextEditingController(text: dept.name);
    final descCtrl = TextEditingController(text: dept.description ?? '');

    showDialog(
      context: context,
      builder:
          (context) => ReusableDialog(
            title: 'Ã˜ÂªÃ˜Â¹Ã˜Â¯Ã™Å Ã™â€ž Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
            headerIcon: Icon(
              Icons.edit_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
            children: [
              ReusableInput.text(label: 'Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã™â€¦', controller: nameCtrl),
              SizedBox(height: AppSpacing.md.h),
              ReusableInput.text(label: 'Ã˜Â§Ã™â€žÃ™Ë†Ã˜ÂµÃ™Â', controller: descCtrl),
              SizedBox(height: AppSpacing.lg.h),
              DialogActions(
                confirmText: 'Ã˜Â­Ã™ÂÃ˜Â¸',
                onConfirm: () async {
                  bloc.add(
                    UpdateDepartment(
                      id: dept.id,
                      name: nameCtrl.text.trim(),
                      description:
                          descCtrl.text.trim().isEmpty
                              ? null
                              : descCtrl.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}


