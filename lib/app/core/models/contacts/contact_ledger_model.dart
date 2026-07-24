import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 🧾 نوع الحركة المالية في دفتر الأستاذ
enum LedgerTransactionType {
  purchaseInvoice, // فاتورة شراء
  saleInvoice,     // فاتورة مبيعات
  payment,         // دفعة سداد
  returnInvoice,   // فاتورة مرتجع
  adjustment,      // تسوية حسابية
}

/// 📖 موديل حركات كشف حساب دفتر الأستاذ (Contact Ledger Record Model)
class ContactLedgerModel implements SyncableEntity {
  // 🆔 المعرف الفريد لحركة كشف الحساب (Primary Key)
  final String id;

  // 👤 معرف جهة التعامل (مورد / عميل / صيدلية)
  final String contactId;

  // 📅 تاريخ ووقت الحركة المالية
  final DateTime transactionDate;

  // 🔢 رقم المرجع/الفاتورة/السند (مثال: PUR-0030, RCV-0044)
  final String referenceNumber;

  // 🧾 نوع الحركة المالية (فاتورة شراء، دفعة، مرتجع...)
  final LedgerTransactionType transactionType;

  // 💰 المبلغ المدين في هذه الحركة (المستحق للصيدلية)
  final double debitAmount;

  // 💰 المبلغ الدائن في هذه الحركة (المستحق لجهة التعامل)
  final double creditAmount;

  // ⚖️ الرصيد التراكمي المتبقي بعد تنفيذ الحركة مباشرة
  final double runningBalance;

  // 📝 بيان ووصف الحركة المالية
  final String? description;

  // 🏬 معرف الفرع
  final String? branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // ⚙️ حقول الإدارة والمزامنة
  final int syncVersion;
  @override
  final DateTime lastModified;
  @override
  final bool isDeleted;

  @override
  String? get syncBranchId => branchId;

  ContactLedgerModel({
    required this.id,
    required this.contactId,
    required this.transactionDate,
    required this.referenceNumber,
    required this.transactionType,
    this.debitAmount = 0.0,
    this.creditAmount = 0.0,
    required this.runningBalance,
    this.description,
    this.branchId,
    this.accountId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contact_id': contactId,
    'transaction_date': transactionDate.toIso8601String(),
    'reference_number': referenceNumber,
    'transaction_type': transactionType.name,
    'debit_amount': debitAmount,
    'credit_amount': creditAmount,
    'running_balance': runningBalance,
    'description': description,
    'branch_id': branchId,
    'account_id': accountId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ContactLedgerModel.fromJson(Map<String, dynamic> json) => ContactLedgerModel(
    id: json['id'] as String,
    contactId: json['contact_id'] as String,
    transactionDate: DateTime.tryParse(json['transaction_date'] as String? ?? '') ?? DateTime.now(),
    referenceNumber: json['reference_number'] as String,
    transactionType: LedgerTransactionType.values.firstWhere(
      (e) => e.name == json['transaction_type'],
      orElse: () => LedgerTransactionType.adjustment,
    ),
    debitAmount: (json['debit_amount'] as num?)?.toDouble() ?? 0.0,
    creditAmount: (json['credit_amount'] as num?)?.toDouble() ?? 0.0,
    runningBalance: (json['running_balance'] as num?)?.toDouble() ?? 0.0,
    description: json['description'] as String?,
    branchId: json['branch_id'] as String?,
    accountId: json['account_id'] as String?,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
