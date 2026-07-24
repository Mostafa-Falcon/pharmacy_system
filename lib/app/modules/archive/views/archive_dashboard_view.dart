import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../bloc/archive_bloc.dart';
import 'package:pharmacy_system/app/modules/archive/models/archive_record_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
class ArchiveDashboardView extends StatelessWidget {
  const ArchiveDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null || !user.isOwner) {
      return const HomeShell(
        title: '??????? ???????',
        child: AppStateView.permissionDenied(
          title: '???? ??? ????',
          message: '??? ?????? ????? ??? ????? ????????.',
        ),
      );
    }

    return HomeShell(
      title: ArchiveStrings.archiveDashboard,
      subtitle: ArchiveStrings.archiveSubtitle,
      child: BlocProvider(
        create: (_) => ArchiveBloc()..add(const LoadArchive()),
        child: const _ArchiveBody(),
      ),
    );
  }
}

class _ArchiveBody extends StatelessWidget {
  const _ArchiveBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundOf(context),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ArchiveToolbar(),
          SizedBox(height: AppSpacing.md),
          Expanded(child: _ArchiveContent()),
        ],
      ),
    );
  }
}

class _ArchiveToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ArchiveBloc>();

    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              SizedBox(
                width: 200.w,
                child: DropdownButtonFormField<ArchiveEntityType?>(
                  key: ValueKey(state.selectedType),
                  initialValue: state.selectedType,
                  decoration: InputDecoration(
                    labelText: ArchiveStrings.filterByType,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: AppText(ArchiveStrings.allTypes),
                    ),
                    for (final type in ArchiveEntityType.values)
                      DropdownMenuItem(
                        value: type,
                        child: AppText(type.displayName),
                      ),
                  ],
                  onChanged: (v) => bloc.add(ChangeArchiveEntityType(v)),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppInput(
                  hint: ArchiveStrings.archiveSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  showClearButton: true,
                  textDirection: TextDirection.rtl,
                  onChanged: (v) => bloc.add(SearchArchive(v)),
                  onClear: () => bloc.add(const SearchArchive('')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArchiveContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        if (state.status == ArchiveStatus.initial || state.status == ArchiveStatus.loading) {
          return const LoadingIndicator(message: '???? ????? ???????...');
        }

        if (state.status == ArchiveStatus.error) {
          return Center(
            child: ReusableStateView(
              title: '??? ?? ???????',
              message: state.error ?? '??? ??? ??? ?????',
              icon: Icons.error_outline_rounded,
            ),
          );
        }

        final records = state.records;
        if (records.isEmpty) {
          return const AppStateView.empty(
            icon: Icons.archive_outlined,
            title: ArchiveStrings.archiveEmpty,
            subtitle: ArchiveStrings.archiveEmptySubtitle,
          );
        }

        return Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return _ArchiveCardList(records: records);
                  }
                  return _ArchiveTable(records: records);
                },
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _ArchivePagination(),
          ],
        );
      },
    );
  }
}

class _ArchiveTable extends StatelessWidget {
  final List<ArchiveRecordModel> records;
  const _ArchiveTable({required this.records});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        final bloc = context.read<ArchiveBloc>();
        final isDisabled = state.isWorking;

