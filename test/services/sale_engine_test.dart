import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/modules/sales/models/pos_cart_line.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';

void main() {
  group('PosCartLine', () {
    final medicine = MedicineModel(
      id: 'med_1',
      name: 'Panadol',
      nameEn: 'Panadol',
      category: 'Pain',
      barcodes: const ['123456'],
      buyPrice: 10,
      sellPrice: 15,
      quantity: 100,
      minStock: 10,
      branchId: 'br_1',
      syncVersion: 1,
      lastModified: DateTime.now(),
      isDeleted: false,
      expiryTrackingEnabled: false,
      units: const [],
      alertEnabled: false,
      dosageFormEnabled: false,
      allowNegativeStock: false,
      isTaxable: false,
      pricesIncludeTax: false,
      isActive: true,
      createdAt: DateTime.now(),
    );

    test('lineGross computes correctly', () {
      final line = PosCartLine(medicine: medicine, quantity: 3, unitPrice: 15);
      expect(line.lineGross, 45.0);
    });

    test('lineTotal applies discount', () {
      final line = PosCartLine(medicine: medicine, quantity: 2, unitPrice: 10, discountPercent: 10);
      expect(line.lineGross, 20.0);
      expect(line.discountAmount.toStringAsFixed(2), '2.00');
      expect(line.lineTotal.toStringAsFixed(2), '18.00');
    });

    test('taxAmount is zero when not taxable', () {
      final line = PosCartLine(medicine: medicine, quantity: 2, unitPrice: 15);
      expect(line.taxAmount, 0);
    });

    test('taxAmount computes correctly when taxable', () {
      final taxableMedicine = MedicineModel(
        id: 'med_2',
        name: 'Taxed',
        nameEn: 'Taxed',
        category: 'Rx',
        barcodes: const [],
        buyPrice: 10,
        sellPrice: 15,
        quantity: 100,
        minStock: 10,
        branchId: 'br_1',
        syncVersion: 1,
        lastModified: DateTime.now(),
        isDeleted: false,
        expiryTrackingEnabled: false,
        units: const [],
        alertEnabled: false,
        dosageFormEnabled: false,
        allowNegativeStock: false,
        isTaxable: true,
        taxValue: 14,
        pricesIncludeTax: false,
        isActive: true,
        createdAt: DateTime.now(),
      );
      final line = PosCartLine(medicine: taxableMedicine, quantity: 2, unitPrice: 15);
      expect(line.taxPercent, 14);
      expect(line.taxAmount.toStringAsFixed(2), '4.20');
    });

    test('copyWith creates modified copy', () {
      final line = PosCartLine(medicine: medicine, quantity: 2, unitPrice: 15);
      final copied = line.copyWith(quantity: 5);
      expect(copied.quantity, 5);
      expect(copied.medicine.id, medicine.id);
    });
  });
}
