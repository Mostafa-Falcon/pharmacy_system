/// 🟢 حالة وردية الكاشير والخزينة (مفتوحة أم مغلقة)
enum CashierShiftStatus {
  open,   // وردية مفتوحة حالياً
  closed, // وردية مغلقة ومسواة
}

/// 💵 موديل سجل ووردية الكاشير والخزينة (Cashier Shift Model)
class CashierShiftModel {
  // 🆔 المعرف الفريد لوردية الكاشير (Primary Key)
  final String id;

  // 🔢 رقم الوردية التسلسلي (مثال: وردية #105)
  final int shiftNumber;

  // 🏬 معرف الفرع
  final String branchId;

  // 👤 معرف الكاشير/الصيدلي المسئول عن الوردية
  final String cashierId;

  // 👤 اسم الكاشير/الصيدلي (مثل: د. أحمد)
  final String cashierName;

  // 📱 معرف جهاز الكاشير (POS Terminal ID)
  final String deviceId;

  // 🕒 تاريخ ووقت فتح الوردية
  final DateTime openedAt;

  // 💵 المبلغ الافتتاحي في الخزينة عند فتح الوردية
  final double openingCash;

  // 🟢 حالة الوردية (مفتوحة open / مغلقة closed)
  final CashierShiftStatus status;

  // 🕒 تاريخ ووقت إغلاق الوردية
  final DateTime? closedAt;

  // 💰 المبلغ المتوقع دفترياً في الخزينة (الافتتاحي + المبيعات الكاش - المصروفات)
  final double? expectedCash;

  // 💰 المبلغ الجاري المجرود فعلياً باليد عند الإغلاق
  final double? countedCash;

  // ⚖️ الفرق المالي (عجز بالسالب أم زيادة بالموجب)
  final double? difference;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📝 ملاحظات الكاشير أو المشرف عند إغلاق الوردية
  final String? notes;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  CashierShiftModel({
    required this.id,
    required this.shiftNumber,
    required this.branchId,
    required this.cashierId,
    required this.cashierName,
    this.deviceId = 'POS-1',
    required this.openedAt,
    this.openingCash = 0.0,
    this.status = CashierShiftStatus.open,
    this.closedAt,
    this.expectedCash,
    this.countedCash,
    this.difference,
    this.accountId,
    this.notes,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CashierShiftModel copyWith({
    String? id,
    int? shiftNumber,
    String? branchId,
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
    String? accountId,
    String? notes,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CashierShiftModel(
      id: id ?? this.id,
      shiftNumber: shiftNumber ?? this.shiftNumber,
      branchId: branchId ?? this.branchId,
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
      accountId: accountId ?? this.accountId,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shift_number': shiftNumber,
    'branch_id': branchId,
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
    'account_id': accountId,
    'notes': notes,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CashierShiftModel.fromJson(Map<String, dynamic> json) => CashierShiftModel(
    id: json['id'] as String,
    shiftNumber: (json['shift_number'] as num?)?.toInt() ?? 1,
    branchId: json['branch_id'] as String? ?? '',
    cashierId: json['cashier_id'] as String? ?? '',
    cashierName: json['cashier_name'] as String? ?? '',
    deviceId: json['device_id'] as String? ?? 'POS-1',
    openedAt: DateTime.tryParse(json['opened_at'] as String? ?? '') ?? DateTime.now(),
    openingCash: (json['opening_cash'] as num?)?.toDouble() ?? 0.0,
    status: json['status'] == 'closed' ? CashierShiftStatus.closed : CashierShiftStatus.open,
    closedAt: json['closed_at'] != null ? DateTime.tryParse(json['closed_at'] as String) : null,
    expectedCash: (json['expected_cash'] as num?)?.toDouble(),
    countedCash: (json['counted_cash'] as num?)?.toDouble(),
    difference: (json['difference'] as num?)?.toDouble(),
    accountId: json['account_id'] as String?,
    notes: json['notes'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


