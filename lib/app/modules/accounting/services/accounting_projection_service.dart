import 'dart:convert';

import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/expenses_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/journal_entries_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/accounting/models/expense_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/account_enums.dart';

class AccountBalanceProjection {
  final String accountId;
  final String accountName;
  final AccountType type;
  final double debit;
  final double credit;
  final double balance;

  const AccountBalanceProjection({
    required this.accountId,
    required this.accountName,
    required this.type,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}

class AccountingSummaryProjection {
  final double revenue;
  final double costOfGoodsSold;
  final double operatingExpenses;
  final double grossProfit;
  final double netProfit;
  final double assets;
  final double liabilities;
  final double totalDebit;
  final double totalCredit;

  const AccountingSummaryProjection({
    required this.revenue,
    required this.costOfGoodsSold,
    required this.operatingExpenses,
    required this.grossProfit,
    required this.netProfit,
    required this.assets,
    required this.liabilities,
    required this.totalDebit,
    required this.totalCredit,
  });

  bool get balanced => (totalDebit - totalCredit).abs() < 0.01;
}

class AccountingProjectionService {
  static final JournalEntriesDao _journalDao = sl<JournalEntriesDao>();
  static final ExpensesDao _expensesDao = sl<ExpensesDao>();

  static const Map<String, String> _arabicNames = {
    'system:cash': 'Ã˜Â§Ã™â€žÃ˜Â®Ã˜Â²Ã™Å Ã™â€ Ã˜Â© Ã˜Â§Ã™â€žÃ˜Â±Ã˜Â¦Ã™Å Ã˜Â³Ã™Å Ã˜Â©',
    'system:bank': 'Ã˜Â§Ã™â€žÃ˜Â¨Ã™â€ Ã™Æ’',
    'system:card_clearing': 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â·Ã˜Â§Ã™â€šÃ˜Â§Ã˜Âª',
    'system:mobile_wallet': 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â­Ã˜Â§Ã™ÂÃ˜Â¸ Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å Ã˜Â©',
    'system:accounts_receivable': 'Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â¡',
    'system:accounts_payable': 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
    'system:inventory': 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
    'system:sales_revenue': 'Ã˜Â¥Ã™Å Ã˜Â±Ã˜Â§Ã˜Â¯Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¨Ã™Å Ã˜Â¹Ã˜Â§Ã˜Âª',
    'system:tax_payable': 'Ã˜Â¶Ã˜Â±Ã™Å Ã˜Â¨Ã˜Â© Ã™â€¦Ã˜Â³Ã˜ÂªÃ˜Â­Ã™â€šÃ˜Â©',
    'system:cost_of_goods_sold': 'Ã˜ÂªÃ™Æ’Ã™â€žÃ™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â¶Ã˜Â§Ã˜Â¹Ã˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¨Ã˜Â§Ã˜Â¹Ã˜Â©',
    'system:inventory_gain': 'Ã˜Â£Ã˜Â±Ã˜Â¨Ã˜Â§Ã˜Â­ Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
    'system:inventory_shrinkage': 'Ã˜Â¹Ã˜Â¬Ã˜Â² Ã™Ë†Ã˜ÂªÃ˜Â§Ã™â€žÃ™Â Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
    'system:supplier_adjustments': 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â§Ã˜Âª Ã™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Å Ã™â€ ',
    'system:purchase_discounts': 'Ã˜Â®Ã˜ÂµÃ™Ë†Ã™â€¦Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â´Ã˜ÂªÃ˜Â±Ã™Å Ã˜Â§Ã˜Âª',
    'system:opening_balance_equity': 'Ã˜Â­Ã™â€šÃ™Ë†Ã™â€š Ã™â€¦Ã™â€žÃ™Æ’Ã™Å Ã˜Â© Ã˜Â§Ã™ÂÃ˜ÂªÃ˜ÂªÃ˜Â§Ã˜Â­Ã™Å Ã˜Â©',
  };

  static Future<List<JournalEntryModel>> getJournals({
    String? branchId,
    DateTime? from,
    DateTime? to,
  }) async {
    final rows = await _journalDao.getAll();
    var entries = rows
        .where((e) => !e.isDeleted)
        .where((e) => branchId == null || e.branchId == branchId)
        .map(_toJournalModel)
        .where((e) {
          if (from != null && e.entryDate.isBefore(_startOfDay(from))) return false;
          if (to != null && e.entryDate.isAfter(_endOfDay(to))) return false;
          return true;
        })
        .toList();
    entries.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return entries;
  }

  static Future<List<ExpenseModel>> getExpenses({
    String? branchId,
    DateTime? from,
    DateTime? to,
  }) async {
    final rows = await _expensesDao.getAll();
    var expenses = rows
        .where((e) => !e.isDeleted)
        .where((e) => branchId == null || e.branchId == branchId)
        .map(_toExpenseModel)
        .where((e) {
          if (from != null && e.expenseDate.isBefore(_startOfDay(from))) return false;
          if (to != null && e.expenseDate.isAfter(_endOfDay(to))) return false;
          return true;
        })
        .toList();
    expenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return expenses;
  }

  static Future<List<AccountBalanceProjection>> getBalances({
    String? branchId,
    DateTime? from,
    DateTime? to,
  }) async {
    final journals = await getJournals(branchId: branchId, from: from, to: to);
    final totals = <String, _MutableBalance>{};

    for (final entry in journals) {
      for (final line in entry.lines) {
        final current = totals.putIfAbsent(
          line.accountId,
          () => _MutableBalance(
            accountId: line.accountId,
            name: _accountName(line.accountId, line.accountName),
            type: _accountType(line.accountId),
          ),
        );
        current.debit += line.debit;
        current.credit += line.credit;
      }
    }

    final values = totals.values.map((v) {
      final naturalDebit = v.type == AccountType.asset || v.type == AccountType.expense;
      final balance = naturalDebit ? v.debit - v.credit : v.credit - v.debit;
      return AccountBalanceProjection(
        accountId: v.accountId,
        accountName: v.name,
        type: v.type,
        debit: _money(v.debit),
        credit: _money(v.credit),
        balance: _money(balance),
      );
    }).toList();

    values.sort((a, b) {
      final byType = a.type.index.compareTo(b.type.index);
      return byType == 0 ? a.accountName.compareTo(b.accountName) : byType;
    });
    return values;
  }

  static Future<AccountingSummaryProjection> getSummary({
    String? branchId,
    DateTime? from,
    DateTime? to,
  }) async {
    final values = await getBalances(branchId: branchId, from: from, to: to);
    var revenue = 0.0;
    var costOfGoodsSold = 0.0;
    var operatingExpenses = 0.0;
    var assets = 0.0;
    var liabilities = 0.0;
    var totalDebit = 0.0;
    var totalCredit = 0.0;

    for (final v in values) {
      totalDebit += v.debit;
      totalCredit += v.credit;
      if (v.type == AccountType.asset) assets += v.balance;
      if (v.type == AccountType.liability) liabilities += v.balance;
      if (v.type == AccountType.income) revenue += v.balance;
      if (v.accountId == 'system:cost_of_goods_sold') {
        costOfGoodsSold += v.balance;
      } else if (v.type == AccountType.expense) {
        operatingExpenses += v.balance;
      }
    }

    final grossProfit = revenue - costOfGoodsSold;
    return AccountingSummaryProjection(
      revenue: _money(revenue),
      costOfGoodsSold: _money(costOfGoodsSold),
      operatingExpenses: _money(operatingExpenses),
      grossProfit: _money(grossProfit),
      netProfit: _money(grossProfit - operatingExpenses),
      assets: _money(assets),
      liabilities: _money(liabilities),
      totalDebit: _money(totalDebit),
      totalCredit: _money(totalCredit),
    );
  }

  static Future<List<Map<String, dynamic>>> getRecentActivity({
    String? branchId,
    int limit = 10,
  }) async {
    final activities = <Map<String, dynamic>>[];

    final journalRows = await _journalDao.getAll();
    for (final row in journalRows) {
      if (row.isDeleted) continue;
      if (branchId != null && row.branchId != branchId) continue;
      final entry = _toJournalModel(row);
      activities.add({
        'type': 'journal',
        'id': entry.id,
        'date': entry.entryDate,
        'number': entry.entryNumber,
        'description': entry.description ?? 'Ã™â€šÃ™Å Ã˜Â¯ Ã™Å Ã™Ë†Ã™â€¦Ã™Å ',
        'amount': entry.totalDebit,
      });
    }

    final expenseRows = await _expensesDao.getAll();
    for (final row in expenseRows) {
      if (row.isDeleted) continue;
      if (branchId != null && row.branchId != branchId) continue;
      final expense = _toExpenseModel(row);
      activities.add({
        'type': 'expense',
        'id': expense.id,
        'date': expense.expenseDate,
        'number': expense.expenseNumber,
        'description': expense.description ?? expense.category,
        'amount': expense.amount,
      });
    }

    activities.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return activities.take(limit).toList();
  }

  static ExpenseModel _toExpenseModel(ExpensesTableData d) => ExpenseModel(
    id: d.id,
    branchId: d.branchId,
    expenseNumber: d.expenseNumber,
    expenseDate: d.expenseDate,
    category: d.category,
    description: d.description,
    amount: d.amount,
    paymentMethod: d.paymentMethod,
    createdById: d.createdById,
    createdByName: d.createdByName,
    notes: d.notes,
    createdAt: d.createdAt,
    updatedAt: d.updatedAt,
  );

  static AccountType _accountType(String accountId) {
    if (accountId.startsWith('system:expense:') ||
        accountId == 'system:cost_of_goods_sold' ||
        accountId == 'system:inventory_shrinkage') {
      return AccountType.expense;
    }
    if (accountId == 'system:sales_revenue' || accountId == 'system:inventory_gain') {
      return AccountType.income;
    }
    if (accountId == 'system:accounts_payable' || accountId == 'system:tax_payable') {
      return AccountType.liability;
    }
    if (accountId.startsWith('system:equity')) return AccountType.equity;
    return AccountType.asset;
  }

  static String _accountName(String accountId, String? supplied) {
    if (supplied?.trim().isNotEmpty == true) return supplied!.trim();
    if (_arabicNames.containsKey(accountId)) return _arabicNames[accountId]!;
    if (accountId.startsWith('system:expense:')) {
      return accountId.substring('system:expense:'.length).replaceAll('_', ' ');
    }
    return accountId;
  }

  static DateTime _startOfDay(DateTime value) => DateTime(value.year, value.month, value.day);
  static DateTime _endOfDay(DateTime value) => DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  static double _money(double value) => (value * 100).roundToDouble() / 100;

  static JournalEntryModel _toJournalModel(JournalEntriesTableData d) {
    List<JournalEntryLineModel> lines = [];
    try {
      final decoded = jsonDecode(d.lines);
      if (decoded is List) {
        lines = decoded
            .map((e) => JournalEntryLineModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}

    return JournalEntryModel(
      id: d.id,
      branchId: d.branchId,
      entryNumber: d.entryNumber,
      entryDate: d.entryDate,
      entryType: JournalEntryType.values.firstWhere(
        (e) => e.name == d.entryType,
        orElse: () => JournalEntryType.other,
      ),
      referenceId: d.referenceId,
      referenceNumber: d.referenceNumber,
      description: d.description,
      lines: lines,
      totalDebit: d.totalDebit,
      totalCredit: d.totalCredit,
      createdById: d.createdById,
      createdByName: d.createdByName,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
    );
  }
}

class _MutableBalance {
  final String accountId;
  final String name;
  final AccountType type;
  double debit = 0;
  double credit = 0;
  _MutableBalance({required this.accountId, required this.name, required this.type});
}

