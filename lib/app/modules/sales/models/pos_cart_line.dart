import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';

class PosCartLine {
  final MedicineModel medicine;
  final int quantity;
  final double unitPrice;
  final double discountPercent;
  final String? unitName;
  final double conversionFactor;

  PosCartLine({
    required this.medicine,
    required this.quantity,
    double? unitPrice,
    this.discountPercent = 0,
    this.unitName,
    this.conversionFactor = 1.0,
  }) : unitPrice = unitPrice ?? medicine.sellPrice;

  double get lineGross => unitPrice * quantity;

  int get totalPieces => (quantity * conversionFactor).toInt();

  double get discountAmount =>
      double.parse((lineGross * discountPercent / 100).toStringAsFixed(2));

  double get lineTotal =>
      double.parse((lineGross - discountAmount).toStringAsFixed(2));

  double get taxPercent => medicine.isTaxable ? (medicine.taxValue ?? 0) : 0;

  double get taxAmount =>
      double.parse((lineTotal * taxPercent / 100).toStringAsFixed(2));

  double get lineNet =>
      double.parse((lineTotal + taxAmount).toStringAsFixed(2));

  PosCartLine copyWith({
    MedicineModel? medicine,
    int? quantity,
    double? unitPrice,
    double? discountPercent,
    String? unitName,
    double? conversionFactor,
  }) {
    return PosCartLine(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      unitName: unitName ?? this.unitName,
      conversionFactor: conversionFactor ?? this.conversionFactor,
    );
  }

  Map<String, dynamic> toJson() => {
    'medicine_id': medicine.id,
    'medicine_name': medicine.name,
    'quantity': quantity,
    'unit_price': unitPrice,
    'discount_percent': discountPercent,
    'unit_name': unitName,
    'conversion_factor': conversionFactor,
  };
}

