/// 📊 موديل الباركود المنفصل الخاص بالدواء/الصنف (Medicine Barcode Model)
class MedicineBarcodeModel {
  // 🆔 المعرف الفريد لرقم الباركود (Primary Key)
  final String id;

  // 💊 معرف الدواء/الصنف المرتبط
  final String medicineId;

  // 🏷️ رقم أو نص الباركود الممسوح (مثال: 622300012345)
  final String barcode;

  // ⭐ هل هو الباركود الرئيسي المعتمد للصنف؟
  final bool isPrimary;

  // 📝 وصف أو ملاحظة الباركود (مثال: باركود مصنع، باركود علبة بديلة)
  final String? description;

  // 🕒 تاريخ ووقت إضافة الباركود
  final DateTime createdAt;

  MedicineBarcodeModel({
    required this.id,
    required this.medicineId,
    required this.barcode,
    this.isPrimary = false,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  MedicineBarcodeModel copyWith({
    String? id,
    String? medicineId,
    String? barcode,
    bool? isPrimary,
    String? description,
    DateTime? createdAt,
  }) {
    return MedicineBarcodeModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      barcode: barcode ?? this.barcode,
      isPrimary: isPrimary ?? this.isPrimary,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'barcode': barcode,
    'is_primary': isPrimary,
    'description': description,
    'created_at': createdAt.toIso8601String(),
  };

  factory MedicineBarcodeModel.fromJson(Map<String, dynamic> json) => MedicineBarcodeModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String? ?? '',
    barcode: json['barcode'] as String? ?? '',
    isPrimary: json['is_primary'] as bool? ?? false,
    description: json['description'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
  );
}


