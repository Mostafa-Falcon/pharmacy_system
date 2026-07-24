import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
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
              ? AppStateView.empty(
                  icon: Icons.business_rounded,
                  title: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø¥Ø¯Ø§Ø±Ø§Øª',
                  subtitle: 'Ù„Ù… ÙŠØªÙ… Ø¥Ø¶Ø§ÙØ© Ø£ÙŠ Ø¥Ø¯Ø§Ø±Ø§Øª Ø¨Ø¹Ø¯',
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
                (context, setState) => AppDialog(
                  title: 'Ø¥Ø¶Ø§ÙØ© Ø¥Ø¯Ø§Ø±Ø© Ø¬Ø¯ÙŠØ¯Ø©',
                  headerIcon: Icon(
                    Icons.add_business_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  children: [
                    AppInput.text(
                      label: 'Ø§Ø³Ù… Ø§Ù„Ø¥Ø¯Ø§Ø±Ø©',
                      hint: 'Ù…Ø«Ø§Ù„: Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
                      controller: nameCtrl,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppInput.text(
                      label: 'Ø§Ù„ÙˆØµÙ',
                      hint: 'ÙˆØµÙ Ù…Ø®ØªØµØ±',
                      controller: descCtrl,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    if (employees.isNotEmpty)
                      ReusableDropdown<String>(
                        labelText: 'Ù…Ø¯ÙŠØ± Ø§Ù„Ø¥Ø¯Ø§Ø±Ø©',
                        hintText: 'Ø§Ø®ØªØ± Ù…ÙˆØ¸Ù',
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
                      confirmText: 'Ø¥Ø¶Ø§ÙØ©',
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
          child: AppText(
            department.name.isNotEmpty ? department.name[0] : '?',
            style: TextStyle(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        title: AppText(
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
              AppText(
                'Ù…Ø¯ÙŠØ±: ${department.managerName}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            if (department.description != null &&
                department.description!.isNotEmpty)
              AppText(
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
              child: AppText(
                '${department.employeeCount} Ù…ÙˆØ¸Ù',
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
                      title: 'Ø­Ø°Ù Ø§Ù„Ø¥Ø¯Ø§Ø±Ø©',
                      message: 'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù ${department.name}ØŸ',
                      onConfirm: () => bloc.add(DeleteDepartment(department.id)),
                    );
                }
              },
              itemBuilder: (context) => [
                ReusableActionMenuItem(
                  value: 'edit',
                  icon: Icons.edit_outlined,
                  label: GeneralStrings.edit,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: GeneralStrings.delete,
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
          (context) => AppDialog(
            title: 'ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ø¥Ø¯Ø§Ø±Ø©',
            headerIcon: Icon(
              Icons.edit_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
            children: [
              AppInput.text(label: 'Ø§Ù„Ø§Ø³Ù…', controller: nameCtrl),
              SizedBox(height: AppSpacing.md.h),
              AppInput.text(label: 'Ø§Ù„ÙˆØµÙ', controller: descCtrl),
              SizedBox(height: AppSpacing.lg.h),
              DialogActions(
                confirmText: 'Ø­ÙØ¸',
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






