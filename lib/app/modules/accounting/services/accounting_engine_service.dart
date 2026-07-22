import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/account_enums.dart';
import 'journal_entry_service.dart';

class SalesAccountingPolicy {
  final String cashAccountId;
  final String cardAccountId;
  final String bankAccountId;
  final String walletAccountId;
  final String receivablesAccountId;
  final String salesRevenueAccountId;
  final String taxPayableAccountId;
  final String inventoryAccountId;
  final String costOfGoodsSoldAccountId;

  const SalesAccountingPolicy({
    this.cashAccountId = 'system:cash',
    this.cardAccountId = 'system:card_clearing',
    this.bankAccountId = 'system:bank',
    this.walletAccountId = 'system:mobile_wallet',
    this.receivablesAccountId = 'system:accounts_receivable',
    this.salesRevenueAccountId = 'system:sales_revenue',
    this.taxPayableAccountId = 'system:tax_payable',
    this.inventoryAccountId = 'system:inventory',
    this.costOfGoodsSoldAccountId = 'system:cost_of_goods_sold',
  });
}

class PurchaseAccountingPolicy {
  final String inventoryAccountId;
  final String accountsPayableAccountId;
  final String cashAccountId;

  const PurchaseAccountingPolicy({
    this.inventoryAccountId = 'system:inventory',
    this.accountsPayableAccountId = 'system:accounts_payable',
    this.cashAccountId = 'system:cash',
  });
}

class ReturnAccountingPolicy {
  final String cashAccountId;
  final String cardAccountId;
  final String bankAccountId;
  final String walletAccountId;
  final String receivablesAccountId;
  final String salesRevenueAccountId;
  final String taxPayableAccountId;
  final String inventoryAccountId;
  final String costOfGoodsSoldAccountId;
  final String accountsPayableAccountId;

  const ReturnAccountingPolicy({
    this.cashAccountId = 'system:cash',
    this.cardAccountId = 'system:card_clearing',
    this.bankAccountId = 'system:bank',
    this.walletAccountId = 'system:mobile_wallet',
    this.receivablesAccountId = 'system:accounts_receivable',
    this.salesRevenueAccountId = 'system:sales_revenue',
    this.taxPayableAccountId = 'system:tax_payable',
    this.inventoryAccountId = 'system:inventory',
    this.costOfGoodsSoldAccountId = 'system:cost_of_goods_sold',
    this.accountsPayableAccountId = 'system:accounts_payable',
  });
}

class InventoryAccountingPolicy {
  final String inventoryAccountId;
  final String inventoryGainAccountId;
  final String inventoryLossAccountId;

  const InventoryAccountingPolicy({
    this.inventoryAccountId = 'system:inventory',
    this.inventoryGainAccountId = 'system:inventory_gain',
    this.inventoryLossAccountId = 'system:inventory_shrinkage',
  });
}

class SalesAccountingService {
  const SalesAccountingService({this.policy = const SalesAccountingPolicy()});
  final SalesAccountingPolicy policy;

