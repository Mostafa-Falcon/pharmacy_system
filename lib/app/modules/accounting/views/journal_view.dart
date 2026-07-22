import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  final DateTime _toDate = DateTime.now();

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
                      label: 'Ã™â€¦Ã™â€  Ã˜ÂªÃ˜Â§Ã˜Â±Ã™Å Ã˜Â®',
                      initialDate: _fromDate,
                      onChanged: (d) {
                        context.read<AccountingBloc>().add(
                          LoadJournalsInRange(from: d, to: _toDate),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: _DatePickerField(
                      label: 'Ã˜Â¥Ã™â€žÃ™â€° Ã˜ÂªÃ˜Â§Ã˜Â±Ã™Å Ã˜Â®',
                      initialDate: _toDate,
                      onChanged: (d) {
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
                      title: 'Ã™â€žÃ˜Â§ Ã˜ÂªÃ™Ë†Ã˜Â¬Ã˜Â¯ Ã™â€šÃ™Å Ã™Ë†Ã˜Â¯ Ã™ÂÃ™Å  Ã™â€¡Ã˜Â°Ã™â€¡ Ã˜Â§Ã™â€žÃ™ÂÃ˜ÂªÃ˜Â±Ã˜Â©',
                      subtitle: 'Ã™Å Ã˜Â±Ã˜Â¬Ã™â€° Ã˜Â§Ã˜Â®Ã˜ÂªÃ™Å Ã˜Â§Ã˜Â± Ã™â€ Ã˜Â·Ã˜Â§Ã™â€š Ã˜Â²Ã™â€¦Ã™â€ Ã™Å  Ã˜Â¢Ã˜Â®Ã˜Â± Ã˜Â£Ã™Ë† Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã™Ë†Ã˜Â¬Ã™Ë†Ã˜Â¯ Ã˜Â¹Ã™â€¦Ã™â€žÃ™Å Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â³Ã˜Â¬Ã™â€žÃ˜Â©.',
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.md.w,
                        0,
                        AppSpacing.md.w,
                        AppSpacing.lg.h,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.journalsInRange.length,
                      separatorBuilder: (_, index) => SizedBox(height: AppSpacing.sm.h),
                      itemBuilder: (context, index) {
                        return _JournalEntryCard(entry: state.journalsInRange[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
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
                  '${initialDate.year}-${initialDate.month}-${initialDate.day}',
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

class _JournalEntryCard extends StatefulWidget {
  final JournalEntryModel entry;
  const _JournalEntryCard({required this.entry});

  @override
  State<_JournalEntryCard> createState() => _JournalEntryCardState();
}

class _JournalEntryCardState extends State<_JournalEntryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: AppIconSize.md.value,
                      color: scheme.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          'Ã™â€šÃ™Å Ã˜Â¯ Ã˜Â±Ã™â€šÃ™â€¦ #${e.entryNumber}',
                          style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
                        ),
                        ReusableText(
                          '${e.entryDate.toString().substring(0, 10)} | ${_formatType(e.entryType.name)}',
                          style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ReusableText(
                        '${e.totalDebit.toStringAsFixed(2)} Ã˜Â¬.Ã™â€¦',
                        style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.success),
                      ),
                      ReusableText(
                        'Ã™â€¦Ã˜ÂªÃ™Ë†Ã˜Â§Ã˜Â²Ã™â€ ',
                        variant: ReusableTextVariant.caption,
                      ),
                    ],
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: AppIconSize.md.value,
                    color: AppColors.textMutedOf(context),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Container(
              padding: EdgeInsets.all(AppSpacing.md.w),
              color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
              child: Column(
                children: [
                  ...e.lines.map((line) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.subdirectory_arrow_left_rounded,
                              size: AppIconSize.sm.value,
                              color: scheme.primary.withValues(alpha: 0.5),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              flex: 4,
                              child: ReusableText(
                                line.accountName,
                                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (line.debit > 0)
                              ReusableText(
                                '${line.debit.toStringAsFixed(2)} (Ã™â€¦Ã˜Â¯Ã™Å Ã™â€ )',
                                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.success),
                              ),
                            if (line.credit > 0)
                              ReusableText(
                                '${line.credit.toStringAsFixed(2)} (Ã˜Â¯Ã˜Â§Ã˜Â¦Ã™â€ )',
                                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.error),
                              ),
                          ],
                        ),
                      )),
                  if (e.description?.isNotEmpty == true) ...[
                    SizedBox(height: AppSpacing.md.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.sm.r),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: ReusableText(
                        'Ã˜Â§Ã™â€žÃ˜Â¨Ã™Å Ã˜Â§Ã™â€ : ${e.description!}',
                        style: AppTextStyles.caption(context).copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatType(String t) => switch (t) {
    'sale' => 'Ã™â€¦Ã˜Â¨Ã™Å Ã˜Â¹Ã˜Â§Ã˜Âª',
    'purchase' => 'Ã™â€¦Ã˜Â´Ã˜ÂªÃ˜Â±Ã™Å Ã˜Â§Ã˜Âª',
    'expense' => 'Ã™â€¦Ã˜ÂµÃ˜Â±Ã™Ë†Ã™ÂÃ˜Â§Ã˜Âª',
    _ => t,
  };
}


