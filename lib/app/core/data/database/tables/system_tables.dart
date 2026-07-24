import 'package:drift/drift.dart';

/// 👤 1. جدول المستخدمين والموظفين
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text().withDefault(const Constant('employee'))();
  TextColumn get assignedBranchId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  TextColumn get activeDeviceId => text().nullable()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🏬 2. جدول الفروع
class BranchesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isMainBranch => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔐 3. جدول الصلاحيات
class PermissionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get permissionKey => text()();
  BoolColumn get isAllowed => boolean().withDefault(const Constant(true))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// ⚙️ 4. جدول إعدادات المنظومة والصيدلية
class AppSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get pharmacyName => text().withDefault(const Constant('صيدليتي'))();
  TextColumn get pharmacyPhone => text().nullable()();
  TextColumn get pharmacyAddress => text().nullable()();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  BoolColumn get enableAutomaticPrint => boolean().withDefault(const Constant(false))();
  BoolColumn get enablePOSDrawer => boolean().withDefault(const Constant(true))();
  TextColumn get defaultReceiptFooter => text().nullable()();
  TextColumn get pharmacyNameEn => text().nullable()();
  TextColumn get commercialRegister => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get email => text().nullable()();
  IntColumn get defaultLowStockThreshold => integer().withDefault(const Constant(10))();
  IntColumn get nearExpiryAlertDays => integer().withDefault(const Constant(90))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🗑️ 5. جدول الأرشيف وسلة المهملات الموحدة الذكية
class ArchiveRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get entityTitle => text().named('entity_name')();
  TextColumn get entityDataJson => text()();
  TextColumn get deletedById => text()();
  TextColumn get deletedByName => text().withDefault(const Constant('المستخدم'))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime()();
  DateTimeColumn get restoredAt => dateTime().nullable()();
  TextColumn get restoredBy => text().nullable()();
  DateTimeColumn get permanentlyDeletedAt => dateTime().nullable()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🕵️ 6. جدول مراقبة وتدقيق المنظومة (Audit Log)
class AuditLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get actionType => text()();
  TextColumn get actionDetails => text()();
  TextColumn get performedById => text()();
  TextColumn get performedByName => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔔 7. جدول التنبيهات والإشعارات
class NotificationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get type => text().withDefault(const Constant('systemAlert'))();
  TextColumn get targetRoute => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📤 8. جدول صندوق عمليات المزامنة الخارجي (Sync Outbox)
class SyncOutboxTable extends Table {
  TextColumn get id => text()();
  TextColumn get operationType => text()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get payloadJson => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔄 9. جدول حالة وحاويات المزامنة (Sync State)
class SyncStateTable extends Table {
  TextColumn get id => text()();
  TextColumn get targetTable => text().named('table_name')();
  DateTimeColumn get lastSyncedAt => dateTime()();
  IntColumn get lastSyncedVersion => integer().withDefault(const Constant(0))();
  TextColumn get branchId => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔢 10. جدول عدادات وترقيم الإيصالات والفواتير
class ReceiptCountersTable extends Table {
  TextColumn get id => text()();
  TextColumn get counterType => text()();
  IntColumn get lastNumber => integer().withDefault(const Constant(0))();
  TextColumn get prefix => text().withDefault(const Constant(''))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  DateTimeColumn get lastModified => dateTime()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📋 11. جدول الأنواع والقوائم المرجعية (Lookups)
class LookupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ❌ 12. جدول سجل الأخطاء
class ErrorLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get source => text().nullable()();
  TextColumn get stackTrace => text().nullable()();
  TextColumn get severity => text().withDefault(const Constant('warning'))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔧 13. جدول سجل التصحيحات
class CorrectionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get referenceType => text()();
  TextColumn get referenceId => text()();
  TextColumn get action => text()();
  TextColumn get userId => text()();
  TextColumn get userDisplayName => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get details => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


