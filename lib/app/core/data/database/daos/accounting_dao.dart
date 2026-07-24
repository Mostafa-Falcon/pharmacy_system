import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/accounting_tables.dart';

part 'accounting_dao.g.dart';

/// 🏛️ كائن الاستعلامات والتنفيذ المالي لـ شجرة الحسابات والمصاريف وقيود اليومية والسندات
@DriftAccessor(tables: [
  AccountTreeTable,
  ExpenseCategoriesTable,
  ExpensesTable,
  JournalEntriesTable,
  PaymentVouchersTable,
])
class AccountingDao extends DatabaseAccessor<AppDatabase> with _$AccountingDaoMixin {
  AccountingDao(super.db);

  // ─── 1. شجرة ودليل الحسابات المالية ───
  Future<List<AccountTreeTableData>> getAllAccounts() =>
      (select(accountTreeTable)..where((t) => t.isDeleted.not())).get();

  Future<AccountTreeTableData?> getAccountById(String id) =>
      (select(accountTreeTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertAccount(AccountTreeTableCompanion account) async {
    await into(accountTreeTable).insertOnConflictUpdate(account);
  }

  // ─── 2. فئات وقائمة المصاريف ───
  Future<List<ExpenseCategoriesTableData>> getAllExpenseCategories() =>
      (select(expenseCategoriesTable)..where((t) => t.isDeleted.not())).get();

  Future<void> upsertExpenseCategory(ExpenseCategoriesTableCompanion category) async {
    await into(expenseCategoriesTable).insertOnConflictUpdate(category);
  }

  Future<List<ExpensesTableData>> getExpensesByBranch(String branchId) =>
      (select(expensesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
          .get();

  Future<void> upsertExpense(ExpensesTableCompanion expense) async {
    await into(expensesTable).insertOnConflictUpdate(expense);
  }

  // ─── 3. قيود اليومية المزدوجة وسندات القبض والدفع ───
  Future<List<JournalEntriesTableData>> getJournalEntries(String branchId) =>
      (select(journalEntriesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
          .get();

  Future<void> upsertJournalEntry(JournalEntriesTableCompanion entry) async {
    await into(journalEntriesTable).insertOnConflictUpdate(entry);
  }

  Future<List<PaymentVouchersTableData>> getPaymentVouchers(String branchId) =>
      (select(paymentVouchersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.voucherDate)]))
          .get();

  Future<void> upsertPaymentVoucher(PaymentVouchersTableCompanion voucher) async {
    await into(paymentVouchersTable).insertOnConflictUpdate(voucher);
  }
}


