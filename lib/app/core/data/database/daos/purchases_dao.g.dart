// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_dao.dart';

// ignore_for_file: type=lint
mixin _$PurchasesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PurchaseInvoicesTableTable get purchaseInvoicesTable =>
      attachedDatabase.purchaseInvoicesTable;
  $SuppliedItemsTableTable get suppliedItemsTable =>
      attachedDatabase.suppliedItemsTable;
  PurchasesDaoManager get managers => PurchasesDaoManager(this);
}

class PurchasesDaoManager {
  final _$PurchasesDaoMixin _db;
  PurchasesDaoManager(this._db);
  $$PurchaseInvoicesTableTableTableManager get purchaseInvoicesTable =>
      $$PurchaseInvoicesTableTableTableManager(
        _db.attachedDatabase,
        _db.purchaseInvoicesTable,
      );
  $$SuppliedItemsTableTableTableManager get suppliedItemsTable =>
      $$SuppliedItemsTableTableTableManager(
        _db.attachedDatabase,
        _db.suppliedItemsTable,
      );
}
