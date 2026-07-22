class ProjectSettings {
  String pharmacyName;
  String pharmacyNameEn;
  String currency;
  String costingMethod;
  String? taxNumber;
  String? commercialRegister;
  String? logoUrl;
  String? address;
  String? phone;
  String? email;
  String? website;
  bool enableMultiBranch;
  bool enableMultiCurrency;

  ProjectSettings({
    this.pharmacyName = '',
    this.pharmacyNameEn = '',
    this.currency = 'ج.م',
    this.costingMethod = 'weighted_average',
    this.taxNumber,
    this.commercialRegister,
    this.logoUrl,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.enableMultiBranch = false,
    this.enableMultiCurrency = false,
  });

  Map<String, dynamic> toJson() => {
        'pharmacyName': pharmacyName,
        'pharmacyNameEn': pharmacyNameEn,
        'currency': currency,
        'costingMethod': costingMethod,
        'taxNumber': taxNumber,
        'commercialRegister': commercialRegister,
        'logoUrl': logoUrl,
        'address': address,
        'phone': phone,
        'email': email,
        'website': website,
        'enableMultiBranch': enableMultiBranch,
        'enableMultiCurrency': enableMultiCurrency,
      };

  factory ProjectSettings.fromJson(Map<String, dynamic> json) =>
      ProjectSettings(
        pharmacyName: json['pharmacyName'] as String? ?? '',
        pharmacyNameEn: json['pharmacyNameEn'] as String? ?? '',
        currency: json['currency'] as String? ?? 'ج.م',
        costingMethod: json['costingMethod'] as String? ?? 'weighted_average',
        taxNumber: json['taxNumber'] as String?,
        commercialRegister: json['commercialRegister'] as String?,
        logoUrl: json['logoUrl'] as String?,
        address: json['address'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        website: json['website'] as String?,
        enableMultiBranch: json['enableMultiBranch'] as bool? ?? false,
        enableMultiCurrency: json['enableMultiCurrency'] as bool? ?? false,
      );
}

class TaxSettings {
  String taxMode;
  double defaultTaxRate;
  bool priceIncludesTax;
  bool showTaxOnReceipt;

  TaxSettings({
    this.taxMode = 'exclusive',
    this.defaultTaxRate = 0.0,
    this.priceIncludesTax = false,
    this.showTaxOnReceipt = true,
  });

  Map<String, dynamic> toJson() => {
        'taxMode': taxMode,
        'defaultTaxRate': defaultTaxRate,
        'priceIncludesTax': priceIncludesTax,
        'showTaxOnReceipt': showTaxOnReceipt,
      };

  factory TaxSettings.fromJson(Map<String, dynamic> json) => TaxSettings(
        taxMode: json['taxMode'] as String? ?? 'exclusive',
        defaultTaxRate: (json['defaultTaxRate'] as num?)?.toDouble() ?? 0.0,
        priceIncludesTax: json['priceIncludesTax'] as bool? ?? false,
        showTaxOnReceipt: json['showTaxOnReceipt'] as bool? ?? true,
      );
}

class ItemsSettings {
  bool enableExpiryTracking;
  bool enableBatchTracking;
  bool enableUnits;
  bool enableMultipleBarcodes;
  int lowStockThreshold;
  int nearExpiryDays;
  String defaultUnit;

  ItemsSettings({
    this.enableExpiryTracking = true,
    this.enableBatchTracking = false,
    this.enableUnits = true,
    this.enableMultipleBarcodes = true,
    this.lowStockThreshold = 10,
    this.nearExpiryDays = 30,
    this.defaultUnit = 'قطعة',
  });

  Map<String, dynamic> toJson() => {
        'enableExpiryTracking': enableExpiryTracking,
        'enableBatchTracking': enableBatchTracking,
        'enableUnits': enableUnits,
        'enableMultipleBarcodes': enableMultipleBarcodes,
        'lowStockThreshold': lowStockThreshold,
        'nearExpiryDays': nearExpiryDays,
        'defaultUnit': defaultUnit,
      };

  factory ItemsSettings.fromJson(Map<String, dynamic> json) => ItemsSettings(
        enableExpiryTracking: json['enableExpiryTracking'] as bool? ?? true,
        enableBatchTracking: json['enableBatchTracking'] as bool? ?? false,
        enableUnits: json['enableUnits'] as bool? ?? true,
        enableMultipleBarcodes:
            json['enableMultipleBarcodes'] as bool? ?? true,
        lowStockThreshold: json['lowStockThreshold'] as int? ?? 10,
        nearExpiryDays: json['nearExpiryDays'] as int? ?? 30,
        defaultUnit: json['defaultUnit'] as String? ?? 'قطعة',
      );
}

class SalesSettings {
  bool enableDiscount;
  double maxDiscountPercent;
  bool requireDiscountApproval;
  bool enableCreditSales;
  bool enableMixedPayment;
  bool showPriceHistory;
  bool requireCustomerForSale;
  String defaultSaleType;

  SalesSettings({
    this.enableDiscount = true,
    this.maxDiscountPercent = 25.0,
    this.requireDiscountApproval = true,
    this.enableCreditSales = false,
    this.enableMixedPayment = true,
    this.showPriceHistory = true,
    this.requireCustomerForSale = false,
    this.defaultSaleType = 'cash',
  });

  Map<String, dynamic> toJson() => {
        'enableDiscount': enableDiscount,
        'maxDiscountPercent': maxDiscountPercent,
        'requireDiscountApproval': requireDiscountApproval,
        'enableCreditSales': enableCreditSales,
        'enableMixedPayment': enableMixedPayment,
        'showPriceHistory': showPriceHistory,
        'requireCustomerForSale': requireCustomerForSale,
        'defaultSaleType': defaultSaleType,
      };

  factory SalesSettings.fromJson(Map<String, dynamic> json) => SalesSettings(
        enableDiscount: json['enableDiscount'] as bool? ?? true,
        maxDiscountPercent:
            (json['maxDiscountPercent'] as num?)?.toDouble() ?? 25.0,
        requireDiscountApproval:
            json['requireDiscountApproval'] as bool? ?? true,
        enableCreditSales: json['enableCreditSales'] as bool? ?? false,
        enableMixedPayment: json['enableMixedPayment'] as bool? ?? true,
        showPriceHistory: json['showPriceHistory'] as bool? ?? true,
        requireCustomerForSale:
            json['requireCustomerForSale'] as bool? ?? false,
        defaultSaleType: json['defaultSaleType'] as String? ?? 'cash',
      );
}

class SystemSettings {
  String language;
  String? defaultBranchId;
  int defaultTableRows;
  int sessionTimeoutMinutes;
  bool showHelpText;
  bool enableAuditLog;
  bool enableOfflineCache;
  bool enableAutoBackup;

  SystemSettings({
    this.language = 'ar',
    this.defaultBranchId,
    this.defaultTableRows = 50,
    this.sessionTimeoutMinutes = 120,
    this.showHelpText = true,
    this.enableAuditLog = true,
    this.enableOfflineCache = true,
    this.enableAutoBackup = false,
  });

  Map<String, dynamic> toJson() => {
        'language': language,
        'defaultBranchId': defaultBranchId,
        'defaultTableRows': defaultTableRows,
        'sessionTimeoutMinutes': sessionTimeoutMinutes,
        'showHelpText': showHelpText,
        'enableAuditLog': enableAuditLog,
        'enableOfflineCache': enableOfflineCache,
        'enableAutoBackup': enableAutoBackup,
      };

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
        language: json['language'] as String? ?? 'ar',
        defaultBranchId: json['defaultBranchId'] as String?,
        defaultTableRows: json['defaultTableRows'] as int? ?? 50,
        sessionTimeoutMinutes:
            json['sessionTimeoutMinutes'] as int? ?? 120,
        showHelpText: json['showHelpText'] as bool? ?? true,
        enableAuditLog: json['enableAuditLog'] as bool? ?? true,
        enableOfflineCache: json['enableOfflineCache'] as bool? ?? true,
        enableAutoBackup: json['enableAutoBackup'] as bool? ?? false,
      );
}

