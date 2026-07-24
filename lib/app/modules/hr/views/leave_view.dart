import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/leave_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import '../services/leave_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';

class LeaveView extends StatelessWidget {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading && state.leaveRecords.isEmpty) {
          return const LoadingIndicator();
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: EdgeInsets.all(AppSpacing.md.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _LeaveBalanceCard(employees: state.employees),
              SizedBox(height: AppSpacing.md.h),
              _PendingLeavesCard(pending: state.pendingLeaves),
              SizedBox(height: AppSpacing.md.h),
              _LeaveHistoryCard(records: state.leaveRecords),
              SizedBox(height: AppSpacing.xxl.h),
            ],
          ),
          floatingActionButton: ReusableFab(
            icon: Icons.event_rounded,
            onPressed: () => _showRequestLeaveDialog(context, state.employees),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _showRequestLeaveDialog(BuildContext context, List<EmployeeModel> employees) {
    final bloc = context.read<HrBloc>();
    final startDateCtrl = TextEditingController();
    final endDateCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    final leaveTypes = <String>['sick', 'annual', 'emergency', 'unpaid'];
    var selectedType = 'annual';
    var selectedEmployeeId = '';
    var selectedEmployeeName = '';

    if (employees.isNotEmpty) {
      selectedEmployeeId = employees.first.id;
      selectedEmployeeName = employees.first.name;
    }

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: '??? ????? ?????',
        headerIcon: const Icon(Icons.event_rounded),
        children: [
          if (employees.isNotEmpty)
            ReusableDropdown<String>(
              labelText: '??????',
              hintText: '???? ??????',
              items: employees.map((e) => e.name).toList(),
              value: selectedEmployeeName.isEmpty ? null : selectedEmployeeName,
              itemAsString: (s) => s,
              onChanged: (v) {
                if (v != null) {
                  final emp = employees.firstWhere((e) => e.name == v);
                  selectedEmployeeId = emp.id;
                  selectedEmployeeName = emp.name;
                }
              },
            ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableDropdown<String>(
            labelText: '??? ???????',
            hintText: '???? ?????',
            items: leaveTypes,
            value: selectedType,
            itemAsString: (s) => s == 'sick'
                ? '?????'
                : s == 'annual'
                    ? '?????'
                    : s == 'emergency'
                        ? '?????'
                        : '???? ????',
            onChanged: (v) {
              if (v != null) selectedType = v;
            },
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            label: '????? ???????',
            hint: 'YYYY-MM-DD',
            controller: startDateCtrl,
            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            label: '????? ???????',
            hint: 'YYYY-MM-DD',
            controller: endDateCtrl,
            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            label: '?????',
            hint: '??? ???????...',
            controller: reasonCtrl,
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.lg.h),
          DialogActions(
            confirmText: '????? ??? ???????',
            onConfirm: () async {
              if (selectedEmployeeId.isEmpty) return;
              if (startDateCtrl.text.isEmpty || endDateCtrl.text.isEmpty) {
                AppSnackbar.error('???? ????? ?????? ???????');
                return;
              }
              bloc.add(RequestLeave(
                employeeId: selectedEmployeeId,
                employeeName: selectedEmployeeName,
                leaveType: selectedType,
                startDate: startDateCtrl.text.trim(),
                endDate: endDateCtrl.text.trim(),
                reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim(),
              ));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _LeaveBalanceCard extends StatefulWidget {
  final List<EmployeeModel> employees;
  const _LeaveBalanceCard({required this.employees});

  @override
  State<_LeaveBalanceCard> createState() => _LeaveBalanceCardState();
}

class _LeaveBalanceCardState extends State<_LeaveBalanceCard> {
  LeaveBalance? _balance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.employees.isEmpty) return;
    final balance = await LeaveService.getBalance(widget.employees.first.id);
    if (mounted) setState(() => _balance = balance);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.employees.isEmpty) {
      return const AppCard(
        child: ReusableText('?? ???? ?????? ?????? ???? ????? ???????? ??????.'),
      );
    }
    final balance = _balance;
    if (balance == null) return const AppCard(child: LoadingIndicator());

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.account_balance_wallet_rounded, title: '????? ???????? ???????'),
          SizedBox(height: AppSpacing.sm.h),
          _BalanceRow(
              label: '???????? ???????',
              used: balance.sick.used,
              total: balance.sick.total,
              color: AppColors.error),
          _BalanceRow(
              label: '???????? ???????',
              used: balance.annual.used,
              total: balance.annual.total,
              color: AppColors.primary),
          _BalanceRow(
              label: '?????? ?????',
              used: balance.emergency.used,
              total: balance.emergency.total,
              color: AppColors.warning),
          _BalanceRow(
              label: '???? ????',
              used: balance.unpaid.used,
              total: balance.unpaid.total,
              color: AppColors.textSecondaryOf(context)),
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final String label;
  final int used;
  final int total;
  final Color color;
  const _BalanceRow(
      {required this.label,
      required this.used,
      required this.total,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final remaining = total - used;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 10.w),
          ReusableText(label, style: AppTextStyles.body(context).copyWith(color: AppColors.textPrimaryOf(context))),
          const Spacer(),
          ReusableText('$remaining', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: color)),
          SizedBox(width: 6.w),
          ReusableText('/ $total ???', style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context))),
        ],
      ),
    );
  }
}

