import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

import '../bloc/tasks_bloc.dart';

/// علامة تبويب الملاحظات (BLoC).
class NotesTabView extends StatelessWidget {
  const NotesTabView({super.key});

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
          Expanded(child: _buildNotesList(scheme)),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        AppButton(
          text: 'إضافة ملاحظة',
          prefixIcon: Icons.add,
          onPressed: () => _showNoteDialog(context),
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

  Widget _buildNotesList(ColorScheme scheme) {
    return BlocBuilder<TasksBloc, TasksState>(
      buildWhen: (previous, current) =>
          previous.notes != current.notes ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator();
        }
        final list = state.notes;
        if (list.isEmpty) {
          return Center(
            child: Text(
              'لا توجد ملاحظات',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14.sp),
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => _NoteCard(note: list[i], scheme: scheme),
        );
      },
    );
  }

  void _showNoteDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة ملاحظة'),
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
              controller: contentCtrl,
              decoration: const InputDecoration(
                labelText: 'المحتوى',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
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
            text: TasksStrings.notesAdd,
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              context.read<TasksBloc>().add(
                    AddNote(
                      title: titleCtrl.text.trim(),
                      content: contentCtrl.text.trim(),
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

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final ColorScheme scheme;
  const _NoteCard({required this.note, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
          children: [
            if (note.pinned)
              Icon(Icons.push_pin, color: AppColors.warning, size: 20.w),
            if (note.pinned) SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'pin') {
                  context.read<TasksBloc>().add(TogglePinNote(note.id));
                } else if (v == 'delete') {
                  context.read<TasksBloc>().add(DeleteNote(note.id));
                }
              },
              itemBuilder: (_) => [
                ReusableActionMenuItem(
                  value: 'pin',
                  icon: note.pinned ? Icons.push_pin_outlined : Icons.push_pin,
                  label: note.pinned ? TasksStrings.notesUnpin : TasksStrings.notesPin,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: GeneralStrings.delete,
                  color: AppColors.error,
                ),
              ],
            ),
          ],
        ),
      );
  }
}




