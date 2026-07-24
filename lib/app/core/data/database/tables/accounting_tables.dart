import 'package:drift/drift.dart';

/// 🏛️ 1. جدول شجرة ودليل الحسابات المالية
class AccountTreeTable extends Table {
  TextColumn get id => text()();
  TextColumn get accountCode => text()();
  TextColumn get name => text()();
  TextColumn get accountType => text()();
  TextColumn get parentAccountId => text().nullable()();
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isDebitNature => boolean().withDefault(const Constant(true))();
  BoolColumn get isSubAccount => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📂 2. جدول فئات وتصنيفات المصاريف
class ExpenseCategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 💵 3. جدول قائمة وتفاصيل المصاريف
class ExpensesTable extends Table {
  TextColumn get id => text()();
  IntColumn get expenseNumber => integer().withDefault(const Constant(1))();
  TextColumn get category => text()(); // From Seed Model
  TextColumn get description => text().nullable()();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get createdById => text()();
  TextColumn get createdByName => text().nullable()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expenseDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ⚖️ 4. جدول قيود اليومية المزدوجة
class JournalEntriesTable extends Table {
  TextColumn get id => text()();
  IntColumn get entryNumber => integer().withDefault(const Constant(1))();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get entryType => text().withDefault(const Constant('general'))();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  
  // JSON Field (Matching Seed Model)
  TextColumn get lines => text()(); // List<JournalEntryLineModel>
  
  RealColumn get totalDebit => real().withDefault(const Constant(0.0))();
  RealColumn get totalCredit => real().withDefault(const Constant(0.0))();
  TextColumn get createdById => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🧾 5. جدول سندات القبض والدفع
class PaymentVouchersTable extends Table {
  TextColumn get id => text()();
  IntColumn get voucherNumber => integer().withDefault(const Constant(1))();
  TextColumn get voucherType => text().withDefault(const Constant('receipt'))();
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text()();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get createdById => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get voucherDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


