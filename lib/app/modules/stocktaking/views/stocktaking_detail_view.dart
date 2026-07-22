import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stocktaking_period_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import '../bloc/stocktaking_bloc.dart';

class StocktakingDetailView extends StatelessWidget {
  final String periodId;
  const StocktakingDetailView({super.key, required this.periodId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<StocktakingBloc, StocktakingState>(
      builder: (context, state) {
        final period = state.selectedPeriod;
        if (period == null) {
          return const Scaffold(body: LoadingIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: Text(period.name)),
          backgroundColor: scheme.surfaceContainerLow.withValues(alpha: 0.3),
          body: Padding(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Column(
              children: [
                _buildPeriodHeader(period, scheme, context),
                SizedBox(height: AppSpacing.md.h),
                _buildCountToolbar(context, period, scheme),
                SizedBox(height: AppSpacing.md.h),
                Expanded(child: _buildCountsList(context, scheme, period)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodHeader(StocktakingPeriodModel period, ColorScheme scheme, BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _HeaderStat(
                label: StocktakingStrings.stocktakingTotalItems,
                value: '${period.totalItems}',
                color: AppColors.primary,
              ),
              _HeaderStat(
                label: StocktakingStrings.stocktakingCounted,
                value: '${period.countedItems}',
                color: AppColors.info,
              ),
              _HeaderStat(
                label: StocktakingStrings.stocktakingDifference,
                value: period.totalDifference.toStringAsFixed(2),
                color: period.totalDifference != 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            '${StocktakingStrings.stocktakingStartDate}: ${DateFormat('yyyy-MM-dd HH:mm').format(period.startedAt)}',
            style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
          ),
          if (period.closedAt != null)
            Text(
              '${StocktakingStrings.stocktakingCloseDate}: ${DateFormat('yyyy-MM-dd HH:mm').format(period.closedAt!)}',
              style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _buildCountToolbar(
    BuildContext context,
    StocktakingPeriodModel period,
    ColorScheme scheme,
  ) {
    return Row(
      children: [
        if (!period.isClosed && !period.isCancelled)
          ReusableButton(
            text: StocktakingStrings.stocktakingRecordCount,
            prefixIcon: Icons.add,
            onPressed: () => _showCountDialog(context, period.id),
          ),
        const Spacer(),
        if (!period.isClosed && !period.isCancelled)
          ReusableButton(
            text: StocktakingStrings.stocktakingClosePeriod,
            prefixIcon: Icons.lock,
            onPressed: () {
              _showClosePeriodDialog(context, period.id);
            },
          ),
        if (period.isClosed || period.isCancelled)
          ReusableButton(
            text: StocktakingStrings.stocktakingBack,
            prefixIcon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
    );
  }

  void _showClosePeriodDialog(BuildContext context, String periodId) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(StocktakingStrings.stocktakingConfirmCloseTitle),
        content: Text(StocktakingStrings.stocktakingConfirmCloseMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<StocktakingBloc>().add(
                CloseStocktakingPeriod(periodId),
              );
            },
            child: Text(StocktakingStrings.stocktakingConfirmCloseAction),
          ),
        ],
      ),
    );
  }

  Widget _buildCountsList(
    BuildContext context,
    ColorScheme scheme,
    StocktakingPeriodModel period,
  ) {
    return BlocBuilder<StocktakingBloc, StocktakingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator();
        }
        final list = state.counts;
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 64.w,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  StocktakingStrings.stocktakingEmptyDetail,
                  style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) =>
              _CountCard(count: list[i], scheme: scheme, period: period),
        );
      },
    );
  }

  void _showCountDialog(BuildContext context, String periodId) {
    final qtyCtrl = TextEditingController();
    MedicineModel? selectedMedicine;
    String searchQuery = '';

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(StocktakingStrings.stocktakingRecordItem),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 400.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: StocktakingStrings.stocktakingSearchItem,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => searchQuery = v),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  if (selectedMedicine == null && searchQuery.isNotEmpty)
                    SizedBox(
                      height: 150.h,
                      child: ListView(
                        children: BranchDataService.getMedicines()
                            .where(
                              (m) => m.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ),
                            )
                            .take(20)
                            .map(
                              (m) => ListTile(
                                dense: true,
                                title: Text(m.name),
                                subtitle: Text(
                                  '${StocktakingStrings.stocktakingQuantityLabel}: ${m.quantity} | ${AppStrings.cartPrice}: ${m.buyPrice}',
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMedicine = m;
                                    qtyCtrl.text = m.quantity.toString();
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  if (selectedMedicine != null) ...[
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        title: Text(selectedMedicine!.name),
                        subtitle: Text(
                          '${StocktakingStrings.stocktakingCurrentQty}: ${selectedMedicine!.quantity}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => selectedMedicine = null);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    TextField(
                      controller: qtyCtrl,
                      decoration: InputDecoration(
                        labelText: StocktakingStrings.stocktakingActualQty,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: selectedMedicine == null
            ? null
            : [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppStrings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final med = selectedMedicine!;
                    final actual =
                        int.tryParse(qtyCtrl.text.trim()) ?? med.quantity;
                    context.read<StocktakingBloc>().add(
                      RecordStocktakingCount(
                        periodId: periodId,
                        itemId: med.id,
                        itemName: med.name,
                        systemQuantity: med.quantity,
                        actualQuantity: actual,
                        buyPrice: med.buyPrice,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(StocktakingStrings.stocktakingRecordCountAction),
                ),
              ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _HeaderStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline(context).copyWith(color: color),
        ),
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _DetailChip({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.onSurfaceVariant)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs.r),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final StocktakingCountModel count;
  final ColorScheme scheme;
  final StocktakingPeriodModel period;
  const _CountCard({
    required this.count,
    required this.scheme,
    required this.period,
  });

  Color _diffColor() {
    if (count.difference > 0) return AppColors.warning;
    if (count.difference < 0) return AppColors.error;
    return AppColors.success;
  }

  void _showEditDialog(BuildContext context) {
    final qtyCtrl = TextEditingController(
      text: count.actualQuantity.toString(),
    );
    final notesCtrl = TextEditingController(text: count.notes ?? '');

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(StocktakingStrings.stocktakingEditRecord),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${count.itemName} - ${StocktakingStrings.stocktakingCurrentQty}: ${count.systemQuantity}',
              style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.md.h),
            TextField(
              controller: qtyCtrl,
              decoration: InputDecoration(
                labelText: StocktakingStrings.stocktakingActualQty,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md.h),
            TextField(
              controller: notesCtrl,
              decoration: InputDecoration(
                labelText: StocktakingStrings.stocktakingNotes,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(qtyCtrl.text.trim());
              if (qty == null) return;
              context.read<StocktakingBloc>().add(
                UpdateStocktakingCount(
                  count.id,
                  actualQuantity: qty,
                  notes: notesCtrl.text.trim().isEmpty
                      ? null
                      : notesCtrl.text.trim(),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: _diffColor(),
              borderRadius: BorderRadius.circular(AppRadius.xs.r),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.itemName,
                  style: AppTextStyles.bodyBold(context),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _DetailChip(
                      label: StocktakingStrings.stocktakingSystemLabel,
                      value: '${count.systemQuantity}',
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    _DetailChip(
                      label: StocktakingStrings.stocktakingActualLabel,
                      value: '${count.actualQuantity}',
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    _DetailChip(
                      label: StocktakingStrings.stocktakingDifference,
                      value: count.difference.toString(),
                      color: _diffColor(),
                    ),
                  ],
                ),
                if (count.differenceValue != 0)
                  Text(
                    '${StocktakingStrings.stocktakingDiffValue}: ${count.differenceValue.toStringAsFixed(2)}',
                    style: AppTextStyles.caption(context).copyWith(color: _diffColor()),
                  ),
              ],
            ),
          ),
          if (!period.isClosed && !period.isCancelled)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') {
                  _showEditDialog(context);
                } else if (v == 'delete') {
                  context.read<StocktakingBloc>().add(
                    DeleteStocktakingCount(count.id),
                  );
                }
              },
              itemBuilder: (_) => [
                ReusableActionMenuItem(
                  value: 'edit',
                  icon: Icons.edit_outlined,
                  label: AppStrings.edit,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: AppStrings.delete,
                  color: AppColors.error,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

