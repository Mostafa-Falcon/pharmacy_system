import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/purchases_tables.dart';

part 'purchases_dao.g.dart';

/// 🧾 كائن الاستعلامات والتنفيذ المالي المباشر لموديول المشتريات والتوريدات
@DriftAccessor(tables: [
  PurchaseInvoicesTable,
  SuppliedItemsTable,
])
class PurchasesDao extends DatabaseAccessor<AppDatabase> with _$PurchasesDaoMixin {
  PurchasesDao(super.db);

  // ─── 1. فواتير المشتريات ───
  Future<List<PurchaseInvoicesTableData>> getInvoicesByBranch(String branchId) =>
      (select(purchaseInvoicesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<PurchaseInvoicesTableData?> getInvoiceById(String id) =>
      (select(purchaseInvoicesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertInvoice(PurchaseInvoicesTableCompanion invoice) async {
    await into(purchaseInvoicesTable).insertOnConflictUpdate(invoice);
  }

  // ─── 2. الأصناف الموردة ───
  Future<List<SuppliedItemsTableData>> getSuppliedItemsByMedicine(String medicineId) =>
      (select(suppliedItemsTable)
            ..where((t) => t.medicineId.equals(medicineId))
            ..orderBy([(t) => OrderingTerm.desc(t.lastPurchaseDate)]))
          .get();

  Future<void> insertSuppliedItems(List<SuppliedItemsTableCompanion> items) async {
    await db.batch((batch) {
      for (final item in items) {
        batch.insert(suppliedItemsTable, item, mode: InsertMode.insertOrReplace);
      }
    });
  }
}


