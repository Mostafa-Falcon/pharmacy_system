import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/models/sales/quote_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/quotes_bloc.dart';
import '../bloc/quotes_event.dart';
import '../bloc/quotes_state.dart';


class QuotesListView extends StatelessWidget {
  const QuotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _QuotesBody();
  }
}

class _QuotesBody extends StatelessWidget {
  const _QuotesBody();

  static const _statusLabels = {
    QuoteStatus.draft: SalesStrings.statusDraft,
    QuoteStatus.sent: SalesStrings.statusSent,
    QuoteStatus.accepted: SalesStrings.statusAccepted,
    QuoteStatus.rejected: SalesStrings.statusRejected,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: SalesStrings.quotesTitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: BlocBuilder<QuotesBloc, QuotesState>(
          builder: (context, state) {
            if (state.status == QuotesStatus.initial || state.status == QuotesStatus.loading) {
              return const Center(child: LoadingIndicator());
            }
            if (state.status == QuotesStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(state.error ?? SalesStrings.errorLoadingQuotes),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: GeneralStrings.refresh,
                      onPressed: () => context.read<QuotesBloc>().add(const LoadQuotes()),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                _buildHeader(context),
                SizedBox(height: AppSpacing.lg.h),
                Expanded(child: _buildList(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        AppButton(
          text: SalesStrings.createQuoteAction,
          prefixIcon: Icons.add_rounded,
          onPressed: () => _showCreateQuoteDialog(context),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildList(BuildContext context, QuotesState state) {
    if (state.quotes.isEmpty) {
      return const AppStateView.empty(
        icon: Icons.sell_outlined,
        title: SalesStrings.noPriceQuotes,
      );
    }
    return ListView.separated(
      itemCount: state.quotes.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
      itemBuilder: (_, i) {
        final q = state.quotes[i];
        final statusColor = switch (q.status) {
          QuoteStatus.draft => AppColors.textMutedOf(context),
          QuoteStatus.sent => AppColors.info,
          QuoteStatus.accepted => AppColors.success,
          QuoteStatus.rejected => AppColors.error,
        };
        return TransactionCard(
          icon: Icons.sell_outlined,
          iconColor: AppColors.primary,
          title: SalesStrings.quoteNumberTitleFormat.replaceFirst('%s', q.number.toString()).replaceFirst('%s', q.customerName),
          tags: [
            Tag(
              label: _statusLabels[q.status] ?? '',
              color: statusColor,
            ),
          ],
          amount: formatMoney(q.total),
          date: formatDateTime(q.createdAt),
          menuItems: [
            ReusableActionMenuItem(
              value: 'delete',
              icon: Icons.delete_outline_rounded,
              label: GeneralStrings.delete,
              color: AppColors.error,
            ),
          ],
          onMenuSelected: (value) {
            if (value == 'delete') {
              _confirmDeleteQuote(context, q);
            }
          },
        );
      },
    );
  }

  void _confirmDeleteQuote(BuildContext context, QuoteModel quote) {
    final bloc = context.read<QuotesBloc>();
    ConfirmDeleteDialog.show(
      context,
      title: SalesStrings.deleteQuoteTitle,
      message: SalesStrings.deleteQuoteConfirmFormat.replaceFirst('%s', quote.number.toString()),
      onConfirm: () => bloc.add(DeleteQuote(quote.id)),
    );
  }

  void _showCreateQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CreateQuoteDialog(
        onConfirm: (customer, notes, items, subtotal, discount, total) {
          context.read<QuotesBloc>().add(CreateQuote(
                customerName: customer,
                notes: notes,
                items: items.cast<Map<String, dynamic>>(),
                subtotal: subtotal,
                discount: discount,
                total: total,
              ));
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CreateQuoteDialog extends StatefulWidget {
  final Function(String customer, String notes, List<dynamic> items, double subtotal, double discount, double total) onConfirm;

  const _CreateQuoteDialog({required this.onConfirm});

  @override
  State<_CreateQuoteDialog> createState() => _CreateQuoteDialogState();
}

class _CreateQuoteDialogState extends State<_CreateQuoteDialog> {
  final _customerCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إنشاء عرض سعر جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _customerCtrl,
            decoration: const InputDecoration(labelText: 'اسم العميل'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'المبلغ الإجمالي (ج.م)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(labelText: 'ملاحظات'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            final total = double.tryParse(_amountCtrl.text) ?? 0.0;
            widget.onConfirm(_customerCtrl.text.trim(), _notesCtrl.text.trim(), [], total, 0, total);
          },
          child: const Text('إنشاء'),
        ),
      ],
    );
  }
}








