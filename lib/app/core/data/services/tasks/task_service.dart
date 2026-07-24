import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/tasks/models/task_models.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/task_daos.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  static TaskService get to => GetIt.instance<TaskService>();

  static TasksDao get _tasksDao => sl<TasksDao>();
  static NotesDao get _notesDao => sl<NotesDao>();
  static RemindersDao get _remindersDao => sl<RemindersDao>();
  static MessagesDao get _messagesDao => sl<MessagesDao>();

  Future<void> init() async {}

  String get _branchId => AuthService.currentBranchId ?? '';

  // --- Helpers ---

  static TaskModel _toTask(TasksTableData d) => TaskModel(
    id: d.id,
    branchId: d.branchId,
    title: d.title,
    description: d.description,
    priority: d.priority,
    status: d.status,
    assignedTo: d.assignedTo,
    assignedName: d.assignedName,
    dueDate: d.dueDate,
    completedAt: d.completedAt,
    createdAt: d.createdAt,
    updatedAt: d.updatedAt,
  );

  static TasksTableCompanion _toTaskCompanion(TaskModel m) => TasksTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    title: Value(m.title),
    description: Value(m.description),
    priority: Value(m.priority),
    status: Value(m.status),
    assignedTo: Value(m.assignedTo),
    assignedName: Value(m.assignedName),
    dueDate: Value(m.dueDate),
    completedAt: Value(m.completedAt),
    createdAt: Value(m.createdAt),
    updatedAt: Value(m.updatedAt),
    syncVersion: const Value(0),
    lastModified: Value(DateTime.now()),
    isDeleted: const Value(false),
  );

  static NoteModel _toNote(NotesTableData d) => NoteModel(
    id: d.id,
    branchId: d.branchId,
    title: d.title,
    content: d.content,
    pinned: d.pinned,
    color: d.color,
    createdAt: d.createdAt,
    updatedAt: d.updatedAt,
  );

  static NotesTableCompanion _toNoteCompanion(NoteModel m) => NotesTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    title: Value(m.title),
    content: Value(m.content),
    pinned: Value(m.pinned),
    color: Value(m.color),
    createdAt: Value(m.createdAt),
    updatedAt: Value(m.updatedAt),
    syncVersion: const Value(0),
    lastModified: Value(DateTime.now()),
    isDeleted: const Value(false),
  );

  static ReminderModel _toReminder(RemindersTableData d) => ReminderModel(
    id: d.id,
    branchId: d.branchId,
    title: d.title,
    message: d.message,
    remindAt: d.remindAt,
    repeat: d.repeat,
    dismissed: d.dismissed,
    lastTriggered: d.lastTriggered,
    createdAt: d.createdAt,
  );

  static RemindersTableCompanion _toReminderCompanion(ReminderModel m) => RemindersTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    title: Value(m.title),
    message: Value(m.message),
    remindAt: Value(m.remindAt),
    repeat: Value(m.repeat),
    dismissed: Value(m.dismissed),
    lastTriggered: Value(m.lastTriggered),
    createdAt: Value(m.createdAt),
    syncVersion: const Value(0),
    lastModified: Value(DateTime.now()),
    isDeleted: const Value(false),
  );

  static MessageModel _toMessage(MessagesTableData d) => MessageModel(
    id: d.id,
    branchId: d.branchId,
    fromUserId: d.fromUserId,
    fromName: d.fromName,
    toUserId: d.toUserId,
    toName: d.toName,
    subject: d.subject,
    body: d.body,
    priority: d.priority,
    readAt: d.readAt,
    createdAt: d.createdAt,
  );

  static MessagesTableCompanion _toMessageCompanion(MessageModel m) => MessagesTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    fromUserId: Value(m.fromUserId),
    fromName: Value(m.fromName),
    toUserId: Value(m.toUserId),
    toName: Value(m.toName),
    subject: Value(m.subject),
    body: Value(m.body),
    priority: Value(m.priority),
    readAt: Value(m.readAt),
    createdAt: Value(m.createdAt),
    syncVersion: const Value(0),
    lastModified: Value(DateTime.now()),
    isDeleted: const Value(false),
  );

  // --- Tasks ---

  Future<List<TaskModel>> getTasks({
    String? status,
    String? priority,
    String? assignedTo,
  }) async {
    final items = await _tasksDao.getByBranch(_branchId);
    var tasks = items.map(_toTask).toList();
    if (status != null) tasks = tasks.where((t) => t.status == status).toList();
    if (priority != null) tasks = tasks.where((t) => t.priority == priority).toList();
    if (assignedTo != null) tasks = tasks.where((t) => t.assignedTo == assignedTo).toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  Future<TaskModel> createTask({
    required String title,
    String? description,
    String priority = 'medium',
    String? assignedTo,
    String? assignedName,
    DateTime? dueDate,
  }) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      title: title,
      description: description,
      priority: priority,
      assignedTo: assignedTo,
      assignedName: assignedName,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _tasksDao.upsert(_toTaskCompanion(task));
    return task;
  }

  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
    String? priority,
    String? status,
    String? assignedTo,
    String? assignedName,
    DateTime? dueDate,
    DateTime? completedAt,
  }) async {
    final existing = await _tasksDao.getById(id);
    if (existing == null) return;
    final task = _toTask(existing);
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (priority != null) task.priority = priority;
    if (status != null) task.status = status;
    if (assignedTo != null) task.assignedTo = assignedTo;
    if (assignedName != null) task.assignedName = assignedName;
    if (dueDate != null) task.dueDate = dueDate;
    task.updatedAt = DateTime.now();
    if (status == 'completed') task.completedAt = DateTime.now();
    task.completedAt = completedAt;
    await _tasksDao.upsert(_toTaskCompanion(task));
  }

  Future<void> deleteTask(String id) async {
    await _tasksDao.softDelete(id);
  }

  Future<void> completeTask(String id) async =>
      updateTask(id, status: 'completed');

  Future<void> reopenTask(String id) async =>
      updateTask(id, status: 'pending', completedAt: null);

  // --- Notes ---

  Future<List<NoteModel>> getNotes() async {
    final items = await _notesDao.getByBranch(_branchId);
    var notes = items.map(_toNote).toList();
    notes.sort((a, b) {
      if (a.pinned && !b.pinned) return -1;
      if (!a.pinned && b.pinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return notes;
  }

  Future<NoteModel> createNote({
    required String title,
    required String content,
    bool pinned = false,
    String? color,
  }) async {
    final note = NoteModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      title: title,
      content: content,
      pinned: pinned,
      color: color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _notesDao.upsert(_toNoteCompanion(note));
    return note;
  }

  Future<void> updateNote(
    String id, {
    String? title,
    String? content,
    bool? pinned,
    String? color,
  }) async {
    final existing = await _notesDao.getById(id);
    if (existing == null) return;
    final note = _toNote(existing);
    if (title != null) note.title = title;
    if (content != null) note.content = content;
    if (pinned != null) note.pinned = pinned;
    if (color != null) note.color = color;
    note.updatedAt = DateTime.now();
    await _notesDao.upsert(_toNoteCompanion(note));
  }

  Future<void> deleteNote(String id) async {
    await _notesDao.softDelete(id);
  }

  Future<void> togglePinNote(String id) async {
    final existing = await _notesDao.getById(id);
    if (existing == null) return;
    final note = _toNote(existing);
    note.pinned = !note.pinned;
    await _notesDao.upsert(_toNoteCompanion(note));
  }

  // --- Reminders ---

  Future<List<ReminderModel>> getReminders({bool? dismissed}) async {
    final items = await _remindersDao.getByBranch(_branchId);
    var reminders = items.map(_toReminder).toList();
    if (dismissed != null) {
      reminders = reminders.where((r) => r.dismissed == dismissed).toList();
    }
    reminders.sort((a, b) => a.remindAt.compareTo(b.remindAt));
    return reminders;
  }

  Future<ReminderModel> createReminder({
    required String title,
    required String message,
    required DateTime remindAt,
    String repeat = 'none',
  }) async {
    final reminder = ReminderModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      title: title,
      message: message,
      remindAt: remindAt,
      repeat: repeat,
      createdAt: DateTime.now(),
    );
    await _remindersDao.upsert(_toReminderCompanion(reminder));
    return reminder;
  }

  Future<void> dismissReminder(String id) async {
    final existing = await _remindersDao.getById(id);
    if (existing == null) return;
    final reminder = _toReminder(existing);
    reminder.dismissed = true;
    await _remindersDao.upsert(_toReminderCompanion(reminder));
  }

  Future<void> deleteReminder(String id) async {
    await _remindersDao.softDelete(id);
  }

  // --- Messages ---

  Future<List<MessageModel>> getMessages({String? userId}) async {
    final items = await _messagesDao.getByBranch(_branchId);
    var messages = items.map(_toMessage).toList();
    if (userId != null) {
      messages = messages
          .where((m) => m.toUserId == userId || m.fromUserId == userId)
          .toList();
    }
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages;
  }

  Future<MessageModel> sendMessage({
    required String toUserId,
    required String toName,
    required String subject,
    required String body,
    String priority = 'normal',
  }) async {
    final user = AuthService.currentUser;
    final msg = MessageModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      fromUserId: user?.id ?? '',
      fromName: user?.name ?? '',
      toUserId: toUserId,
      toName: toName,
      subject: subject,
      body: body,
      priority: priority,
      createdAt: DateTime.now(),
    );
    await _messagesDao.upsert(_toMessageCompanion(msg));
    return msg;
  }

  Future<void> markMessageRead(String id) async {
    final existing = await _messagesDao.getById(id);
    if (existing == null) return;
    final msg = _toMessage(existing);
    msg.readAt = DateTime.now();
    await _messagesDao.upsert(_toMessageCompanion(msg));
  }

  Future<void> deleteMessage(String id) async {
    await _messagesDao.softDelete(id);
  }

  Future<int> get unreadCount async {
    final items = await _messagesDao.getByBranch(_branchId);
    return items.where((m) => m.readAt == null).length;
  }
}



