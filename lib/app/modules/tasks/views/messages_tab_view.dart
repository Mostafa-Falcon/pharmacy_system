import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

import '../bloc/tasks_bloc.dart';

/// علامة تبويب الرسائل (BLoC).
class MessagesTabView extends StatelessWidget {
  const MessagesTabView({super.key});

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
          Expanded(child: _buildMessagesList(scheme)),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        ReusableButton(
          text: 'إرسال رسالة',
          prefixIcon: Icons.send,
          onPressed: () => _showMessageDialog(context),
        ),
        const Spacer(),
        BlocBuilder<TasksBloc, TasksState>(
          buildWhen: (previous, current) =>
              previous.messages != current.messages,
          builder: (context, state) {
            final unread = state.messages.where((m) => m.readAt == null).length;
            return ReusableText('رسائل غير مقروءة: $unread', fontSize: 14.sp);
          },
        ),
        SizedBox(width: AppSpacing.md.w),
        ReusableButton(
          text: 'تحديث',
          prefixIcon: Icons.refresh,
          type: ButtonType.tonal,
          onPressed: () => context.read<TasksBloc>().add(LoadTasks()),
        ),
      ],
    );
  }

  Widget _buildMessagesList(ColorScheme scheme) {
    return BlocBuilder<TasksBloc, TasksState>(
      buildWhen: (previous, current) =>
          previous.messages != current.messages ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator();
        }
        final list = state.messages;
        if (list.isEmpty) {
          return Center(
            child: Text(
              'لا توجد رسائل',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14.sp),
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => _MessageCard(message: list[i], scheme: scheme),
        );
      },
    );
  }

  void _showMessageDialog(BuildContext context) {
    final toCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إرسال رسالة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: toCtrl,
              decoration: const InputDecoration(
                labelText: 'إلى (معرف المستخدم)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: subjectCtrl,
              decoration: const InputDecoration(
                labelText: 'الموضوع',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'النص',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          ReusableButton(
            text: AppStrings.cancel,
            type: ButtonType.text,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ReusableButton(
            text: TasksStrings.messagesSendButton,
            onPressed: () {
              if (subjectCtrl.text.trim().isEmpty ||
                  bodyCtrl.text.trim().isEmpty) {
                return;
              }
              context.read<TasksBloc>().add(
                    SendMessage(
                      toUserId: toCtrl.text.trim(),
                      toName: toCtrl.text.trim(),
                      subject: subjectCtrl.text.trim(),
                      body: bodyCtrl.text.trim(),
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

class _MessageCard extends StatelessWidget {
  final MessageModel message;
  final ColorScheme scheme;
  const _MessageCard({required this.message, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final isUnread = message.readAt == null;
    final currentUserId = AuthService.currentUser?.id ?? '';
    final isIncoming = message.toUserId == currentUserId;

    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      backgroundColor: isUnread ? scheme.primaryContainer.withValues(alpha: 0.3) : null,
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUnread
              ? AppColors.primary
              : scheme.surfaceContainerHighest,
          child: Text(
            isIncoming
                ? message.fromName[0].toUpperCase()
                : message.toName[0].toUpperCase(),
            style: TextStyle(color: isUnread ? Colors.white : scheme.onSurface),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.subject,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (message.priority == 'high')
              Icon(Icons.priority_high, color: AppColors.error, size: 16.w),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${isIncoming ? 'من' : 'إلى'}: ${isIncoming ? message.fromName : message.toName}',
              style: TextStyle(fontSize: 11.sp),
            ),
            Text(
              message.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
            ),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(message.createdAt),
              style: TextStyle(fontSize: 10.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'read' && isUnread) {
              context.read<TasksBloc>().add(MarkMessageRead(message.id));
            } else if (v == 'delete') {
              context.read<TasksBloc>().add(DeleteMessage(message.id));
            }
          },
          itemBuilder: (_) => [
            if (isUnread)
              ReusableActionMenuItem(
                value: 'read',
                icon: Icons.mark_email_read,
                label: TasksStrings.markAsRead,
              ),
            ReusableActionMenuItem(
              value: 'delete',
              icon: Icons.delete_outline_rounded,
              label: AppStrings.delete,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
