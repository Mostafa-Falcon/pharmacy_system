/// 📦 موديل رصيد أول المدة (سجل إدخال الكميات الابتدائية عند التأسيس)
class OpeningStockModel {
  // 🆔 معرف سجل رصيد أول المدة
  final String id;

  // 💊 معرف الدواء/الصنف المرتبط
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف
  final String medicineName;

  // 📦 كمية رصيد أول المدة من العبوة الرئيسية (العلبة - unit1)
  final int unit1Quantity;

  // 📦 كمية رصيد أول المدة من الوحدة الفرعية 1 (الشريط - unit2)
  final int? unit2Quantity;

  // 📦 كمية رصيد أول المدة من الوحدة الفرعية 2 (القرص - unit3)
  final int? unit3Quantity;

  // 💵 سعر الشراء/التكلفة للعبوة الرئيسية
  final double buyPrice;

  // 🏬 معرف الفرع التابع له الرصيد
  final String branchId;

  // 👤 اسم/معرف الكاشير أو الصيدلي الذي سجل رصيد أول المدة
  final String recordedBy;

  // 📅 تاريخ ووقت تسجيل رصيد أول المدة
  final DateTime recordedAt;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  OpeningStockModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.unit1Quantity,
    this.unit2Quantity,
    this.unit3Quantity,
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
    int? unit1Quantity,
    int? unit2Quantity,
    int? unit3Quantity,
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
      unit1Quantity: unit1Quantity ?? this.unit1Quantity,
      unit2Quantity: unit2Quantity ?? this.unit2Quantity,
      unit3Quantity: unit3Quantity ?? this.unit3Quantity,
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
    'unit_1_quantity': unit1Quantity,
    'unit_2_quantity': unit2Quantity,
    'unit_3_quantity': unit3Quantity,
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
    unit1Quantity: (json['unit_1_quantity'] as num?)?.toInt() ?? (json['quantity'] as num?)?.toInt() ?? 0,
    unit2Quantity: (json['unit_2_quantity'] as num?)?.toInt(),
    unit3Quantity: (json['unit_3_quantity'] as num?)?.toInt(),
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0,
    branchId: json['branch_id'] as String? ?? '',
    recordedBy: json['recorded_by'] as String? ?? '',
    recordedAt: json['recorded_at'] != null ? DateTime.tryParse(json['recorded_at'] as String) ?? DateTime.now() : DateTime.now(),
    lastModified: json['last_modified'] != null ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now() : DateTime.now(),
  );
}


