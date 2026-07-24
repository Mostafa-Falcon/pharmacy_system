import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/injection.dart';
import '../bloc/hr_bloc.dart';
import 'employees_view.dart';
import 'attendance_view.dart';
import 'leave_view.dart';
import 'payroll_view.dart';
import 'departments_view.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/shareds/home_shell.dart';

class HrShellView extends StatelessWidget {
  const HrShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HrBloc>(),
      child: HomeShell(
        title: 'إدارة الموارد البشرية',
        subtitle: 'شؤون الموظفين، الرواتب، والحضور والانصراف',
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Container(
                color: AppColors.surfaceOf(context),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: AppColors.textSecondaryOf(context),
                  labelStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'الموظفين'),
                    Tab(text: 'الحضور والانصراف'),
                    Tab(text: 'الإجازات'),
                    Tab(text: 'الرواتب'),
                    Tab(text: 'الإدارات'),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    EmployeesView(),
                    AttendanceView(),
                    LeaveView(),
                    PayrollView(),
                    DepartmentsView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



