/// 🔄 موديل سطر الصنف المتبادل (داخل أو خارج)
class SwapItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف بالعربي
  final String medicineName;

  // 🔢 مستوى الوحدة المتبادلة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية المتبادلة
  final int quantity;

  // 💵 سعر تكلفة/بيع الوحدة المتبادلة
  final double unitPrice;

  // ٪ قيمة الخصم المطبقة على الصنف
  final double discountAmount;

  // 💰 الإجمالي الصافي لسطر التبادل
  final double totalPrice;

  SwapItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.quantity,
    required this.unitPrice,
    this.discountAmount = 0.0,
    required this.totalPrice,
  });

  SwapItemModel copyWith({
    String? medicineId,
    String? medicineName,
    int? unitLevel,
    String? unitName,
    int? quantity,
    double? unitPrice,
    double? discountAmount,
    double? totalPrice,
  }) =>
      SwapItemModel(
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        unitLevel: unitLevel ?? this.unitLevel,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        discountAmount: discountAmount ?? this.discountAmount,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'discount_amount': discountAmount,
    'total_price': totalPrice,
  };

  factory SwapItemModel.fromJson(Map<String, dynamic> json) => SwapItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 🔄 موديل عملية تبادل أصناف المخزون الموحد (Item Swap / Stock Exchange Model)
class ItemSwapModel {
  // 🆔 المعرف الفريد لعملية التبادل (Primary Key)
  final String id;

  // 🔢 رقم التبادل المرجعي
  final String swapNumber;

  // 🤝 نوع الطرف الآخر (عميل / مورد / فرع)
  final String partyType;

  // 👤 معرف الطرف الآخر
  final String? partyId;

  // 👤 اسم الطرف الآخر (اسم العميل أو المورد)
  final String partyName;

  // 💳 معرف الخزينة المسؤولة عن تحصيل/سداد فرق القيمة النقدي
  final String? cashRegisterId;

  // 📦 الأصناف الداخلة للمخزون (الصيدلية تستلم - تزود المخزون)
  final List<SwapItemModel> incomingItems;

  // 📦 الأصناف الخارجة من المخزون (الصيدلية تسلم - تقلل المخزون)
  final List<SwapItemModel> outgoingItems;

  // 💰 إجمالي قيمة أصناف الداخل بالجنيه
  final double totalIncomingAmount;

  // 💰 إجمالي قيمة أصناف الخارج بالجنيه
  final double totalOutgoingAmount;

  // 💵 الفرق النقدي الذي تستلمه الصيدلية أو تدفعه (الداخل - الخارج)
  final double netCashDifference;

  // 👤 اسم/معرف الصيدلي الذي قام بتنفيذ التبادل
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 ملاحظات الإدارة على عملية التبادل
  final String? notes;

  // 📅 تاريخ ووقت عملية التبادل
  final DateTime swapDate;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  ItemSwapModel({
    required this.id,
    required this.swapNumber,
    this.partyType = 'customer',
    this.partyId,
    required this.partyName,
    this.cashRegisterId,
    required this.incomingItems,
    required this.outgoingItems,
    required this.totalIncomingAmount,
    required this.totalOutgoingAmount,
    required this.netCashDifference,
    required this.createdBy,
    required this.branchId,
    required this.accountId,
    this.notes,
    DateTime? swapDate,
    DateTime? lastModified,
  })  : swapDate = swapDate ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  ItemSwapModel copyWith({
    String? id,
    String? swapNumber,
    String? partyType,
    bool clearPartyId = false,
    String? partyId,
    String? partyName,
    bool clearCashRegisterId = false,
    String? cashRegisterId,
    List<SwapItemModel>? incomingItems,
    List<SwapItemModel>? outgoingItems,
    double? totalIncomingAmount,
    double? totalOutgoingAmount,
    double? netCashDifference,
    String? createdBy,
    String? branchId,
    String? accountId,
    bool clearNotes = false,
    String? notes,
    DateTime? swapDate,
    DateTime? lastModified,
  }) =>
      ItemSwapModel(
        id: id ?? this.id,
        swapNumber: swapNumber ?? this.swapNumber,
        partyType: partyType ?? this.partyType,
        partyId: clearPartyId ? null : (partyId ?? this.partyId),
        partyName: partyName ?? this.partyName,
        cashRegisterId:
            clearCashRegisterId ? null : (cashRegisterId ?? this.cashRegisterId),
        incomingItems: incomingItems ?? this.incomingItems,
        outgoingItems: outgoingItems ?? this.outgoingItems,
        totalIncomingAmount:
            totalIncomingAmount ?? this.totalIncomingAmount,
        totalOutgoingAmount:
            totalOutgoingAmount ?? this.totalOutgoingAmount,
        netCashDifference: netCashDifference ?? this.netCashDifference,
        createdBy: createdBy ?? this.createdBy,
        branchId: branchId ?? this.branchId,
        accountId: accountId ?? this.accountId,
        notes: clearNotes ? null : (notes ?? this.notes),
        swapDate: swapDate ?? this.swapDate,
        lastModified: lastModified ?? this.lastModified,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'swap_number': swapNumber,
    'party_type': partyType,
    'party_id': partyId,
    'party_name': partyName,
    'cash_register_id': cashRegisterId,
    'incoming_items': incomingItems.map((i) => i.toJson()).toList(),
    'outgoing_items': outgoingItems.map((i) => i.toJson()).toList(),
    'total_incoming_amount': totalIncomingAmount,
    'total_outgoing_amount': totalOutgoingAmount,
    'net_cash_difference': netCashDifference,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'swap_date': swapDate.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
  };

  factory ItemSwapModel.fromJson(Map<String, dynamic> json) => ItemSwapModel(
    id: json['id'] as String,
    swapNumber: json['swap_number'] as String,
    partyType: json['party_type'] as String? ?? 'customer',
    partyId: json['party_id'] as String?,
    partyName: json['party_name'] as String? ?? '',
    cashRegisterId: json['cash_register_id'] as String?,
    incomingItems: (json['incoming_items'] as List<dynamic>?)
        ?.map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    outgoingItems: (json['outgoing_items'] as List<dynamic>?)
        ?.map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalIncomingAmount: (json['total_incoming_amount'] as num?)?.toDouble() ?? 0.0,
    totalOutgoingAmount: (json['total_outgoing_amount'] as num?)?.toDouble() ?? 0.0,
    netCashDifference: (json['net_cash_difference'] as num?)?.toDouble() ?? 0.0,
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    notes: json['notes'] as String?,
    swapDate: DateTime.tryParse(json['swap_date'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
  );
}


