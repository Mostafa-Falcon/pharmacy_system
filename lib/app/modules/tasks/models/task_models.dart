class TaskModel {
  String id;
  String branchId;
  String title;
  String? description;
  String priority; // low, medium, high, urgent
  String status; // pending, inProgress, completed, cancelled
  String? assignedTo;
  String? assignedName;
  DateTime? dueDate;
  DateTime? completedAt;
  DateTime createdAt;
  DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.branchId,
    required this.title,
    this.description,
    this.priority = 'medium',
    this.status = 'pending',
    this.assignedTo,
    this.assignedName,
    this.dueDate,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'branch_id': branchId, 'title': title,
    'description': description, 'priority': priority, 'status': status,
    'assigned_to': assignedTo, 'assigned_name': assignedName,
    'due_date': dueDate?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as String, branchId: json['branch_id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    priority: json['priority'] as String? ?? 'medium',
    status: json['status'] as String? ?? 'pending',
    assignedTo: json['assigned_to'] as String?,
    assignedName: json['assigned_name'] as String?,
    dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date'] as String) : null,
    completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'] as String) : null,
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now(),
  );

  TaskModel copyWith({String? id, String? title, String? description, String? priority, String? status, String? assignedTo, String? assignedName, DateTime? dueDate, DateTime? completedAt}) => TaskModel(
    id: id ?? this.id, branchId: branchId, title: title ?? this.title,
    description: description ?? this.description, priority: priority ?? this.priority,
    status: status ?? this.status, assignedTo: assignedTo ?? this.assignedTo,
    assignedName: assignedName ?? this.assignedName, dueDate: dueDate ?? this.dueDate,
    completedAt: completedAt ?? this.completedAt, createdAt: createdAt, updatedAt: DateTime.now(),
  );
}

class NoteModel {
  String id;
  String branchId;
  String title;
  String content;
  bool pinned;
  String? color;
  DateTime createdAt;
  DateTime updatedAt;

  NoteModel({required this.id, required this.branchId, required this.title, required this.content, this.pinned = false, this.color, required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toJson() => {
    'id': id, 'branch_id': branchId, 'title': title, 'content': content,
    'pinned': pinned, 'color': color, 'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] as String, branchId: json['branch_id'] as String,
    title: json['title'] as String, content: json['content'] as String,
    pinned: json['pinned'] as bool? ?? false, color: json['color'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now(),
  );

  NoteModel copyWith({String? title, String? content, bool? pinned, String? color}) => NoteModel(
    id: id, branchId: branchId, title: title ?? this.title,
    content: content ?? this.content, pinned: pinned ?? this.pinned,
    color: color ?? this.color, createdAt: createdAt, updatedAt: DateTime.now(),
  );
}

class ReminderModel {
  String id;
  String branchId;
  String title;
  String message;
  DateTime remindAt;
  String repeat; // none, daily, weekly, monthly
  bool dismissed;
  DateTime? lastTriggered;
  DateTime createdAt;

  ReminderModel({required this.id, required this.branchId, required this.title, required this.message, required this.remindAt, this.repeat = 'none', this.dismissed = false, this.lastTriggered, required this.createdAt});
}

class MessageModel {
  String id;
  String branchId;
  String fromUserId;
  String fromName;
  String toUserId;
  String toName;
  String subject;
  String body;
  String priority; // normal, high
  DateTime? readAt;
  DateTime createdAt;

  MessageModel({required this.id, required this.branchId, required this.fromUserId, required this.fromName, required this.toUserId, required this.toName, required this.subject, required this.body, this.priority = 'normal', this.readAt, required this.createdAt});
}
