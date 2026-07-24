import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/constants/strings/tasks_strings.dart';
import 'package:pharmacy_system/app/core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

import '../bloc/tasks_bloc.dart';

/// ????? ????? ?????? (BLoC).
class TasksTabView extends StatelessWidget {
  const TasksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        children: [
          _buildStatsRow(),
          SizedBox(height: AppSpacing.lg.h),
          _buildToolbar(context),
          SizedBox(height: AppSpacing.md.h),
          Expanded(child: _buildTaskList(context, scheme)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return BlocBuilder<TasksBloc, TasksState>(
      buildWhen: (previous, current) => previous.tasks == current.tasks || previous.isLoading != current.isLoading,
      builder: (context, state) {
        final s = state.taskStats;
        return Row(
          children: [
            Expanded(child: SummaryCard(label: '?????? ??????', value: '${s['total']}', color: AppColors.primary, icon: Icons.assignment_rounded)),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(child: SummaryCard(label: '????', value: '${s['pending']}', color: AppColors.warning, icon: Icons.pending_actions_rounded)),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(child: SummaryCard(label: '??? ???????', value: '${s['inProgress']}', color: AppColors.info, icon: Icons.running_with_errors_rounded)),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(child: SummaryCard(label: '??????', value: '${s['completed']}', color: AppColors.success, icon: Icons.task_alt_rounded)),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(child: SummaryCard(label: '??????', value: '${s['overdue']}', color: AppColors.error, icon: Icons.notification_important_rounded)),
          ],
        );
      },
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final bloc = context.read<TasksBloc>();
    return Row(
      children: [
        AppButton(
          text: '????? ???? ?????',
          prefixIcon: Icons.add_task_rounded,
          onPressed: () => _showTaskDialog(context),
        ),
        SizedBox(width: AppSpacing.lg.w),
        SizedBox(
          width: 200.w,
          child: BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              return ReusableDropdown<String?>(
                hintText: '???? ???????',
                value: state.tasksFilterStatusOrNull,
                items: const [null, 'pending', 'inProgress', 'completed'],
                itemAsString: (v) => switch (v) {
                  'pending' => '????',
                  'inProgress' => '??? ???????',
                  'completed' => '?????',
                  _ => '???? ???????',
                },
                onChanged: (v) => bloc.add(FilterTasks(status: v, priority: null)),
                isCompact: true,
              );
            },
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        SizedBox(
          width: 200.w,
          child: BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              return ReusableDropdown<String?>(
                hintText: '???? ?????????',
                value: state.tasksFilterPriorityOrNull,
                items: const [null, 'low', 'medium', 'high', 'urgent'],
                itemAsString: (v) => switch (v) {
                  'low' => '?????? ??????',
                  'medium' => '?????? ??????',
                  'high' => '?????? ?????',
                  'urgent' => '?????? ????? ????',
                  _ => '???? ?????????',
                },
                onChanged: (v) => bloc.add(FilterTasks(priority: v, status: null)),
                isCompact: true,
              );
            },
          ),
        ),
        const Spacer(),
        AppButton(
          text: '????? ???????',
          prefixIcon: Icons.refresh_rounded,
          type: ButtonType.outlined,
          onPressed: () => bloc.add(LoadTasks()),
        ),
      ],
    );
  }

