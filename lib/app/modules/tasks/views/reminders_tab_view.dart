import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

import '../bloc/tasks_bloc.dart';

/// علامة تبويب التذكيرات (BLoC).
class RemindersTabView extends StatelessWidget {
  const RemindersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        children: [
          _buildToolbar(context),
          SizedBox(height: AppSpacing.md.h),
          Expanded(child: _buildRemindersList(scheme)),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        AppButton(
          text: 'إضافة تذكير',
          prefixIcon: Icons.add,
          onPressed: () => _showReminderDialog(context),
        ),
        const Spacer(),
        AppButton(
          text: 'تحديث',
          prefixIcon: Icons.refresh,
          type: ButtonType.tonal,
          onPressed: () => context.read<TasksBloc>().add(LoadTasks()),
        ),
      ],
    );
  }

  Widget _buildRemindersList(ColorScheme scheme) {
    return BlocBuilder<TasksBloc, TasksState>(
      buildWhen: (previous, current) =>
          previous.reminders != current.reminders ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator();
        }
        final list = state.reminders;
        if (list.isEmpty) {
          return Center(
            child: Text(
              'لا توجد تذكيرات',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14.sp),
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) =>
              _ReminderCard(reminder: list[i], scheme: scheme),
        );
      },
    );
  }

  void _showReminderDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    String repeat = 'none';
    DateTime remindAt = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة تذكير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: msgCtrl,
              decoration: const InputDecoration(
                labelText: 'الرسالة',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12.h),
            ListTile(
              title: Text(
                'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(remindAt)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: ctx,
                  initialDate: remindAt,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date == null) return;
                if (!ctx.mounted) return;
                final time = await showTimePicker(
                  context: ctx,
                  initialTime: TimeOfDay.fromDateTime(remindAt),
                );
                if (time == null) return;
                remindAt = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              },
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: repeat,
              decoration: const InputDecoration(
                labelText: 'التكرار',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('بدون تكرار')),
                DropdownMenuItem(value: 'daily', child: Text('يومي')),
                DropdownMenuItem(value: 'weekly', child: Text('أسبوعي')),
                DropdownMenuItem(value: 'monthly', child: Text('شهري')),
              ],
              onChanged: (v) => repeat = v ?? 'none',
            ),
          ],
        ),
        actions: [
          AppButton(
            text: GeneralStrings.cancel,
            type: ButtonType.text,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(
            text: TasksStrings.remindersAddButton,
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              context.read<TasksBloc>().add(
                    AddReminder(
                      title: titleCtrl.text.trim(),
                      message: msgCtrl.text.trim(),
                      remindAt: remindAt,
                      repeat: repeat,
                    ),
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final ColorScheme scheme;
  const _ReminderCard({required this.reminder, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final isDismissed = reminder.dismissed;
    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      backgroundColor: isDismissed ? scheme.surfaceContainerHighest : null,
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          reminder.repeat != 'none' ? Icons.repeat : Icons.alarm,
          color: isDismissed ? scheme.onSurfaceVariant : AppColors.warning,
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            decoration: isDismissed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reminder.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(reminder.remindAt),
              style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'dismiss') {
              context.read<TasksBloc>().add(DismissReminder(reminder.id));
            } else if (v == 'delete') {
              context.read<TasksBloc>().add(DeleteReminder(reminder.id));
            }
          },
          itemBuilder: (_) => [
            if (!reminder.dismissed)
              ReusableActionMenuItem(
                value: 'dismiss',
                icon: Icons.check,
                label: TasksStrings.remindersDismiss,
              ),
            ReusableActionMenuItem(
              value: 'delete',
              icon: Icons.delete_outline_rounded,
              label: GeneralStrings.delete,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}