class EmailSettings {
  String smtpHost;
  int smtpPort;
  String smtpUsername;
  String smtpPassword;
  String encryption;
  String senderEmail;
  String senderName;
  bool enabled;

  EmailSettings({
    this.smtpHost = '',
    this.smtpPort = 587,
    this.smtpUsername = '',
    this.smtpPassword = '',
    this.encryption = 'tls',
    this.senderEmail = '',
    this.senderName = '',
    this.enabled = false,
  });

  Map<String, dynamic> toJson() => {
        'smtpHost': smtpHost,
        'smtpPort': smtpPort,
        'smtpUsername': smtpUsername,
        'smtpPassword': smtpPassword,
        'encryption': encryption,
        'senderEmail': senderEmail,
        'senderName': senderName,
        'enabled': enabled,
      };

  factory EmailSettings.fromJson(Map<String, dynamic> json) => EmailSettings(
        smtpHost: json['smtpHost'] as String? ?? '',
        smtpPort: json['smtpPort'] as int? ?? 587,
        smtpUsername: json['smtpUsername'] as String? ?? '',
        smtpPassword: json['smtpPassword'] as String? ?? '',
        encryption: json['encryption'] as String? ?? 'tls',
        senderEmail: json['senderEmail'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? false,
      );
}

class SmsSettings {
  String provider;
  String apiUrl;
  String apiKey;
  String senderName;
  bool enabled;

