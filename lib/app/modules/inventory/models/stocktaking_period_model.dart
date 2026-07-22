import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class StocktakingPeriodModel {
  String id;
  String branchId;
  String name;
  String status; // open, inProgress, closed, cancelled
  int totalItems;
  int countedItems;
  double totalDifference;
  DateTime startedAt;
  DateTime? closedAt;
  String? notes;
  String createdBy;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  StocktakingPeriodModel({
    required this.id,
    required this.branchId,
    required this.name,
    this.status = 'open',
    this.totalItems = 0,
    this.countedItems = 0,
    this.totalDifference = 0,
    required this.startedAt,
    this.closedAt,
    this.notes,
    required this.createdBy,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  bool get isOpen => status == 'open';
  bool get isInProgress => status == 'inProgress';
  bool get isClosed => status == 'closed';
  bool get isCancelled => status == 'cancelled';

  Map<String, dynamic> toJson() => {
    'id': id, 'branch_id': branchId, 'name': name, 'status': status,
    'total_items': totalItems, 'counted_items': countedItems,
    'total_difference': totalDifference,
    'started_at': startedAt.toIso8601String(),
    'closed_at': closedAt?.toIso8601String(),
    'notes': notes, 'created_by': createdBy,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory StocktakingPeriodModel.fromJson(Map<String, dynamic> json) => StocktakingPeriodModel(
    id: json['id'] as String, branchId: json['branch_id'] as String,
    name: json['name'] as String, status: json['status'] as String? ?? 'open',
    totalItems: json['total_items'] as int? ?? 0,
    countedItems: json['counted_items'] as int? ?? 0,
    totalDifference: (json['total_difference'] as num?)?.toDouble() ?? 0,
    startedAt: DateTime.tryParse(json['started_at'] as String) ?? DateTime.now(),
    closedAt: json['closed_at'] != null ? DateTime.tryParse(json['closed_at'] as String) : null,
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as String,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}

class StocktakingCountModel {
  String id;
  String periodId;
  String itemId;
  String itemName;
  String? sku;
  String unit;
  int systemQuantity;
  int actualQuantity;
  int difference;
  double buyPrice;
  double differenceValue;
  String? notes;
  DateTime countedAt;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  StocktakingCountModel({
    required this.id,
    required this.periodId,
    required this.itemId,
    required this.itemName,
    this.sku,
    this.unit = AppStrings.unit,
    required this.systemQuantity,
    required this.actualQuantity,
    int? difference,
    this.buyPrice = 0,
    double? differenceValue,
    this.notes,
    DateTime? countedAt,
    required this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  })  : difference = difference ?? (actualQuantity - systemQuantity),
        differenceValue = differenceValue ?? ((actualQuantity - systemQuantity) * buyPrice),
        countedAt = countedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id, 'period_id': periodId, 'item_id': itemId, 'item_name': itemName,
    'sku': sku, 'unit': unit, 'system_quantity': systemQuantity,
    'actual_quantity': actualQuantity, 'difference': difference,
    'buy_price': buyPrice, 'difference_value': differenceValue,
    'notes': notes, 'counted_at': countedAt.toIso8601String(),
    'created_by': createdBy, 'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory StocktakingCountModel.fromJson(Map<String, dynamic> json) => StocktakingCountModel(
    id: json['id'] as String, periodId: json['period_id'] as String,
    itemId: json['item_id'] as String, itemName: json['item_name'] as String,
    sku: json['sku'] as String?, unit: json['unit'] as String? ?? AppStrings.unit,
    systemQuantity: json['system_quantity'] as int? ?? 0,
    actualQuantity: json['actual_quantity'] as int? ?? 0,
    difference: json['difference'] as int?,
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0,
    differenceValue: (json['difference_value'] as num?)?.toDouble(),
    notes: json['notes'] as String?,
    countedAt: json['counted_at'] != null ? DateTime.tryParse(json['counted_at'] as String) : null,
    createdBy: json['created_by'] as String,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now() : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
