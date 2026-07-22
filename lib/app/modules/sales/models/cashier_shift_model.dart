enum CashierShiftStatus { open, closed }

class CashierShiftModel {
  String id;
  String branchId;
  int shiftNumber;
  String cashierId;
  String cashierName;
  String deviceId;
  DateTime openedAt;
  double openingCash;
  CashierShiftStatus status;
  DateTime? closedAt;
  double? expectedCash;
  double? countedCash;
  double? difference;
  String? notes;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  CashierShiftModel({
    required this.id,
    required this.branchId,
    required this.shiftNumber,
    required this.cashierId,
    required this.cashierName,
    required this.deviceId,
    required this.openedAt,
    this.openingCash = 0,
    this.status = CashierShiftStatus.open,
    this.closedAt,
    this.expectedCash,
    this.countedCash,
    this.difference,
    this.notes,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CashierShiftModel copyWith({
    String? id,
    String? branchId,
    int? shiftNumber,
    String? cashierId,
    String? cashierName,
    String? deviceId,
    DateTime? openedAt,
    double? openingCash,
    CashierShiftStatus? status,
    DateTime? closedAt,
    double? expectedCash,
    double? countedCash,
    double? difference,
    String? notes,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CashierShiftModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      shiftNumber: shiftNumber ?? this.shiftNumber,
      cashierId: cashierId ?? this.cashierId,
      cashierName: cashierName ?? this.cashierName,
      deviceId: deviceId ?? this.deviceId,
      openedAt: openedAt ?? this.openedAt,
      openingCash: openingCash ?? this.openingCash,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      expectedCash: expectedCash ?? this.expectedCash,
      countedCash: countedCash ?? this.countedCash,
      difference: difference ?? this.difference,
      notes: notes ?? this.notes,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'shift_number': shiftNumber,
    'cashier_id': cashierId,
    'cashier_name': cashierName,
    'device_id': deviceId,
    'opened_at': openedAt.toIso8601String(),
    'opening_cash': openingCash,
    'status': status.name,
    'closed_at': closedAt?.toIso8601String(),
    'expected_cash': expectedCash,
    'counted_cash': countedCash,
    'difference': difference,
    'notes': notes,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CashierShiftModel.fromJson(Map<String, dynamic> json) =>
      CashierShiftModel(
        id: json['id'] as String,
        branchId: json['branch_id'] as String,
        shiftNumber: json['shift_number'] as int? ?? 1,
        cashierId: json['cashier_id'] as String,
        cashierName: json['cashier_name'] as String? ?? '',
        deviceId: json['device_id'] as String? ?? '',
        openedAt:
            DateTime.tryParse(json['opened_at'] as String) ?? DateTime.now(),
        openingCash: (json['opening_cash'] as num?)?.toDouble() ?? 0,
        status: CashierShiftStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => CashierShiftStatus.open,
        ),
        closedAt: json['closed_at'] != null
            ? DateTime.tryParse(json['closed_at'] as String)
            : null,
        expectedCash: (json['expected_cash'] as num?)?.toDouble(),
        countedCash: (json['counted_cash'] as num?)?.toDouble(),
        difference: (json['difference'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        syncVersion: json['sync_version'] as int? ?? 1,
        lastModified: json['last_modified'] != null
            ? DateTime.tryParse(json['last_modified'] as String) ??
                DateTime.now()
            : DateTime.now(),
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
}
