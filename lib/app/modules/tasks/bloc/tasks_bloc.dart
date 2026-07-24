import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/tasks/task_service.dart';

import 'tasks_event.dart';
import 'tasks_state.dart';

export 'tasks_event.dart';
export 'tasks_state.dart';

/// Bloc إدارة المهام والملاحظات والتذكيرات والرسائل.
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskService taskService;

  TasksBloc({TaskService? service})
      : taskService = service ?? TaskService.to,
        super(const TasksState()) {
    on<LoadTasks>(_onLoad);
    on<FilterTasks>(_onFilter);
    on<AddTask>(_onAddTask);
    on<CompleteTask>(_onCompleteTask);
    on<ReopenTask>(_onReopenTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<TogglePinNote>(_onTogglePin);
    on<AddReminder>(_onAddReminder);
    on<DismissReminder>(_onDismissReminder);
    on<DeleteReminder>(_onDeleteReminder);
    on<SendMessage>(_onSendMessage);
    on<MarkMessageRead>(_onMarkRead);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoad(LoadTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tasks = await taskService.getTasks(
      status: state.tasksFilterStatusOrNull,
      priority: state.tasksFilterPriorityOrNull,
    );
    emit(state.copyWith(
      tasks: tasks,
      notes: await taskService.getNotes(),
      reminders: await taskService.getReminders(),
      messages: await taskService.getMessages(),
      isLoading: false,
    ));
  }

  Future<void> _onFilter(FilterTasks event, Emitter<TasksState> emit) async {
    final status = event.status ?? state.tasksFilterStatus;
    final priority = event.priority ?? state.tasksFilterPriority;
    emit(state.copyWith(tasksFilterStatus: status, tasksFilterPriority: priority));
    emit(state.copyWith(tasks: await taskService.getTasks(
      status: status.isNotEmpty ? status : null,
      priority: priority.isNotEmpty ? priority : null,
    )));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await taskService.createTask(
      title: event.title,
      description: event.description,
      priority: event.priority,
      assignedTo: event.assignedTo,
      assignedName: event.assignedName,
      dueDate: event.dueDate,
    );
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onCompleteTask(CompleteTask event, Emitter<TasksState> emit) async {
    await taskService.completeTask(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onReopenTask(ReopenTask event, Emitter<TasksState> emit) async {
    await taskService.reopenTask(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    await taskService.updateTask(
      event.id,
      title: event.title,
      description: event.description,
      priority: event.priority,
      status: event.status,
      assignedTo: event.assignedTo,
      assignedName: event.assignedName,
      dueDate: event.dueDate,
    );
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await taskService.deleteTask(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onAddNote(AddNote event, Emitter<TasksState> emit) async {
    await taskService.createNote(title: event.title, content: event.content, pinned: event.pinned, color: event.color);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<TasksState> emit) async {
    await taskService.updateNote(event.id, title: event.title, content: event.content, pinned: event.pinned, color: event.color);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<TasksState> emit) async {
    await taskService.deleteNote(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onTogglePin(TogglePinNote event, Emitter<TasksState> emit) async {
    await taskService.togglePinNote(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onAddReminder(AddReminder event, Emitter<TasksState> emit) async {
    await taskService.createReminder(title: event.title, message: event.message, remindAt: event.remindAt, repeat: event.repeat ?? 'none');
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onDismissReminder(DismissReminder event, Emitter<TasksState> emit) async {
    await taskService.dismissReminder(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onDeleteReminder(DeleteReminder event, Emitter<TasksState> emit) async {
    await taskService.deleteReminder(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<TasksState> emit) async {
    await taskService.sendMessage(
      toUserId: event.toUserId,
      toName: event.toName,
      subject: event.subject,
      body: event.body,
      priority: event.priority,
    );
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onMarkRead(MarkMessageRead event, Emitter<TasksState> emit) async {
    await taskService.markMessageRead(event.id);
    if (!isClosed) add(LoadTasks());
  }

  Future<void> _onDeleteMessage(DeleteMessage event, Emitter<TasksState> emit) async {
    await taskService.deleteMessage(event.id);
    if (!isClosed) add(LoadTasks());
  }
}

