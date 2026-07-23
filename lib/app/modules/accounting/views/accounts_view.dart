import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final columns = [
      ReusableTableColumn<JournalEntryModel>(
        id: 'num',
        title: '#',
        width: 80.w,
        textBuilder: (j) => '#${j.entryNumber}',
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'desc',
        title: 'البيان والنوع',
        flex: 2,
        cellBuilder: (j) => TableContactNameCell(
          name: j.description ?? 'قيد محاسبي',
          subtitle: _formatEntryType(j.entryType.name),
          icon: Icons.receipt_long_rounded,
          iconColor: scheme.primary,
        ),
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'amount',
        title: 'القيمة',
        width: 120.w,
        isNumeric: true,
        cellBuilder: (j) => TableMoneyCell(amount: j.totalDebit, currency: AppStrings.currency, isHighlight: true),
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'date',
        title: 'التاريخ',
        width: 140.w,
        textBuilder: (j) => DateFormat('yyyy/MM/dd').format(j.entryDate),
      ),
    ];

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

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.md.w),
              child: Row(
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
            ),
            const SectionHeader(
              icon: Icons.history_rounded, 
              title: 'أحدث قيود اليومية العامة',
            ),
            SizedBox(height: AppSpacing.sm.h),
            Expanded(
              child: state.journals.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'لا توجد قيود يومية',
                      subtitle: 'سوف تظهر القيود الآلية واليدوية هنا بمجرد بدء المعاملات المالية.',
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                      child: ReusableTable<JournalEntryModel>(
                        columns: columns,
                        items: state.journals,
                        itemLabel: 'قيد يومية',
                      ),
                    ),
            ),
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