        return AppCard(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerLow.withValues(alpha: 0.5)),
              columns: [
                DataColumn(label: AppText(ArchiveStrings.colEntityType, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: AppText(ArchiveStrings.colEntityName, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: AppText(ArchiveStrings.colDeletedBy, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: AppText(ArchiveStrings.colDeletedAt, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: AppText(ArchiveStrings.colStatus, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: AppText(ArchiveStrings.colActions, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
              ],
              rows: [
                for (final record in records)
                  DataRow(cells: [
                    DataCell(_EntityTypeChip(type: record.entityType)),
                    DataCell(AppText(record.entityName, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600))),
                    DataCell(AppText(record.deletedByName, variant: AppTextVariant.caption)),
                    DataCell(
                      AppText(
                        DateFormat('yyyy/MM/dd HH:mm').format(record.deletedAt.toLocal()),
                        variant: AppTextVariant.caption,
                      ),
                    ),
                    DataCell(_StatusBadge(record: record)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (record.isActive) ...[
                            IconButton(
                              tooltip: ArchiveStrings.viewArchiveDetails,
                              onPressed: () => _showDetailsDialog(context, record),
                              icon: const Icon(Icons.info_outline_rounded, size: 20),
                            ),
                            IconButton(
                              tooltip: ArchiveStrings.restoreItem,
                              onPressed: isDisabled
                                  ? null
                                  : () => _confirmRestore(context, record, bloc),
                              icon: Icon(Icons.restore_rounded, color: AppColors.success, size: 20),
                            ),
                            IconButton(
                              tooltip: ArchiveStrings.editBeforeRestore,
                              onPressed: isDisabled
                                  ? null
                                  : () => _showEditBeforeRestoreDialog(context, record, bloc),
                              icon: const Icon(Icons.edit_rounded, size: 20),
                            ),
                            IconButton(
                              tooltip: ArchiveStrings.permanentDeleteItem,
                              onPressed: isDisabled
                                  ? null
                                  : () => _confirmPermanentDelete(context, record, bloc),
                              icon: Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context, ArchiveRecordModel record) {
    final data = record.entityData;
    AppDialog.show(
      context,
      title: '?????? ??????',
      headerIcon: Icon(Icons.info_outline_rounded, color: AppColors.info),
      maxWidth: 500,
      children: [
        _DetailRow(label: '?????', value: record.entityName),
        _DetailRow(label: '?????', value: record.entityType.displayName),
        _DetailRow(label: '????? ??????', value: record.deletedByName),
        _DetailRow(label: '????? ?????', value: DateFormat('yyyy/MM/dd HH:mm:ss').format(record.deletedAt.toLocal())),
        if (data.isNotEmpty)
          ...data.entries.take(15).map((e) => _DetailRow(
            label: e.key,
            value: e.value?.toString() ?? '—',
          )),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              text: '?????',
              onPressed: () => Navigator.of(context).pop(),
              type: ButtonType.text,
            ),
          ],
        ),
      ],
    );
  }

  void _confirmRestore(BuildContext context, ArchiveRecordModel record, ArchiveBloc bloc) {
    AppDialog.show(
      context,
      title: ArchiveStrings.restoreConfirmTitle,
      headerIcon: const Icon(Icons.restore_rounded, color: AppColors.success),
      maxWidth: 400,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: AppText(
            '${ArchiveStrings.restoreConfirmMessage}\n\n"${record.entityName}"',
            style: AppTextStyles.body(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
        ),
        SizedBox(height: 24),
        DialogActions(
          cancelText: '?????',
          confirmText: ArchiveStrings.restore,
          confirmType: ButtonType.success,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            bloc.add(RestoreArchiveItem(record.id));
          },
        ),
      ],
    );
  }

  void _confirmPermanentDelete(BuildContext context, ArchiveRecordModel record, ArchiveBloc bloc) {
    AppDialog.show(
      context,
      title: ArchiveStrings.permanentDeleteConfirmTitle,
      headerIcon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
      maxWidth: 400,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: AppText(
            '${ArchiveStrings.permanentDeleteConfirmMessage}\n\n"${record.entityName}"',
            style: AppTextStyles.body(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
        ),
        SizedBox(height: 24),
        DialogActions(
          cancelText: '?????',
          confirmText: ArchiveStrings.archivePermanentDelete,
          confirmType: ButtonType.error,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            bloc.add(PermanentDeleteArchiveItem(record.id));
          },
        ),
      ],
    );
  }

  void _showEditBeforeRestoreDialog(BuildContext context, ArchiveRecordModel record, ArchiveBloc bloc) {
    final data = record.entityData;
    AppDialog.show(
      context,
      title: ArchiveStrings.editBeforeRestoreTitle,
      headerIcon: const Icon(Icons.edit_rounded, color: AppColors.warning),
      maxWidth: 500,
      children: [
        AppText(
          '?????? "${record.entityName}" ??? ?????:',
          style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
        ),
        SizedBox(height: 12),
        if (data.isNotEmpty)
          ...data.entries.take(20).map((e) => _DetailRow(
            label: e.key,
            value: e.value?.toString() ?? '—',
          )),
        SizedBox(height: 16),
        AppText(
          '???? ??????? ?????? ???????? ???????. ????? ??????? ??? ????????? ?? ???? ???????.',
          style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
        ),
        SizedBox(height: 24),
        DialogActions(
          cancelText: '?????',
          confirmText: ArchiveStrings.restore,
          confirmType: ButtonType.success,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            bloc.add(RestoreArchiveItem(record.id));
          },
        ),
      ],
    );
  }
}

class _ArchiveCardList extends StatelessWidget {
  final List<ArchiveRecordModel> records;
  const _ArchiveCardList({required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, i) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _ArchiveCard(record: records[i]),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final ArchiveRecordModel record;
  const _ArchiveCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        final bloc = context.read<ArchiveBloc>();
        final isDisabled = state.isWorking;
        return AppCard(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              _EntityTypeChip(type: record.entityType),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(record.entityName, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    AppText(
                      '${record.deletedByName} | ${DateFormat('yyyy/MM/dd').format(record.deletedAt.toLocal())}',
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ),
              ),
              _StatusBadge(record: record),
              if (record.isActive) ...[
                SizedBox(width: 8.w),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: isDisabled ? null : () => bloc.add(RestoreArchiveItem(record.id)),
                  icon: Icon(Icons.restore_rounded, color: AppColors.success, size: 20),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: isDisabled ? null : () => bloc.add(PermanentDeleteArchiveItem(record.id)),
                  icon: Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ArchivePagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveBloc, ArchiveState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              text: '??????',
              prefixIcon: Icons.arrow_back_rounded,
              onPressed: state.hasPreviousPage ? () => context.read<ArchiveBloc>().add(const PreviousArchivePage()) : null,
              type: ButtonType.outlined,
              height: 40,
            ),
            SizedBox(width: AppSpacing.md),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: AppText(
                '${ArchiveStrings.showingRecords} ${state.currentPage} ${ArchiveStrings.ofRecords} ${state.totalPages} (${state.totalRecords})',
                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            AppButton(
              text: '??????',
              prefixIcon: Icons.arrow_forward_rounded,
              onPressed: state.hasNextPage ? () => context.read<ArchiveBloc>().add(const NextArchivePage()) : null,
              type: ButtonType.outlined,
              height: 40,
            ),
          ],
        );
      },
    );
  }
}

class _EntityTypeChip extends StatelessWidget {
  final ArchiveEntityType type;
  const _EntityTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final config = _typeConfig(type);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: AppIconSize.sm.value, color: config.color),
          SizedBox(width: 4.w),
          AppText(
            type.displayName,
            style: AppTextStyles.caption(context).copyWith(color: config.color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _TypeConfig _typeConfig(ArchiveEntityType t) {
    switch (t) {
      case ArchiveEntityType.medicine:
        return _TypeConfig(Icons.medication_rounded, AppColors.info);
      case ArchiveEntityType.sale:
        return _TypeConfig(Icons.shopping_cart_rounded, AppColors.success);
      case ArchiveEntityType.purchase:
        return _TypeConfig(Icons.inventory_2_rounded, AppColors.warning);
      case ArchiveEntityType.customer:
        return _TypeConfig(Icons.people_rounded, AppColors.primary);
      case ArchiveEntityType.supplier:
        return _TypeConfig(Icons.business_rounded, AppColors.error);
      case ArchiveEntityType.return_:
        return _TypeConfig(Icons.currency_exchange_rounded, Colors.orange);
      case ArchiveEntityType.customerGroup:
        return _TypeConfig(Icons.group_work_rounded, Colors.teal);
      case ArchiveEntityType.supplierCustomer:
        return _TypeConfig(Icons.swap_horiz_rounded, Colors.indigo);
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  const _TypeConfig(this.icon, this.color);
}

class _StatusBadge extends StatelessWidget {
  final ArchiveRecordModel record;
  const _StatusBadge({required this.record});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    IconData icon;

    if (record.isPermanentlyDeleted) {
      text = ArchiveStrings.statusPermanentlyDeleted;
      color = AppColors.error;
      icon = Icons.delete_forever_rounded;
    } else if (record.isRestored) {
      text = ArchiveStrings.statusRestored;
      color = AppColors.success;
      icon = Icons.restore_rounded;
    } else {
      text = ArchiveStrings.statusActive;
      color = AppColors.warning;
      icon = Icons.archive_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSize.xs.value, color: color),
          SizedBox(width: 4.w),
          AppText(
            text,
            style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: AppText(
              label,
              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondaryOf(context)),
            ),
          ),
          Expanded(
            child: AppText(
              value,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textPrimaryOf(context)),
            ),
          ),
        ],
      ),
    );
  }
}






