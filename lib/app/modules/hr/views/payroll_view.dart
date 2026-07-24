import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/models/payroll_model.dart';
import '../services/payroll_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/strings/hr_strings.dart';

class PayrollView extends StatelessWidget {
  const PayrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state.status == HrStatus.loading && state.payrollRecords.isEmpty) {
          return const LoadingIndicator();
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          body: ListView(
            padding: EdgeInsets.all(AppSpacing.md.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _PayrollSummaryCard(
                totalSalaries: state.currentMonthSalaryTotal,
                payroll: state.currentPayroll,
              ),
              SizedBox(height: AppSpacing.md.h),
              _PayrollListCard(records: state.payrollRecords),
            ],
          ),
          floatingActionButton: ReusableFab(
            icon: Icons.add_chart_rounded,
            onPressed: () => _showCreatePayrollDialog(context),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _showCreatePayrollDialog(BuildContext context) {
    final now = DateTime.now();
    final monthCtrl = TextEditingController(text: now.month.toString());
    final yearCtrl = TextEditingController(text: now.year.toString());

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Ø¥Ù†Ø´Ø§Ø¡ ÙƒØ´Ù Ø±Ø§ØªØ¨ Ø¬Ø¯ÙŠØ¯',
        headerIcon: const Icon(Icons.add_chart_rounded),
        children: [
          AppInput(
            label: 'Ø§Ù„Ø´Ù‡Ø± (Ø±Ù‚Ù…)',
            hint: 'Ù…Ø«Ø§Ù„: 1-12',
            controller: monthCtrl,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            label: 'Ø§Ù„Ø³Ù†Ø©',
            hint: 'Ù…Ø«Ø§Ù„: 2026',
            controller: yearCtrl,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.lg.h),
          DialogActions(
            confirmText: 'Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„ÙƒØ´Ù',
            onConfirm: () async {
              final month = int.tryParse(monthCtrl.text);
              final year = int.tryParse(yearCtrl.text);
              if (month == null || year == null) return;
              context.read<HrBloc>().add(CreatePayroll(month, year));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _PayrollSummaryCard extends StatelessWidget {
  final double totalSalaries;
  final PayrollModel? payroll;
  const _PayrollSummaryCard({required this.totalSalaries, this.payroll});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.payments_rounded, size: 28.sp, color: scheme.primary),
          ),
          SizedBox(height: AppSpacing.sm.h),
          const AppText(
            'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ù…Ø®ØµØµØ§Øª Ø§Ù„Ø±ÙˆØ§ØªØ¨ Ù„Ù„Ø´Ù‡Ø± Ø§Ù„Ø­Ø§Ù„ÙŠ',
            variant: AppTextVariant.caption,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs.h),
          AppText(
            '${totalSalaries.toStringAsFixed(0)} Ø¬.Ù…',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          if (payroll != null) ...[
            SizedBox(height: AppSpacing.sm.h),
            StatusBadge(
              label: _statusText(payroll!.status),
              color: _statusColor(context, payroll!.status),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) => switch (status) {
    'draft' => Colors.grey,
    'processing' => AppColors.info,
    'approved' => AppColors.success,
    'paid' => AppColors.primary,
    _ => AppColors.textSecondaryOf(context),
  };

  String _statusText(String status) => switch (status) {
    'draft' => 'Ù…Ø³ÙˆØ¯Ø©',
    'processing' => 'Ù‚ÙŠØ¯ Ø§Ù„ØªØ¬Ù‡ÙŠØ²',
    'approved' => 'Ù…Ø¹ØªÙ…Ø¯',
    'paid' => 'Ù…Ø¯ÙÙˆØ¹',
    _ => status,
  };
}

class _PayrollListCard extends StatelessWidget {
  final List<PayrollModel> records;
  const _PayrollListCard({required this.records});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HrBloc>();
    final scheme = Theme.of(context).colorScheme;
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.list_alt_rounded, title: 'ÙƒØ´ÙˆÙ Ø§Ù„Ø±ÙˆØ§ØªØ¨ Ø§Ù„Ø³Ø§Ø¨Ù‚Ø©'),
          SizedBox(height: AppSpacing.sm.h),
          if (records.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(
                child: AppText(
                  'Ù„Ø§ ØªÙˆØ¬Ø¯ ÙƒØ´ÙˆÙ Ø±ÙˆØ§ØªØ¨ Ù…Ø³Ø¬Ù„Ø© Ø­ØªÙ‰ Ø§Ù„Ø¢Ù†.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.1)),
              itemBuilder: (context, i) {
                final p = records[i];
                final statusColor = switch (p.status) {
                  'draft' => Colors.grey,
                  'processing' => AppColors.info,
                  'approved' => AppColors.success,
                  'paid' => AppColors.primary,
                  _ => AppColors.textSecondaryOf(context),
                };
                final statusText = switch (p.status) {
                  'draft' => 'Ù…Ø³ÙˆØ¯Ø©',
                  'processing' => 'Ù‚ÙŠØ¯ Ø§Ù„ØªØ¬Ù‡ÙŠØ²',
                  'approved' => 'Ù…Ø¹ØªÙ…Ø¯',
                  'paid' => 'Ù…Ø¯ÙÙˆØ¹',
                  _ => p.status,
                };

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                  title: AppText(
                    'ÙƒØ´Ù Ø´Ù‡Ø± ${p.month} - Ù„Ø³Ù†Ø© ${p.year}',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: AppText(
                    'Ø¹Ø¯Ø¯ Ø§Ù„Ù…ÙˆØ¸ÙÙŠÙ†: ${p.employeeCount} | Ø§Ù„ØµØ§ÙÙŠ: ${p.netTotal.toStringAsFixed(0)} Ø¬.Ù…',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondaryOf(context)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatusBadge(label: statusText, color: statusColor),
                      SizedBox(width: 4.w),
                      if (p.status == 'draft' || p.status == 'processing' || p.status == 'approved')
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            switch (value) {
                              case 'process':
                                bloc.add(ProcessPayroll(p.id));
                                break;
                              case 'approve':
                                bloc.add(ApprovePayroll(p.id));
                                break;
                              case 'lines':
                                _showPayrollLines(context, p.id);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            if (p.status == 'draft')
                              ReusableActionMenuItem(
                                value: 'process',
                                icon: Icons.play_circle_outline_rounded,
                                label: HrStrings.hrStartProcessing,
                              ),
                            if (p.status == 'processing')
                              ReusableActionMenuItem(
                                value: 'approve',
                                icon: Icons.check_circle_outline_rounded,
                                label: HrStrings.hrApprovePayroll,
                              ),
                            ReusableActionMenuItem(
                              value: 'lines',
                              icon: Icons.visibility_outlined,
                              label: HrStrings.hrViewDetails,
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showPayrollLines(BuildContext context, String payrollId) {
    final lines = PayrollService.getLines(payrollId);
    final scheme = Theme.of(context).colorScheme;

    AppDialog.show(
      context,
      title: 'ØªÙØ§ØµÙŠÙ„ ÙƒØ´Ù Ø§Ù„Ø±ÙˆØ§ØªØ¨',
      headerIcon: const Icon(Icons.info_outline_rounded),
      maxWidth: 600,
      children: [
        if (lines.isEmpty)
          const AppStateView.empty(message: 'Ù„Ø§ ØªÙˆØ¬Ø¯ ØªÙØ§ØµÙŠÙ„ Ù…ØªØ§Ø­Ø© Ù„Ù‡Ø°Ø§ Ø§Ù„ÙƒØ´Ù.', compact: true)
        else
          SizedBox(
            height: 400.h,
            child: ListView.separated(
              itemCount: lines.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.1)),
              itemBuilder: (context, i) {
                final line = lines[i];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  title: AppText(line.employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: AppText(
                    'Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ: ${line.baseSalary.toStringAsFixed(0)} | Ø®ØµÙˆÙ…Ø§Øª: ${line.deductions.toStringAsFixed(0)} | Ø­ÙˆØ§ÙØ²: ${line.bonuses.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondaryOf(context)),
                  ),
                  trailing: AppText(
                    '${line.netSalary.toStringAsFixed(0)} Ø¬.Ù…',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: scheme.primary),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}




