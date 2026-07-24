import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 💵 موديل المصروفات والإيجار والفواتير (Expense Model)
class ExpenseModel implements SyncableEntity {
  // 🆔 المعرف الفريد لسند المصروف (Primary Key)
  final String id;

  // 🔢 رقم التسلسل المرجعي للمصروف
  final int expenseNumber;

  // 📂 تصنيف وبند المصروف (مثال: إيجار / كهرباء / أكياس ومستلزمات / رواتب)
  final String category;

  // 📝 بيان ووصف تفصيلي للمصروف
  final String? description;

  // 💰 قيمة ومبلغ المصروف بالجنيه
  final double amount;

  // 💳 طريقة الدفع (كاش / فيزا / من الخزينة)
  final String paymentMethod;

  // 👤 معرف الموظف الذي سجل المصروف
  final String createdById;

  // 👤 اسم الموظف الذي سجل المصروف (مثل: د. أحمد)
  final String? createdByName;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📝 ملاحظات إضافية
  final String? notes;

  // 📅 تاريخ ووقت دفع المصروف
  final DateTime expenseDate;

  // 🕒 تاريخ ووقت التسجيل
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

  ExpenseModel({
    required this.id,
    required this.expenseNumber,
    required this.category,
    this.description,
    required this.amount,
    this.paymentMethod = 'cash',
    required this.createdById,
    this.createdByName,
    required this.branchId,
    this.accountId,
    this.notes,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : expenseDate = expenseDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'expense_number': expenseNumber,
    'category': category,
    'description': description,
    'amount': amount,
    'payment_method': paymentMethod,
    'created_by_id': createdById,
    'created_by_name': createdByName,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'expense_date': expenseDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  ExpenseModel copyWith({
    String? id,
    int? expenseNumber,
    String? category,
    String? description,
    double? amount,
    String? paymentMethod,
    String? createdById,
    String? createdByName,
    String? branchId,
    String? accountId,
    String? notes,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expenseNumber: expenseNumber ?? this.expenseNumber,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['id'] as String,
    expenseNumber: (json['expense_number'] as num?)?.toInt() ?? 0,
    category: json['category'] as String,
    description: json['description'] as String?,
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['payment_method'] as String? ?? 'cash',
    createdById: json['created_by_id'] as String? ?? '',
    createdByName: json['created_by_name'] as String?,
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    notes: json['notes'] as String?,
    expenseDate: DateTime.tryParse(json['expense_date'] as String? ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


