// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_dao.dart';

// ignore_for_file: type=lint
mixin _$ContactsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SuppliersTableTable get suppliersTable => attachedDatabase.suppliersTable;
  $CustomersTableTable get customersTable => attachedDatabase.customersTable;
  $SupplierCustomersTableTable get supplierCustomersTable =>
      attachedDatabase.supplierCustomersTable;
  $SalesRepsTableTable get salesRepsTable => attachedDatabase.salesRepsTable;
  $CustomerGroupsTableTable get customerGroupsTable =>
      attachedDatabase.customerGroupsTable;
  $ContactLedgersTableTable get contactLedgersTable =>
      attachedDatabase.contactLedgersTable;
  ContactsDaoManager get managers => ContactsDaoManager(this);
}

class ContactsDaoManager {
  final _$ContactsDaoMixin _db;
  ContactsDaoManager(this._db);
  $$SuppliersTableTableTableManager get suppliersTable =>
      $$SuppliersTableTableTableManager(
        _db.attachedDatabase,
        _db.suppliersTable,
      );
  $$CustomersTableTableTableManager get customersTable =>
      $$CustomersTableTableTableManager(
        _db.attachedDatabase,
        _db.customersTable,
      );
  $$SupplierCustomersTableTableTableManager get supplierCustomersTable =>
      $$SupplierCustomersTableTableTableManager(
        _db.attachedDatabase,
        _db.supplierCustomersTable,
      );
  $$SalesRepsTableTableTableManager get salesRepsTable =>
      $$SalesRepsTableTableTableManager(
        _db.attachedDatabase,
        _db.salesRepsTable,
      );
  $$CustomerGroupsTableTableTableManager get customerGroupsTable =>
      $$CustomerGroupsTableTableTableManager(
        _db.attachedDatabase,
        _db.customerGroupsTable,
      );
  $$ContactLedgersTableTableTableManager get contactLedgersTable =>
      $$ContactLedgersTableTableTableManager(
        _db.attachedDatabase,
        _db.contactLedgersTable,
      );
}
