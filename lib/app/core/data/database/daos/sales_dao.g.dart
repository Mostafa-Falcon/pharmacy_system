// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_dao.dart';

// ignore_for_file: type=lint
mixin _$SalesDaoMixin on DatabaseAccessor<AppDatabase> {
  $SaleInvoicesTableTable get saleInvoicesTable =>
      attachedDatabase.saleInvoicesTable;
  $InvoiceReturnsTableTable get invoiceReturnsTable =>
      attachedDatabase.invoiceReturnsTable;
  $FreeReturnsTableTable get freeReturnsTable =>
      attachedDatabase.freeReturnsTable;
  $CashierShiftsTableTable get cashierShiftsTable =>
      attachedDatabase.cashierShiftsTable;
  $ShippingOrdersTableTable get shippingOrdersTable =>
      attachedDatabase.shippingOrdersTable;
  $QuotationsTableTable get quotationsTable => attachedDatabase.quotationsTable;
  $SuspendedSalesTableTable get suspendedSalesTable =>
      attachedDatabase.suspendedSalesTable;
  $PromotionsTableTable get promotionsTable => attachedDatabase.promotionsTable;
  SalesDaoManager get managers => SalesDaoManager(this);
}

class SalesDaoManager {
  final _$SalesDaoMixin _db;
  SalesDaoManager(this._db);
  $$SaleInvoicesTableTableTableManager get saleInvoicesTable =>
      $$SaleInvoicesTableTableTableManager(
        _db.attachedDatabase,
        _db.saleInvoicesTable,
      );
  $$InvoiceReturnsTableTableTableManager get invoiceReturnsTable =>
      $$InvoiceReturnsTableTableTableManager(
        _db.attachedDatabase,
        _db.invoiceReturnsTable,
      );
  $$FreeReturnsTableTableTableManager get freeReturnsTable =>
      $$FreeReturnsTableTableTableManager(
        _db.attachedDatabase,
        _db.freeReturnsTable,
      );
  $$CashierShiftsTableTableTableManager get cashierShiftsTable =>
      $$CashierShiftsTableTableTableManager(
        _db.attachedDatabase,
        _db.cashierShiftsTable,
      );
  $$ShippingOrdersTableTableTableManager get shippingOrdersTable =>
      $$ShippingOrdersTableTableTableManager(
        _db.attachedDatabase,
        _db.shippingOrdersTable,
      );
  $$QuotationsTableTableTableManager get quotationsTable =>
      $$QuotationsTableTableTableManager(
        _db.attachedDatabase,
        _db.quotationsTable,
      );
  $$SuspendedSalesTableTableTableManager get suspendedSalesTable =>
      $$SuspendedSalesTableTableTableManager(
        _db.attachedDatabase,
        _db.suspendedSalesTable,
      );
  $$PromotionsTableTableTableManager get promotionsTable =>
      $$PromotionsTableTableTableManager(
        _db.attachedDatabase,
        _db.promotionsTable,
      );
}
