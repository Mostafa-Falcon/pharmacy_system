/// 💳 نوع سند القبض/الدفع
enum VoucherType {
  receipt, // سند قبض (استلام مبالغ من عميل/صيدلية)
  payment, // سند دفع (سداد مبالغ لمورد/مصروف)
}

/// 💳 موديل سندات القبض والدفع المالية (Payment Voucher Model)
class PaymentVoucherModel {
  // 🆔 المعرف الفريد لسند القبض/الدفع (Primary Key)
  final String id;

  // 🔢 رقم السند المرجعي التسلسلي
  final int voucherNumber;

  // 💳 نوع السند (سند قبض receipt / سند دفع payment)
  final VoucherType voucherType;

  // 👤 معرف جهة التعامل (المورد أو العميل)
  final String? partyId;

  // 👤 اسم جهة التعامل (اسم العميل أو المورد)
  final String partyName;

  // 💰 المبلغ المسدد/المقبوض بالجنيه
  final double amount;

  // 💳 طريقة الدفع (كاش / فيزا / تحويل بنكي / شيك)
  final String paymentMethod;

  // 🔢 رقم المرجع البنكي أو رقم الشيك (إن وجد)
  final String? referenceNumber;

  // 📝 بيان ووصف الغرض من السند
  final String? description;

  // 👤 معرف الصيدلي/الموظف المنشئ للسند
  final String createdById;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📅 تاريخ ووقت إصدار السند
  final DateTime voucherDate;

  // 🕒 تاريخ ووقت التسجيل
  final DateTime createdAt;

  PaymentVoucherModel({
    required this.id,
    required this.voucherNumber,
    required this.voucherType,
    this.partyId,
    required this.partyName,
    required this.amount,
    this.paymentMethod = 'cash',
    this.referenceNumber,
    this.description,
    required this.createdById,
    required this.branchId,
    this.accountId,
    DateTime? voucherDate,
    DateTime? createdAt,
  })  : voucherDate = voucherDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'voucher_number': voucherNumber,
    'voucher_type': voucherType.name,
    'party_id': partyId,
    'party_name': partyName,
    'amount': amount,
    'payment_method': paymentMethod,
    'reference_number': referenceNumber,
    'description': description,
    'created_by_id': createdById,
    'branch_id': branchId,
    'account_id': accountId,
    'voucher_date': voucherDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  PaymentVoucherModel copyWith({
    String? id,
    int? voucherNumber,
    VoucherType? voucherType,
    String? partyId,
    String? partyName,
    double? amount,
    String? paymentMethod,
    String? referenceNumber,
    String? description,
    String? createdById,
    String? branchId,
    String? accountId,
    DateTime? voucherDate,
    DateTime? createdAt,
  }) {
    return PaymentVoucherModel(
      id: id ?? this.id,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      voucherType: voucherType ?? this.voucherType,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      description: description ?? this.description,
      createdById: createdById ?? this.createdById,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      voucherDate: voucherDate ?? this.voucherDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PaymentVoucherModel.fromJson(Map<String, dynamic> json) => PaymentVoucherModel(
    id: json['id'] as String,
    voucherNumber: (json['voucher_number'] as num?)?.toInt() ?? 0,
    voucherType: json['voucher_type'] == 'receipt' ? VoucherType.receipt : VoucherType.payment,
    partyId: json['party_id'] as String?,
    partyName: json['party_name'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['payment_method'] as String? ?? 'cash',
    referenceNumber: json['reference_number'] as String?,
    description: json['description'] as String?,
    createdById: json['created_by_id'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    voucherDate: DateTime.tryParse(json['voucher_date'] as String? ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
  );
}