  Future<JournalEntryModel> buildEntry({
    required SaleModel sale,
    required String actorId,
    double paidTotal = 0,
  }) async {
    final lines = <JournalEntryLineModel>[];
    final method = sale.paymentMethod;
    final amount = sale.finalAmount;
    final isCredit = method == 'credit';
    final isMixed = method == 'mixed';

    if (isCredit) {
      // Ã˜Â¢Ã˜Â¬Ã™â€ž Ã˜Â¨Ã˜Â§Ã™â€žÃ™Æ’Ã˜Â§Ã™â€¦Ã™â€ž Ã¢â€ ’ Ã™â€¦Ã˜Â¯Ã™Å Ã™Ë†Ã™â€ Ã™Å Ã˜Â© Ã™Æ’Ã˜Â§Ã™â€¦Ã™â€žÃ˜Â© Ã™ÂÃ™Å  Ã˜Â§Ã™â€žÃ˜Â°Ã™â€¦Ã™â€¦.
      lines.add(_line(
        accountId: policy.receivablesAccountId,
        debit: amount,
        description: 'Ã™ÂÃ˜Â§Ã˜ÂªÃ™Ë†Ã˜Â±Ã˜Â© Ã˜Â¢Ã˜Â¬Ã™â€žÃ˜Â© ${sale.id}',
      ));
    } else if (isMixed) {
      // Ã™â€¦Ã˜Â®Ã˜ÂªÃ™â€žÃ˜Â·: Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹ Ã™ÂÃ™Å  Ã˜Â­Ã˜Â³Ã˜Â§Ã˜Â¨ Ã˜Â§Ã™â€žÃ˜Â¯Ã™ÂÃ˜Â¹ + Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂªÃ˜Â¨Ã™â€šÃ™Å  Ã™ÂÃ™Å  Ã˜Â§Ã™â€žÃ˜Â°Ã™â€¦Ã™â€¦ (Ã˜Â§Ã™â€žÃ˜Â¢Ã˜Â¬Ã™â€ž).
      final paid = _money(paidTotal.clamp(0, amount));
      final due = _money((amount - paid).clamp(0, double.infinity));
      if (paid > 0) {
        lines.add(_line(
          accountId: _paymentAccount('cash'),
          debit: paid,
          description: 'Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â®Ã˜ÂªÃ™â€žÃ˜Â·Ã˜Â© ${sale.id}',
        ));
      }
      if (due > 0) {
        lines.add(_line(
          accountId: policy.receivablesAccountId,
          debit: due,
          description: 'Ã™â€¦Ã˜Â³Ã˜ÂªÃ˜Â­Ã™â€š Ã˜Â¢Ã˜Â¬Ã™â€ž (Ã™â€¦Ã˜Â®Ã˜ÂªÃ™â€žÃ˜Â·) ${sale.id}',
        ));
      }
    } else {
      lines.add(_line(
        accountId: _paymentAccount(method),
        debit: amount,
        description: 'Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª ${_methodLabel(method)}',
      ));
    }

    final revenue = amount;
    lines.add(_line(
      accountId: policy.salesRevenueAccountId,
      credit: revenue,
      description: 'Ã˜Â¥Ã™Å Ã˜Â±Ã˜Â§Ã˜Â¯ Ã™â€¦Ã˜Â¨Ã™Å Ã˜Â¹Ã˜Â§Ã˜Âª',
    ));

    final totalCost = sale.items.fold<double>(
      0,
      (sum, item) => sum + (item.costPrice * item.quantity),
    );
    if (totalCost > 0) {
      lines.add(_line(
        accountId: policy.costOfGoodsSoldAccountId,
        debit: totalCost,
        description: 'Ã˜ÂªÃ™Æ’Ã™â€žÃ™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â¶Ã˜Â§Ã˜Â¹Ã˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¨Ã˜Â§Ã˜Â¹Ã˜Â©',
      ));
      lines.add(_line(
        accountId: policy.inventoryAccountId,
        credit: totalCost,
        description: 'Ã˜ÂªÃ˜Â®Ã™ÂÃ™Å Ã˜Â¶ Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
      ));
    }

    return _finalize(
      id: 'journal:sale:${sale.id}',
      branchId: sale.branchId,
      date: sale.createdAt,
      type: JournalEntryType.sales,
      referenceId: sale.id,
      referenceNumber: sale.id,
      description: 'Ã™ÂÃ˜Â§Ã˜ÂªÃ™Ë†Ã˜Â±Ã˜Â© Ã˜Â¨Ã™Å Ã˜Â¹ #${sale.id.substring(0, 8)}',
      actorId: actorId,
      occurredAt: sale.createdAt,
      lines: lines,
    );
  }

  String _paymentAccount(String method) {
    switch (method) {
      case 'cash': return policy.cashAccountId;
      case 'card': return policy.cardAccountId;
      case 'bank': return policy.bankAccountId;
      case 'wallet': return policy.walletAccountId;
      default: return policy.cashAccountId;
    }
  }

