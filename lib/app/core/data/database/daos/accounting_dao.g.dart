// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_dao.dart';

// ignore_for_file: type=lint
mixin _$AccountingDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountTreeTableTable get accountTreeTable =>
      attachedDatabase.accountTreeTable;
  $ExpenseCategoriesTableTable get expenseCategoriesTable =>
      attachedDatabase.expenseCategoriesTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  $JournalEntriesTableTable get journalEntriesTable =>
      attachedDatabase.journalEntriesTable;
  $PaymentVouchersTableTable get paymentVouchersTable =>
      attachedDatabase.paymentVouchersTable;
  AccountingDaoManager get managers => AccountingDaoManager(this);
}

class AccountingDaoManager {
  final _$AccountingDaoMixin _db;
  AccountingDaoManager(this._db);
  $$AccountTreeTableTableTableManager get accountTreeTable =>
      $$AccountTreeTableTableTableManager(
        _db.attachedDatabase,
        _db.accountTreeTable,
      );
  $$ExpenseCategoriesTableTableTableManager get expenseCategoriesTable =>
      $$ExpenseCategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.expenseCategoriesTable,
      );
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db.attachedDatabase, _db.expensesTable);
  $$JournalEntriesTableTableTableManager get journalEntriesTable =>
      $$JournalEntriesTableTableTableManager(
        _db.attachedDatabase,
        _db.journalEntriesTable,
      );
  $$PaymentVouchersTableTableTableManager get paymentVouchersTable =>
      $$PaymentVouchersTableTableTableManager(
        _db.attachedDatabase,
        _db.paymentVouchersTable,
      );
}
