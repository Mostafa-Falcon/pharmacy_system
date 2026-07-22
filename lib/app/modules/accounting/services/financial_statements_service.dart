import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/account_enums.dart';
import '../services/journal_entry_service.dart';

enum FinancialStatementType {
  balanceSheet,
  cashFlow,
  trialBalance,
  profitAndLoss,
}

class BalanceSheetRow {
  final String accountId;
  final String accountName;
  final String accountCode;
  final double debit;
  final double credit;
  final double balance;

  BalanceSheetRow({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}

class CashFlowRow {
  final String description;
  final double amount;
  final String category;

  CashFlowRow({
    required this.description,
    required this.amount,
    required this.category,
  });
}

class TrialBalanceRow {
  final String accountId;
  final String accountName;
  final String accountCode;
  final double debit;
  final double credit;

  TrialBalanceRow({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    required this.debit,
    required this.credit,
  });
}

class ProfitAndLossRow {
  final String accountId;
  final String accountName;
  final String accountCode;
  final double amount;

  ProfitAndLossRow({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
    required this.amount,
  });
}

class FinancialStatementsService {
  static Future<List<JournalEntryModel>> _getJournalEntries(String branchId, DateTime fromDate, DateTime toDate) async {
    final allEntries = await JournalEntryService.getAll(branchId: branchId);
    return allEntries.where((e) =>
      e.entryDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
      e.entryDate.isBefore(toDate.add(const Duration(days: 1)))
    ).toList();
  }

  static Future<List<BalanceSheetRow>> getBalanceSheet(String branchId, DateTime asOfDate) async {
    final entries = await _getJournalEntries(branchId, DateTime(1900), asOfDate);
    final accountMap = <String, _AccountBalance>{};

    for (final entry in entries) {
      for (final line in entry.lines) {
        final balance = accountMap.putIfAbsent(line.accountId, () => _AccountBalance(
          accountId: line.accountId,
          accountName: line.accountName,
          accountCode: line.accountCode,
        ));
        balance.debit += line.debit;
        balance.credit += line.credit;
      }
    }

    final assets = <BalanceSheetRow>[];
    final liabilities = <BalanceSheetRow>[];
    final equity = <BalanceSheetRow>[];

    for (final balance in accountMap.values) {
      final netBalance = balance.debit - balance.credit;
      if (netBalance.abs() < 0.01) continue;

      final row = BalanceSheetRow(
        accountId: balance.accountId,
        accountName: balance.accountName,
        accountCode: balance.accountCode,
        debit: balance.debit,
        credit: balance.credit,
        balance: netBalance.abs(),
      );

      if (_isAssetAccount(balance.accountId)) {
        assets.add(row);
      } else if (_isLiabilityAccount(balance.accountId)) {
        liabilities.add(row);
      } else {
        equity.add(row);
      }
    }

    return [...assets, ...liabilities, ...equity];
  }

  static Future<List<CashFlowRow>> getCashFlowStatement(String branchId, DateTime fromDate, DateTime toDate) async {
    final entries = await _getJournalEntries(branchId, fromDate, toDate);
    final operating = <CashFlowRow>[];
    final investing = <CashFlowRow>[];
    final financing = <CashFlowRow>[];

    double operatingTotal = 0;
    double investingTotal = 0;
    double financingTotal = 0;

    for (final entry in entries) {
      for (final line in entry.lines) {
        final amount = line.debit - line.credit;
        if (amount.abs() < 0.01) continue;

        final row = CashFlowRow(
          description: line.description ?? line.accountName,
          amount: amount.abs(),
          category: _categorizeCashFlow(line.accountId, entry.entryType),
        );

        switch (row.category) {
          case 'Operating':
            operating.add(row);
            operatingTotal += amount.abs();
            break;
          case 'Investing':
            investing.add(row);
            investingTotal += amount.abs();
            break;
          case 'Financing':
            financing.add(row);
            financingTotal += amount.abs();
            break;
        }
      }
    }

    return [
      ...operating,
      CashFlowRow(description: 'Operating Total', amount: operatingTotal, category: 'Operating'),
      ...investing,
      CashFlowRow(description: 'Investing Total', amount: investingTotal, category: 'Investing'),
      ...financing,
      CashFlowRow(description: 'Financing Total', amount: financingTotal, category: 'Financing'),
    ];
  }

  static Future<List<TrialBalanceRow>> getTrialBalance(String branchId, DateTime asOfDate) async {
    final entries = await _getJournalEntries(branchId, DateTime(1900), asOfDate);
    final accountMap = <String, _AccountBalance>{};

    for (final entry in entries) {
      for (final line in entry.lines) {
        final balance = accountMap.putIfAbsent(line.accountId, () => _AccountBalance(
          accountId: line.accountId,
          accountName: line.accountName,
          accountCode: line.accountCode,
        ));
        balance.debit += line.debit;
        balance.credit += line.credit;
      }
    }

    return accountMap.values.map((balance) {
      final netDebit = balance.debit - balance.credit;
      return TrialBalanceRow(
        accountId: balance.accountId,
        accountName: balance.accountName,
        accountCode: balance.accountCode,
        debit: netDebit > 0 ? netDebit : 0,
        credit: netDebit < 0 ? netDebit.abs() : 0,
      );
    }).toList();
  }

  static Future<List<ProfitAndLossRow>> getProfitAndLoss(String branchId, DateTime fromDate, DateTime toDate) async {
    final entries = await _getJournalEntries(branchId, fromDate, toDate);
    final revenues = <ProfitAndLossRow>[];
    final expenses = <ProfitAndLossRow>[];

    double totalRevenue = 0;
    double totalExpenses = 0;

    for (final entry in entries) {
      for (final line in entry.lines) {
        if (_isRevenueAccount(line.accountId)) {
          final amount = line.credit - line.debit;
          if (amount.abs() < 0.01) continue;
          revenues.add(ProfitAndLossRow(
            accountId: line.accountId,
            accountName: line.accountName,
            accountCode: line.accountCode,
            amount: amount,
          ));
          totalRevenue += amount;
        } else if (_isExpenseAccount(line.accountId)) {
          final amount = line.debit - line.credit;
          if (amount.abs() < 0.01) continue;
          expenses.add(ProfitAndLossRow(
            accountId: line.accountId,
            accountName: line.accountName,
            accountCode: line.accountCode,
            amount: amount,
          ));
          totalExpenses += amount;
        }
      }
    }

    return [
      ...revenues,
      ProfitAndLossRow(accountId: 'total_revenue', accountName: 'Ã˜Â¥Ã˜Â¬Ã™â€¦Ã˜Â§Ã™â€žÃ™Å  Ã˜Â§Ã™â€žÃ˜Â¥Ã™Å Ã˜Â±Ã˜Â§Ã˜Â¯Ã˜Â§Ã˜Âª', accountCode: '', amount: totalRevenue),
      ...expenses,
      ProfitAndLossRow(accountId: 'total_expenses', accountName: 'Ã˜Â¥Ã˜Â¬Ã™â€¦Ã˜Â§Ã™â€žÃ™Å  Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂµÃ˜Â±Ã™Ë†Ã™ÂÃ˜Â§Ã˜Âª', accountCode: '', amount: totalExpenses),
      ProfitAndLossRow(accountId: 'net_profit', accountName: 'Ã˜ÂµÃ˜Â§Ã™ÂÃ™Å  Ã˜Â§Ã™â€žÃ˜Â±Ã˜Â¨Ã˜Â­', accountCode: '', amount: totalRevenue - totalExpenses),
    ];
  }

  static bool _isAssetAccount(String accountId) {
    return accountId.startsWith('system:inventory') ||
           accountId.startsWith('system:cash') ||
           accountId.startsWith('system:bank') ||
           accountId.startsWith('system:card') ||
           accountId.startsWith('system:wallet') ||
           accountId.startsWith('system:accounts_receivable');
  }

  static bool _isLiabilityAccount(String accountId) {
    return accountId.startsWith('system:accounts_payable') ||
           accountId.startsWith('system:tax_payable');
  }

  static bool _isRevenueAccount(String accountId) {
    return accountId.startsWith('system:sales_revenue');
  }

  static bool _isExpenseAccount(String accountId) {
    return accountId.startsWith('system:cost_of_goods_sold') ||
           accountId.startsWith('system:expense') ||
           accountId.startsWith('system:inventory_shrinkage');
  }

  static String _categorizeCashFlow(String accountId, JournalEntryType entryType) {
    if (_isAssetAccount(accountId) || _isRevenueAccount(accountId)) {
      return 'Operating';
    }
    if (accountId.startsWith('system:inventory')) {
      return 'Investing';
    }
    if (accountId.startsWith('system:accounts_payable') || accountId.startsWith('system:accounts_receivable')) {
      return 'Financing';
    }
    return 'Operating';
  }
}

class _AccountBalance {
  final String accountId;
  String accountName;
  String accountCode;
  double debit = 0;
  double credit = 0;

  _AccountBalance({
    required this.accountId,
    required this.accountName,
    required this.accountCode,
  });
}