  String _methodLabel(String m) {
    switch (m) {
      case 'cash': return 'Ã™â€ Ã™â€šÃ˜Â¯Ã™Å Ã˜Â©';
      case 'card': return 'Ã˜Â¨Ã˜Â·Ã˜Â§Ã™â€šÃ˜Â©';
      case 'bank': return 'Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â¨Ã™â€ Ã™Æ’Ã™Å ';
      case 'wallet': return 'Ã™â€¦Ã˜Â­Ã™ÂÃ˜Â¸Ã˜Â© Ã˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å Ã˜Â©';
      default: return m;
    }
  }

  JournalEntryLineModel _line({
    required String accountId,
    double debit = 0,
    double credit = 0,
    String? description,
  }) {
    return JournalEntryLineModel(
      id: const Uuid().v4(),
      accountId: accountId,
      debit: _money(debit),
      credit: _money(credit),
      description: description,
    );
  }

  Future<JournalEntryModel> _finalize({
    required String id,
    required String branchId,
    required DateTime date,
    required JournalEntryType type,
    required String referenceId,
    required String referenceNumber,
    required String description,
    required String actorId,
    required DateTime occurredAt,
    required List<JournalEntryLineModel> lines,
  }) async {
    final debit = _money(lines.fold<double>(0, (sum, l) => sum + l.debit));
    final credit = _money(lines.fold<double>(0, (sum, l) => sum + l.credit));
    if ((debit - credit).abs() > 0.01) {
      throw StateError('Ã™â€šÃ™Å Ã™Ë†Ã˜Â¯ Ã˜ÂºÃ™Å Ã˜Â± Ã™â€¦Ã˜ÂªÃ˜Â²Ã™â€ Ã˜Â©. Ã˜Â§Ã™â€žÃ˜Â®Ã˜ÂµÃ™â€¦: $debit, Ã˜Â§Ã™â€žÃ˜Â¯Ã˜Â§Ã˜Â¦Ã™â€ : $credit');
    }
    final entry = JournalEntryModel(
      id: id,
      branchId: branchId,
      entryNumber: await JournalEntryService.nextNumber(branchId),
      entryDate: date,
      entryType: type,
      referenceId: referenceId,
      referenceNumber: referenceNumber,
      description: description,
      lines: lines,
      totalDebit: debit,
      totalCredit: credit,
      createdById: actorId,
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );
    await JournalEntryService.create(entry);
    return entry;
  }

  double _money(double value) => (value * 100).roundToDouble() / 100;
}

class PurchaseAccountingService {
  const PurchaseAccountingService({this.policy = const PurchaseAccountingPolicy()});
  final PurchaseAccountingPolicy policy;

  Future<JournalEntryModel> buildEntry({
    required PurchaseModel purchase,
    required String actorId,
    required double paidAmount,
    required String paymentAccountId,
  }) async {
    final total = _money(purchase.totalAmount);
    final paid = _money(min(paidAmount, total));
    final due = _money(total - paid);

    final lines = <JournalEntryLineModel>[
      _line(
        accountId: policy.inventoryAccountId,
        debit: total,
        description: 'Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€  Ã™Ë†Ã˜Â§Ã˜Â±Ã˜Â¯',
      ),
      if (paid > 0)
        _line(
          accountId: paymentAccountId,
          credit: paid,
          description: 'Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª Ã™â€žÃ™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
        ),
      if (due > 0)
        _line(
          accountId: policy.accountsPayableAccountId,
          credit: due,
          description: 'Ã™â€¦Ã˜Â³Ã˜ÂªÃ˜Â­Ã™â€š Ã™â€žÃ™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
        ),
    ];

    return _finalize(
      id: 'journal:purchase:${purchase.id}',
      branchId: purchase.branchId,
      date: purchase.createdAt,
      type: JournalEntryType.purchase,
      referenceId: purchase.id,
      referenceNumber: purchase.id,
      description: 'Ã™ÂÃ˜Â§Ã˜ÂªÃ™Ë†Ã˜Â±Ã˜Â© Ã˜Â´Ã˜Â±Ã˜Â§Ã˜Â¡ #${purchase.id.substring(0, 8)}',
      actorId: actorId,
      occurredAt: purchase.createdAt,
      lines: lines,
    );
  }

