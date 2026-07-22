import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(
      builder: (context, state) {
        if (state.status == AccountingStatus.loading) {
          return const LoadingIndicator();
        }
        if (state.status == AccountingStatus.error) {
          return ReusableStateView(
            message: state.errorMessage ?? 'حدث خطأ أثناء تحميل البيانات المالية',
            icon: Icons.error_outline_rounded,
            action: ReusableButton(
              text: 'إعادة المحاولة',
              onPressed: () => context.read<AccountingBloc>().add(const LoadAccounting()),
            ),
          );
        }
        
        final scheme = Theme.of(context).colorScheme;

        return ListView(
          padding: EdgeInsets.all(AppSpacing.md.w),
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    label: 'إجمالي الإيرادات',
                    value: '${state.totalRevenue.toStringAsFixed(2)} ج.م',
                    color: AppColors.success,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: SummaryCard(
                    label: 'إجمالي المصروفات',
                    value: '${state.totalExpenses.toStringAsFixed(2)} ج.م',
                    color: AppColors.error,
                    icon: Icons.trending_down_rounded,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: SummaryCard(
                    label: 'صافي الربح التشغيلي',
                    value: '${state.netProfit.toStringAsFixed(2)} ج.م',
                    color: scheme.primary,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg.h),
            const SectionHeader(
              icon: Icons.history_rounded, 
              title: 'أحدث قيود اليومية العامة',
            ),
            SizedBox(height: AppSpacing.sm.h),
            if (state.journals.isEmpty)
              const EmptyState(
                icon: Icons.receipt_long_rounded,
                title: 'لا توجد قيود يومية',
                subtitle: 'سوف تظهر القيود الآلية واليدوية هنا بمجرد بدء المعاملات المالية.',
              )
            else
              ...state.journals.map((j) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
                child: TransactionCard(
                  icon: Icons.receipt_long_rounded,
                  iconColor: scheme.primary,
                  title: 'قيد يومية رقم #${j.entryNumber}',
                  tags: [
                    if (j.description?.isNotEmpty == true)
                      Tag(label: j.description!, color: AppColors.textSecondaryOf(context)),
                    Tag(label: _formatEntryType(j.entryType.name), color: scheme.secondary),
                  ],
                  amount: '${j.totalDebit.toStringAsFixed(2)} ج.م',
                  date: j.entryDate.toString().substring(0, 10),
                  amountSubtext: 'مدين / دائن متوازن',
                ),
              )),
          ],
        );
      },
    );
  }

  String _formatEntryType(String type) => switch (type) {
    'sale' => 'مبيعات',
    'purchase' => 'مشتريات',
    'expense' => 'مصروفات',
    'payment' => 'سداد',
    'receipt' => 'تحصيل',
    _ => type,
  };
}
