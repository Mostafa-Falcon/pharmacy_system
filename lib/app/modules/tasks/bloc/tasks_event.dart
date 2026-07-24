import 'package:equatable/equatable.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TasksEvent {}

class FilterTasks extends TasksEvent {
  final String? status;
  final String? priority;
  const FilterTasks({this.status, this.priority});

  @override
  List<Object?> get props => [status, priority];
}

class AddTask extends TasksEvent {
  final String title;
  final String? description;
  final String priority;
  final String? assignedTo;
  final String? assignedName;
  final DateTime? dueDate;
  const AddTask({
    required this.title,
    this.description,
    this.priority = 'medium',
    this.assignedTo,
    this.assignedName,
    this.dueDate,
  });
}

class CompleteTask extends TasksEvent {
  final String id;
  const CompleteTask(this.id);
}

class ReopenTask extends TasksEvent {
  final String id;
  const ReopenTask(this.id);
}

class UpdateTask extends TasksEvent {
  final String id;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final String? assignedTo;
  final String? assignedName;
  final DateTime? dueDate;
  const UpdateTask({
    required this.id,
    this.title,
    this.description,
    this.priority,
    this.status,
    this.assignedTo,
    this.assignedName,
    this.dueDate,
  });
}

class DeleteTask extends TasksEvent {
  final String id;
  const DeleteTask(this.id);
}

class AddNote extends TasksEvent {
  final String title;
  final String content;
  final bool pinned;
  final String? color;
  const AddNote({
    required this.title,
    required this.content,
    this.pinned = false,
    this.color,
  });
}

class UpdateNote extends TasksEvent {
  final String id;
  final String? title;
  final String? content;
  final bool? pinned;
  final String? color;
  const UpdateNote({
    required this.id,
    this.title,
    this.content,
    this.pinned,
    this.color,
  });
}

class DeleteNote extends TasksEvent {
  final String id;
  const DeleteNote(this.id);
}

class TogglePinNote extends TasksEvent {
  final String id;
  const TogglePinNote(this.id);
}

class AddReminder extends TasksEvent {
  final String title;
  final String message;
  final DateTime remindAt;
  final String? repeat;
  const AddReminder({
    required this.title,
    required this.message,
    required this.remindAt,
    this.repeat,
  });
}

class DismissReminder extends TasksEvent {
  final String id;
  const DismissReminder(this.id);
}

class DeleteReminder extends TasksEvent {
  final String id;
  const DeleteReminder(this.id);
}

class SendMessage extends TasksEvent {
  final String toUserId;
  final String toName;
  final String subject;
  final String body;
  final String priority;
  const SendMessage({
    required this.toUserId,
    required this.toName,
    required this.subject,
    required this.body,
    this.priority = 'normal',
  });
}

class MarkMessageRead extends TasksEvent {
  final String id;
  const MarkMessageRead(this.id);
}

class DeleteMessage extends TasksEvent {
  final String id;
  const DeleteMessage(this.id);
}


