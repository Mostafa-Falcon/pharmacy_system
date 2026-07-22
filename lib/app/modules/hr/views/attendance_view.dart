import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/attendance_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading && state.attendanceRecords.isEmpty) {
          return const LoadingIndicator();
        }
        final today = DateTime.now().toIso8601String().substring(0, 10);
        final todayRecords = state.attendanceRecords
            .where((a) => a.date == today)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          body: RefreshIndicator(
            onRefresh: () async => context.read<HrBloc>().add(const LoadHrData()),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md.w),
              physics: const BouncingScrollPhysics(),
              children: [
                _TodaySummaryCard(todayRecords: todayRecords),
                SizedBox(height: AppSpacing.md.h),
                _ClockInOutCard(todayRecords: todayRecords),
                SizedBox(height: AppSpacing.md.h),
                _AttendanceHistoryCard(records: state.attendanceRecords, employees: state.employees),
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
            Icon(Icons.access_time_rounded,
                size: 32.sp, color: AppColors.primary),
            SizedBox(height: AppSpacing.sm.h),
            ReusableText(
              'حضور اليوم',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                    icon: Icons.login_rounded,
                    label: 'تم الحضور',
                    value: '$checkedIn'),
                _StatItem(
                    icon: Icons.logout_rounded,
                    label: 'تم الانصراف',
                    value: '$checkedOut'),
                _StatItem(
                    icon: Icons.people_rounded,
                    label: 'الإجمالي',
                    value: '${todayRecords.length}'),
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
  const _StatItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(height: 4.h),
        ReusableText(value,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryOf(context))),
        ReusableText(label,
            style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondaryOf(context))),
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
                      bloc.add(ClockIn(
                        employeeId: emp.id,
                        employeeName: emp.name,
                      ));
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
  const _AttendanceHistoryCard({required this.records, required this.employees});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            'سجل الحضور',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ...records.take(20).map((a) {
            final hours = a.workedHours;
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 16.r,
                backgroundColor: _statusColor(context, a.status).withValues(alpha: 0.12),
                child: Icon(
                  _statusIcon(a.status),
                  size: 16.sp,
                  color: _statusColor(context, a.status),
                ),
              ),
              title: ReusableText(
                a.employeeName.isNotEmpty ? a.employeeName : a.employeeId,
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: ReusableText(
                '${a.date} | ${a.clockIn.isNotEmpty ? a.clockIn.substring(11, 19) : '--'}',
                style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondaryOf(context)),
              ),
              trailing: ReusableText(
                hours > 0 ? '$hours س' : a.status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _statusColor(context, a.status),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

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


