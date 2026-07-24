import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/party_payments_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_enums.dart';
import 'package:pharmacy_system/app/core/models/accounting/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/account_enums.dart';
import 'journal_entry_service.dart';

class PartyPaymentService {
  static final PartyPaymentsDao _dao = sl<PartyPaymentsDao>();
  static List<PartyPaymentsTableData> _cached = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<PartyPaymentModel>> getAll({String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    final payments = _cached
        .where((e) => e.branchId == bid && !e.isDeleted)
        .map(_toModel)
        .toList();
    payments.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return payments;
  }

  static Future<List<PartyPaymentModel>> getByKind(PartyPaymentKind kind,
      {String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    final payments = _cached
        .where((e) => e.branchId == bid && !e.isDeleted && _toKind(e.kind) == kind)
        .map(_toModel)
        .toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return payments;
  }

  static Future<void> create(PartyPaymentModel payment) async {
    await _ensureReady();
    final companion = PartyPaymentsTableCompanion(
      id: Value(payment.id),
      branchId: Value(payment.branchId),
      number: Value(payment.number),
      paymentDate: Value(payment.paymentDate),
      kind: Value(payment.kind.name),
      partyId: Value(payment.partyId),
      partyName: Value(payment.partyName),
      amount: Value(payment.amount),
      paymentMethod: Value(payment.paymentMethod),
      balanceEffect: Value(payment.balanceEffect?.name),
      purchaseReceiptId: Value(payment.purchaseReceiptId),
      purchaseReceiptNumber: Value(payment.purchaseReceiptNumber),
      referenceNumber: Value(payment.referenceNumber),
      notes: Value(payment.notes),
      createdById: Value(payment.createdById),
      createdByName: Value(payment.createdByName),
      createdAt: Value(payment.createdAt),
      updatedAt: Value(payment.updatedAt),
      isDeleted: const Value(false),
    );
    await _dao.upsert(companion);
    final saved = await _dao.getById(payment.id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'party_payments',
        data: payment.toJson(),
        branchId: _currentBranchId,
      );
    } catch (_) {}

    await _updateLedger(payment);
    await _createJournalEntry(payment);
  }

  static Future<void> delete(String id) async {
    await _ensureReady();
    await _dao.softDelete(id);
    _cached.removeWhere((e) => e.id == id);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'party_payments',
        data: {'id': id, 'is_deleted': true},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<void> _updateLedger(PartyPaymentModel payment) async {
    switch (payment.kind) {
      case PartyPaymentKind.customerReceipt:
        await CustomerLedgerService.recordCustomerPayment(
          customerId: payment.partyId,
          branchId: payment.branchId,
          amount: payment.amount,
          createdBy: payment.createdById,
          notes: payment.notes,
          referenceId: payment.id,
        );
        break;
      case PartyPaymentKind.supplierPayment:
        await SupplierLedgerService.recordSupplierPayment(
          supplierId: payment.partyId,
          branchId: payment.branchId,
          amount: payment.amount,
          createdBy: payment.createdById,
          notes: payment.notes,
          referenceId: payment.id,
        );
        break;
      case PartyPaymentKind.supplierReceipt:
        await SupplierLedgerService.recordAdditionNotice(
          supplierId: payment.partyId,
          branchId: payment.branchId,
          amount: payment.amount,
          createdBy: payment.createdById,
          notes: payment.notes ?? 'Ã˜Â§Ã˜Â³Ã˜ÂªÃ™â€žÃ˜Â§Ã™â€¦ Ã™â€ Ã™â€šÃ˜Â¯Ã™Å Ã˜Â© Ã™â€¦Ã™â€  Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
          referenceId: payment.id,
        );
        break;
      case PartyPaymentKind.supplierAdditionNote:
        await SupplierLedgerService.recordAdditionNotice(
          supplierId: payment.partyId,
          branchId: payment.branchId,
          amount: payment.amount,
          createdBy: payment.createdById,
          notes: payment.notes,
          referenceId: payment.id,
        );
        break;
      case PartyPaymentKind.supplierDiscountNote:
        await SupplierLedgerService.recordDiscountNotice(
          supplierId: payment.partyId,
          branchId: payment.branchId,
          amount: payment.amount,
          createdBy: payment.createdById,
          notes: payment.notes,
          referenceId: payment.id,
        );
        break;
      case PartyPaymentKind.supplierOpeningBalance:
        if (payment.effectiveBalanceEffect == PartyBalanceEffect.increase) {
          await SupplierLedgerService.recordOpeningBalanceDirect(
            supplierId: payment.partyId,
            branchId: payment.branchId,
            amount: payment.amount,
            createdBy: payment.createdById,
            notes: payment.notes,
            referenceId: payment.id,
          );
        } else {
          await SupplierLedgerService.recordOpeningBalanceAsCredit(
            supplierId: payment.partyId,
            branchId: payment.branchId,
            amount: payment.amount,
            createdBy: payment.createdById,
            notes: payment.notes,
            referenceId: payment.id,
          );
        }
        break;
    }
  }

  static Future<void> _createJournalEntry(PartyPaymentModel payment) async {
    final amount = payment.amount;
    final settAccount = _settlementAccount(payment.paymentMethod);
    final entryType = _journalEntryType(payment.kind);
    final entryNumber = await JournalEntryService.nextNumber(payment.branchId);

    List<JournalEntryLineModel> lines;
    String description;

    switch (payment.kind) {
      case PartyPaymentKind.customerReceipt:
        description = 'Ã™â€¦Ã™â€šÃ˜Â¨Ã™Ë†Ã˜Â¶Ã˜Â§Ã˜Âª Ã™â€¦Ã™â€  ${payment.partyName}';
        lines = [
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: settAccount,
            accountName: _accountName(payment.paymentMethod),
            debit: amount,
            credit: 0,
            description: payment.number.toString(),
          ),
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'accounts_receivable',
            accountName: 'Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â¡',
            debit: 0,
            credit: amount,
            description: 'Ã˜ÂªÃ˜Â®Ã™ÂÃ™Å Ã˜Â¶ Ã˜Â±Ã˜ÂµÃ™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€¦Ã™Å Ã™â€ž',
          ),
        ];
        break;
      case PartyPaymentKind.supplierPayment:
        description = 'Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª Ã™â€žÃ™â‚¬ ${payment.partyName}';
        lines = [
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'accounts_payable',
            accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
            debit: amount,
            credit: 0,
            description: 'Ã˜ÂªÃ˜Â®Ã™ÂÃ™Å Ã˜Â¶ Ã˜Â±Ã˜ÂµÃ™Å Ã˜Â¯ Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
          ),
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: settAccount,
            accountName: _accountName(payment.paymentMethod),
            debit: 0,
            credit: amount,
            description: payment.number.toString(),
          ),
        ];
        break;
      case PartyPaymentKind.supplierReceipt:
        description = 'Ã™â€¦Ã™â€šÃ˜Â¨Ã™Ë†Ã˜Â¶Ã˜Â§Ã˜Âª Ã™â€¦Ã™â€  Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯ ${payment.partyName}';
        lines = [
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: settAccount,
            accountName: _accountName(payment.paymentMethod),
            debit: amount,
            credit: 0,
            description: payment.number.toString(),
          ),
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'accounts_payable',
            accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
            debit: 0,
            credit: amount,
            description: 'Ã™â€¦Ã™â€šÃ˜Â¨Ã™Ë†Ã˜Â¶Ã˜Â§Ã˜Âª Ã™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
          ),
        ];
        break;
      case PartyPaymentKind.supplierAdditionNote:
        description = 'Ã˜Â¥Ã˜Â´Ã˜Â¹Ã˜Â§Ã˜Â± Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯ ${payment.partyName}';
        lines = [
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'supplier_adjustments',
            accountName: 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â§Ã˜Âª Ã™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Å Ã™â€ ',
            debit: amount,
            credit: 0,
            description: description,
          ),
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'accounts_payable',
            accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
            debit: 0,
            credit: amount,
            description: description,
          ),
        ];
        break;
      case PartyPaymentKind.supplierDiscountNote:
        description = 'Ã˜Â¥Ã˜Â´Ã˜Â¹Ã˜Â§Ã˜Â± Ã˜Â®Ã˜ÂµÃ™â€¦ Ã™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯ ${payment.partyName}';
        lines = [
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'accounts_payable',
            accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
            debit: amount,
            credit: 0,
            description: description,
          ),
          JournalEntryLineModel(
            id: const Uuid().v4(),
            accountId: 'purchase_discounts',
            accountName: 'Ã˜Â®Ã˜ÂµÃ™Ë†Ã™â€¦Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â´Ã˜ÂªÃ˜Â±Ã™Å Ã˜Â§Ã˜Âª',
            debit: 0,
            credit: amount,
            description: description,
          ),
        ];
        break;
      case PartyPaymentKind.supplierOpeningBalance:
        description = 'Ã˜Â±Ã˜ÂµÃ™Å Ã˜Â¯ Ã˜Â§Ã™ÂÃ˜ÂªÃ˜ÂªÃ˜Â§Ã˜Â­Ã™Å  ${payment.partyName}';
        final isIncrease =
            payment.effectiveBalanceEffect == PartyBalanceEffect.increase;
        lines = isIncrease
            ? [
                JournalEntryLineModel(
                  id: const Uuid().v4(),
                  accountId: 'opening_balance_equity',
                  accountName: 'Ã˜Â­Ã™â€šÃ™Ë†Ã™â€š Ã™â€¦Ã™â€žÃ™Æ’Ã™Å Ã˜Â© Ã˜Â§Ã™ÂÃ˜ÂªÃ˜ÂªÃ˜Â§Ã˜Â­Ã™Å Ã˜Â©',
                  debit: amount,
                  credit: 0,
                  description: description,
                ),
                JournalEntryLineModel(
                  id: const Uuid().v4(),
                  accountId: 'accounts_payable',
                  accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
                  debit: 0,
                  credit: amount,
                  description: description,
                ),
              ]
            : [
                JournalEntryLineModel(
                  id: const Uuid().v4(),
                  accountId: 'accounts_payable',
                  accountName: 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Ë†Ã™â€ ',
                  debit: amount,
                  credit: 0,
                  description: description,
                ),
                JournalEntryLineModel(
                  id: const Uuid().v4(),
                  accountId: 'opening_balance_equity',
                  accountName: 'Ã˜Â­Ã™â€šÃ™Ë†Ã™â€š Ã™â€¦Ã™â€žÃ™Æ’Ã™Å Ã˜Â© Ã˜Â§Ã™ÂÃ˜ÂªÃ˜ÂªÃ˜Â§Ã˜Â­Ã™Å Ã˜Â©',
                  debit: 0,
                  credit: amount,
                  description: description,
                ),
              ];
        break;
    }

    final journalEntry = JournalEntryModel(
      id: const Uuid().v4(),
      branchId: payment.branchId,
      entryNumber: entryNumber,
      entryDate: payment.paymentDate,
      entryType: entryType,
      referenceId: payment.id,
      referenceNumber: payment.number.toString(),
      description: description,
      lines: lines,
      totalDebit: amount,
      totalCredit: amount,
      createdById: payment.createdById,
      createdByName: payment.createdByName,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    );
    await JournalEntryService.create(journalEntry);
  }

  static JournalEntryType _journalEntryType(PartyPaymentKind kind) {
    switch (kind) {
      case PartyPaymentKind.customerReceipt:
      case PartyPaymentKind.supplierReceipt:
        return JournalEntryType.receipt;
      case PartyPaymentKind.supplierPayment:
        return JournalEntryType.payment;
      case PartyPaymentKind.supplierAdditionNote:
      case PartyPaymentKind.supplierDiscountNote:
      case PartyPaymentKind.supplierOpeningBalance:
        return JournalEntryType.adjustment;
    }
  }

  static String _settlementAccount(String method) {
    switch (method) {
      case 'card':
        return 'card_clearing';
      case 'bank_transfer':
        return 'bank';
      case 'mobile_wallet':
        return 'mobile_wallet';
      default:
        return 'cash';
    }
  }

  static String _accountName(String method) {
    switch (method) {
      case 'card':
        return 'Ã˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ˜Â¨Ã˜Â·Ã˜Â§Ã™â€šÃ˜Â§Ã˜Âª';
      case 'bank_transfer':
        return 'Ã˜Â§Ã™â€žÃ˜Â¨Ã™â€ Ã™Æ’';
      case 'mobile_wallet':
        return 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â­Ã™ÂÃ˜Â¸Ã˜Â© Ã˜Â§Ã™â€žÃ˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å Ã˜Â©';
      default:
        return 'Ã˜Â§Ã™â€žÃ˜Â®Ã˜Â²Ã™Å Ã™â€ Ã˜Â©';
    }
  }

  static Future<int> nextNumber(String branchId) async {
    final payments = await getAll(branchId: branchId);
    if (payments.isEmpty) return 1;
    return payments.map((e) => e.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  static PartyPaymentKind _toKind(String value) {
    return PartyPaymentKind.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PartyPaymentKind.supplierPayment,
    );
  }

  static PartyBalanceEffect? _toBalanceEffect(String? value) {
    if (value == null) return null;
    return PartyBalanceEffect.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PartyBalanceEffect.increase,
    );
  }

  static PartyPaymentModel _toModel(PartyPaymentsTableData d) =>
      PartyPaymentModel(
        id: d.id,
        branchId: d.branchId,
        number: d.number,
        paymentDate: d.paymentDate,
        kind: _toKind(d.kind),
        partyId: d.partyId,
        partyName: d.partyName,
        amount: d.amount,
        paymentMethod: d.paymentMethod,
        balanceEffect: _toBalanceEffect(d.balanceEffect),
        purchaseReceiptId: d.purchaseReceiptId,
        purchaseReceiptNumber: d.purchaseReceiptNumber,
        referenceNumber: d.referenceNumber,
        notes: d.notes,
        createdById: d.createdById,
        createdByName: d.createdByName,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
      );
}





