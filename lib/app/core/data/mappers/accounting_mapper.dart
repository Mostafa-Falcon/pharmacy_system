import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/accounting/account_tree_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_category_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/payment_voucher_model.dart';

import '../database/database.dart';

class AccountingMapper {
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
    syncVersion: const Value.absent(),
  );

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

  static JournalEntryModel journalEntryFromData(JournalEntriesTableData d) => JournalEntryModel(
    id: d.id,
    entryNumber: d.entryNumber,
    entryDate: d.entryDate,
    entryType: d.entryType,
    referenceNumber: d.referenceNumber,
    description: d.description,
    lines: (jsonDecode(d.lines) as List).map((e) => JournalEntryLineModel.fromJson(e)).toList(),
    totalDebit: d.totalDebit,
    totalCredit: d.totalCredit,
    createdById: d.createdById,
    branchId: d.branchId,
    accountId: d.accountId,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static JournalEntriesTableCompanion journalEntryToCompanion(JournalEntryModel m) => JournalEntriesTableCompanion(
    id: Value(m.id),
    entryNumber: Value(m.entryNumber),
    entryDate: Value(m.entryDate),
    entryType: Value(m.entryType),
    referenceNumber: Value(m.referenceNumber),
    description: Value(m.description),
    lines: Value(jsonEncode(m.lines.map((e) => e.toJson()).toList())),
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

  static PaymentVoucherModel paymentVoucherFromData(PaymentVouchersTableData d) => PaymentVoucherModel(
    id: d.id,
    voucherNumber: d.voucherNumber,
    voucherType: VoucherType.values.firstWhere(
      (t) => t.name == d.voucherType,
      orElse: () => VoucherType.receipt,
    ),
    partyId: d.partyId,
    partyName: d.partyName,
    amount: d.amount,
    paymentMethod: d.paymentMethod,
    referenceNumber: d.referenceNumber,
    description: d.description,
    createdById: d.createdById,
    branchId: d.branchId,
    accountId: d.accountId,
    voucherDate: d.voucherDate,
    createdAt: d.createdAt,
  );

  static PaymentVouchersTableCompanion paymentVoucherToCompanion(PaymentVoucherModel m) => PaymentVouchersTableCompanion(
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
    lastModified: const Value.absent(),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );
}