import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AccountingBloc>().add(LoadJournalsInRange(from: _fromDate, to: _toDate));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(
      builder: (context, state) {
        if (state.status == AccountingStatus.loading) {
          return const LoadingIndicator();
        }
        return Column(
          children: [
            AppCard(
              margin: EdgeInsets.all(AppSpacing.md.w),
              padding: EdgeInsets.all(AppSpacing.sm.w),
              child: Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'من تاريخ',
                      initialDate: _fromDate,
                      onChanged: (d) {
                        setState(() => _fromDate = d);
                        context.read<AccountingBloc>().add(
                          LoadJournalsInRange(from: d, to: _toDate),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: _DatePickerField(
                      label: 'إلى تاريخ',
                      initialDate: _toDate,
                      onChanged: (d) {
                        setState(() => _toDate = d);
                        context.read<AccountingBloc>().add(
                          LoadJournalsInRange(from: _fromDate, to: d),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.journalsInRange.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'لا توجد قيود في هذه الفترة',
                      subtitle: 'يرجى اختيار نطاق زمني آخر أو التأكد من وجود عمليات مسجلة.',
                    )
                  : _buildJournalTable(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJournalTable(BuildContext context, AccountingState state) {
    final scheme = Theme.of(context).colorScheme;

    final columns = [
      ReusableTableColumn<JournalEntryModel>(
        id: 'entryNumber',
        title: '#',
        width: 100.w,
        isSortable: true,
        textBuilder: (j) => '#${j.entryNumber}',
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'description',
        title: 'البيان والقيد',
        flex: 2,
        isSortable: true,
        cellBuilder: (j) => TableContactNameCell(
          name: j.description ?? 'قيد محاسبي',
          subtitle: _formatType(j.entryType.name),
          icon: Icons.receipt_long_rounded,
          iconColor: scheme.primary,
        ),
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'debit',
        title: 'مدين',
        width: 120.w,
        isNumeric: true,
        cellBuilder: (j) => TableMoneyCell(amount: j.totalDebit, currency: AppStrings.currency, isHighlight: false),
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'credit',
        title: 'دائن',
        width: 120.w,
        isNumeric: true,
        cellBuilder: (j) => TableMoneyCell(amount: j.totalCredit, currency: AppStrings.currency, isHighlight: false),
      ),
      ReusableTableColumn<JournalEntryModel>(
        id: 'date',
        title: 'تاريخ القيد',
        width: 140.w,
        isSortable: true,
        textBuilder: (j) => DateFormat('yyyy/MM/dd').format(j.entryDate),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: ReusableTable<JournalEntryModel>(
        columns: columns,
        items: state.journalsInRange,
        itemLabel: 'قيد يومية',
        onTapRow: (j) => _showEntryDetails(context, j),
        rowActions: (j) => TableOptionsButton(
          onSelected: (v) {
             if (v == 'view') _showEntryDetails(context, j);
             if (v == 'delete') context.read<AccountingBloc>().add(DeleteJournalEntry(id: j.id));
          },
          menuItems: [
            const PopupMenuItem(value: 'view', child: ReusableText('عرض التفاصيل')),
            const PopupMenuItem(value: 'delete', child: ReusableText('حذف القيد', color: AppColors.error)),
          ],
        ),
      ),
    );
  }

  void _showEntryDetails(BuildContext context, JournalEntryModel entry) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: 'تفاصيل القيد رقم #${entry.entryNumber}',
        headerIcon: const Icon(Icons.receipt_long_rounded),
        maxWidth: 600,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      const Expanded(child: ReusableText('الحساب', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 100.w, child: const ReusableText('مدين', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 100.w, child: const ReusableText('دائن', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                ...entry.lines.map((l) => Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)))),
                  child: Row(
                    children: [
                      Expanded(child: ReusableText(l.accountName)),
                      SizedBox(width: 100.w, child: ReusableText(l.debit > 0 ? l.debit.toStringAsFixed(2) : '—', textAlign: TextAlign.center, color: AppColors.success)),
                      SizedBox(width: 100.w, child: ReusableText(l.credit > 0 ? l.credit.toStringAsFixed(2) : '—', textAlign: TextAlign.center, color: AppColors.error)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          if (entry.description != null) ...[
            SizedBox(height: 16.h),
            ReusableText('البيان: ${entry.description!}', style: AppTextStyles.caption(context).copyWith(fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }

  String _formatType(String t) => switch (t) {
    'sale' => 'مبيعات',
    'purchase' => 'مشتريات',
    'expense' => 'مصروفات',
    _ => t,
  };
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerField({
    required this.label,
    required this.initialDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final scheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );
        if (picked != null) onChanged(picked);
      },
      borderRadius: BorderRadius.circular(AppRadius.md.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.5),
          border: Border.all(
            color: AppColors.borderOf(context).withValues(alpha: isDark ? 0.2 : 0.3),
          ),
          borderRadius: BorderRadius.circular(AppRadius.md.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14.sp,
              color: scheme.primary,
            ),
            SizedBox(width: AppSpacing.xs.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableText(
                  label,
                  variant: ReusableTextVariant.caption,
                  style: AppTextStyles.caption(context),
                ),
                ReusableText(
                  '${initialDate.year}-${initialDate.month.toString().padLeft(2,'0')}-${initialDate.day.toString().padLeft(2,'0')}',
                  style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
