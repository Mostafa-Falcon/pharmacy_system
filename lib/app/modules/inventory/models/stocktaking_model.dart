class StocktakingItemModel {
  String id;
  String stocktakingId;
  String medicineId;
  String medicineName;
  int systemQuantity;
  int countedQuantity;
  int difference;
  String? notes;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  StocktakingItemModel({
    required this.id,
    required this.stocktakingId,
    required this.medicineId,
    required this.medicineName,
    required this.systemQuantity,
    required this.countedQuantity,
    int? difference,
    this.notes,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  })  : difference = difference ?? (countedQuantity - systemQuantity),
        lastModified = lastModified ?? DateTime.now();

  StocktakingItemModel copyWith({
    String? id,
    String? stocktakingId,
    String? medicineId,
    String? medicineName,
    int? systemQuantity,
    int? countedQuantity,
    String? notes,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return StocktakingItemModel(
      id: id ?? this.id,
      stocktakingId: stocktakingId ?? this.stocktakingId,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      systemQuantity: systemQuantity ?? this.systemQuantity,
      countedQuantity: countedQuantity ?? this.countedQuantity,
      notes: notes ?? this.notes,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'stocktaking_id': stocktakingId,
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'system_quantity': systemQuantity,
    'counted_quantity': countedQuantity,
    'difference': difference,
    'notes': notes,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory StocktakingItemModel.fromJson(Map<String, dynamic> json) =>
      StocktakingItemModel(
        id: json['id'] as String,
        stocktakingId: json['stocktaking_id'] as String,
        medicineId: json['medicine_id'] as String,
        medicineName: json['medicine_name'] as String,
        systemQuantity: json['system_quantity'] as int? ?? 0,
        countedQuantity: json['counted_quantity'] as int? ?? 0,
        notes: json['notes'] as String?,
        syncVersion: json['sync_version'] as int? ?? 1,
        lastModified: json['last_modified'] != null
            ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
            : DateTime.now(),
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
}

enum StocktakingStatus { draft, confirmed }

class StocktakingModel {
  String id;
  String branchId;
  DateTime startDate;
  DateTime? endDate;
  StocktakingStatus status;
  String? notes;
  String createdBy;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  StocktakingModel({
    required this.id,
    required this.branchId,
    required this.startDate,
    this.endDate,
    this.status = StocktakingStatus.draft,
    this.notes,
    required this.createdBy,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  StocktakingModel copyWith({
    String? id,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    StocktakingStatus? status,
    String? notes,
    String? createdBy,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return StocktakingModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'status': status.name,
    'notes': notes,
    'created_by': createdBy,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory StocktakingModel.fromJson(Map<String, dynamic> json) =>
      StocktakingModel(
        id: json['id'] as String,
        branchId: json['branch_id'] as String,
        startDate:
            DateTime.tryParse(json['start_date'] as String) ?? DateTime.now(),
        endDate: json['end_date'] != null
            ? DateTime.tryParse(json['end_date'] as String)
            : null,
        status: StocktakingStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => StocktakingStatus.draft,
        ),
        notes: json['notes'] as String?,
        createdBy: json['created_by'] as String,
        syncVersion: json['sync_version'] as int? ?? 1,
        lastModified: json['last_modified'] != null
            ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
            : DateTime.now(),
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
}
