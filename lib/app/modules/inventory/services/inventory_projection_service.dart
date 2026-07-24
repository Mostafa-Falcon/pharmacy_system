import 'package:get_it/get_it.dart';

import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';

class InventoryProjectionService {
  static final InventoryProjectionService _instance = InventoryProjectionService._internal();
  factory InventoryProjectionService() => _instance;
  InventoryProjectionService._internal();

  static InventoryProjectionService get to => GetIt.instance<InventoryProjectionService>();

  int getCurrentStock(String branchId, String medicineId) {
    final medicines =
        BranchDataService.getMedicines(branchId: branchId);
    final medicine = medicines.cast<MedicineModel?>().firstWhere(
          (m) => m!.id == medicineId,
          orElse: () => null,
        );
    return medicine?.quantity ?? 0;
  }

  double getStockValue(String branchId) {
    final medicines =
        BranchDataService.getMedicines(branchId: branchId);
    return medicines.fold<double>(
      0,
      (sum, m) => sum + (m.quantity * m.buyPrice),
    );
  }

  List<MedicineModel> getLowStockItems(String branchId, {int threshold = 10}) {
    final medicines =
        BranchDataService.getMedicines(branchId: branchId);
    return medicines
        .where((m) => !m.isDeleted && m.quantity <= threshold)
        .toList()
      ..sort((a, b) => a.quantity.compareTo(b.quantity));
  }

  List<MedicineModel> getExpiringItems(String branchId, {int days = 30}) {
    final medicines =
        BranchDataService.getMedicines(branchId: branchId);
    final now = DateTime.now();
    final cutoff = now.add(Duration(days: days));
    return medicines
        .where(
          (m) =>
              !m.isDeleted &&
              m.expiryDate != null &&
              m.expiryDate!.isAfter(now) &&
              m.expiryDate!.isBefore(cutoff),
        )
        .toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
  }
}




