/// 📦 موديل تشغيلة الصنف وتاريخ الصلاحية (Item Batch & Expiry Date Model)
class ItemBatchModel {
  // 🆔 المعرف الفريد لتشغيلة الصنف (Primary Key)
  final String id;

  // 💊 معرف الدواء/الصنف المرتبط
  final String medicineId;

  // 🏷️ رقم التشغيلة/الطبخة المسجلة على العبوة (Batch Number)
  final String? batchNumber;

  // ⏳ تاريخ ووقت انتهاء الصلاحية المكتوبة على التشغيلة
  final DateTime? expiryDate;

  // 📦 الكمية الكلية المتاحة في هذه التشغيلة
  final int quantity;

  // 📦 الكمية التالفة/المتضررة في هذه التشغيلة
  final int damagedQuantity;

  // 💵 سعر شراء العلبة في هذه التشغيلة
  final double? purchasePrice;

  // 🟢 حالة تفعيل التشغيلة للصرف
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت إنشاء التشغيلة
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ItemBatchModel({
    required this.id,
    required this.medicineId,
    this.batchNumber,
    this.expiryDate,
    this.quantity = 0,
    this.damagedQuantity = 0,
    this.purchasePrice,
    this.isActive = true,
    this.accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  // 🧮 الكمية المتبقية السليمة (الكلية - التالفة)
  int get remainingQuantity {
    final remaining = quantity - damagedQuantity;
    return remaining > 0 ? remaining : 0;
  }

  // 🧮 الكمية المتاحة للصرف الفعلي (شرط التفعيل وعدم الانتهاء)
  int get availableQuantity => isActive && !isExpired ? remainingQuantity : 0;

  // ⏳ فحص تلقائي: هل انتهت صلاحية التشغيلة حالياً؟
  bool get isExpired {
    if (expiryDate == null) return false;
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    return expiryDate!.isBefore(currentDate);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'batch_number': batchNumber,
    'expiry_date': expiryDate?.toIso8601String(),
    'quantity': quantity,
    'damaged_quantity': damagedQuantity,
    'purchase_price': purchasePrice,
    'is_active': isActive,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ItemBatchModel.fromJson(Map<String, dynamic> json) => ItemBatchModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    batchNumber: json['batch_number'] as String?,
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    damagedQuantity: (json['damaged_quantity'] as num?)?.toInt() ?? 0,
    purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );

  ItemBatchModel copyWith({
    String? id,
    String? medicineId,
    String? batchNumber,
    DateTime? expiryDate,
    int? quantity,
    int? damagedQuantity,
    double? purchasePrice,
    bool? isActive,
    String? accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return ItemBatchModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      damagedQuantity: damagedQuantity ?? this.damagedQuantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}


