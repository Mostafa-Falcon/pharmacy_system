import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';

class TasksState extends Equatable {
  final bool isLoading;
  final int selectedTab;
  final String searchQuery;
  final String tasksFilterStatus;
  final String tasksFilterPriority;
  final List<TaskModel> tasks;
  final List<NoteModel> notes;
  final List<ReminderModel> reminders;
  final List<MessageModel> messages;

  const TasksState({
    this.isLoading = false,
    this.selectedTab = 0,
    this.searchQuery = '',
    this.tasksFilterStatus = '',
    this.tasksFilterPriority = '',
    this.tasks = const [],
    this.notes = const [],
    this.reminders = const [],
    this.messages = const [],
  });

  TasksState copyWith({
    bool? isLoading,
    int? selectedTab,
    String? searchQuery,
    String? tasksFilterStatus,
    String? tasksFilterPriority,
    List<TaskModel>? tasks,
    List<NoteModel>? notes,
    List<ReminderModel>? reminders,
    List<MessageModel>? messages,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      tasksFilterStatus: tasksFilterStatus ?? this.tasksFilterStatus,
      tasksFilterPriority: tasksFilterPriority ?? this.tasksFilterPriority,
      tasks: tasks ?? this.tasks,
      notes: notes ?? this.notes,
      reminders: reminders ?? this.reminders,
      messages: messages ?? this.messages,
    );
  }

  String? get tasksFilterStatusOrNull =>
      tasksFilterStatus.isEmpty ? null : tasksFilterStatus;
  String? get tasksFilterPriorityOrNull =>
      tasksFilterPriority.isEmpty ? null : tasksFilterPriority;

  Map<String, int> get taskStats {
    final all = tasks;
    return {
      'total': all.length,
      'pending': all.where((t) => t.status == 'pending').length,
      'inProgress': all.where((t) => t.status == 'inProgress').length,
      'completed': all.where((t) => t.status == 'completed').length,
      'overdue': all
          .where(
            (t) =>
                t.dueDate != null &&
                t.dueDate!.isBefore(DateTime.now()) &&
                t.status != 'completed',
          )
          .length,
    };
  }

  @override
  List<Object?> get props => [
    isLoading,
    selectedTab,
    searchQuery,
    tasksFilterStatus,
    tasksFilterPriority,
    tasks,
    notes,
    reminders,
    messages,
  ];
}



