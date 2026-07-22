enum CrmLeadStatus { newLead, contacted, interested, converted, notInterested }

class CrmLeadModel {
  String id;
  String branchId;
  String name;
  String? phone;
  String? email;
  CrmLeadStatus status;
  String? source;
  String? notes;
  String? assignedTo;
  DateTime createdAt;
  DateTime? nextFollowUp;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  CrmLeadModel({
    required this.id,
    required this.branchId,
    required this.name,
    this.phone,
    this.email,
    this.status = CrmLeadStatus.newLead,
    this.source,
    this.notes,
    this.assignedTo,
    required this.createdAt,
    this.nextFollowUp,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CrmLeadModel copyWith({
    String? id,
    String? branchId,
    String? name,
    String? phone,
    String? email,
    CrmLeadStatus? status,
    String? source,
    String? notes,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? nextFollowUp,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CrmLeadModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      nextFollowUp: nextFollowUp ?? this.nextFollowUp,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'name': name,
    'phone': phone,
    'email': email,
    'status': status.name,
    'source': source,
    'notes': notes,
    'assigned_to': assignedTo,
    'created_at': createdAt.toIso8601String(),
    'next_follow_up': nextFollowUp?.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CrmLeadModel.fromJson(Map<String, dynamic> json) => CrmLeadModel(
    id: json['id'] as String,
    branchId: json['branch_id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    status: CrmLeadStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => CrmLeadStatus.newLead,
    ),
    source: json['source'] as String?,
    notes: json['notes'] as String?,
    assignedTo: json['assigned_to'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    nextFollowUp: json['next_follow_up'] != null
        ? DateTime.tryParse(json['next_follow_up'] as String)
        : null,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}

class CrmFollowUpModel {
  String id;
  String leadId;
  String branchId;
  DateTime followUpDate;
  String notes;
  String createdBy;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  CrmFollowUpModel({
    required this.id,
    required this.leadId,
    required this.branchId,
    required this.followUpDate,
    required this.notes,
    required this.createdBy,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CrmFollowUpModel copyWith({
    String? id,
    String? leadId,
    String? branchId,
    DateTime? followUpDate,
    String? notes,
    String? createdBy,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CrmFollowUpModel(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      branchId: branchId ?? this.branchId,
      followUpDate: followUpDate ?? this.followUpDate,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'branch_id': branchId,
    'follow_up_date': followUpDate.toIso8601String(),
    'notes': notes,
    'created_by': createdBy,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CrmFollowUpModel.fromJson(Map<String, dynamic> json) => CrmFollowUpModel(
    id: json['id'] as String,
    leadId: json['lead_id'] as String,
    branchId: json['branch_id'] as String,
    followUpDate:
        DateTime.tryParse(json['follow_up_date'] as String) ?? DateTime.now(),
    notes: json['notes'] as String? ?? '',
    createdBy: json['created_by'] as String,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
