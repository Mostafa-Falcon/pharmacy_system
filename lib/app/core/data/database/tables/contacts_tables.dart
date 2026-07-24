import 'package:drift/drift.dart';

/// 👥 1. مجموعات العملاء
class CustomerGroupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get discountPercent => real().withDefault(const Constant(0.0))();
  TextColumn get priceGroupId => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 👤 2. العملاء (Matching CustomerModel)
class CustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get secondPhone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  
  // Group Link
  TextColumn get groupId => text().nullable()();
  TextColumn get groupName => text().nullable()();

  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  RealColumn get discountPercent => real().withDefault(const Constant(0.0))();
  
  // Financials
  RealColumn get debitAmount => real().withDefault(const Constant(0.0))();
  RealColumn get creditAmount => real().withDefault(const Constant(0.0))();
  
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  
  TextColumn get branchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🚚 3. الموردين (Matching SupplierModel)
class SuppliersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get taxId => text().nullable()();
  
  // Financials
  RealColumn get creditAmount => real().withDefault(const Constant(0.0))();
  RealColumn get debitAmount => real().withDefault(const Constant(0.0))();
  
  IntColumn get paymentTermDays => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  
  TextColumn get branchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🤝 4. مورد/عميل موحد (Matching SupplierCustomerModel)
class SupplierCustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get companyName => text().nullable()();
  TextColumn get taxId => text().nullable()();
  
  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  RealColumn get discountPercent => real().withDefault(const Constant(0.0))();
  IntColumn get paymentTermDays => integer().withDefault(const Constant(0))();
  
  RealColumn get supplierBalance => real().withDefault(const Constant(0.0))();
  RealColumn get customerBalance => real().withDefault(const Constant(0.0))();
  
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  
  TextColumn get branchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 👔 5. مندوبي المبيعات
class SalesRepsTable extends Table {
  @override
  String get tableName => 'sales_agents';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  RealColumn get commissionPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get totalCommissionEarned => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  
  TextColumn get branchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📊 6. دفتر الأستاذ الموحد
class ContactLedgersTable extends Table {
  @override
  String get tableName => 'contact_ledger';

  TextColumn get id => text()();
  TextColumn get contactId => text()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get referenceNumber => text()();
  TextColumn get entryType => text()();
  RealColumn get debit => real().withDefault(const Constant(0.0))();
  RealColumn get credit => real().withDefault(const Constant(0.0))();
  RealColumn get balanceAfter => real().withDefault(const Constant(0.0))();
  TextColumn get description => text().nullable()();
  
  TextColumn get branchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


