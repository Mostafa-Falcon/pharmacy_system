import 'package:get_it/get_it.dart';

import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';

class ReconciliationResult {
  final List<ReconciliationVariance> variances;
  final int totalChecked;
  final int totalMatched;
  final int totalVariances;

  const ReconciliationResult({
    required this.variances,
    required this.totalChecked,
    required this.totalMatched,
    required this.totalVariances,
  });

  double get totalDifferenceValue {
    return variances.fold<double>(
        0, (sum, v) => sum + v.differenceValue);
  }
}

class ReconciliationVariance {
  final String medicineId;
  final String medicineName;
  final int systemQuantity;
  final int actualQuantity;
  final int difference;
  final double buyPrice;

  double get differenceValue => difference.abs() * buyPrice;

  const ReconciliationVariance({
    required this.medicineId,
    required this.medicineName,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.difference,
    required this.buyPrice,
  });
}

class InventoryReconciliationService {
  static final InventoryReconciliationService _instance = InventoryReconciliationService._internal();
  factory InventoryReconciliationService() => _instance;
  InventoryReconciliationService._internal();

  static InventoryReconciliationService get to => GetIt.instance<InventoryReconciliationService>();

  ReconciliationResult reconcile({
    required String branchId,
    required List<PhysicalCount> counts,
  }) {
    final variances = <ReconciliationVariance>[];
    var matched = 0;

    for (final count in counts) {
      final medicine =
          BranchDataService.getMedicine(count.medicineId);
      if (medicine == null) continue;

      final system = medicine.quantity;
      final diff = count.actualQuantity - system;

      if (diff != 0) {
        variances.add(ReconciliationVariance(
          medicineId: medicine.id,
          medicineName: medicine.name,
          systemQuantity: system,
          actualQuantity: count.actualQuantity,
          difference: diff,
          buyPrice: medicine.buyPrice,
        ));
      } else {
        matched++;
      }
    }

    return ReconciliationResult(
      variances: variances,
      totalChecked: counts.length,
      totalMatched: matched,
      totalVariances: variances.length,
    );
  }
}

class PhysicalCount {
  final String medicineId;
  final int actualQuantity;

  const PhysicalCount({
    required this.medicineId,
    required this.actualQuantity,
  });
}


