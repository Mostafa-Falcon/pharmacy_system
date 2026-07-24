import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/accounting/account_tree_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_category_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/payment_voucher_model.dart';

import '../database/database.dart';

class AccountingMapper {
  // ── AccountTree ──
  static AccountTreeModel accountTreeFromData(AccountTreeTableData d) => AccountTreeModel(
    id: d.id,
    accountCode: d.accountCode,
    name: d.name,
    accountType: AccountType.values.firstWhere(
      (t) => t.name == d.accountType,
      orElse: () => AccountType.expense,
    ),
    parentAccountId: d.parentAccountId,
    currentBalance: d.currentBalance,
    isDebitNature: d.isDebitNature,
    isSubAccount: d.isSubAccount,
    isActive: d.isActive,
    accountId: d.accountId,
    description: d.description,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static AccountTreeTableCompanion accountTreeToCompanion(AccountTreeModel m) => AccountTreeTableCompanion(
    id: Value(m.id),
    accountCode: Value(m.accountCode),
    name: Value(m.name),
    accountType: Value(m.accountType.name),
    parentAccountId: Value(m.parentAccountId),
    currentBalance: Value(m.currentBalance),
    isDebitNature: Value(m.isDebitNature),
    isSubAccount: Value(m.isSubAccount),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    description: Value(m.description),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  // ── ExpenseCategory ──
  static ExpenseCategoryModel expenseCategoryFromData(ExpenseCategoriesTableData d) => ExpenseCategoryModel(
    id: d.id,
    name: d.name,
    code: d.code,
    description: d.description,
    isActive: d.isActive,
    accountId: d.accountId,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static ExpenseCategoriesTableCompanion expenseCategoryToCompanion(ExpenseCategoryModel m) => ExpenseCategoriesTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    code: Value(m.code),
    description: Value(m.description),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ── Expense ──
  static ExpenseModel expenseFromData(ExpensesTableData d) => ExpenseModel(
    id: d.id,
    expenseNumber: d.expenseNumber,
    category: d.category,
    description: d.description,
    amount: d.amount,
    paymentMethod: d.paymentMethod,
    createdById: d.createdById,
    createdByName: d.createdByName,
    branchId: d.branchId,
    accountId: d.accountId,
    notes: d.notes,
    expenseDate: d.expenseDate,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static ExpensesTableCompanion expenseToCompanion(ExpenseModel m) => ExpensesTableCompanion(
    id: Value(m.id),
    expenseNumber: Value(m.expenseNumber),
    category: Value(m.category),
    description: Value(m.description),
    amount: Value(m.amount),
    paymentMethod: Value(m.paymentMethod),
    createdById: Value(m.createdById),
    createdByName: Value(m.createdByName),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    notes: Value(m.notes),
    expenseDate: Value(m.expenseDate),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  // ── JournalEntry ──
  static JournalEntryModel journalEntryFromData(JournalEntriesTableData d) => JournalEntryModel.fromJson({
    'id': d.id,
    'entry_number': d.entryNumber,
    'entry_date': d.entryDate.toIso8601String(),
    'entry_type': d.entryType,
    'reference_number': d.referenceNumber,
    'description': d.description,
    'lines': jsonDecode(d.lines),
    'total_debit': d.totalDebit,
    'total_credit': d.totalCredit,
    'created_by_id': d.createdById,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static JournalEntriesTableCompanion journalEntryToCompanion(JournalEntryModel m) {
    final json = m.toJson();
    return JournalEntriesTableCompanion(
      id: Value(m.id),
      entryNumber: Value(m.entryNumber),
      entryDate: Value(m.entryDate),
      entryType: Value(m.entryType),
      referenceNumber: Value(m.referenceNumber),
      description: Value(m.description),
      lines: Value(jsonEncode(json['lines'])),
      totalDebit: Value(m.totalDebit),
      totalCredit: Value(m.totalCredit),
      createdById: Value(m.createdById),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      createdAt: Value(m.createdAt),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  // ── PaymentVoucher ──
  static PaymentVoucherModel paymentVoucherFromData(PaymentVouchersTableData d) => PaymentVoucherModel.fromJson({
    'id': d.id,
    'voucher_number': d.voucherNumber,
    'voucher_type': d.voucherType,
    'party_id': d.partyId,
    'party_name': d.partyName,
    'amount': d.amount,
    'payment_method': d.paymentMethod,
    'reference_number': d.referenceNumber,
    'description': d.description,
    'created_by_id': d.createdById,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'voucher_date': d.voucherDate.toIso8601String(),
    'created_at': d.createdAt.toIso8601String(),
  });

  static PaymentVouchersTableCompanion paymentVoucherToCompanion(PaymentVoucherModel m) {
    return PaymentVouchersTableCompanion(
      id: Value(m.id),
      voucherNumber: Value(m.voucherNumber),
      voucherType: Value(m.voucherType.name),
      partyId: Value(m.partyId),
      partyName: Value(m.partyName),
      amount: Value(m.amount),
      paymentMethod: Value(m.paymentMethod),
      referenceNumber: Value(m.referenceNumber),
      description: Value(m.description),
      createdById: Value(m.createdById),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      voucherDate: Value(m.voucherDate),
      createdAt: Value(m.createdAt),
      isDeleted: const Value(false),
      syncVersion: const Value(1),
    );
  }
}
