import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/inventory/models/promotion_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/promotions/promotions_bloc.dart';

class PromotionsView extends StatefulWidget {
  const PromotionsView({super.key});

  @override
  State<PromotionsView> createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<PromotionsView> {
  @override
  void initState() {
    super.initState();
    context.read<PromotionsBloc>().add(const LoadPromotions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionsBloc, PromotionsState>(
      builder: (context, state) {
        return StandardModuleLayout(
          title: AppStrings.promotionsTitle,
          actions: [
            ReusableButton(
              text: AppStrings.createPromotion,
              prefixIcon: Icons.add_rounded,
              onPressed: () => _showPromotionDialog(context),
            ),
          ],
          stats: [
            SummaryCard(
              label: 'إجمالي العروض',
              value: '${state.promotions.length}',
              icon: Icons.local_offer_rounded,
            ),
          ],
          content: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PromotionsState state) {
    if (state.status == PromotionsStatus.loading) {
      return const Center(child: LoadingIndicator());
    }
    if (state.status == PromotionsStatus.error) {
      return Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              SizedBox(height: AppSpacing.md.h),
              ReusableText(state.error ?? '', variant: ReusableTextVariant.body),
              SizedBox(height: AppSpacing.md.h),
              ReusableButton(
                text: AppStrings.refresh,
                onPressed: () =>
                    context.read<PromotionsBloc>().add(const LoadPromotions()),
              ),
            ],
          ),
        ),
      );
    }

    if (state.promotions.isEmpty) {
      return const EmptyState(
        icon: Icons.local_offer_outlined,
        title: AppStrings.noPromotions,
      );
    }

    return ListView.separated(
      itemCount: state.promotions.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
      itemBuilder: (context, i) {
        final p = state.promotions[i];
        return _PromotionCard(
          promotion: p,
          onEdit: () => _showPromotionDialog(context, existing: p),
          onDelete: () => _showDeleteDialog(context, p),
          onToggle: () => context
              .read<PromotionsBloc>()
              .add(TogglePromotionStatus(p.id, !p.isActive)),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, PromotionModel promotion) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.delete),
        content: Text('${AppStrings.confirmDelete} "${promotion.name}"؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () {
              context.read<PromotionsBloc>().add(DeletePromotion(promotion.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppStrings.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPromotionDialog(BuildContext context, {PromotionModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final valueCtrl = TextEditingController(text: existing?.value.toString() ?? '');
    bool isPercentage = existing?.isPercentage ?? true;
    PromotionType type = existing?.type ?? PromotionType.discount;
    DateTime startDate = existing?.startDate ?? DateTime.now();
    DateTime endDate = existing?.endDate ?? DateTime.now().add(const Duration(days: 30));
    bool isActive = existing?.isActive ?? true;
    final isEdit = existing != null;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => ReusableDialog(
          headerIcon: Icon(isEdit ? Icons.edit_rounded : Icons.local_offer_rounded),
          headerIconColor: AppColors.warning,
          title: isEdit ? AppStrings.edit : AppStrings.createPromotion,
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableInput(label: AppStrings.promotionNameLabel, hint: 'ادخل اسم العرض', controller: nameCtrl),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableDropdown<PromotionType>(
                    labelText: AppStrings.promotionTypeLabel,
                    hintText: AppStrings.promotionTypeLabel,
                    items: PromotionType.values,
                    value: type,
                    itemAsString: (t) => t.name,
                    onChanged: (v) {
                      if (v != null) setDialogState(() => type = v);
                    },
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ReusableInput(
                          label: AppStrings.promotionValueLabel,
                          hint: '0.00',
                          controller: valueCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: ReusableDropdown<String>(
                          labelText: '',
                          hintText: '',
                          items: ['%', 'قيمة'],
                          value: isPercentage ? '%' : 'قيمة',
                          itemAsString: (s) => s,
                          onChanged: (v) {
                            if (v != null) setDialogState(() => isPercentage = v == '%');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Row(
                    children: [
                      Expanded(
                        child: _dateField(context, AppStrings.promotionStartDate, startDate, (d) {
                          if (d != null) setDialogState(() => startDate = d);
                        }),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: _dateField(context, AppStrings.promotionEndDate, endDate, (d) {
                          if (d != null) setDialogState(() => endDate = d);
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  SwitchListTile(
                    title: Text(AppStrings.promotionActiveLabel),
                    value: isActive,
                    onChanged: (v) => setDialogState(() => isActive = v),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  ReusableButton(
                    text: isEdit ? AppStrings.save : AppStrings.create,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final value = double.tryParse(valueCtrl.text) ?? 0;
                      final promo = PromotionModel(
                        id: existing?.id ?? '',
                        name: nameCtrl.text,
                        description: null,
                        type: type,
                        value: value,
                        isPercentage: isPercentage,
                        startDate: startDate,
                        endDate: endDate,
                        medicineIds: existing?.medicineIds ?? [],
                        categoryFilters: existing?.categoryFilters ?? [],
                        customerGroupId: existing?.customerGroupId,
                        branchId: existing?.branchId ?? '',
                        isActive: isActive,
                        lastModified: DateTime.now(),
                      );
                      if (isEdit) {
                        context.read<PromotionsBloc>().add(UpdatePromotion(promo));
                      } else {
                        context.read<PromotionsBloc>().add(CreatePromotion(promo));
                      }
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField(BuildContext context, String label, DateTime value, ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (date != null) onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        child: Text('${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'),
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  const _PromotionCard({
    required this.promotion,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = promotion.isCurrentlyActive;
    final color = isActive ? AppColors.success : AppColors.textMutedOf(context);

    final menuItems = <PopupMenuEntry<String>>[
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
    ];

    return PartyListTile(
      avatarIcon: Icons.local_offer_rounded,
      avatarColor: color,
      title: promotion.name,
      subtitle: promotion.isPercentage
          ? '${promotion.value.toStringAsFixed(0)}%'
          : '${promotion.value.toStringAsFixed(2)} ${AppStrings.currency}',
      tags: [
        Tag(
          label: isActive ? AppStrings.active : AppStrings.inactive,
          color: color,
        ),
      ],
      trailing: IconButton(
        icon: Icon(
            isActive ? Icons.toggle_on_rounded : Icons.toggle_off_outlined,
            color: color),
        onPressed: onToggle,
      ),
      menuItems: menuItems,
      onMenuSelected: (v) {
        switch (v) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      onTap: onEdit,
    );
  }
}

