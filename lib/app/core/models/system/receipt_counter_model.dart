class ReceiptCounterModel {
  final String id;
  final String counterType;
  final int lastNumber;
  final String prefix;
  final String branchId;
  final DateTime lastModified;
  final int syncVersion;
  final bool isDeleted;

  ReceiptCounterModel({
    required this.id,
    required this.counterType,
    this.lastNumber = 0,
    this.prefix = '',
    required this.branchId,
    DateTime? lastModified,
    this.syncVersion = 1,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  ReceiptCounterModel copyWith({
    String? id,
    String? counterType,
    int? lastNumber,
    String? prefix,
    String? branchId,
    DateTime? lastModified,
    int? syncVersion,
    bool? isDeleted,
  }) =>
      ReceiptCounterModel(
        id: id ?? this.id,
        counterType: counterType ?? this.counterType,
        lastNumber: lastNumber ?? this.lastNumber,
        prefix: prefix ?? this.prefix,
        branchId: branchId ?? this.branchId,
        lastModified: lastModified ?? this.lastModified,
        syncVersion: syncVersion ?? this.syncVersion,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'counter_type': counterType,
    'last_number': lastNumber,
    'prefix': prefix,
    'branch_id': branchId,
    'last_modified': lastModified.toIso8601String(),
    'sync_version': syncVersion,
    'is_deleted': isDeleted,
  };

  factory ReceiptCounterModel.fromJson(Map<String, dynamic> json) => ReceiptCounterModel(
    id: json['id'] as String,
    counterType: json['counter_type'] as String,
    lastNumber: (json['last_number'] as num?)?.toInt() ?? 0,
    prefix: json['prefix'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}