  JournalEntryLineModel _line({
    required String accountId,
    double debit = 0,
    double credit = 0,
    String? description,
  }) {
    return JournalEntryLineModel(
      id: const Uuid().v4(),
      accountId: accountId,
      debit: _money(debit),
      credit: _money(credit),
      description: description,
    );
  }

  Future<JournalEntryModel> _finalize({
    required String id,
    required String branchId,

    required DateTime date,
    required JournalEntryType type,
    required String referenceId,
    required String referenceNumber,
    required String description,
    required String actorId,
    required DateTime occurredAt,
    required List<JournalEntryLineModel> lines,
  }) async {
    final debit = _money(lines.fold<double>(0, (sum, l) => sum + l.debit));
    final credit = _money(lines.fold<double>(0, (sum, l) => sum + l.credit));
    if ((debit - credit).abs() > 0.01) {
      throw StateError('Ã™â€šÃ™Å Ã™Ë†Ã˜Â¯ Ã™â€¦Ã˜Â´Ã˜ÂªÃ˜Â±Ã™Å Ã˜Â§Ã˜Âª Ã˜ÂºÃ™Å Ã˜Â± Ã™â€¦Ã˜ÂªÃ˜Â²Ã™â€ Ã˜Â©. Ã˜Â§Ã™â€žÃ˜Â®Ã˜ÂµÃ™â€¦: $debit, Ã˜Â§Ã™â€žÃ˜Â¯Ã˜Â§Ã˜Â¦Ã™â€ : $credit');
    }
    final entry = JournalEntryModel(
      id: id,
      branchId: branchId,
      entryNumber: await JournalEntryService.nextNumber(branchId),
      entryDate: date,
      entryType: type,
      referenceId: referenceId,
      referenceNumber: referenceNumber,
      description: description,
      lines: lines,
      totalDebit: debit,
      totalCredit: credit,
      createdById: actorId,
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );
    await JournalEntryService.create(entry);
    return entry;
  }

  double _money(double value) => (value * 100).roundToDouble() / 100;
}

class ReturnAccountingService {
  const ReturnAccountingService({this.policy = const ReturnAccountingPolicy()});
  final ReturnAccountingPolicy policy;

  Future<JournalEntryModel> buildSalesReturnEntry({
    required ReturnModel salesReturn,
    required String actorId,
  }) async {
    final gross = _money(salesReturn.totalAmount);
    final lines = <JournalEntryLineModel>[
      _line(
        accountId: policy.salesRevenueAccountId,
        debit: gross,
        description: 'Ã˜Â¹Ã™Æ’Ã˜Â³ Ã˜Â¥Ã™Å Ã˜Â±Ã˜Â§Ã˜Â¯ Ã™â€¦Ã˜Â¨Ã™Å Ã˜Â¹Ã˜Â§Ã˜Âª',
      ),
      _line(
        accountId: policy.cashAccountId,
        credit: gross,
        description: 'Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹ Ã˜Â¨Ã™Å Ã˜Â¹',
      ),
    ];

    final totalCost = salesReturn.items.fold<double>(
      0, (sum, item) => sum + (item.costPrice * item.quantity),
    );
    if (totalCost > 0) {
      lines.add(_line(
        accountId: policy.inventoryAccountId,
        debit: totalCost,
        description: 'Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€  Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹',
      ));
      lines.add(_line(
        accountId: policy.costOfGoodsSoldAccountId,
        credit: totalCost,
        description: 'Ã˜Â¹Ã™Æ’Ã˜Â³ Ã˜ÂªÃ™Æ’Ã™â€žÃ™ÂÃ˜Â© Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â¶Ã˜Â§Ã˜Â¹Ã˜Â©',
      ));
    }

    return _finalize(
      id: 'journal:sales_return:${salesReturn.id}',
      branchId: salesReturn.branchId,
      date: salesReturn.createdAt,
      type: JournalEntryType.salesReturn,
      referenceId: salesReturn.id,
      referenceNumber: salesReturn.id,
      description: 'Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹ Ã˜Â¨Ã™Å Ã˜Â¹ #${salesReturn.id.substring(0, 8)}',
      actorId: actorId,
      occurredAt: salesReturn.createdAt,
      lines: lines,
    );
  }

