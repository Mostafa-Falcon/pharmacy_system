import 'package:pharmacy_system/app/modules/inventory/services/barcode_code_service.dart';

enum BarcodePrintLayout {
  labelPrinter,
  a4Sheet,
}

class BarcodeSettingsModel {
  const BarcodeSettingsModel({
    this.prefix = '20',
    this.shortCodeLength = 8,
    this.generationFormat = BarcodeGenerationFormat.shortCode128,
    this.lastSerial = 0,
    this.labelWidthMm = 62,
    this.labelHeightMm = 32,
    this.copiesPerItem = 1,
    this.showPrice = true,
    this.showItemName = true,
    this.showUnitName = true,
    this.showHumanReadableCode = true,
    this.showExpiry = false,
    this.showBatch = false,
    this.printLayout = BarcodePrintLayout.labelPrinter,
    this.serialReserved = 0,
    this.companyPrefix = '',
    this.eanCountryCode = '000',
    this.pharmacyName = '',
    this.showPharmacyName = false,
    this.usePharmacySignature = false,
    this.directPrint = false,
    this.printerUrl = '',
    this.printerName = '',
    this.itemsPerRow = 4,
  });

  final String prefix;
  final int shortCodeLength;
  final BarcodeGenerationFormat generationFormat;
  final int lastSerial;
  final double labelWidthMm;
  final double labelHeightMm;
  final int copiesPerItem;
  final bool showPrice;
  final bool showItemName;
  final bool showUnitName;
  final bool showHumanReadableCode;
  final bool showExpiry;
  final bool showBatch;
  final BarcodePrintLayout printLayout;
  final int serialReserved;
  final String companyPrefix;
  final String eanCountryCode;
  final String pharmacyName;
  final bool showPharmacyName;
  final bool usePharmacySignature;
  final bool directPrint;
  final String printerUrl;
  final String printerName;
  final int itemsPerRow;

  String get effectivePrefix => usePharmacySignature && pharmacyName.trim().isNotEmpty
      ? BarcodeCodeService.pharmacySignaturePrefix(pharmacyName)
      : BarcodeCodeService.normalizePrefix(prefix);

