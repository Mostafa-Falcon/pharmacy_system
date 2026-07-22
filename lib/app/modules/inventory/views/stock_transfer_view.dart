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
          title: 'Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
          subtitle: 'Ã˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â© Ã˜Â­Ã˜Â±Ã™Æ’Ã˜Â© Ã˜Â§Ã™â€žÃ˜Â£Ã˜ÂµÃ™â€ Ã˜Â§Ã™Â Ã˜Â¨Ã™Å Ã™â€  Ã˜Â§Ã™â€žÃ™ÂÃ˜Â±Ã™Ë†Ã˜Â¹ Ã™Ë†Ã™â€¦Ã˜ÂªÃ˜Â§Ã˜Â¨Ã˜Â¹Ã˜Â© Ã˜Â§Ã™â€žÃ˜Â´Ã˜Â­Ã™â€ Ã˜Â§Ã˜Âª',
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
        text: 'Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯',
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.STOCK_TRANSFER_ADD),
      ),
      SizedBox(width: AppSpacing.sm),
      if (pending.isNotEmpty)
        ReusableBadge.tone(
          label: '${pending.length} Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª Ã™Ë†Ã˜Â§Ã˜Â±Ã˜Â¯Ã˜Â© Ã™â€¦Ã˜Â¹Ã™â€žÃ™â€šÃ˜Â©',
          tone: ReusableBadgeTone.warning,
        ),
      StatChip(
        label: 'Ã˜Â¥Ã˜Â¬Ã™â€¦Ã˜Â§Ã™â€žÃ™Å  Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª',
        count: state.transfers.length,
        color: scheme.primary,
        icon: Icons.swap_horiz_rounded,
      ),
      ReusableButton(
        text: 'Ã˜ÂªÃ˜Â­Ã˜Â¯Ã™Å Ã˜Â«',
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
            label: 'Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ˜ÂµÃ˜Â§Ã˜Â¯Ã˜Â±Ã˜Â©',
            count: outgoing,
            icon: Icons.arrow_upward_rounded,
            selected: state.selectedTab == 0,
            onTap: () => bloc.add(const SelectTransferTab(0)),
          ),
          _TabItem(
            label: 'Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™Ë†Ã˜Â§Ã˜Â±Ã˜Â¯Ã˜Â©',
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
            ? 'Ã™â€žÃ˜Â§ Ã˜ÂªÃ™Ë†Ã˜Â¬Ã˜Â¯ Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª Ã˜ÂµÃ˜Â§Ã˜Â¯Ã˜Â±Ã˜Â©'
            : 'Ã™â€žÃ˜Â§ Ã˜ÂªÃ™Ë†Ã˜Â¬Ã˜Â¯ Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€žÃ˜Â§Ã˜Âª Ã™Ë†Ã˜Â§Ã˜Â±Ã˜Â¯Ã˜Â©',
        subtitle:
            'Ã˜Â§Ã˜Â¶Ã˜ÂºÃ˜Â· Ã˜Â¹Ã™â€žÃ™â€° "Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯" Ã™â€žÃ˜Â¥Ã™â€ Ã˜Â´Ã˜Â§Ã˜Â¡ Ã˜Â£Ã™Ë†Ã™â€ž Ã˜Â¹Ã™â€¦Ã™â€žÃ™Å Ã˜Â© Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â¨Ã™Å Ã™â€  Ã˜Â§Ã™â€žÃ™ÂÃ˜Â±Ã™Ë†Ã˜Â¹ Ã˜Â¨Ã™Æ’Ã™â€ž Ã˜Â³Ã™â€¡Ã™Ë†Ã™â€žÃ˜Â©.',
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
      TransferStatus.draft => 'Ã™â€¦Ã˜Â³Ã™Ë†Ã˜Â¯Ã˜Â©',
      TransferStatus.sent => 'Ã™â€¦Ã˜Â±Ã˜Â³Ã™â€ž',
      TransferStatus.received => 'Ã™â€¦Ã˜Â³Ã˜ÂªÃ™â€žÃ™â€¦',
      TransferStatus.cancelled => 'Ã™â€¦Ã™â€žÃ˜ÂºÃ™Å ',
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
                              'Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â±Ã™â€šÃ™â€¦ #${t.transferNumber}',
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
                      InfoChip(icon: Icons.inventory_2_outlined, label: '${t.items.length} Ã˜Â£Ã˜ÂµÃ™â€ Ã˜Â§Ã™Â'),
                      SizedBox(width: AppSpacing.md.w),
                      InfoChip(icon: Icons.numbers_rounded, label: '$_totalQuantity Ã™Ë†Ã˜Â­Ã˜Â¯Ã˜Â©'),
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
                  const SectionHeader(icon: Icons.list_alt_rounded, title: 'Ã˜Â§Ã™â€žÃ˜Â£Ã˜ÂµÃ™â€ Ã˜Â§Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã™â€ Ã™â€šÃ™Ë†Ã™â€žÃ˜Â©'),
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
                                child: Tag(label: 'Ã˜Â¯Ã™ÂÃ˜Â¹Ã˜Â©: ${item.batchNumber}', color: AppColors.info),
                              ),
                            ReusableText(
                              '${item.quantity} Ã™Ë†Ã˜Â­Ã˜Â¯Ã˜Â©',
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
                        'Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â­Ã˜Â¸Ã˜Â§Ã˜Âª: ${t.notes}',
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
                          text: 'Ã˜Â¥Ã™â€žÃ˜ÂºÃ˜Â§Ã˜Â¡ Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž',
                          type: ButtonType.outlined,
                          color: AppColors.error,
                          onPressed: () => _confirmCancel(context, bloc),
                        ),
                      if (t.status == TransferStatus.sent && _isIncoming) ...[
                        SizedBox(width: AppSpacing.md.w),
                        ReusableButton(
                          text: 'Ã˜ÂªÃ˜Â£Ã™Æ’Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã˜ÂªÃ™â€žÃ˜Â§Ã™â€¦',
                          prefixIcon: Icons.check_circle_rounded,
                          onPressed: () => _confirmReceive(context, bloc),
                        ),
                      ],
                      if (t.status == TransferStatus.draft && !_isIncoming) ...[
                        SizedBox(width: AppSpacing.md.w),
                        ReusableButton(
                          text: 'Ã˜Â¥Ã˜Â±Ã˜Â³Ã˜Â§Ã™â€ž Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž',
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
      title: 'Ã˜ÂªÃ˜Â£Ã™Æ’Ã™Å Ã˜Â¯ Ã˜Â§Ã˜Â³Ã˜ÂªÃ™â€žÃ˜Â§Ã™â€¦ Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž',
      headerIcon: const Icon(Icons.inventory_rounded),
      children: [
        ReusableText(
          'Ã˜Â³Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ˜Â£Ã˜ÂµÃ™â€ Ã˜Â§Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã™â€ Ã™â€šÃ™Ë†Ã™â€žÃ˜Â© Ã˜Â¥Ã™â€žÃ™â€° Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€  Ã™ÂÃ˜Â±Ã˜Â¹Ã™Æ’ Ã˜Â§Ã™â€žÃ˜Â­Ã˜Â§Ã™â€žÃ™Å  Ã™Ë†Ã˜ÂªÃ˜Â­Ã˜Â¯Ã™Å Ã˜Â« Ã˜Â§Ã™â€žÃ™Æ’Ã™â€¦Ã™Å Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂªÃ™Ë†Ã™ÂÃ˜Â±Ã˜Â©. Ã™â€¡Ã™â€ž Ã˜ÂªÃ˜Â±Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã˜ÂªÃ™â€¦Ã˜Â±Ã˜Â§Ã˜Â±Ã˜Å¸',
          style: AppTextStyles.body(context).copyWith(height: 1.5),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: 'Ã˜Â§Ã˜Â³Ã˜ÂªÃ™â€žÃ˜Â§Ã™â€¦ Ã˜Â§Ã™â€žÃ™Æ’Ã™â€¦Ã™Å Ã˜Â©',
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
      title: 'Ã˜ÂªÃ˜Â£Ã™Æ’Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ˜ÂºÃ˜Â§Ã˜Â¡',
      headerIcon: const Icon(Icons.cancel_rounded, color: AppColors.error),
      children: [
        ReusableText(
          widget.transfer.status == TransferStatus.sent ? 'Ã˜Â³Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â¥Ã™â€žÃ˜ÂºÃ˜Â§Ã˜Â¡ Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã™Ë†Ã˜Â¥Ã˜Â¹Ã˜Â§Ã˜Â¯Ã˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€  Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â­Ã˜Â¬Ã™Ë†Ã˜Â² Ã™â€žÃ™â€žÃ™ÂÃ˜Â±Ã˜Â¹ Ã˜Â§Ã™â€žÃ˜Â£Ã˜ÂµÃ™â€žÃ™Å .' : 'Ã™â€¡Ã™â€ž Ã˜Â£Ã™â€ Ã˜Âª Ã™â€¦Ã˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã˜Â±Ã˜ÂºÃ˜Â¨Ã˜ÂªÃ™Æ’ Ã™ÂÃ™Å  Ã˜Â¥Ã™â€žÃ˜ÂºÃ˜Â§Ã˜Â¡ Ã™â€¡Ã˜Â°Ã˜Â§ Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã™â€ Ã™â€¡Ã˜Â§Ã˜Â¦Ã™Å Ã˜Â§Ã™â€¹Ã˜Å¸',
          style: AppTextStyles.body(context).copyWith(height: 1.5),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: 'Ã˜ÂªÃ˜Â£Ã™Æ’Ã™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ˜ÂºÃ˜Â§Ã˜Â¡',
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


