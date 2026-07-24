import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/presentation/widgets/shareds/home_shell.dart';

import '../bloc/tasks_bloc.dart';
import 'messages_tab_view.dart';
import 'notes_tab_view.dart';
import 'reminders_tab_view.dart';
import 'tasks_tab_view.dart';

/// صفحة المهام والملاحظات (BLoC).
class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: 'المهام والملاحظات',
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
              ),
              child: BlocBuilder<TasksBloc, TasksState>(
                buildWhen: (previous, current) =>
                    previous.tasks != current.tasks ||
                    previous.notes != current.notes ||
                    previous.reminders != current.reminders ||
                    previous.messages != current.messages,
                builder: (context, state) {
                  return TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: scheme.primary,
                    labelColor: scheme.primary,
                    unselectedLabelColor: scheme.onSurfaceVariant,
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: 'المهام (${state.taskStats['total'] ?? 0})'),
                      Tab(text: 'الملاحظات (${state.notes.length})'),
                      Tab(text: 'التذكيرات (${state.reminders.length})'),
                      Tab(text: 'الرسائل (${state.messages.length})'),
                    ],
                  );
                },
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              TasksTabView(),
              NotesTabView(),
              RemindersTabView(),
              MessagesTabView(),
            ],
          ),
        ),
      ),
    );
  }
}


