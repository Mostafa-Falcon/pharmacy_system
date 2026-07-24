import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// ⚖️ نوع تسوية المخزون (تالف / عجز جرد / زيادة جرد)
enum AdjustmentType {
  damage,   // هالك / تالف / كسر
  shortage, // عجز في الجرد
  surplus,  // زيادة في الجرد
}

/// 📦 موديل سطر الصنف المتأثر بالتسوية المخزنية
class StockAdjustmentItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف بالعربي
  final String medicineName;

  // 🔢 مستوى الوحدة المتأثرة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المتأثرة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية المتأثرة بالتعديل (الكمية التالفة أم العجز أم الزيادة)
  final int quantity;

  // 💵 سعر التكلفة/الشراء للوحدة المتأثرة
  final double buyPrice;

  // 💰 إجمالي القيمة المالية للتسوية لهذا السطر (الكمية × التكلفة)
  final double totalPrice;

  // 📝 سبب تسوية هذا الصنف بالذات (مثل: تاريخ صلاحية منتهي / زجاجة مكسورة)
  final String? itemReason;

  StockAdjustmentItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.quantity,
    required this.buyPrice,
    required this.totalPrice,
    this.itemReason,
  });

  StockAdjustmentItemModel copyWith({
    String? medicineId,
    String? medicineName,
    int? unitLevel,
    String? unitName,
    int? quantity,
    double? buyPrice,
    double? totalPrice,
    bool clearItemReason = false,
    String? itemReason,
  }) =>
      StockAdjustmentItemModel(
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        unitLevel: unitLevel ?? this.unitLevel,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        buyPrice: buyPrice ?? this.buyPrice,
        totalPrice: totalPrice ?? this.totalPrice,
        itemReason: clearItemReason ? null : (itemReason ?? this.itemReason),
      );

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'buy_price': buyPrice,
    'total_price': totalPrice,
    'item_reason': itemReason,
  };

  factory StockAdjustmentItemModel.fromJson(Map<String, dynamic> json) => StockAdjustmentItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    itemReason: json['item_reason'] as String?,
  );
}

/// Backward Compatibility Type Alias
typedef DamagedStockModel = StockAdjustmentModel;

/// 📋 موديل إذن تسوية وعجز المخزون الموحد (Stock Adjustment Model)
class StockAdjustmentModel implements SyncableEntity {
  // 🆔 المعرف الفريد لإذن التسوية (Primary Key)
  final String id;

  // 🔢 رقم الإذن التسلسلي المرجعي (مثل: ADJ-1004)
  final String adjustmentNumber;

  // ⚖️ نوع التسوية (تالف damage / عجز shortage / زيادة surplus)
  final AdjustmentType adjustmentType;

  // 📦 قائمة الأصناف والمستويات المتأثرة بالتسوية
  final List<StockAdjustmentItemModel> items;

  // 💰 إجمالي القيمة المالية الإجمالية للتسوية
  final double totalAmount;

  // 👤 معرف اسم الصيدلي/الموظف الذي أجرى التسوية
  final String adjustedBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 السبب أو الملاحظات العامة لإذن التسوية
  final String? notes;

  // 📅 تاريخ ووقت إجراء التسوية
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  @override
  String? get syncBranchId => branchId;

  StockAdjustmentModel({
    required this.id,
    required this.adjustmentNumber,
    required this.adjustmentType,
    required this.items,
    required this.totalAmount,
    required this.adjustedBy,
    required this.branchId,
    required this.accountId,
    this.notes,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  StockAdjustmentModel copyWith({
    String? id,
    String? adjustmentNumber,
    AdjustmentType? adjustmentType,
    List<StockAdjustmentItemModel>? items,
    double? totalAmount,
    String? adjustedBy,
    String? branchId,
    String? accountId,
    bool clearNotes = false,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) =>
      StockAdjustmentModel(
        id: id ?? this.id,
        adjustmentNumber: adjustmentNumber ?? this.adjustmentNumber,
        adjustmentType: adjustmentType ?? this.adjustmentType,
        items: items ?? this.items,
        totalAmount: totalAmount ?? this.totalAmount,
        adjustedBy: adjustedBy ?? this.adjustedBy,
        branchId: branchId ?? this.branchId,
        accountId: accountId ?? this.accountId,
        notes: clearNotes ? null : (notes ?? this.notes),
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
        isDeleted: isDeleted ?? this.isDeleted,
        syncVersion: syncVersion ?? this.syncVersion,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'adjustment_number': adjustmentNumber,
    'adjustment_type': adjustmentType.name,
    'items': items.map((i) => i.toJson()).toList(),
    'total_amount': totalAmount,
    'adjusted_by': adjustedBy,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) => StockAdjustmentModel(
    id: json['id'] as String,
    adjustmentNumber: json['adjustment_number'] as String,
    adjustmentType: json['adjustment_type'] == 'surplus'
        ? AdjustmentType.surplus
        : json['adjustment_type'] == 'shortage'
            ? AdjustmentType.shortage
            : AdjustmentType.damage,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => StockAdjustmentItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    adjustedBy: json['adjusted_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    notes: json['notes'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


