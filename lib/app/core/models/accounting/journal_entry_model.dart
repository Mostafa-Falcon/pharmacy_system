import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 📖 موديل سطر قيد اليومية (Journal Entry Line Model)
class JournalEntryLineModel {
  // 🆔 المعرف الفريد لسطر القيد
  final String id;

  // 🆔 معرف الحساب المالي
  final String accountId;

  // 🏷️ اسم الحساب المالي (مثل: الصندوق / المبيعات / الموردين)
  final String accountName;

  // 🔢 كود الحساب في الشجرة المحاسبية
  final String accountCode;

  // 💰 قيمة جانب المدين (Debit)
  final double debit;

  // 💰 قيمة جانب الدائن (Credit)
  final double credit;

  // 📝 بيان ووصف السطر
  final String? description;

  JournalEntryLineModel({
    required this.id,
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    this.debit = 0.0,
    this.credit = 0.0,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'account_id': accountId,
    'account_name': accountName,
    'account_code': accountCode,
    'debit': debit,
    'credit': credit,
    'description': description,
  };

  JournalEntryLineModel copyWith({
    String? id,
    String? accountId,
    String? accountName,
    String? accountCode,
    double? debit,
    double? credit,
    String? description,
  }) {
    return JournalEntryLineModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      accountCode: accountCode ?? this.accountCode,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
    );
  }

  factory JournalEntryLineModel.fromJson(Map<String, dynamic> json) => JournalEntryLineModel(
    id: json['id'] as String,
    accountId: json['account_id'] as String,
    accountName: json['account_name'] as String? ?? '',
    accountCode: json['account_code'] as String? ?? '',
    debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
    credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
    description: json['description'] as String?,
  );
}

/// 📖 موديل قيد اليومية المحاسبي المزدوج (Double-Entry Journal Entry Model)
class JournalEntryModel implements SyncableEntity {
  // 🆔 المعرف الفريد لقيد اليومية (Primary Key)
  final String id;

  // 🔢 رقم القيد المرجعي
  final int entryNumber;

  // 📅 تاريخ ووقت إنشاء القيد
  final DateTime entryDate;

  // 🏷️ نوع القيد (فاتورة بيع، شراء، مصروف، قيد افتتاحي، يدوي)
  final String entryType;

  // 🔢 رقم الفاتورة أو المرجع المرتبط بالقيد (إن وجد)
  final String? referenceNumber;

  // 📝 بيان ووصف القيد الكلي
  final String? description;

  // 📜 خطوط وأطراف القيد (مدين ودائن)
  final List<JournalEntryLineModel> lines;

  // 💰 إجمالي المبلغ المدين
  final double totalDebit;

  // 💰 إجمالي المبلغ الدائن
  final double totalCredit;

  // 👤 معرف الموظف/المحاسب المنشئ للقيد
  final String createdById;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

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

  JournalEntryModel({
    required this.id,
    required this.entryNumber,
    DateTime? entryDate,
    this.entryType = 'general',
    this.referenceNumber,
    this.description,
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
    required this.createdById,
    required this.branchId,
    this.accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : entryDate = entryDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  // ⚖️ التأكد من توازن القيد المحاسبي (إجمالي المدين = إجمالي الدائن)
  bool get isBalanced => (totalDebit - totalCredit).abs() < 0.001;

  Map<String, dynamic> toJson() => {
    'id': id,
    'entry_number': entryNumber,
    'entry_date': entryDate.toIso8601String(),
    'entry_type': entryType,
    'reference_number': referenceNumber,
    'description': description,
    'lines': lines.map((l) => l.toJson()).toList(),
    'total_debit': totalDebit,
    'total_credit': totalCredit,
    'created_by_id': createdById,
    'branch_id': branchId,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  JournalEntryModel copyWith({
    String? id,
    int? entryNumber,
    DateTime? entryDate,
    String? entryType,
    String? referenceNumber,
    String? description,
    List<JournalEntryLineModel>? lines,
    double? totalDebit,
    double? totalCredit,
    String? createdById,
    String? branchId,
    String? accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      entryNumber: entryNumber ?? this.entryNumber,
      entryDate: entryDate ?? this.entryDate,
      entryType: entryType ?? this.entryType,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      description: description ?? this.description,
      lines: lines ?? this.lines,
      totalDebit: totalDebit ?? this.totalDebit,
      totalCredit: totalCredit ?? this.totalCredit,
      createdById: createdById ?? this.createdById,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) => JournalEntryModel(
    id: json['id'] as String,
    entryNumber: (json['entry_number'] as num?)?.toInt() ?? 0,
    entryDate: DateTime.tryParse(json['entry_date'] as String? ?? '') ?? DateTime.now(),
    entryType: json['entry_type'] as String? ?? 'general',
    referenceNumber: json['reference_number'] as String?,
    description: json['description'] as String?,
    lines: (json['lines'] as List<dynamic>?)
        ?.map((e) => JournalEntryLineModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalDebit: (json['total_debit'] as num?)?.toDouble() ?? 0.0,
    totalCredit: (json['total_credit'] as num?)?.toDouble() ?? 0.0,
    createdById: json['created_by_id'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