class _PendingLeavesCard extends StatelessWidget {
  final List<LeaveModel> pending;
  const _PendingLeavesCard({required this.pending});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HrBloc>();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: SectionHeader(icon: Icons.pending_actions_rounded, title: '????? ??????? ???????')),
              if (pending.isNotEmpty)
                ReusableBadge.tone(
                  label: '${pending.length} ?????',
                  tone: ReusableBadgeTone.warning,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          if (pending.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
              child: const ReusableText('?? ???? ????? ????? ????? ??????.',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pending.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
              itemBuilder: (_, i) => _LeaveRequestTile(leave: pending[i], bloc: bloc),
            ),
        ],
      ),
    );
  }
}

class _LeaveRequestTile extends StatelessWidget {
  final LeaveModel leave;
  final HrBloc bloc;
  const _LeaveRequestTile({required this.leave, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: ReusableText(
        '${leave.employeeName} - ${_leaveTypeText(leave.leaveType)}',
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: ReusableText(
        '?? ${leave.startDate} ??? ${leave.endDate} (${leave.duration} ???)',
        style: TextStyle(
            fontSize: 11.5.sp,
            color: AppColors.textSecondaryOf(context)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 22.sp),
            onPressed: () => bloc.add(ApproveLeave(leave.id)),
            tooltip: '????',
          ),
          IconButton(
            icon: Icon(Icons.cancel_rounded,
                color: AppColors.error, size: 22.sp),
            onPressed: () {
              ReusableDialog.show(
                context,
                title: '??? ???????',
                headerIcon: Icon(Icons.cancel_rounded, color: AppColors.error),
                children: [
                  ReusableText('?? ??? ????? ?? ????? ?? ??? ??? ??????? ?????? "${leave.employeeName}"?'),
                  SizedBox(height: 24.h),
                  DialogActions(
                    confirmText: '??? ?????',
                    confirmType: ButtonType.primary,
                    onConfirm: () {
                      bloc.add(RejectLeave(leave.id));
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
            tooltip: '???',
          ),
        ],
      ),
    );
  }

  String _leaveTypeText(String type) => switch (type) {
        'sick' => '?????',
        'annual' => '?????',
        'emergency' => '?????',
        'unpaid' => '???? ????',
        _ => type,
      };
}

class _LeaveHistoryCard extends StatelessWidget {
  final List<LeaveModel> records;
  const _LeaveHistoryCard({required this.records});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.history_rounded, title: '????? ????? ???????'),
          SizedBox(height: AppSpacing.sm.h),
          if (records.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: ReusableText('?? ???? ????? ?????? ?????.', style: TextStyle(color: Colors.grey))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.take(15).length,
              separatorBuilder: (_, index) => Divider(height: 1, color: scheme.outline.withValues(alpha: 0.1)),
              itemBuilder: (context, i) {
                final leave = records[i];
                final (statusColor, statusLabel) = switch (leave.status) {
                  'approved' => (AppColors.success, '??????'),
                  'rejected' => (AppColors.error, '??????'),
                  _ => (AppColors.warning, '?????'),
                };
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    child: Icon(Icons.event_note_rounded, size: 14.sp, color: statusColor),
                  ),
                  title: ReusableText(
                    '${leave.employeeName} - ${_leaveTypeText(leave.leaveType)}',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: ReusableText(
                    '${leave.startDate} ? ${leave.endDate}',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryOf(context)),
                  ),
                  trailing: StatusBadge(label: statusLabel, color: statusColor),
                );
              },
            ),
        ],
      ),
    );
  }

  String _leaveTypeText(String type) => switch (type) {
        'sick' => '?????',
        'annual' => '?????',
        'emergency' => '?????',
        'unpaid' => '???? ????',
        _ => type,
      };
}




