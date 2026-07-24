import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/inventory_tables.dart';

part 'inventory_dao.g.dart';

/// 💊 كائن الاستعلامات والتنفيذ المالي والمخزني الموحد لحزمة الأصناف والمخزون
@DriftAccessor(tables: [
  MedicinesTable,
  ItemBatchesTable,
  ItemCategoriesTable,
  MedicineBrandsTable,
  ItemVariantsTable,
  ItemWarrantiesTable,
  PriceGroupsTable,
  StocktakingTable,
  StockAdjustmentsTable,
  ItemSwapsTable,
  OpeningStockTable,
  BarcodeSettingsTable,
  InventoryTransactionsTable,
])
class InventoryDao extends DatabaseAccessor<AppDatabase> with _$InventoryDaoMixin {
  InventoryDao(super.db);

  // ─── 1. الأدوية والأصناف ───
  Future<List<MedicinesTableData>> getAllMedicines() =>
      (select(medicinesTable)..where((t) => t.isDeleted.not())).get();

  Stream<List<MedicinesTableData>> watchAllMedicines() =>
      (select(medicinesTable)..where((t) => t.isDeleted.not())).watch();

  Future<MedicinesTableData?> getMedicineById(String id) =>
      (select(medicinesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertMedicine(MedicinesTableCompanion entry) async {
    await into(medicinesTable).insertOnConflictUpdate(entry);
  }

  // ─── 2. التشغيلات والصلاحيات (Batches & FEFO Auto Selection) ───
  Future<ItemBatchesTableData?> getFEFOBatch(String medicineId) =>
      (select(itemBatchesTable)
            ..where((t) =>
                t.medicineId.equals(medicineId) &
                t.isActive.equals(true) &
                t.isDeleted.not() &
                t.quantity.isBiggerThanValue(0))
            ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
          .getSingleOrNull();

  Future<void> upsertBatch(ItemBatchesTableCompanion batch) async {
    await into(itemBatchesTable).insertOnConflictUpdate(batch);
  }

  // ─── 3. الفئات، الماركات، والشرائح ───
  Future<List<ItemCategoriesTableData>> getAllCategories() =>
      (select(itemCategoriesTable)..where((t) => t.isDeleted.not())).get();

  Future<List<MedicineBrandsTableData>> getAllBrands() =>
      (select(medicineBrandsTable)..where((t) => t.isDeleted.not())).get();

  Future<List<PriceGroupsTableData>> getAllPriceGroups() =>
      (select(priceGroupsTable)..where((t) => t.isDeleted.not())).get();
}


