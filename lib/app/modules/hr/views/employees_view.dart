import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/tables/shared_table_cells.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
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
            body: const AppStateView.empty(
              icon: Icons.people_outline_rounded,
              title: '?? ???? ??????',
              subtitle: '?? ??? ????? ?? ?????? ??? ?? ??? ?????',
            ),
            floatingActionButton: ReusableFab(
              icon: Icons.person_add_rounded,
              onPressed: () => _showAddEmployeeDialog(
                  context, state.departments, state.employees),
            ),
          );
        }

        final columns = [
          AppTableColumn<EmployeeModel>(
            id: 'name',
            title: '?????? ????????',
            flex: 2,
            isSortable: true,
            cellBuilder: (e) => TableContactNameCell(
              name: e.name,
              subtitle: e.jobTitle,
              icon: Icons.person_rounded,
              iconColor: scheme.primary,
            ),
          ),
          AppTableColumn<EmployeeModel>(
            id: 'dept',
            title: '?????',
            width: 150.w,
            textBuilder: (e) => e.departmentName.isNotEmpty ? e.departmentName : '???',
          ),
          AppTableColumn<EmployeeModel>(
            id: 'salary',
            title: '??????',
            width: 130.w,
            isNumeric: true,
            cellBuilder: (e) => TableMoneyCell(amount: e.salary, currency: GeneralStrings.currency, isHighlight: true),
          ),
          AppTableColumn<EmployeeModel>(
            id: 'status',
            title: '??????',
            width: 110.w,
            cellBuilder: (e) {
               final (color, text, icon) = _getStatus(e.status);
               return StatusBadge(label: text, color: color, icon: icon);
            },
          ),
          AppTableColumn<EmployeeModel>(
            id: 'phone',
            title: '??? ??????',
            width: 140.w,
            textBuilder: (e) => e.phone,
          ),
        ];

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: AppTable<EmployeeModel>(
              columns: columns,
              items: state.employees,
              itemLabel: '????',
              rowActions: (e) => TableOptionsButton(
                onSelected: (val) {
                  if (val == 'edit') _showEditDialog(context, context.read<HrBloc>(), e);
                  if (val == 'delete') {
                    ConfirmDeleteDialog.show(
                      context,
                      title: '??? ??????',
                      message: '?? ??? ????? ?? ??? ?????? "${e.name}"? ???? ??? ???? ??????? ???????.',
                      onConfirm: () => context.read<HrBloc>().add(DeleteEmployee(e.id)),
                    );
                  }
                },
                menuItems: [
                  const PopupMenuItem(value: 'edit', child: AppText('????? ????????')),
                  PopupMenuItem(value: 'delete', child: AppText('??? ?????', color: AppColors.error)),
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
      'active' => (AppColors.success, '???', Icons.check_circle_rounded),
      'inactive' => (AppColors.warning, '??? ???', Icons.pause_circle_rounded),
      'left' => (AppColors.error, '????', Icons.exit_to_app_rounded),
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
                (context, setState) => AppDialog(
                  title: '????? ???? ????',
                  headerIcon: const Icon(Icons.person_add_rounded),
                  children: [
                    AppInput(
                      label: '??? ?????? *',
                      hint: '????? ??????',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '??? ??????',
                      hint: '??? ??????',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput.email(
                      label: '?????? ??????????',
                      hint: 'example@domain.com',
                      controller: emailCtrl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '?????? ???????',
                      hint: '???: ?????? ?????',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    if (departmentOptions.isNotEmpty)
                      ReusableDropdown<String>(
                        labelText: '???????',
                        hintText: '???? ???????',
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
                    AppInput(
                      label: '?????? ??????? (?.?)',
                      hint: '0.00',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '???????',
                      hint: '??????? ??????',
                      controller: notesCtrl,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: '????? ??????',
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
                (context, setState) => AppDialog(
                  title: '????? ?????? ??????',
                  headerIcon: const Icon(Icons.edit_rounded),
                  children: [
                    AppInput(
                      label: '?????',
                      controller: nameCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '??? ??????',
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput.email(label: '?????? ??????????', controller: emailCtrl),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '?????? ???????',
                      controller: jobTitleCtrl,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppInput(
                      label: '?????? ???????',
                      controller: salaryCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableDropdown<String>(
                      labelText: '???? ??????',
                      hintText: '???? ??????',
                      items: const ['active', 'inactive', 'left'],
                      value: selectedStatus,
                      itemAsString:
                          (s) => switch (s) {
                            'active' => '???',
                            'inactive' => '??? ???',
                            'left' => '????',
                            _ => s,
                          },
                      onChanged: (v) {
                        if (v != null) setState(() => selectedStatus = v);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    DialogActions(
                      confirmText: '??? ?????????',
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




