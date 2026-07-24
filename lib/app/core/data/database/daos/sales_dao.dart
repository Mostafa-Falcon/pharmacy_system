import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sales_tables.dart';

part 'sales_dao.g.dart';

/// 🧾 كائن الاستعلامات والتنفيذ المالي والمبيعات الموحد
@DriftAccessor(tables: [
  SaleInvoicesTable,
  InvoiceReturnsTable,
  FreeReturnsTable,
  CashierShiftsTable,
  ShippingOrdersTable,
  QuotationsTable,
  SuspendedSalesTable,
  PromotionsTable,
])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  // ─── 1. فواتير المبيعات ───
  Future<List<SaleInvoicesTableData>> getInvoicesByBranch(String branchId) =>
      (select(saleInvoicesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<SaleInvoicesTableData>> watchInvoicesByBranch(String branchId) =>
      (select(saleInvoicesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<SaleInvoicesTableData?> getInvoiceById(String id) =>
      (select(saleInvoicesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertInvoice(SaleInvoicesTableCompanion invoice) async {
    await into(saleInvoicesTable).insertOnConflictUpdate(invoice);
  }

  // ─── 2. المرتجع المربوط والمرتجع الحر ───
  Future<List<InvoiceReturnsTableData>> getInvoiceReturns(String branchId) =>
      (select(invoiceReturnsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<FreeReturnsTableData>> getFreeReturns(String branchId) =>
      (select(freeReturnsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<void> upsertInvoiceReturn(InvoiceReturnsTableCompanion entry) async {
    await into(invoiceReturnsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertFreeReturn(FreeReturnsTableCompanion entry) async {
    await into(freeReturnsTable).insertOnConflictUpdate(entry);
  }

  // ─── 3. ورديات الكاشير وإذونات الشحن ───
  Future<CashierShiftsTableData?> getActiveShift(String cashierId) =>
      (select(cashierShiftsTable)
            ..where((t) => t.cashierId.equals(cashierId) & t.status.equals('open') & t.isDeleted.not()))
          .getSingleOrNull();

  Future<void> upsertShift(CashierShiftsTableCompanion shift) async {
    await into(cashierShiftsTable).insertOnConflictUpdate(shift);
  }

  Future<List<ShippingOrdersTableData>> getShippingOrders(String branchId) =>
      (select(shippingOrdersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.shippingDate)]))
          .get();

  Future<void> upsertShippingOrder(ShippingOrdersTableCompanion order) async {
    await into(shippingOrdersTable).insertOnConflictUpdate(order);
  }
}