  SmsSettings({
    this.provider = '',
    this.apiUrl = '',
    this.apiKey = '',
    this.senderName = '',
    this.enabled = false,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'apiUrl': apiUrl,
        'apiKey': apiKey,
        'senderName': senderName,
        'enabled': enabled,
      };

  factory SmsSettings.fromJson(Map<String, dynamic> json) => SmsSettings(
        provider: json['provider'] as String? ?? '',
        apiUrl: json['apiUrl'] as String? ?? '',
        apiKey: json['apiKey'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? false,
      );
}

class RewardsSettings {
  bool enabled;
  double pointsPerAmount;
  double amountPerPoint;
  int expiryDays;
  double? minimumRedeemAmount;
  bool allowPartialRedeem;

  RewardsSettings({
    this.enabled = false,
    this.pointsPerAmount = 10.0,
    this.amountPerPoint = 1.0,
    this.expiryDays = 365,
    this.minimumRedeemAmount,
    this.allowPartialRedeem = true,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'pointsPerAmount': pointsPerAmount,
        'amountPerPoint': amountPerPoint,
        'expiryDays': expiryDays,
        'minimumRedeemAmount': minimumRedeemAmount,
        'allowPartialRedeem': allowPartialRedeem,
      };

  factory RewardsSettings.fromJson(Map<String, dynamic> json) =>
      RewardsSettings(
        enabled: json['enabled'] as bool? ?? false,
        pointsPerAmount: (json['pointsPerAmount'] as num?)?.toDouble() ?? 10.0,
        amountPerPoint: (json['amountPerPoint'] as num?)?.toDouble() ?? 1.0,
        expiryDays: json['expiryDays'] as int? ?? 365,
        minimumRedeemAmount:
            (json['minimumRedeemAmount'] as num?)?.toDouble(),
        allowPartialRedeem: json['allowPartialRedeem'] as bool? ?? true,
      );
}

class ShortcutsSettings {
  String purchaseOrder;
  String creditNote;
  String stockTransfer;
  String salesInvoice;
  String purchaseReturn;
  String salesReturn;
  String quotation;
  String stockAdjustment;

  ShortcutsSettings({
    this.purchaseOrder = 'PO',
    this.creditNote = 'CN',
    this.stockTransfer = 'ST',
    this.salesInvoice = 'SI',
    this.purchaseReturn = 'PR',
    this.salesReturn = 'SR',
    this.quotation = 'QT',
    this.stockAdjustment = 'SA',
  });

  Map<String, dynamic> toJson() => {
        'purchaseOrder': purchaseOrder,
        'creditNote': creditNote,
        'stockTransfer': stockTransfer,
        'salesInvoice': salesInvoice,
        'purchaseReturn': purchaseReturn,
        'salesReturn': salesReturn,
        'quotation': quotation,
        'stockAdjustment': stockAdjustment,
      };

  factory ShortcutsSettings.fromJson(Map<String, dynamic> json) =>
      ShortcutsSettings(
        purchaseOrder: json['purchaseOrder'] as String? ?? 'PO',
        creditNote: json['creditNote'] as String? ?? 'CN',
        stockTransfer: json['stockTransfer'] as String? ?? 'ST',
        salesInvoice: json['salesInvoice'] as String? ?? 'SI',
        purchaseReturn: json['purchaseReturn'] as String? ?? 'PR',
        salesReturn: json['salesReturn'] as String? ?? 'SR',
        quotation: json['quotation'] as String? ?? 'QT',
        stockAdjustment: json['stockAdjustment'] as String? ?? 'SA',
      );
}

class ExtraUnitsSettings {
  bool enableAccounting;
  bool enableZatca;
  bool enableKitchen;
  bool enableHr;
  bool enableMaintenance;
  bool enableLaundry;
  bool enableSalon;
  bool enableRestaurant;
  bool enableHotel;
  bool enableClinic;
  bool enableSchool;
  bool enableGym;
  bool enableWarehouse;

  ExtraUnitsSettings({
    this.enableAccounting = false,
    this.enableZatca = false,
    this.enableKitchen = false,
    this.enableHr = false,
    this.enableMaintenance = false,
    this.enableLaundry = false,
    this.enableSalon = false,
    this.enableRestaurant = false,
    this.enableHotel = false,
    this.enableClinic = false,
    this.enableSchool = false,
    this.enableGym = false,
    this.enableWarehouse = false,
  });

  Map<String, dynamic> toJson() => {
        'enableAccounting': enableAccounting,
        'enableZatca': enableZatca,
        'enableKitchen': enableKitchen,
        'enableHr': enableHr,
        'enableMaintenance': enableMaintenance,
        'enableLaundry': enableLaundry,
        'enableSalon': enableSalon,
        'enableRestaurant': enableRestaurant,
        'enableHotel': enableHotel,
        'enableClinic': enableClinic,
        'enableSchool': enableSchool,
        'enableGym': enableGym,
        'enableWarehouse': enableWarehouse,
      };

  factory ExtraUnitsSettings.fromJson(Map<String, dynamic> json) =>
      ExtraUnitsSettings(
        enableAccounting: json['enableAccounting'] as bool? ?? false,
        enableZatca: json['enableZatca'] as bool? ?? false,
        enableKitchen: json['enableKitchen'] as bool? ?? false,
        enableHr: json['enableHr'] as bool? ?? false,
        enableMaintenance: json['enableMaintenance'] as bool? ?? false,
        enableLaundry: json['enableLaundry'] as bool? ?? false,
        enableSalon: json['enableSalon'] as bool? ?? false,
        enableRestaurant: json['enableRestaurant'] as bool? ?? false,
        enableHotel: json['enableHotel'] as bool? ?? false,
        enableClinic: json['enableClinic'] as bool? ?? false,
        enableSchool: json['enableSchool'] as bool? ?? false,
        enableGym: json['enableGym'] as bool? ?? false,
        enableWarehouse: json['enableWarehouse'] as bool? ?? false,
      );
}

class InvoiceLayoutSettings {
  bool showLogo;
  bool showCustomerInfo;
  bool showTax;
  bool showDiscount;
  bool showBarcode;
  bool showPrice;
  String paperSize;
  String fontSize;
  String? footerText;

  InvoiceLayoutSettings({
    this.showLogo = true,
    this.showCustomerInfo = true,
    this.showTax = true,
    this.showDiscount = true,
    this.showBarcode = false,
    this.showPrice = true,
    this.paperSize = '80mm',
    this.fontSize = 'medium',
    this.footerText,
  });

  Map<String, dynamic> toJson() => {
        'showLogo': showLogo,
        'showCustomerInfo': showCustomerInfo,
        'showTax': showTax,
        'showDiscount': showDiscount,
        'showBarcode': showBarcode,
        'showPrice': showPrice,
        'paperSize': paperSize,
        'fontSize': fontSize,
        'footerText': footerText,
      };

  factory InvoiceLayoutSettings.fromJson(Map<String, dynamic> json) =>
      InvoiceLayoutSettings(
        showLogo: json['showLogo'] as bool? ?? true,
        showCustomerInfo: json['showCustomerInfo'] as bool? ?? true,
        showTax: json['showTax'] as bool? ?? true,
        showDiscount: json['showDiscount'] as bool? ?? true,
        showBarcode: json['showBarcode'] as bool? ?? false,
        showPrice: json['showPrice'] as bool? ?? true,
        paperSize: json['paperSize'] as String? ?? '80mm',
        fontSize: json['fontSize'] as String? ?? 'medium',
        footerText: json['footerText'] as String?,
      );
}

class PharmacySettings {
  ProjectSettings project;
  TaxSettings tax;
  ItemsSettings items;
  SalesSettings sales;
  SystemSettings system;
  EmailSettings email;
  SmsSettings sms;
  RewardsSettings rewards;
  ShortcutsSettings shortcuts;
  ExtraUnitsSettings extraUnits;
  InvoiceLayoutSettings invoiceLayout;

  PharmacySettings({
    ProjectSettings? project,
    TaxSettings? tax,
    ItemsSettings? items,
    SalesSettings? sales,
    SystemSettings? system,
    EmailSettings? email,
    SmsSettings? sms,
    RewardsSettings? rewards,
    ShortcutsSettings? shortcuts,
    ExtraUnitsSettings? extraUnits,
    InvoiceLayoutSettings? invoiceLayout,
  })  : project = project ?? ProjectSettings(),
        tax = tax ?? TaxSettings(),
        items = items ?? ItemsSettings(),
        sales = sales ?? SalesSettings(),
        system = system ?? SystemSettings(),
        email = email ?? EmailSettings(),
        sms = sms ?? SmsSettings(),
        rewards = rewards ?? RewardsSettings(),
        shortcuts = shortcuts ?? ShortcutsSettings(),
        extraUnits = extraUnits ?? ExtraUnitsSettings(),
        invoiceLayout = invoiceLayout ?? InvoiceLayoutSettings();

  Map<String, dynamic> toJson() => {
        'project': project.toJson(),
        'tax': tax.toJson(),
        'items': items.toJson(),
        'sales': sales.toJson(),
        'system': system.toJson(),
        'email': email.toJson(),
        'sms': sms.toJson(),
        'rewards': rewards.toJson(),
        'shortcuts': shortcuts.toJson(),
        'extraUnits': extraUnits.toJson(),
        'invoiceLayout': invoiceLayout.toJson(),
      };

  factory PharmacySettings.fromJson(Map<String, dynamic> json) =>
      PharmacySettings(
        project: json['project'] != null
            ? ProjectSettings.fromJson(json['project'] as Map<String, dynamic>)
            : ProjectSettings(),
        tax: json['tax'] != null
            ? TaxSettings.fromJson(json['tax'] as Map<String, dynamic>)
            : TaxSettings(),
        items: json['items'] != null
            ? ItemsSettings.fromJson(json['items'] as Map<String, dynamic>)
            : ItemsSettings(),
        sales: json['sales'] != null
            ? SalesSettings.fromJson(json['sales'] as Map<String, dynamic>)
            : SalesSettings(),
        system: json['system'] != null
            ? SystemSettings.fromJson(json['system'] as Map<String, dynamic>)
            : SystemSettings(),
        email: json['email'] != null
            ? EmailSettings.fromJson(json['email'] as Map<String, dynamic>)
            : EmailSettings(),
        sms: json['sms'] != null
            ? SmsSettings.fromJson(json['sms'] as Map<String, dynamic>)
            : SmsSettings(),
        rewards: json['rewards'] != null
            ? RewardsSettings.fromJson(json['rewards'] as Map<String, dynamic>)
            : RewardsSettings(),
        shortcuts: json['shortcuts'] != null
            ? ShortcutsSettings.fromJson(
                json['shortcuts'] as Map<String, dynamic>)
            : ShortcutsSettings(),
        extraUnits: json['extraUnits'] != null
            ? ExtraUnitsSettings.fromJson(
                json['extraUnits'] as Map<String, dynamic>)
            : ExtraUnitsSettings(),
        invoiceLayout: json['invoiceLayout'] != null
            ? InvoiceLayoutSettings.fromJson(
                json['invoiceLayout'] as Map<String, dynamic>)
            : InvoiceLayoutSettings(),
      );
}
