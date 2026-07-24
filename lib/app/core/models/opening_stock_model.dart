class OpeningStockModel {
  String id;
  String medicineId;
  String medicineName;
  int quantity;
  double buyPrice;
  String branchId;
  String recordedBy;
  DateTime recordedAt;
  DateTime lastModified;

  OpeningStockModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.buyPrice,
    required this.branchId,
    required this.recordedBy,
    DateTime? recordedAt,
    DateTime? lastModified,
  })  : recordedAt = recordedAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  OpeningStockModel copyWith({
    String? id,
    String? medicineId,
    String? medicineName,
    int? quantity,
    double? buyPrice,
    String? branchId,
    String? recordedBy,
    DateTime? recordedAt,
    DateTime? lastModified,
  }) {
    return OpeningStockModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      quantity: quantity ?? this.quantity,
      buyPrice: buyPrice ?? this.buyPrice,
      branchId: branchId ?? this.branchId,
      recordedBy: recordedBy ?? this.recordedBy,
      recordedAt: recordedAt ?? this.recordedAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'quantity': quantity,
    'buy_price': buyPrice,
    'branch_id': branchId,
    'recorded_by': recordedBy,
    'recorded_at': recordedAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
  };

  factory OpeningStockModel.fromJson(Map<String, dynamic> json) => OpeningStockModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0,
    branchId: json['branch_id'] as String? ?? '',
    recordedBy: json['recorded_by'] as String? ?? '',
    recordedAt: json['recorded_at'] != null ? DateTime.tryParse(json['recorded_at'] as String) ?? DateTime.now() : DateTime.now(),
    lastModified: json['last_modified'] != null ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now() : DateTime.now(),
  );
}
