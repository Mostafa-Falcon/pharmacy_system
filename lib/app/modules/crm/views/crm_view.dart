import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:pharmacy_system/app/modules/crm/models/crm_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
import '../bloc/crm_bloc.dart';
import '../bloc/crm_event.dart';
import '../bloc/crm_state.dart';

class CrmView extends StatelessWidget {
  const CrmView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CrmBody();
  }
}

class _CrmBody extends StatelessWidget {
  const _CrmBody();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: CrmStrings.crmTitleAbbr,
      subtitle: CrmStrings.crmSubtitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: BlocBuilder<CrmBloc, CrmState>(
          builder: (context, state) {
            if (state.status == CrmStatus.initial || state.status == CrmStatus.loading) {
              return const LoadingIndicator();
            }
            if (state.status == CrmStatus.error) {
              return ReusableStateView(
                message: state.error ?? CrmStrings.crmError,
                action: ReusableButton(
                  text: AppStrings.refresh,
                  onPressed: () => context.read<CrmBloc>().add(const LoadCrmLeads()),
                ),
              );
            }
            return Column(
              children: [
                _buildStatsRow(scheme, state),
                SizedBox(height: AppSpacing.lg.h),
                _buildToolbar(context, state),
                SizedBox(height: AppSpacing.md.h),
                Expanded(child: _buildList(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsRow(ColorScheme scheme, CrmState state) {
    final s = state.stats;
    return Row(
      children: [
        Expanded(child: SummaryCard(label: CrmStrings.crmTotal, value: '${s['total']}', color: AppColors.primary)),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: SummaryCard(label: CrmStrings.crmNew, value: '${s['new']}', color: AppColors.info)),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: SummaryCard(label: CrmStrings.crmContacted, value: '${s['contacted']}', color: AppColors.warning)),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: SummaryCard(label: CrmStrings.crmInterested, value: '${s['interested']}', color: AppColors.primary)),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: SummaryCard(label: CrmStrings.crmConverted, value: '${s['converted']}', color: AppColors.success)),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: SummaryCard(label: CrmStrings.crmNotInterested, value: '${s['notInterested']}', color: AppColors.error)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context, CrmState state) {
    return Row(
      children: [
        ReusableButton(
          text: CrmStrings.crmAddLead,
          prefixIcon: Icons.person_add_rounded,
          onPressed: () => _showLeadDialog(context),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: ReusableInput(
            hint: CrmStrings.crmSearchHint,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            showClearButton: true,
            textDirection: TextDirection.rtl,
            onChanged: (v) => context.read<CrmBloc>().add(SearchCrmLeads(v)),
            onClear: () => context.read<CrmBloc>().add(const SearchCrmLeads('')),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, CrmState state) {
    final bloc = context.read<CrmBloc>();
    final items = state.filteredLeads;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline_rounded,
        title: CrmStrings.crmEmpty,
        subtitle: CrmStrings.crmEmptySubtitle,
      );
    }

    final columns = [
      ReusableTableColumn<CrmLeadModel>(
        id: 'name',
        title: 'العميل المتوقع',
        flex: 2,
        isSortable: true,
        cellBuilder: (l) => TableContactNameCell(
          name: l.name,
          subtitle: l.source ?? 'بدون مصدر',
          icon: Icons.person_rounded,
          iconColor: _statusColor(l.status),
        ),
      ),
      ReusableTableColumn<CrmLeadModel>(
        id: 'contact',
        title: 'الاتصال',
        width: 180.w,
        textBuilder: (l) => l.phone ?? l.email ?? '—',
      ),
      ReusableTableColumn<CrmLeadModel>(
        id: 'status',
        title: 'الحالة',
        width: 130.w,
        cellBuilder: (l) => StatusBadge(label: _statusLabel(l.status), color: _statusColor(l.status)),
      ),
      ReusableTableColumn<CrmLeadModel>(
        id: 'date',
        title: 'تاريخ الإضافة',
        width: 140.w,
        textBuilder: (l) => DateFormat('yyyy/MM/dd').format(l.createdAt),
      ),
    ];

    return ReusableTable<CrmLeadModel>(
      columns: columns,
      items: items,
      itemLabel: 'عميل محتمل',
      rowActions: (l) => TableOptionsButton(
        onSelected: (v) {
          if (v.startsWith('status:')) {
            final name = v.substring(7);
            final status = CrmLeadStatus.values.firstWhere((s) => s.name == name);
            bloc.add(UpdateCrmLeadStatus(l, status));
          } else if (v == 'edit') {
            _showLeadDialog(context, lead: l);
          } else if (v == 'followup') {
            _showFollowUpDialog(context, l);
          }
        },
        menuItems: [
          for (final s in CrmLeadStatus.values.where((s) => s != l.status))
            PopupMenuItem<String>(value: 'status:${s.name}', child: ReusableText('نقل إلى: ${_statusLabel(s)}')),
          const PopupMenuItem(value: 'edit', child: ReusableText(AppStrings.editData)),
          const PopupMenuItem(value: 'followup', child: ReusableText(CrmStrings.crmAddFollowUp)),
        ],
      ),
    );
  }

  Color _statusColor(CrmLeadStatus status) => switch (status) {
    CrmLeadStatus.newLead => AppColors.info,
    CrmLeadStatus.contacted => AppColors.warning,
    CrmLeadStatus.interested => AppColors.primary,
    CrmLeadStatus.converted => AppColors.success,
    CrmLeadStatus.notInterested => AppColors.error,
  };

  String _statusLabel(CrmLeadStatus s) => switch (s) {
    CrmLeadStatus.newLead => CrmStrings.crmNew,
    CrmLeadStatus.contacted => CrmStrings.crmContacted,
    CrmLeadStatus.interested => CrmStrings.crmInterested,
    CrmLeadStatus.converted => CrmStrings.crmConverted,
    CrmLeadStatus.notInterested => CrmStrings.crmNotInterested,
  };

  void _showLeadDialog(BuildContext context, {CrmLeadModel? lead}) {
    final nameCtrl = TextEditingController(text: lead?.name ?? '');
    final phoneCtrl = TextEditingController(text: lead?.phone ?? '');
    final emailCtrl = TextEditingController(text: lead?.email ?? '');
    final sourceCtrl = TextEditingController(text: lead?.source ?? '');
    final notesCtrl = TextEditingController(text: lead?.notes ?? '');
    final isEditing = lead != null;
    final bloc = context.read<CrmBloc>();

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: isEditing ? CrmStrings.crmEditDialog : CrmStrings.crmAddDialog,
        headerIcon: Icon(isEditing ? Icons.edit_rounded : Icons.person_add_rounded),
        children: [
          ReusableInput(
            controller: nameCtrl,
            label: CrmStrings.crmNameLabel,
            hint: CrmStrings.crmNameHint,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: phoneCtrl,
            label: CrmStrings.crmPhone,
            hint: CrmStrings.crmPhoneHint,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput.email(controller: emailCtrl, label: AppStrings.emailLabel),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: sourceCtrl,
            label: CrmStrings.crmSource,
            hint: CrmStrings.crmSourceHint,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: notesCtrl,
            label: CrmStrings.crmAdditionalNotes,
            maxLines: 3,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: isEditing ? CrmStrings.crmSaveEdit : CrmStrings.crmAddNow,
            onConfirm: () async {
              if (nameCtrl.text.trim().isEmpty) {
                AppSnackbar.error(CrmStrings.crmNameRequired);
                return;
              }
              if (isEditing) {
                bloc.add(UpdateCrmLead(lead.copyWith(
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim().nullIfEmpty,
                  email: emailCtrl.text.trim().nullIfEmpty,
                  source: sourceCtrl.text.trim().nullIfEmpty,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                )));
              } else {
                bloc.add(AddCrmLead(
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim().nullIfEmpty,
                  email: emailCtrl.text.trim().nullIfEmpty,
                  source: sourceCtrl.text.trim().nullIfEmpty,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                ));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ).whenComplete(() {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      emailCtrl.dispose();
      sourceCtrl.dispose();
      notesCtrl.dispose();
    });
  }

  void _showFollowUpDialog(BuildContext context, CrmLeadModel lead) {
    final dateCtrl = TextEditingController(
      text: DateTime.now().add(const Duration(days: 1)).toString().split(' ')[0],
    );
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: CrmStrings.crmFollowUpTitleFormat.replaceAll('%s', lead.name),
        headerIcon: const Icon(Icons.follow_the_signs_rounded),
        children: [
          ReusableInput(
            controller: dateCtrl,
            label: CrmStrings.crmFollowUpDate,
            hint: CrmStrings.dueDateHint,
            prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: notesCtrl,
            label: CrmStrings.crmFollowUpNotes,
            hint: CrmStrings.crmFollowUpHint,
            maxLines: 3,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: CrmStrings.crmSaveFollowUp,
            onConfirm: () async {
              final notes = notesCtrl.text.trim();
              if (notes.isEmpty) { AppSnackbar.error(CrmStrings.crmFollowUpRequired); return; }
              final date = DateTime.tryParse(dateCtrl.text) ?? DateTime.now();
              context.read<CrmBloc>().add(AddCrmFollowUp(lead: lead, notes: notes, followUpDate: date));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ).whenComplete(() {
      dateCtrl.dispose();
      notesCtrl.dispose();
    });
  }
}