  factory BarcodeSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BarcodeSettingsModel();
    return BarcodeSettingsModel(
      prefix: (json['prefix'] as String?) ?? '20',
      shortCodeLength: (json['shortCodeLength'] as num?)?.toInt() ?? 8,
      generationFormat: _generationFormatFromJson(json['generationFormat']),
      lastSerial: (json['lastSerial'] as num?)?.toInt() ?? 0,
      labelWidthMm: (json['labelWidthMm'] as num?)?.toDouble() ?? 62,
      labelHeightMm: (json['labelHeightMm'] as num?)?.toDouble() ?? 32,
      copiesPerItem: (json['copiesPerItem'] as num?)?.toInt() ?? 1,
      showPrice: json['showPrice'] as bool? ?? true,
      showItemName: json['showItemName'] as bool? ?? true,
      showUnitName: json['showUnitName'] as bool? ?? true,
      showHumanReadableCode: json['showHumanReadableCode'] as bool? ?? true,
      showExpiry: json['showExpiry'] as bool? ?? false,
      showBatch: json['showBatch'] as bool? ?? false,
      printLayout: _printLayoutFromJson(json['printLayout']),
      serialReserved: (json['serialReserved'] as num?)?.toInt() ?? 0,
      companyPrefix: (json['companyPrefix'] as String?) ?? '',
      eanCountryCode: (json['eanCountryCode'] as String?) ?? '000',
      pharmacyName: (json['pharmacyName'] as String?) ?? '',
      showPharmacyName: json['showPharmacyName'] as bool? ?? false,
      usePharmacySignature: json['usePharmacySignature'] as bool? ?? false,
      directPrint: json['directPrint'] as bool? ?? false,
      printerUrl: (json['printerUrl'] as String?) ?? '',
      printerName: (json['printerName'] as String?) ?? '',
      itemsPerRow: (json['itemsPerRow'] as num?)?.toInt() ?? 4,
    ).normalized();
  }

  BarcodeSettingsModel normalized() {
    final safeFormat = generationFormat;
    final safeLength = shortCodeLength.clamp(6, 12).toInt();
    final safePrefix = BarcodeCodeService.normalizePrefix(
      prefix,
      maxLength: safeFormat == BarcodeGenerationFormat.ean13
          ? 4
          : (safeLength - 1).clamp(1, 4).toInt(),
    );
    final resolvedPrefix = usePharmacySignature && pharmacyName.trim().isNotEmpty
        ? BarcodeCodeService.pharmacySignaturePrefix(pharmacyName)
        : safePrefix;
    final maxSerial = BarcodeCodeService.maxSerial(
      format: safeFormat,
      prefix: resolvedPrefix,
      shortCodeLength: safeLength,
    );
    final safeLast = lastSerial.clamp(0, maxSerial).toInt();
    final selectedPrinterUrl = printerUrl.trim();
    final safeItemsPerRow = itemsPerRow.clamp(1, 10).toInt();

    return BarcodeSettingsModel(
      prefix: safePrefix,
      shortCodeLength: safeLength,
      generationFormat: safeFormat,
      lastSerial: safeLast,
      labelWidthMm: labelWidthMm.clamp(30, 120).toDouble(),
      labelHeightMm: labelHeightMm.clamp(18, 80).toDouble(),
      copiesPerItem: copiesPerItem.clamp(1, 100).toInt(),
      showPrice: showPrice,
      showItemName: showItemName,
      showUnitName: showUnitName,
      showHumanReadableCode: showHumanReadableCode,
      showExpiry: showExpiry,
      showBatch: showBatch,
      printLayout: printLayout,
      serialReserved: serialReserved.clamp(0, maxSerial).toInt(),
      companyPrefix: companyPrefix.trim(),
      eanCountryCode: eanCountryCode.trim(),
      pharmacyName: pharmacyName.trim(),
      showPharmacyName: showPharmacyName && pharmacyName.trim().isNotEmpty,
      usePharmacySignature: usePharmacySignature && pharmacyName.trim().isNotEmpty,
      directPrint: directPrint && selectedPrinterUrl.isNotEmpty,
      printerUrl: selectedPrinterUrl,
      printerName: printerName.trim(),
      itemsPerRow: safeItemsPerRow,
    );
  }

  BarcodeSettingsModel copyWith({
    String? prefix,
    int? shortCodeLength,
    BarcodeGenerationFormat? generationFormat,
    int? lastSerial,
    double? labelWidthMm,
    double? labelHeightMm,
    int? copiesPerItem,
    bool? showPrice,
    bool? showItemName,
    bool? showUnitName,
    bool? showHumanReadableCode,
    bool? showExpiry,
    bool? showBatch,
    BarcodePrintLayout? printLayout,
    int? serialReserved,
    String? companyPrefix,
    String? eanCountryCode,
    String? pharmacyName,
    bool? showPharmacyName,
    bool? usePharmacySignature,
    bool? directPrint,
    String? printerUrl,
    String? printerName,
    int? itemsPerRow,
  }) {
    return BarcodeSettingsModel(
      prefix: prefix ?? this.prefix,
      shortCodeLength: shortCodeLength ?? this.shortCodeLength,
      generationFormat: generationFormat ?? this.generationFormat,
      lastSerial: lastSerial ?? this.lastSerial,
      labelWidthMm: labelWidthMm ?? this.labelWidthMm,
      labelHeightMm: labelHeightMm ?? this.labelHeightMm,
      copiesPerItem: copiesPerItem ?? this.copiesPerItem,
      showPrice: showPrice ?? this.showPrice,
      showItemName: showItemName ?? this.showItemName,
      showUnitName: showUnitName ?? this.showUnitName,
      showHumanReadableCode:
          showHumanReadableCode ?? this.showHumanReadableCode,
      showExpiry: showExpiry ?? this.showExpiry,
      showBatch: showBatch ?? this.showBatch,
      printLayout: printLayout ?? this.printLayout,
      serialReserved: serialReserved ?? this.serialReserved,
      companyPrefix: companyPrefix ?? this.companyPrefix,
      eanCountryCode: eanCountryCode ?? this.eanCountryCode,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      showPharmacyName: showPharmacyName ?? this.showPharmacyName,
      usePharmacySignature:
          usePharmacySignature ?? this.usePharmacySignature,
      directPrint: directPrint ?? this.directPrint,
      printerUrl: printerUrl ?? this.printerUrl,
      printerName: printerName ?? this.printerName,
      itemsPerRow: itemsPerRow ?? this.itemsPerRow,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'prefix': prefix,
        'shortCodeLength': shortCodeLength,
        'generationFormat': generationFormat.name,
        'lastSerial': lastSerial,
        'labelWidthMm': labelWidthMm,
        'labelHeightMm': labelHeightMm,
        'copiesPerItem': copiesPerItem,
        'showPrice': showPrice,
        'showItemName': showItemName,
        'showUnitName': showUnitName,
        'showHumanReadableCode': showHumanReadableCode,
        'showExpiry': showExpiry,
        'showBatch': showBatch,
        'printLayout': printLayout.name,
        'serialReserved': serialReserved,
        'companyPrefix': companyPrefix,
        'eanCountryCode': eanCountryCode,
        'pharmacyName': pharmacyName,
        'showPharmacyName': showPharmacyName,
        'usePharmacySignature': usePharmacySignature,
        'directPrint': directPrint,
        'printerUrl': printerUrl,
        'printerName': printerName,
        'itemsPerRow': itemsPerRow,
      };

  static BarcodeGenerationFormat _generationFormatFromJson(Object? raw) {
    final value = raw?.toString().trim();
    return BarcodeGenerationFormat.values.firstWhere(
      (item) => item.name == value,
      orElse: () => BarcodeGenerationFormat.shortCode128,
    );
  }

  static BarcodePrintLayout _printLayoutFromJson(Object? raw) {
    final value = raw?.toString().trim();
    return BarcodePrintLayout.values.firstWhere(
      (item) => item.name == value,
      orElse: () => BarcodePrintLayout.labelPrinter,
    );
  }
}