  Future<JournalEntryModel> buildPurchaseReturnEntry({
    required ReturnModel purchaseReturn,
    required String actorId,
  }) async {
    final total = _money(purchaseReturn.totalAmount);
    final lines = <JournalEntryLineModel>[
      _line(
        accountId: policy.accountsPayableAccountId,
        debit: total,
        description: 'Ã˜ÂªÃ˜Â®Ã™ÂÃ™Å Ã˜Â¶ Ã™â€¦Ã˜Â³Ã˜ÂªÃ˜Â­Ã™â€š Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
      ),
      _line(
        accountId: policy.inventoryAccountId,
        credit: total,
        description: 'Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€  Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹ Ã™â€žÃ™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
      ),
    ];

    return _finalize(
      id: 'journal:purchase_return:${purchaseReturn.id}',
      branchId: purchaseReturn.branchId,
      date: purchaseReturn.createdAt,
      type: JournalEntryType.purchaseReturn,
      referenceId: purchaseReturn.id,
      referenceNumber: purchaseReturn.id,
      description: 'Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹ Ã˜Â´Ã˜Â±Ã˜Â§Ã˜Â¡ #${purchaseReturn.id.substring(0, 8)}',
      actorId: actorId,
      occurredAt: purchaseReturn.createdAt,
      lines: lines,
    );
  }

  JournalEntryLineModel _line({
    required String accountId,
    double debit = 0,
    double credit = 0,
    String? description,
  }) {
    return JournalEntryLineModel(
      id: const Uuid().v4(),
      accountId: accountId,
      debit: _money(debit),
      credit: _money(credit),
      description: description,
    );
  }

  Future<JournalEntryModel> _finalize({
    required String id,
    required String branchId,

    required DateTime date,
    required JournalEntryType type,
    required String referenceId,
    required String referenceNumber,
    required String description,
    required String actorId,
    required DateTime occurredAt,
    required List<JournalEntryLineModel> lines,
  }) async {
    final debit = _money(lines.fold<double>(0, (sum, l) => sum + l.debit));
    final credit = _money(lines.fold<double>(0, (sum, l) => sum + l.credit));
    if ((debit - credit).abs() > 0.01) {
      throw StateError('Ã™â€šÃ™Å Ã™Ë†Ã˜Â¯ Ã™â€¦Ã˜Â±Ã˜ÂªÃ˜Â¬Ã˜Â¹ Ã˜ÂºÃ™Å Ã˜Â± Ã™â€¦Ã˜ÂªÃ˜Â²Ã™â€ Ã˜Â©. Ã˜Â§Ã™â€žÃ˜Â®Ã˜ÂµÃ™â€¦: $debit, Ã˜Â§Ã™â€žÃ˜Â¯Ã˜Â§Ã˜Â¦Ã™â€ : $credit');
    }
    final entry = JournalEntryModel(
      id: id,
      branchId: branchId,
      entryNumber: await JournalEntryService.nextNumber(branchId),
      entryDate: date,
      entryType: type,
      referenceId: referenceId,
      referenceNumber: referenceNumber,
      description: description,
      lines: lines,
      totalDebit: debit,
      totalCredit: credit,
      createdById: actorId,
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );
    await JournalEntryService.create(entry);
    return entry;
  }

