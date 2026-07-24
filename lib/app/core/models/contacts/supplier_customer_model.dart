/// 🤝 موديل النوع الثالث: "مورد وعميل في نفس الوقت" (الصيدليات الشقيقة والشركاء التجاريين)
class SupplierCustomerModel {
  // 🆔 المعرف الفريد للكيان المزدوج (Primary Key)
  final String id;

  // 🏷️ اسم الكيان/الصيدلية الشقيقة (مثال: صيدلية النور / شركة ومركز الأدوية)
  final String name;

  // 📞 رقم الهاتف / التواصل
  final String? phone;

  // 📍 العنوان التفصيلي
  final String? address;

  // 📧 البريد الإلكتروني
  final String? email;

  // 🏢 اسم المؤسسة أو الشريحة التجارية
  final String? companyName;

  // 🧾 الرقم الضريبي / السجل التجاري
  final String? taxId;

  // 💵 حد الائتمان الآجل المسموح
  final double creditLimit;

  // ٪ نسبة الخصم المعتمدة المتبادلة
  final double discountPercent;

  // 📅 فترة السداد المسموحة بالأيام
  final int paymentTermDays;

  // 💰 الرصيد الحالي كمورد (له علينا)
  final double supplierBalance;

  // 💰 الرصيد الحالي كعميل (عليها لنا)
  final double customerBalance;

  // 💰 الرصيد الصافي المتبادل (الفرق الحسابي بين كسب المشتريات والمبيعات)
  double get netBalance => customerBalance - supplierBalance;

  // 🟢 حالة تفعيل التعامل
  final bool isActive;

  // 📝 ملاحظات وشروط التعامل التبادلي
  final String? notes;

  // 🏬 معرف الفرع
  final String? branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة (Tenant ID)
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي (Soft Delete)
  final bool isDeleted;

  SupplierCustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.email,
    this.companyName,
    this.taxId,
    this.creditLimit = 0.0,
    this.discountPercent = 0.0,
    this.paymentTermDays = 0,
    this.supplierBalance = 0.0,
    this.customerBalance = 0.0,
    this.isActive = true,
    this.notes,
    this.branchId,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  SupplierCustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? email,
    String? companyName,
    String? taxId,
    double? creditLimit,
    double? discountPercent,
    int? paymentTermDays,
    double? supplierBalance,
    double? customerBalance,
    bool? isActive,
    String? notes,
    String? branchId,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return SupplierCustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      taxId: taxId ?? this.taxId,
      creditLimit: creditLimit ?? this.creditLimit,
      discountPercent: discountPercent ?? this.discountPercent,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      supplierBalance: supplierBalance ?? this.supplierBalance,
      customerBalance: customerBalance ?? this.customerBalance,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'email': email,
    'company_name': companyName,
    'tax_id': taxId,
    'credit_limit': creditLimit,
    'discount_percent': discountPercent,
    'payment_term_days': paymentTermDays,
    'supplier_balance': supplierBalance,
    'customer_balance': customerBalance,
    'is_active': isActive,
    'notes': notes,
    'branch_id': branchId,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory SupplierCustomerModel.fromJson(Map<String, dynamic> json) => SupplierCustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    email: json['email'] as String?,
    companyName: json['company_name'] as String?,
    taxId: json['tax_id'] as String?,
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0.0,
    paymentTermDays: (json['payment_term_days'] as num?)?.toInt() ?? 0,
    supplierBalance: (json['supplier_balance'] as num?)?.toDouble() ?? 0.0,
    customerBalance: (json['customer_balance'] as num?)?.toDouble() ?? 0.0,
    isActive: json['is_active'] as bool? ?? true,
    notes: json['notes'] as String?,
    branchId: json['branch_id'] as String?,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


