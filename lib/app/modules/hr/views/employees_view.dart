import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
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
        
        final scheme = Theme.of(context).colorScheme;

        if (state.employees.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: const EmptyState(
              icon: Icons.people_outline_rounded,
              title: 'لا يوجد موظفون',
              subtitle: 'لم يتم إضافة أي موظفين بعد في هذا الفرع',
            ),
            floatingActionButton: ReusableFab(
              icon: Icons.person_add_rounded,
              onPressed: () => _showAddEmployeeDialog(
                  context, state.departments, state.employees),
            ),
          );
        }

        final columns = [
          ReusableTableColumn<EmployeeModel>(
            id: 'name',
            title: 'الموظف والوظيفة',
            flex: 2,
            isSortable: true,
            cellBuilder: (e) => TableContactNameCell(
              name: e.name,
              subtitle: e.jobTitle,
              icon: Icons.person_rounded,
              iconColor: scheme.primary,
            ),
          ),
          ReusableTableColumn<EmployeeModel>(
            id: 'dept',
            title: 'القسم',
            width: 150.w,
            textBuilder: (e) => e.departmentName.isNotEmpty ? e.departmentName : 'عام',
          ),
          ReusableTableColumn<EmployeeModel>(
            id: 'salary',
            title: 'الراتب',
            width: 130.w,
            isNumeric: true,
            cellBuilder: (e) => TableMoneyCell(amount: e.salary, currency: AppStrings.currency, isHighlight: true),
          ),
          ReusableTableColumn<EmployeeModel>(
            id: 'status',
            title: 'الحالة',
            width: 110.w,
            cellBuilder: (e) {
               final (color, text, icon) = _getStatus(e.status);
               return StatusBadge(label: text, color: color, icon: icon);
            },
          ),
          ReusableTableColumn<EmployeeModel>(
            id: 'phone',
            title: 'رقم الهاتف',
            width: 140.w,
            textBuilder: (e) => e.phone,
          ),
        ];

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: ReusableTable<EmployeeModel>(
              columns: columns,
              items: state.employees,
              itemLabel: 'موظف',
              rowActions: (e) => TableOptionsButton(
                onSelected: (val) {
                  if (val == 'edit') _showEditDialog(context, context.read<HrBloc>(), e);
                  if (val == 'delete') {
                    ConfirmDeleteDialog.show(
                      context,
                      title: 'حذف الموظف',
                      message: 'هل أنت متأكد من حذف الموظف "${e.name}"؟ سيتم حذف جميع بياناته نهائياً.',
                      onConfirm: () => context.read<HrBloc>().add(DeleteEmployee(e.id)),
                    );
                  }
                },
                menuItems: [
                  const PopupMenuItem(value: 'edit', child: ReusableText('تعديل البيانات')),
                  const PopupMenuItem(value: 'delete', child: ReusableText('حذف نهائي', color: AppColors.error)),
                ],
              ),
            ),
          ),
          floatingActionButton: ReusableFab(
            icon: Icons.person_add_rounded,
            onPressed: () => _showAddEmployeeDialog(
                context, state.departments, state.employees),
            backgroundColor: scheme.primary,
          ),
        );
      },
    );
  }

  (Color, String, IconData) _getStatus(String status) {
    return switch (status) {
      'active' => (AppColors.success, 'نشط', Icons.check_circle_rounded),
      'inactive' => (AppColors.warning, 'غير نشط', Icons.pause_circle_rounded),
      'left' => (AppColors.error, 'غادر', Icons.exit_to_app_rounded),
      _ => (Colors.grey, status, Icons.help_outline_rounded),
    };
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
                  title: 'إضافة موظف جديد',
                  headerIcon: const Icon(Icons.person_add_rounded),
                  children: [
                    ReusableInput(
                      label: 'اسم الموظف *',
                      hint: 'الاسم الكامل',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'رقم الهاتف',
                      hint: 'رقم الجوال',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput.email(
                      label: 'البريد الإلكتروني',
                      hint: 'example@domain.com',
                      controller: emailCtrl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'المسمى الوظيفي',
                      hint: 'مثل: صيدلي، كاشير',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    if (departmentOptions.isNotEmpty)
                      ReusableDropdown<String>(
                        labelText: 'الإدارة',
                        hintText: 'اختر الإدارة',
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
                      label: 'الراتب الأساسي (ج.م)',
                      hint: '0.00',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'ملاحظات',
                      hint: 'ملاحظات إضافية',
                      controller: notesCtrl,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: 'إضافة الموظف',
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
                  title: 'تعديل بيانات الموظف',
                  headerIcon: const Icon(Icons.edit_rounded),
                  children: [
                    ReusableInput(
                      label: 'الاسم',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'رقم الهاتف',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput.email(label: 'البريد الإلكتروني', controller: emailCtrl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'المسمى الوظيفي',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(
                      label: 'الراتب الأساسي',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableDropdown<String>(
                      labelText: 'حالة الموظف',
                      hintText: 'اختر الحالة',
                      items: const ['active', 'inactive', 'left'],
                      value: selectedStatus,
                      itemAsString:
                          (s) => switch (s) {
                            'active' => 'نشط',
                            'inactive' => 'غير نشط',
                            'left' => 'غادر',
                            _ => s,
                          },
                      onChanged: (v) {
                        if (v != null) setState(() => selectedStatus = v);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: 'حفظ التغييرات',
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
