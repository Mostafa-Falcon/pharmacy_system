import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/models/hr/attendance_model.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/tables/shared_table_cells.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/hr_bloc.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading &&
            state.attendanceRecords.isEmpty) {
          return const LoadingIndicator();
        }
        final today = DateTime.now().toIso8601String().substring(0, 10);
        final todayRecords = state.attendanceRecords
            .where((a) => a.date == today)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<HrBloc>().add(const LoadHrData()),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md.w),
              physics: const BouncingScrollPhysics(),
              children: [
                _TodaySummaryCard(todayRecords: todayRecords),
                SizedBox(height: AppSpacing.md.h),
                _ClockInOutCard(todayRecords: todayRecords),
                SizedBox(height: AppSpacing.md.h),
                _AttendanceHistoryCard(
                  records: state.attendanceRecords,
                  employees: state.employees,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  final List<AttendanceModel> todayRecords;
  const _TodaySummaryCard({required this.todayRecords});

  @override
  Widget build(BuildContext context) {
    final checkedIn = todayRecords.where((a) => a.clockIn.isNotEmpty).length;
    final checkedOut = todayRecords.where((a) => a.clockOut != null).length;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 32.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableText(
              'حضور اليوم',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.login_rounded,
                  label: 'تم الحضور',
                  value: '$checkedIn',
                ),
                _StatItem(
                  icon: Icons.logout_rounded,
                  label: 'تم الانصراف',
                  value: '$checkedOut',
                ),
                _StatItem(
                  icon: Icons.people_rounded,
                  label: 'الإجمالي',
                  value: '${todayRecords.length}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(height: 4.h),
        ReusableText(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        ReusableText(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }
}

class _ClockInOutCard extends StatelessWidget {
  final List<AttendanceModel> todayRecords;
  const _ClockInOutCard({required this.todayRecords});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HrBloc>();
    final hasClockedIn = todayRecords.isNotEmpty;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReusableButton(
                  text: hasClockedIn ? 'تسجيل انصراف' : 'تسجيل حضور',
                  type: hasClockedIn ? ButtonType.outlined : ButtonType.primary,
                  onPressed: () async {
                    final employees = bloc.state.employees;
                    if (employees.isEmpty) {
                      AppSnackbar.warning('لا يوجد موظفون للتسجيل');
                      return;
                    }
                    if (hasClockedIn) {
                      final record = todayRecords.first;
                      bloc.add(ClockOut(record.id));
                    } else {
                      final emp = employees.first;
                      bloc.add(
                        ClockIn(employeeId: emp.id, employeeName: emp.name),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceHistoryCard extends StatelessWidget {
  final List<AttendanceModel> records;
  final List<EmployeeModel> employees;
  const _AttendanceHistoryCard({
    required this.records,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    final columns = [
      ReusableTableColumn<AttendanceModel>(
        id: 'emp',
        title: 'الموظف',
        flex: 2,
        cellBuilder: (a) => TableContactNameCell(
          name: a.employeeName.isNotEmpty ? a.employeeName : a.employeeId,
          subtitle: a.date,
          icon: Icons.person_rounded,
          iconColor: _statusColor(context, a.status),
        ),
      ),
      ReusableTableColumn<AttendanceModel>(
        id: 'in',
        title: 'حضور',
        width: 100.w,
        textBuilder: (a) =>
            a.clockIn.length > 11 ? a.clockIn.substring(11, 16) : '--',
      ),
      ReusableTableColumn<AttendanceModel>(
        id: 'out',
        title: 'انصراف',
        width: 100.w,
        textBuilder: (a) => (a.clockOut?.length ?? 0) > 11
            ? a.clockOut!.substring(11, 16)
            : '--',
      ),
      ReusableTableColumn<AttendanceModel>(
        id: 'hours',
        title: 'ساعات',
        width: 90.w,
        textBuilder: (a) => '${a.workedHours} س',
      ),
      ReusableTableColumn<AttendanceModel>(
        id: 'status',
        title: 'الحالة',
        width: 110.w,
        cellBuilder: (a) => StatusBadge(
          label: _statusLabel(a.status),
          color: _statusColor(context, a.status),
          icon: _statusIcon(a.status),
        ),
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.history_rounded, title: 'سجل الحضور'),
          SizedBox(height: AppSpacing.sm.h),
          SizedBox(
            height: 400.h,
            child: ReusableTable<AttendanceModel>(
              columns: columns,
              items: records,
              itemLabel: 'سجل حضور',
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
    'present' => 'حاضر',
    'late' => 'متأخر',
    'absent' => 'غائب',
    'half-day' => 'نصف يوم',
    _ => status,
  };

  Color _statusColor(BuildContext context, String status) => switch (status) {
    'present' => AppColors.success,
    'late' => AppColors.warning,
    'absent' => AppColors.error,
    'half-day' => AppColors.info,
    _ => AppColors.textMutedOf(context),
  };

  IconData _statusIcon(String status) => switch (status) {
    'present' => Icons.check_circle_rounded,
    'late' => Icons.warning_amber_rounded,
    'absent' => Icons.cancel_rounded,
    'half-day' => Icons.access_time_rounded,
    _ => Icons.help_rounded,
  };
}
