import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../routes/app_routes.dart';
import '../bloc/stock_transfer_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_enums.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_transfer_model.dart';

class StockTransferView extends StatelessWidget {
  const StockTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockTransferBloc, StockTransferState>(
      builder: (context, state) {
        return StandardModuleLayout(
          title: 'تحويل مخزون',
          subtitle: 'إدارة حركة الأصناف بين الفروع ومتابعة الشحنات',
          actions: _buildHeaderActions(context, state),
          filters: _buildTabs(context, state),
          content: _buildList(context, state),
        );
      },
    );
  }

  List<Widget> _buildHeaderActions(
    BuildContext context,
    StockTransferState state,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final branchId = AuthService.currentBranchId ?? '';
    final pending = state.pendingIncoming(branchId);

    return [
      ReusableButton(
        text: 'تحويل جديد',
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.STOCK_TRANSFER_ADD),
      ),
      SizedBox(width: AppSpacing.sm),
      if (pending.isNotEmpty)
        ReusableBadge.tone(
          label: '${pending.length} تحويلات واردة معلقة',
          tone: ReusableBadgeTone.warning,
        ),
      StatChip(
        label: 'إجمالي التحويلات',
        count: state.transfers.length,
        color: scheme.primary,
        icon: Icons.swap_horiz_rounded,
      ),
      ReusableButton(
        text: 'تحديث',
        prefixIcon: Icons.refresh_rounded,
        type: ButtonType.tonal,
        onPressed: () => context
            .read<StockTransferBloc>()
            .add(const LoadStockTransfers()),
      ),
    ];
  }

  Widget _buildTabs(BuildContext context, StockTransferState state) {
    final bloc = context.read<StockTransferBloc>();
    final branchId = AuthService.currentBranchId ?? '';
    final outgoing = state.outgoingTransfers(branchId).length;
    final incoming = state.incomingTransfers(branchId).length;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'التحويلات الصادرة',
            count: outgoing,
            icon: Icons.arrow_upward_rounded,
            selected: state.selectedTab == 0,
            onTap: () => bloc.add(const SelectTransferTab(0)),
          ),
          _TabItem(
            label: 'التحويلات الواردة',
            count: incoming,
            icon: Icons.arrow_downward_rounded,
            selected: state.selectedTab == 1,
            onTap: () => bloc.add(const SelectTransferTab(1)),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, StockTransferState state) {
    if (state.status == StockTransferStatus.loading) {
      return const Center(child: LoadingIndicator());
    }
    final branchId = AuthService.currentBranchId ?? '';
    final list = state.selectedTab == 0
        ? state.outgoingTransfers(branchId)
        : state.incomingTransfers(branchId);

    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.swap_horiz_rounded,
        title: state.selectedTab == 0
            ? 'لا توجد تحويلات صادرة'
            : 'لا توجد تحويلات واردة',
        subtitle:
            'اضغط على "تحويل جديد" لإنشاء أول عملية تحويل بين الفروع بكل سهولة.',
      );
    }
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: list.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return _TransferCard(transfer: list[index]);
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? scheme.primary.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: selected ? scheme.primary : scheme.onSurfaceVariant),
              SizedBox(width: 8.w),
              ReusableText(
                label,
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                  child: ReusableText(
                    '$count',
                    style: AppTextStyles.caption(context).copyWith(
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransferCard extends StatefulWidget {
  final StockTransferModel transfer;
  const _TransferCard({required this.transfer});

  @override
  State<_TransferCard> createState() => _TransferCardState();
}

class _TransferCardState extends State<_TransferCard> {
  bool _expanded = false;

  Color get _statusColor {
    return switch (widget.transfer.status) {
      TransferStatus.draft => Colors.grey,
      TransferStatus.sent => AppColors.info,
      TransferStatus.received => AppColors.success,
      TransferStatus.cancelled => AppColors.error,
    };
  }

  String get _statusText {
    return switch (widget.transfer.status) {
      TransferStatus.draft => 'مسودة',
      TransferStatus.sent => 'مرسل',
      TransferStatus.received => 'مستلم',
      TransferStatus.cancelled => 'ملغي',
    };
  }

  IconData get _statusIcon {
    return switch (widget.transfer.status) {
      TransferStatus.draft => Icons.edit_note_rounded,
      TransferStatus.sent => Icons.local_shipping_rounded,
      TransferStatus.received => Icons.check_circle_rounded,
      TransferStatus.cancelled => Icons.cancel_rounded,
    };
  }

  int get _totalQuantity => widget.transfer.items.fold(0, (sum, item) => sum + item.quantity);
  bool get _isIncoming => widget.transfer.toBranchId == AuthService.currentBranchId;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StockTransferBloc>();
    final scheme = Theme.of(context).colorScheme;
    final t = widget.transfer;

    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.lg,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.sm.w),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                        ),
                        child: Icon(
                          _isIncoming ? Icons.call_received_rounded : Icons.call_made_rounded,
                          size: 20.sp,
                          color: scheme.primary,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              'تحويل رقم #${t.transferNumber}',
                              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                ReusableText(
                                  t.fromBranchName,
                                  style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: AppIconSize.sm.value,
                                    color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                ),
                                ReusableText(
                                  t.toBranchName,
                                  style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(
                        label: _statusText,
                        color: _statusColor,
                        icon: _statusIcon,
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: scheme.onSurfaceVariant,
                            size: AppIconSize.md.value,
                          ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Row(
                    children: [
                      InfoChip(icon: Icons.inventory_2_outlined, label: '${t.items.length} أصناف'),
                      SizedBox(width: AppSpacing.md.w),
                      InfoChip(icon: Icons.numbers_rounded, label: '$_totalQuantity وحدة'),
                      const Spacer(),
                          ReusableText(
                            '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}',
                            style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(icon: Icons.list_alt_rounded, title: 'الأصناف المنقولة'),
                  ...t.items.map((item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: ReusableText(
                                item.medicineName,
                                style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (item.batchNumber != null)
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 8.w),
                                child: Tag(label: 'دفعة: ${item.batchNumber}', color: AppColors.info),
                              ),
                            ReusableText(
                              '${item.quantity} وحدة',
                              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
                            ),
                          ],
                        ),
                      )),
                  if (t.notes?.isNotEmpty == true) ...[
                    SizedBox(height: AppSpacing.md.h),
                    Container(
                      padding: EdgeInsets.all(AppSpacing.sm.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppRadius.sm.r),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
                      ),
                      child: ReusableText(
                        'ملاحظات: ${t.notes}',
                        style: AppTextStyles.caption(context).copyWith(fontStyle: FontStyle.italic, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.lg.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (t.status == TransferStatus.draft || t.status == TransferStatus.sent)
                        ReusableButton(
                          text: 'إلغاء التحويل',
                          type: ButtonType.outlined,
                          color: AppColors.error,
                          onPressed: () => _confirmCancel(context, bloc),
                        ),
                      if (t.status == TransferStatus.sent && _isIncoming) ...[
                        SizedBox(width: AppSpacing.md.w),
                        ReusableButton(
                          text: 'تأكيد الاستلام',
                          prefixIcon: Icons.check_circle_rounded,
                          onPressed: () => _confirmReceive(context, bloc),
                        ),
                      ],
                      if (t.status == TransferStatus.draft && !_isIncoming) ...[
                        SizedBox(width: AppSpacing.md.w),
                        ReusableButton(
                          text: 'إرسال التحويل',
                          prefixIcon: Icons.send_rounded,
                          onPressed: () => bloc.add(SendTransfer(t)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmReceive(BuildContext context, StockTransferBloc bloc) {
    ReusableDialog.show(
      context,
      title: 'تأكيد استلام التحويل',
      headerIcon: const Icon(Icons.inventory_rounded),
      children: [
        ReusableText(
          'سيتم إضافة الأصناف المنقولة إلى مخزون فرعك الحالي وتحديث الكميات المتوفرة. هل تريد الاستمرار؟',
          style: AppTextStyles.body(context).copyWith(height: 1.5),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: 'استلام الكمية',
          onConfirm: () {
            Navigator.of(context).pop();
            bloc.add(ReceiveTransfer(widget.transfer.id));
          },
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context, StockTransferBloc bloc) {
    ReusableDialog.show(
      context,
      title: 'تأكيد الإلغاء',
      headerIcon: const Icon(Icons.cancel_rounded, color: AppColors.error),
      children: [
        ReusableText(
          widget.transfer.status == TransferStatus.sent ? 'سيتم إلغاء التحويل وإعادة المخزون المحجوز للفرع الأصلي.' : 'هل أنت متأكد من رغبتك في إلغاء هذا التحويل نهائياً؟',
          style: AppTextStyles.body(context).copyWith(height: 1.5),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: 'تأكيد الإلغاء',
          confirmType: ButtonType.primary,
          onConfirm: () {
            Navigator.of(context).pop();
            bloc.add(CancelTransfer(widget.transfer.id));
          },
        ),
      ],
    );
  }
}


