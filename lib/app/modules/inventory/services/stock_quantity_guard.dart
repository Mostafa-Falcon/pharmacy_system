import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';

class StockQuantityGuard {
  StockQuantityGuard._();

  static double getAvailableQuantity(String branchId, String medicineId) {
    final medicines =
        BranchDataService.getMedicines(branchId: branchId);
    final medicine = medicines.cast<MedicineModel?>().firstWhere(
          (m) => m!.id == medicineId,
          orElse: () => null,
        );
    if (medicine == null) return 0;
    return medicine.quantity.toDouble();
  }

  static bool canTransfer(
      String branchId, String medicineId, double quantity) {
    final available = getAvailableQuantity(branchId, medicineId);
    final medicine = _getMedicine(medicineId);
    if (medicine == null) return false;
    return medicine.allowNegativeStock || available >= quantity;
  }

  static void ensureSufficientStock(
      String branchId, String medicineId, double quantity,
      {String medicineName = ''}) {
    final medicine = _getMedicine(medicineId);
    if (medicine == null) {
      throw StateError('الصنف غير موجود');
    }
    final available = medicine.quantity.toDouble();
    if (available < quantity && !medicine.allowNegativeStock) {
      throw StateError(
        'الكمية المتاحة من "${medicine.name}" غير كافية'
        ' (المتاح: $available، المطلوب: $quantity)',
      );
    }
  }

  static MedicineModel? _getMedicine(String medicineId) {
    return BranchDataService.getMedicine(medicineId);
  }
}

