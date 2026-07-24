import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/contacts_tables.dart';

part 'contacts_dao.g.dart';

/// 👥 كائن الاستعلامات والتنفيذ المباشر لجهات التعامل (الموردين، العملاء، الجهة المزدوجة، المناديب)
@DriftAccessor(tables: [
  SuppliersTable,
  CustomersTable,
  SupplierCustomersTable,
  SalesRepsTable,
  CustomerGroupsTable,
  ContactLedgersTable,
])
class ContactsDao extends DatabaseAccessor<AppDatabase> with _$ContactsDaoMixin {
  ContactsDao(super.db);

  // ─── 1. الموردين ───
  Future<List<SuppliersTableData>> getAllSuppliers() =>
      (select(suppliersTable)..where((t) => t.isDeleted.not())).get();

  Future<SuppliersTableData?> getSupplierById(String id) =>
      (select(suppliersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertSupplier(SuppliersTableCompanion supplier) async {
    await into(suppliersTable).insertOnConflictUpdate(supplier);
  }

  Future<void> softDeleteSupplier(String id) async {
    await (update(suppliersTable)..where((t) => t.id.equals(id)))
        .write(const SuppliersTableCompanion(isDeleted: Value(true)));
  }

  // ─── 2. العملاء ───
  Future<List<CustomersTableData>> getAllCustomers() =>
      (select(customersTable)..where((t) => t.isDeleted.not())).get();

  Future<CustomersTableData?> getCustomerById(String id) =>
      (select(customersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertCustomer(CustomersTableCompanion customer) async {
    await into(customersTable).insertOnConflictUpdate(customer);
  }

  Future<void> softDeleteCustomer(String id) async {
    await (update(customersTable)..where((t) => t.id.equals(id)))
        .write(const CustomersTableCompanion(isDeleted: Value(true)));
  }
  
  Future<List<CustomersTableData>> searchCustomers(String query) {
    if (query.isEmpty) return getAllCustomers();
    return (select(customersTable)
          ..where((t) =>
              t.isDeleted.not() &
              (t.name.contains(query) |
                  t.phone.contains(query) |
                  t.secondPhone.contains(query))))
        .get();
  }

  // ─── 3. الجهة المزدوجة ───
  Future<List<SupplierCustomersTableData>> getAllSupplierCustomers() =>
      (select(supplierCustomersTable)..where((t) => t.isDeleted.not())).get();

  Future<SupplierCustomersTableData?> getSupplierCustomerById(String id) =>
      (select(supplierCustomersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertSupplierCustomer(SupplierCustomersTableCompanion entry) async {
    await into(supplierCustomersTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDeleteSupplierCustomer(String id) async {
    await (update(supplierCustomersTable)..where((t) => t.id.equals(id)))
        .write(const SupplierCustomersTableCompanion(isDeleted: Value(true)));
  }

  // ─── 4. مندوبي المبيعات والتوزيع ───
  Future<List<SalesRepsTableData>> getAllSalesReps() =>
      (select(salesRepsTable)..where((t) => t.isDeleted.not())).get();

  Future<void> upsertSalesAgent(SalesRepsTableCompanion agent) async {
    await into(salesRepsTable).insertOnConflictUpdate(agent);
  }

  // ─── 5. كشف الحساب ودفتر الأستاذ ───
  Future<List<ContactLedgersTableData>> getAllContactLedgers() =>
      (select(contactLedgersTable)..where((t) => t.isDeleted.not())).get();

  Future<ContactLedgersTableData?> getLedgerById(String id) =>
      (select(contactLedgersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<ContactLedgersTableData>> getLedgerByContact(String contactId) =>
      (select(contactLedgersTable)
            ..where((t) => t.contactId.equals(contactId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
          .get();

  Future<void> insertLedgerEntry(ContactLedgersTableCompanion entry) async {
    await into(contactLedgersTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDeleteLedger(String id) async {
    await (update(contactLedgersTable)..where((t) => t.id.equals(id)))
        .write(const ContactLedgersTableCompanion(isDeleted: Value(true)));
  }

  // ─── Backward Compatibility Helpers ───
  Future<List<ContactLedgersTableData>> getAll() => getAllContactLedgers();
  Future<ContactLedgersTableData?> getById(String id) => getLedgerById(id);
  Future<void> upsert(ContactLedgersTableCompanion entry) => insertLedgerEntry(entry);
  Future<void> softDelete(String id) => softDeleteLedger(id);
}

// ─── Backward Compatibility Typedefs ───
typedef CustomersDao = ContactsDao;
typedef SuppliersDao = ContactsDao;
typedef SupplierCustomersDao = ContactsDao;
typedef SalesRepsDao = ContactsDao;
typedef CustomerGroupsDao = ContactsDao;
typedef CustomerLedgersDao = ContactsDao;
typedef SupplierLedgersDao = ContactsDao;
