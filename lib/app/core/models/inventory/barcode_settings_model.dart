/// 🖨️ نمط وتخطيط طباعة الباركود (طابعة استيكر ملصقات أم ورقة A4)
enum BarcodePrintLayout {
  labelPrinter, // طابعة استيكر حرارية مخصصة
  a4Sheet,      // طباعة على ورقة A4 مقسمة
}

/// ⚙️ موديل إعدادات وقوالب وطباعة ملصقات الباركود (Barcode Settings Model)
class BarcodeSettingsModel {
  // 🆔 المعرف الفريد للإعدادات (Primary Key)
  final String id;

  // 🏷️ الرمز البادئ الثابت للباركود الصيدلي (مثل: 20)
  final String prefix;

  // 📏 عرض ملصق الباركود بالملليمتر (مثل: 62 مم)
  final double labelWidthMm;

  // 📏 ارتفاع ملصق الباركود بالملليمتر (مثل: 32 مم)
  final double labelHeightMm;

  // 🖨️ عدد النسخ المطبوعة افتراضياً لكل صنف
  final int copiesPerItem;

  // 💵 إظهار سعر البيع على ملصق الباركود
  final bool showPrice;

  // 🏷️ إظهار اسم الدواء/الصنف على الملصق
  final bool showItemName;

  // 📦 إظهار اسم الوحدة (علبة/شريط) على الملصق
  final bool showUnitName;

  // 🏛️ إظهار اسم الصيدلية على الملصق
  final bool showPharmacyName;

  // 🏛️ اسم الصيدلية المطبوع على الملصق
  final String pharmacyName;

  // ⏳ إظهار تاريخ انتهاء الصلاحية على الملصق
  final bool showExpiry;

  // 🔢 إظهار رقم التشغيلة/الطبخة Batch على الملصق
  final bool showBatch;

  // 🖨️ نمط التخطيط للطباعة (طابعة ملصقات حرارية labelPrinter أم A4)
  final BarcodePrintLayout printLayout;

  // 🖨️ خيار الطباعة المباشرة بدون نافذة معاينة
  final bool directPrint;

  // 🖨️ اسم طابعة الباركود المعرفة فـ الجهاز (مثل: Xprinter / Zebra)
  final String printerName;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  BarcodeSettingsModel({
    required this.id,
    this.prefix = '20',
    this.labelWidthMm = 62.0,
    this.labelHeightMm = 32.0,
    this.copiesPerItem = 1,
    this.showPrice = true,
    this.showItemName = true,
    this.showUnitName = true,
    this.showPharmacyName = false,
    this.pharmacyName = '',
    this.showExpiry = false,
    this.showBatch = false,
    this.printLayout = BarcodePrintLayout.labelPrinter,
    this.directPrint = false,
    this.printerName = '',
    this.accountId,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'prefix': prefix,
    'label_width_mm': labelWidthMm,
    'label_height_mm': labelHeightMm,
    'copies_per_item': copiesPerItem,
    'show_price': showPrice,
    'show_item_name': showItemName,
    'show_unit_name': showUnitName,
    'show_pharmacy_name': showPharmacyName,
    'pharmacy_name': pharmacyName,
    'show_expiry': showExpiry,
    'show_batch': showBatch,
    'print_layout': printLayout.name,
    'direct_print': directPrint,
    'printer_name': printerName,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
  };

  factory BarcodeSettingsModel.fromJson(Map<String, dynamic> json) => BarcodeSettingsModel(
    id: json['id'] as String,
    prefix: json['prefix'] as String? ?? '20',
    labelWidthMm: (json['label_width_mm'] as num?)?.toDouble() ?? 62.0,
    labelHeightMm: (json['label_height_mm'] as num?)?.toDouble() ?? 32.0,
    copiesPerItem: (json['copies_per_item'] as num?)?.toInt() ?? 1,
    showPrice: json['show_price'] as bool? ?? true,
    showItemName: json['show_item_name'] as bool? ?? true,
    showUnitName: json['show_unit_name'] as bool? ?? true,
    showPharmacyName: json['show_pharmacy_name'] as bool? ?? false,
    pharmacyName: json['pharmacy_name'] as String? ?? '',
    showExpiry: json['show_expiry'] as bool? ?? false,
    showBatch: json['show_batch'] as bool? ?? false,
    printLayout: json['print_layout'] == 'a4Sheet'
        ? BarcodePrintLayout.a4Sheet
        : BarcodePrintLayout.labelPrinter,
    directPrint: json['direct_print'] as bool? ?? false,
    printerName: json['printer_name'] as String? ?? '',
    accountId: json['account_id'] as String?,
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
  );
}


