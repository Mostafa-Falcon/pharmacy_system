import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading && state.employees.isEmpty) {
          return const LoadingIndicator();
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          body: state.employees.isEmpty
              ? const EmptyState(
                  icon: Icons.people_outline_rounded,
                  title: 'Ã™â€žÃ˜Â§ Ã™Å Ã™Ë†Ã˜Â¬Ã˜Â¯ Ã™â€¦Ã™Ë†Ã˜Â¸Ã™ÂÃ™Ë†Ã™â€ ',
                  subtitle: 'Ã™â€žÃ™â€¦ Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â£Ã™Å  Ã™â€¦Ã™Ë†Ã˜Â¸Ã™ÂÃ™Å Ã™â€  Ã˜Â¨Ã˜Â¹Ã˜Â¯ Ã™ÂÃ™Å  Ã™â€¡Ã˜Â°Ã˜Â§ Ã˜Â§Ã™â€žÃ™ÂÃ˜Â±Ã˜Â¹',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) {
                    final emp = state.employees[index];
                    return _EmployeeCard(employee: emp);
                  },
                ),
          floatingActionButton: ReusableFab(
            icon: Icons.person_add_rounded,
            onPressed: () => _showAddEmployeeDialog(
                context, state.departments, state.employees),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _showAddEmployeeDialog(
    BuildContext context,
    List<DepartmentModel> departments,
    List<EmployeeModel> employees,
  ) {
    final bloc = context.read<HrBloc>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final jobTitleCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedDepartmentId = '';
    String? selectedDepartmentName;
    final departmentOptions = departments.map((d) => d.name).toList();
    final departmentKeys = departments.map((d) => d.id).toList();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => ReusableDialog(
                  title: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã™â€¦Ã™Ë†Ã˜Â¸Ã™Â Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯',
                  headerIcon: const Icon(Icons.person_add_rounded),
                  children: [
                    ReusableInput(
                      label: 'Ã˜Â§Ã˜Â³Ã™â€¦ Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â *',
                      hint: 'Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã™â€¦ Ã˜Â§Ã™â€žÃ™Æ’Ã˜Â§Ã™â€¦Ã™â€ž',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â±Ã™â€šÃ™â€¦ Ã˜Â§Ã™â€žÃ™â€¡Ã˜Â§Ã˜ÂªÃ™Â',
                      hint: 'Ã˜Â±Ã™â€šÃ™â€¦ Ã˜Â§Ã™â€žÃ˜Â¬Ã™Ë†Ã˜Â§Ã™â€ž',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput.email(
                      label: 'Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â±Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å ',
                      hint: 'example@domain.com',
                      controller: emailCtrl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â³Ã™â€¦Ã™â€° Ã˜Â§Ã™â€žÃ™Ë†Ã˜Â¸Ã™Å Ã™ÂÃ™Å ',
                      hint: 'Ã™â€¦Ã˜Â«Ã™â€ž: Ã˜ÂµÃ™Å Ã˜Â¯Ã™â€žÃ™Å Ã˜Å’ Ã™Æ’Ã˜Â§Ã˜Â´Ã™Å Ã˜Â±',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    if (departmentOptions.isNotEmpty)
                      ReusableDropdown<String>(
                        labelText: 'Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
                        hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã˜Â§Ã™â€žÃ˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â©',
                        items: departmentOptions,
                        value: selectedDepartmentName,
                        itemAsString: (s) => s,
                        onChanged: (v) {
                          if (v != null) {
                            final idx = departmentOptions.indexOf(v);
                            setState(() {
                              selectedDepartmentId =
                                  idx >= 0 ? departmentKeys[idx] : '';
                              selectedDepartmentName = v;
                            });
                          }
                        },
                      ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â§Ã™â€žÃ˜Â±Ã˜Â§Ã˜ÂªÃ˜Â¨ Ã˜Â§Ã™â€žÃ˜Â£Ã˜Â³Ã˜Â§Ã˜Â³Ã™Å  (Ã˜Â¬.Ã™â€¦)',
                      hint: '0.00',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â­Ã˜Â¸Ã˜Â§Ã˜Âª',
                      hint: 'Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â­Ã˜Â¸Ã˜Â§Ã˜Âª Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ™Å Ã˜Â©',
                      controller: notesCtrl,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                      onConfirm: () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        final salary = double.tryParse(salaryCtrl.text) ?? 0;
                        bloc.add(
                          AddEmployee(
                            name: name,
                            phone: phoneCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            departmentId: selectedDepartmentId,
                            departmentName: selectedDepartmentName ?? '',
                            jobTitle: jobTitleCtrl.text.trim(),
                            salary: salary,
                            notes:
                                notesCtrl.text.trim().isEmpty
                                    ? null
                                    : notesCtrl.text.trim(),
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

class _EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HrBloc>();
    final scheme = Theme.of(context).colorScheme;
    
    final (statusColor, statusText, statusIcon) = switch (employee.status) {
      'active' => (AppColors.success, 'Ã™â€ Ã˜Â´Ã˜Â·', Icons.check_circle_rounded),
      'inactive' => (AppColors.warning, 'Ã˜ÂºÃ™Å Ã˜Â± Ã™â€ Ã˜Â´Ã˜Â·', Icons.pause_circle_rounded),
      'left' => (AppColors.error, 'Ã˜ÂºÃ˜Â§Ã˜Â¯Ã˜Â±', Icons.exit_to_app_rounded),
      _ => (AppColors.textMutedOf(context), employee.status, Icons.help_outline_rounded),
    };

    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: 4.h),
        leading: CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.primarySoftOf(context),
          child: ReusableText(
            employee.name.isNotEmpty ? employee.name[0] : '?',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        title: ReusableText(
          employee.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (employee.jobTitle.isNotEmpty)
              ReusableText(
                employee.jobTitle,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            if (employee.departmentName.isNotEmpty)
              ReusableText(
                employee.departmentName,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textMutedOf(context),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(
              label: statusText,
              color: statusColor,
              icon: statusIcon,
            ),
            SizedBox(width: 12.w),
            ReusableText(
              '${employee.salary.toStringAsFixed(0)} Ã˜Â¬.Ã™â€¦',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    _showEditDialog(context, bloc, employee);
                    break;
                  case 'delete':
                    ConfirmDeleteDialog.show(
                      context,
                      title: 'Ã˜Â­Ã˜Â°Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                      message: 'Ã™â€¡Ã™â€ž Ã˜Â£Ã™â€ Ã˜Âª Ã™â€¦Ã˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã˜Â­Ã˜Â°Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â "${employee.name}"Ã˜Å¸ Ã˜Â³Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â­Ã˜Â°Ã™Â Ã˜Â¬Ã™â€¦Ã™Å Ã˜Â¹ Ã˜Â¨Ã™Å Ã˜Â§Ã™â€ Ã˜Â§Ã˜ÂªÃ™â€¡ Ã™â€ Ã™â€¡Ã˜Â§Ã˜Â¦Ã™Å Ã˜Â§Ã™â€¹.',
                      onConfirm: () => bloc.add(DeleteEmployee(employee.id)),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                ReusableActionMenuItem(
                  value: 'edit',
                  icon: Icons.edit_outlined,
                  label: AppStrings.editData,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: AppStrings.deleteEmployee,
                  color: AppColors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, HrBloc bloc, EmployeeModel emp) {
    final nameCtrl = TextEditingController(text: emp.name);
    final phoneCtrl = TextEditingController(text: emp.phone);
    final emailCtrl = TextEditingController(text: emp.email);
    final jobTitleCtrl = TextEditingController(text: emp.jobTitle);
    final salaryCtrl =
        TextEditingController(text: emp.salary.toStringAsFixed(0));
    String selectedStatus = emp.status;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => ReusableDialog(
                  title: 'Ã˜ÂªÃ˜Â¹Ã˜Â¯Ã™Å Ã™â€ž Ã˜Â¨Ã™Å Ã˜Â§Ã™â€ Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                  headerIcon: const Icon(Icons.edit_rounded),
                  children: [
                    ReusableInput(
                      label: 'Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã™â€¦',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â±Ã™â€šÃ™â€¦ Ã˜Â§Ã™â€žÃ™â€¡Ã˜Â§Ã˜ÂªÃ™Â',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput.email(label: 'Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â±Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å ', controller: emailCtrl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â³Ã™â€¦Ã™â€° Ã˜Â§Ã™â€žÃ™Ë†Ã˜Â¸Ã™Å Ã™ÂÃ™Å ',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'Ã˜Â§Ã™â€žÃ˜Â±Ã˜Â§Ã˜ÂªÃ˜Â¨ Ã˜Â§Ã™â€žÃ˜Â£Ã˜Â³Ã˜Â§Ã˜Â³Ã™Å ',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableDropdown<String>(
                      labelText: 'Ã˜Â­Ã˜Â§Ã™â€žÃ˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¸Ã™Â',
                      hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã˜Â§Ã™â€žÃ˜Â­Ã˜Â§Ã™â€žÃ˜Â©',
                      items: const ['active', 'inactive', 'left'],
                      value: selectedStatus,
                      itemAsString:
                          (s) => switch (s) {
                            'active' => 'Ã™â€ Ã˜Â´Ã˜Â·',
                            'inactive' => 'Ã˜ÂºÃ™Å Ã˜Â± Ã™â€ Ã˜Â´Ã˜Â·',
                            'left' => 'Ã˜ÂºÃ˜Â§Ã˜Â¯Ã˜Â±',
                            _ => s,
                          },
                      onChanged: (v) {
                        if (v != null) setState(() => selectedStatus = v);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: 'Ã˜Â­Ã™ÂÃ˜Â¸ Ã˜Â§Ã™â€žÃ˜ÂªÃ˜ÂºÃ™Å Ã™Å Ã˜Â±Ã˜Â§Ã˜Âª',
                      onConfirm: () async {
                        final salary =
                            double.tryParse(salaryCtrl.text) ?? emp.salary;
                        bloc.add(
                          UpdateEmployee(
                            id: emp.id,
                            name: nameCtrl.text.trim(),
                            phone: phoneCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            jobTitle: jobTitleCtrl.text.trim(),
                            salary: salary,
                            status: selectedStatus,
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

