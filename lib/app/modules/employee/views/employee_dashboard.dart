import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import '../../hr/services/attendance_service.dart';
import '../../home/bloc/monitoring_dashboard_bloc.dart';
import '../../home/views/dashboard_view.dart';
import '../bloc/employee_bloc.dart';

class EmployeeDashboardView extends StatefulWidget {
  const EmployeeDashboardView({super.key});

  @override
  State<EmployeeDashboardView> createState() => _EmployeeDashboardViewState();
}

class _EmployeeDashboardViewState extends State<EmployeeDashboardView> {
  String? _attendanceId;
  bool _isClocking = false;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final user = AuthService.currentUser;
    if (user == null) return;
    final today = await AttendanceService.getTodayRecord(user.id);
    setState(() => _attendanceId = today?.clockOut == null ? today?.id : null);
  }

  Future<void> _toggleAttendance() async {
    final user = AuthService.currentUser;
    if (user == null) return;
    setState(() => _isClocking = true);
    try {
      if (_attendanceId == null) {
        await AttendanceService.clockIn(
          employeeId: user.id,
          employeeName: user.name,
        );
        AppSnackbar.success(AppStrings.hrMsgAttendanceIn);
      } else {
        await AttendanceService.clockOut(_attendanceId!);
        AppSnackbar.success(AppStrings.hrMsgAttendanceOut);
      }
      _loadAttendance();
    } catch (e) {
      AppSnackbar.error('${AppStrings.errorGeneral}: $e');
    }
    setState(() => _isClocking = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final hasShift = CashierShiftService.findOpenShift(
      cashierId: user?.id,
    ) != null;
    final scheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<EmployeeBloc>()),
        BlocProvider.value(value: sl<MonitoringDashboardBloc>()),
      ],
      child: HomeShell(
        title: AppStrings.employeeDashboardTitle,
        subtitle: user?.name ?? 'مستخدم',
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: scheme.surface,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurfaceVariant,
                  tabs: [
                    Tab(text: AppStrings.employeeIndicators),
                    Tab(text: AppStrings.employeeQuickActions),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    const DashboardView(),
                    _QuickActionsTab(
                      attendanceId: _attendanceId,
                      isClocking: _isClocking,
                      hasShift: hasShift,
                      onToggleAttendance: _toggleAttendance,
                    ),
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

class _QuickActionsTab extends StatelessWidget {
  final String? attendanceId;
  final bool isClocking;
  final bool hasShift;
  final VoidCallback onToggleAttendance;

  const _QuickActionsTab({
    required this.attendanceId,
    required this.isClocking,
    required this.hasShift,
    required this.onToggleAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md.w),
      children: [
        AppCard(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(icon: Icons.access_time_rounded, title: AppStrings.hrAttendance),
              SizedBox(height: AppSpacing.md.h),
              ReusableButton(
                text: attendanceId == null ? AppStrings.hrCheckIn : AppStrings.hrCheckOut,
                prefixIcon: attendanceId == null ? Icons.login_rounded : Icons.logout_rounded,
                type: attendanceId == null ? ButtonType.success : ButtonType.error,
                isLoading: isClocking,
                onPressed: onToggleAttendance,
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        AppCard(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(icon: Icons.point_of_sale_rounded, title: AppStrings.sidebarPos),
              SizedBox(height: AppSpacing.md.h),
              ReusableButton(
                text: AppStrings.employeeOpenPos,
                prefixIcon: Icons.shopping_cart_rounded,
                type: ButtonType.primary,
                onPressed: () => context.go('/sales/pos'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
