import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/inventory/barcode_settings_model.dart';
import '../services/barcode_code_service.dart';

enum BarcodeSettingsStatus { initial, loading, loaded, saving, error }

class BarcodeSettingsState extends Equatable {
  final BarcodeSettingsStatus status;
  final String? error;

  // form fields
  final String prefix;
  final int serialLength;
  final int formatIndex;
  final double labelWidth;
  final double labelHeight;
  final bool showPrice;
  final bool showName;
  final bool showBarcode;
  final int printLayoutIndex;
  final int copiesPerItem;
  final String pharmacyName;
  final bool usePharmacySignature;

  // computed from fields
  final String previewCode;

  static const formatOptions = ['shortCode128', 'ean13'];
  static const layoutOptions = ['labelPrinter', 'a4Sheet'];

  const BarcodeSettingsState({
    this.status = BarcodeSettingsStatus.initial,
    this.error,
    this.prefix = '20',
    this.serialLength = 8,
    this.formatIndex = 0,
    this.labelWidth = 62,
    this.labelHeight = 32,
    this.showPrice = true,
    this.showName = true,
    this.showBarcode = true,
    this.printLayoutIndex = 0,
    this.copiesPerItem = 1,
    this.pharmacyName = '',
    this.usePharmacySignature = false,
    this.previewCode = '',
  });

  BarcodeGenerationFormat get generationFormat =>
      BarcodeGenerationFormat.values[formatIndex.clamp(0, 1)];

  BarcodePrintLayout get printLayout =>
      BarcodePrintLayout.values[printLayoutIndex.clamp(0, 1)];

  BarcodeSettingsState copyWith({
    BarcodeSettingsStatus? status,
    String? error,
    bool clearError = false,
    String? prefix,
    int? serialLength,
    int? formatIndex,
    double? labelWidth,
    double? labelHeight,
    bool? showPrice,
    bool? showName,
    bool? showBarcode,
    int? printLayoutIndex,
    int? copiesPerItem,
    String? pharmacyName,
    bool? usePharmacySignature,
    String? previewCode,
  }) {
    return BarcodeSettingsState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      prefix: prefix ?? this.prefix,
      serialLength: serialLength ?? this.serialLength,
      formatIndex: formatIndex ?? this.formatIndex,
      labelWidth: labelWidth ?? this.labelWidth,
      labelHeight: labelHeight ?? this.labelHeight,
      showPrice: showPrice ?? this.showPrice,
      showName: showName ?? this.showName,
      showBarcode: showBarcode ?? this.showBarcode,
      printLayoutIndex: printLayoutIndex ?? this.printLayoutIndex,
      copiesPerItem: copiesPerItem ?? this.copiesPerItem,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      usePharmacySignature: usePharmacySignature ?? this.usePharmacySignature,
      previewCode: previewCode ?? this.previewCode,
    );
  }

  static String _computePreview(BarcodeSettingsState s) {
    final fmt = s.generationFormat;
    final effPrefix = s.usePharmacySignature && s.pharmacyName.trim().isNotEmpty
        ? BarcodeCodeService.pharmacySignaturePrefix(s.pharmacyName)
        : BarcodeCodeService.normalizePrefix(s.prefix);
    final nextSerial = 1;
    final max = BarcodeCodeService.maxSerial(
      format: fmt,
      prefix: effPrefix,
      shortCodeLength: s.serialLength,
    );
    if (nextSerial > max) return '';
    return BarcodeCodeService.fromSerial(
      serial: nextSerial,
      format: fmt,
      prefix: effPrefix,
      shortCodeLength: s.serialLength,
    );
  }

  static BarcodeSettingsState refreshPreview(BarcodeSettingsState s) {
    final preview = _computePreview(s);
    return s.copyWith(previewCode: preview);
  }

  @override
  List<Object?> get props => [
        status,
        error,
        prefix,
        serialLength,
        formatIndex,
        labelWidth,
        labelHeight,
        showPrice,
        showName,
        showBarcode,
        printLayoutIndex,
        copiesPerItem,
        pharmacyName,
        usePharmacySignature,
        previewCode,
      ];
}