  double _money(double value) => (value * 100).roundToDouble() / 100;
}

class InventoryAccountingService {
  const InventoryAccountingService({this.policy = const InventoryAccountingPolicy()});
  final InventoryAccountingPolicy policy;

  Future<JournalEntryModel> buildAdjustmentEntry({
    required String medicineId,
    required String medicineName,
    required String branchId,
    required int oldQuantity,
    required int newQuantity,
    required double unitCost,
    required String actorId,
    required String reason,
  }) async {
    final diff = newQuantity - oldQuantity;
    final value = _money(diff.abs() * unitCost);
    final isIncrease = diff > 0;

    final lines = <JournalEntryLineModel>[];
    if (isIncrease) {
      lines.add(_line(
        accountId: policy.inventoryAccountId, debit: value,
        description: 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ : $medicineName',
      ));
      lines.add(_line(
        accountId: policy.inventoryGainAccountId, credit: value,
        description: 'Ã˜Â£Ã˜Â±Ã˜Â¨Ã˜Â§Ã˜Â­ Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ ',
      ));
    } else {
      lines.add(_line(
        accountId: policy.inventoryLossAccountId, debit: value,
        description: 'Ã˜Â®Ã˜Â³Ã˜Â§Ã˜Â¦Ã˜Â± Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ : $medicineName',
      ));
      lines.add(_line(
        accountId: policy.inventoryAccountId, credit: value,
        description: 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ : $medicineName',
      ));
    }

    return _finalize(
      id: 'journal:adjustment:${medicineId}_${DateTime.now().millisecondsSinceEpoch}',
      branchId: branchId,
      date: DateTime.now(),
      type: JournalEntryType.adjustment,
      referenceId: medicineId,
      referenceNumber: reason,
      description: 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã™â€¦Ã˜Â®Ã˜Â²Ã™Ë†Ã™â€ : $medicineName',
      actorId: actorId,
      occurredAt: DateTime.now(),
      lines: lines,
    );
  }

  JournalEntryLineModel _line({
    required String accountId, double debit = 0, double credit = 0, String? description,
  }) {
    return JournalEntryLineModel(
      id: const Uuid().v4(), accountId: accountId,
      debit: _money(debit), credit: _money(credit), description: description,
    );
  }

  Future<JournalEntryModel> _finalize({
    required String id, required String branchId,
    required DateTime date, required JournalEntryType type,
    required String referenceId, required String referenceNumber,
    required String description, required String actorId,
    required DateTime occurredAt, required List<JournalEntryLineModel> lines,
  }) async {
    final debit = _money(lines.fold<double>(0, (sum, l) => sum + l.debit));
    final credit = _money(lines.fold<double>(0, (sum, l) => sum + l.credit));
    if ((debit - credit).abs() > 0.01) {
      throw StateError('Ã™â€šÃ™Å Ã™Ë†Ã˜Â¯ Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â© Ã˜ÂºÃ™Å Ã˜Â± Ã™â€¦Ã˜ÂªÃ˜Â²Ã™â€ Ã˜Â©. Ã˜Â§Ã™â€žÃ˜Â®Ã˜ÂµÃ™â€¦: $debit, Ã˜Â§Ã™â€žÃ˜Â¯Ã˜Â§Ã˜Â¦Ã™â€ : $credit');
    }
    final entry = JournalEntryModel(
      id: id, branchId: branchId,
      entryNumber: await JournalEntryService.nextNumber(branchId),
      entryDate: date, entryType: type,
      referenceId: referenceId, referenceNumber: referenceNumber,
      description: description, lines: lines,
      totalDebit: debit, totalCredit: credit,
      createdById: actorId, createdAt: occurredAt, updatedAt: occurredAt,
    );
    await JournalEntryService.create(entry);
    return entry;
  }

  double _money(double value) => (value * 100).roundToDouble() / 100;
}

