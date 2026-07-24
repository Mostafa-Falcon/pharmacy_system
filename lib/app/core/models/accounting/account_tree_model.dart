import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 🏛️ تصنيف أنواع الحسابات في الشجرة المالية
enum AccountType {
  asset,     // أصول (متداولة / ثابته)
  liability, // خصوم / التزامات
  equity,    // حقوق ملكية / رأس المال
  revenue,   // إيرادات ومبيعات
  expense,   // مصروفات وتكاليف
}

/// 🌳 موديل شجرة ودليل الحسابات المالية (Chart of Accounts Model)
class AccountTreeModel implements GlobalSyncableEntity {
  // 🆔 المعرف الفريد للحساب في الشجرة (Primary Key)
  final String id;

  // 🔢 رقم/كود الحساب المالي (مثل: 101, 10101, 201)
  final String accountCode;

  // 🏷️ اسم الحساب المالي (مثل: الخزينة الرئيسية / بنك مصر / الأصول المتداولة)
  final String name;

  // 🏛️ نوع الحساب (أصول asset / خصوم liability / ملكية equity / إيرادات revenue / مصروفات expense)
  final AccountType accountType;

  // 🆔 معرف الحساب الأب (Parent Account ID في حالة الشجرة المتفرعة)
  final String? parentAccountId;

  // 💰 الرصيد الحالي للحساب بالجنيه
  final double currentBalance;

  // ⚖️ طبيعة رصيد الحساب الأصلي (مدينة debit / دائنة credit)
  final bool isDebitNature;

  // 🔒 هل الحساب حساب رئيسي تجمعي أم حساب فرعي يقبل القيد؟
  final bool isSubAccount;

  // 🟢 حالة تفعيل الحساب في المنظومة
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📝 وصف أو ملاحظات الحساب
  final String? description;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  @override
  String? get syncBranchId => null; // حسابات عالمية للمنشأة

  AccountTreeModel({
    required this.id,
    required this.accountCode,
    required this.name,
    required this.accountType,
    this.parentAccountId,
    this.currentBalance = 0.0,
    this.isDebitNature = true,
    this.isSubAccount = true,
    this.isActive = true,
    this.accountId,
    this.description,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  }) : lastModified = lastModified ?? DateTime.now();

  AccountTreeModel copyWith({
    String? id,
    String? accountCode,
    String? name,
    AccountType? accountType,
    String? parentAccountId,
    double? currentBalance,
    bool? isDebitNature,
    bool? isSubAccount,
    bool? isActive,
    String? accountId,
    String? description,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return AccountTreeModel(
      id: id ?? this.id,
      accountCode: accountCode ?? this.accountCode,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      parentAccountId: parentAccountId ?? this.parentAccountId,
      currentBalance: currentBalance ?? this.currentBalance,
      isDebitNature: isDebitNature ?? this.isDebitNature,
      isSubAccount: isSubAccount ?? this.isSubAccount,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'account_code': accountCode,
    'name': name,
    'account_type': accountType.name,
    'parent_account_id': parentAccountId,
    'current_balance': currentBalance,
    'is_debit_nature': isDebitNature,
    'is_sub_account': isSubAccount,
    'is_active': isActive,
    'account_id': accountId,
    'description': description,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory AccountTreeModel.fromJson(Map<String, dynamic> json) => AccountTreeModel(
    id: json['id'] as String,
    accountCode: json['account_code'] as String? ?? '',
    name: json['name'] as String,
    accountType: json['account_type'] == 'liability'
        ? AccountType.liability
        : json['account_type'] == 'equity'
            ? AccountType.equity
            : json['account_type'] == 'revenue'
                ? AccountType.revenue
                : json['account_type'] == 'expense'
                    ? AccountType.expense
                    : AccountType.asset,
    parentAccountId: json['parent_account_id'] as String?,
    currentBalance: (json['current_balance'] as num?)?.toDouble() ?? 0.0,
    isDebitNature: json['is_debit_nature'] as bool? ?? true,
    isSubAccount: json['is_sub_account'] as bool? ?? true,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    description: json['description'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


