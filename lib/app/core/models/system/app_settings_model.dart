/// ⚙️ موديل إعدادات المنظومة والصيدلية الموحد الشامل (App Settings Model)
class AppSettingsModel {
  // 🏢 اسم الصيدلية باللغة العربية (مثل: صيدلية النور)
  final String pharmacyName;

  // 🔤 اسم الصيدلية باللغة الإنجليزية (مثل: Al-Noor Pharmacy)
  final String pharmacyNameEn;

  // 💰 العملة الرئيسية المستخدمة (مثل: ج.م / ر.س)
  final String currency;

  // 🧾 الرقم الضريبي الخاص بالصيدلية
  final String? taxNumber;

  // 📜 السجل التجاري للصيدلية
  final String? commercialRegister;

  // 🖼️ رابط/مسار الشعار (Logo URL)
  final String? logoUrl;

  // 📍 عنوان الصيدلية الرئيسي
  final String? address;

  // 📞 تليفون/هاتف الصيدلية الرئيسي
  final String? phone;

  // 📧 البريد الإلكتروني للتواصل
  final String? email;

  // 📊 حد تنبيه النواقص التلقائي للأدوية
  final int defaultLowStockThreshold;

  // ⏳ عدد الأيام للتنبيه بقرب انتهاء الصلاحية (مثال: 90 يوم)
  final int nearExpiryAlertDays;

  // 🖨️ تفعيل فتح درج النقدية التلقائي مع كل فاتورة
  final bool autoOpenCashDrawer;

  // 🖨️ طباعة الفاتورة تلقائياً بعد البيع
  final bool autoPrintReceipt;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل للإعدادات
  final DateTime lastModified;

  AppSettingsModel({
    this.pharmacyName = 'صيدليتي',
    this.pharmacyNameEn = 'My Pharmacy',
    this.currency = 'ج.م',
    this.taxNumber,
    this.commercialRegister,
    this.logoUrl,
    this.address,
    this.phone,
    this.email,
    this.defaultLowStockThreshold = 10,
    this.nearExpiryAlertDays = 90,
    this.autoOpenCashDrawer = true,
    this.autoPrintReceipt = true,
    this.accountId,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  AppSettingsModel copyWith({
    String? pharmacyName,
    String? pharmacyNameEn,
    String? currency,
    String? taxNumber,
    String? commercialRegister,
    String? logoUrl,
    String? address,
    String? phone,
    String? email,
    int? defaultLowStockThreshold,
    int? nearExpiryAlertDays,
    bool? autoOpenCashDrawer,
    bool? autoPrintReceipt,
    String? accountId,
    DateTime? lastModified,
  }) {
    return AppSettingsModel(
      pharmacyName: pharmacyName ?? this.pharmacyName,
      pharmacyNameEn: pharmacyNameEn ?? this.pharmacyNameEn,
      currency: currency ?? this.currency,
      taxNumber: taxNumber ?? this.taxNumber,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      defaultLowStockThreshold: defaultLowStockThreshold ?? this.defaultLowStockThreshold,
      nearExpiryAlertDays: nearExpiryAlertDays ?? this.nearExpiryAlertDays,
      autoOpenCashDrawer: autoOpenCashDrawer ?? this.autoOpenCashDrawer,
      autoPrintReceipt: autoPrintReceipt ?? this.autoPrintReceipt,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'pharmacy_name': pharmacyName,
    'pharmacy_name_en': pharmacyNameEn,
    'currency': currency,
    'tax_number': taxNumber,
    'commercial_register': commercialRegister,
    'logo_url': logoUrl,
    'address': address,
    'phone': phone,
    'email': email,
    'default_low_stock_threshold': defaultLowStockThreshold,
    'near_expiry_alert_days': nearExpiryAlertDays,
    'auto_open_cash_drawer': autoOpenCashDrawer,
    'auto_print_receipt': autoPrintReceipt,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
  };

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) => AppSettingsModel(
    pharmacyName: json['pharmacy_name'] as String? ?? json['pharmacyName'] as String? ?? 'صيدليتي',
    pharmacyNameEn: json['pharmacy_name_en'] as String? ?? json['pharmacyNameEn'] as String? ?? 'My Pharmacy',
    currency: json['currency'] as String? ?? 'ج.م',
    taxNumber: json['tax_number'] as String? ?? json['taxNumber'] as String?,
    commercialRegister: json['commercial_register'] as String? ?? json['commercialRegister'] as String?,
    logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String?,
    address: json['address'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    defaultLowStockThreshold: (json['default_low_stock_threshold'] as num?)?.toInt() ?? 10,
    nearExpiryAlertDays: (json['near_expiry_alert_days'] as num?)?.toInt() ?? 90,
    autoOpenCashDrawer: json['auto_open_cash_drawer'] as bool? ?? true,
    autoPrintReceipt: json['auto_print_receipt'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}


