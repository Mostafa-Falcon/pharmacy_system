import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';

class PosCartLine {
  final MedicineModel medicine;
  final int unitLevel;
  final String unitName;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double taxAmount;

  PosCartLine({
    required this.medicine,
    this.unitLevel = 1,
    this.unitName = 'علبة',
    this.quantity = 1,
    required this.unitPrice,
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
  });

  double get lineGross => unitPrice * quantity;
  double get lineTotal => lineGross - discountAmount + taxAmount;

  // Backward compatibility fields if needed by UI
  int get totalPieces => quantity; // Simplification

  PosCartLine copyWith({
    MedicineModel? medicine,
    int? unitLevel,
    String? unitName,
    int? quantity,
    double? unitPrice,
    double? discountAmount,
    double? taxAmount,
  }) {
    return PosCartLine(
      medicine: medicine ?? this.medicine,
      unitLevel: unitLevel ?? this.unitLevel,
      unitName: unitName ?? this.unitName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }
}