  Widget _buildTaskList(BuildContext context, ColorScheme scheme) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: LoadingIndicator());
        final list = state.tasks;
        if (list.isEmpty) {
          return const AppStateView.empty(icon: Icons.task_outlined, title: '?? ???? ???? ?????? ??????? ??????');
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, index) => SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (_, i) => _TaskCard(task: list[i], scheme: scheme),
        );
      },
    );
  }

  void _showTaskDialog(BuildContext context) {
    final bloc = context.read<TasksBloc>();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String priority = 'medium';
    DateTime? dueDate;

    ReusableDialog.show(
      context,
      title: '????? ???? ??? ?????',
      headerIcon: const Icon(Icons.add_task_rounded),
      children: [
        AppInput(controller: titleCtrl, label: '????? ?????? *', hint: '???? ???? ??? ????...', autofocus: true),
        SizedBox(height: 12.h),
        AppInput(controller: descCtrl, label: '?????? ?????? (???????)', hint: '???? ????? ?????? ??????...', maxLines: 3),
        SizedBox(height: 12.h),
        ReusableDropdown<String>(
          labelText: '???? ??????? (????????)',
          hintText: '???? ????????',
          items: const ['low', 'medium', 'high', 'urgent'],
          value: priority,
          itemAsString: (v) => switch (v) { 'low' => '??????', 'medium' => '??????', 'high' => '?????', 'urgent' => '????? ????', _ => v },
          onChanged: (v) => priority = v ?? 'medium',
        ),
        SizedBox(height: 12.h),
        _buildDatePickerField(context, label: '????? ????????? ???????', date: dueDate, onPicked: (d) => dueDate = d),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: '??? ??????',
          onConfirm: () {
            if (titleCtrl.text.trim().isEmpty) return;
            bloc.add(AddTask(title: titleCtrl.text.trim(), description: descCtrl.text.trim().nullIfEmpty, priority: priority, dueDate: dueDate));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, {required String label, required DateTime? date, required Function(DateTime) onPicked}) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
          if (picked != null) {
            onPicked(picked);
            setState(() => date = picked);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.calendar_month_rounded)),
          child: Text(date != null ? DateFormat('yyyy/MM/dd').format(date!) : '???? ?????? ???????...', style: TextStyle(fontSize: 13.sp)),
        ),
      );
    });
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final ColorScheme scheme;
  const _TaskCard({required this.task, required this.scheme});

  Color _priorityColor() {
    return switch (task.priority) {
      'urgent' => AppColors.error,
      'high' => AppColors.warning,
      'low' => AppColors.success,
      _ => AppColors.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now()) && task.status != 'completed';
    final bloc = context.read<TasksBloc>();

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {}, // Show details later
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Row(
            children: [
              Container(width: 4.w, height: 60.h, decoration: BoxDecoration(color: _priorityColor(), borderRadius: BorderRadius.circular(2.r))),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(task.title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    if (task.description?.isNotEmpty == true) ...[
                      SizedBox(height: 4.h),
                      AppText(task.description!, style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Tag(label: _statusLabel(task.status), color: task.status == 'completed' ? AppColors.success : AppColors.info),
                        SizedBox(width: 8.w),
                        Tag(label: _priorityLabel(task.priority), color: _priorityColor()),
                        if (task.dueDate != null) ...[
                          SizedBox(width: 12.w),
                          Icon(Icons.calendar_today_rounded, size: 12.sp, color: isOverdue ? AppColors.error : scheme.onSurfaceVariant),
                          SizedBox(width: 4.w),
                          AppText(DateFormat('yyyy/MM/dd').format(task.dueDate!), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: isOverdue ? AppColors.error : scheme.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'complete') bloc.add(CompleteTask(task.id));
                  if (v == 'reopen') bloc.add(ReopenTask(task.id));
                  if (v == 'delete') {
                    ConfirmDeleteDialog.show(context, title: '??? ??????', message: '?? ??? ????? ?? ??? ?????? "${task.title}"?', onConfirm: () => bloc.add(DeleteTask(task.id)));
                  }
                },
                icon: const Icon(Icons.more_horiz_rounded),
                itemBuilder: (_) => [
                  if (task.status != 'completed')
                    ReusableActionMenuItem(
                      value: 'complete',
                      icon: Icons.check_circle_rounded,
                      label: TasksStrings.tasksComplete,
                      color: AppColors.success,
                    ),
                  if (task.status == 'completed')
                    ReusableActionMenuItem(
                      value: 'reopen',
                      icon: Icons.refresh_rounded,
                      label: TasksStrings.tasksReopen,
                      color: AppColors.info,
                    ),
                  ReusableActionMenuItem(
                    value: 'delete',
                    icon: Icons.delete_outline_rounded,
                    label: TasksStrings.tasksDeletePermanent,
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String status) => switch (status) { 'pending' => '?????', 'inProgress' => '??? ???????', 'completed' => '??????', 'cancelled' => '?????', _ => status };
  String _priorityLabel(String p) => switch (p) { 'low' => '??????', 'medium' => '??????', 'high' => '?????', 'urgent' => '????? ????', _ => p };
}



