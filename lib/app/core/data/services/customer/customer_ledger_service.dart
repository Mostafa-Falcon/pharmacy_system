import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/ledger_service.dart';

class CustomerLedgerService {
  static Future<void> recordSaleInvoice({
    required String customerId,
    required String branchId,
    required String saleId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    if (dueAmount <= 0) return;

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + dueAmount;

    final entry = ContactLedgerModel(
      id: 'ledger_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.saleInvoice,
      debit: dueAmount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: saleId,
      referenceNumber: invoiceNumber,
      notes: '??????? ????? ?? ?????? ??? ???? / ?????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<void> recordCustomerPayment({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorPaymentMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = ContactLedgerModel(
      id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.customerPayment,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ?? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<void> recordSaleVoid({
    required String customerId,
    required String branchId,
    required String saleId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    if (dueAmount <= 0) return;

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - dueAmount).clamp(0.0, double.infinity);

    final entry = ContactLedgerModel(
      id: 'void_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.saleVoid,
      debit: 0,
      credit: dueAmount,
      balanceAfter: newBalance,
      referenceId: saleId,
      referenceNumber: invoiceNumber,
      notes: '??? ??????? ?????? ?????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<List<ContactLedgerModel>> getCustomerLedger(
    String customerId,
    String branchId,
  ) async {
    return LedgerService.getCustomerEntries(customerId, branchId);
  }

  static Future<double> getCustomerBalance(
    String customerId,
    String branchId,
  ) async {
    return LedgerService.getCustomerBalance(customerId, branchId);
  }

  static Future<void> recordAdditionNotice({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorAdditionMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = ContactLedgerModel(
      id: 'addition_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.additionNotice,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '????? ????? ????? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<void> recordDiscountNotice({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorDiscountMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = ContactLedgerModel(
      id: 'discount_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.discountNotice,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '????? ??? ????? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<void> recordCheckReceipt({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? checkNumber,
    String? bankName,
    String? dueDate,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorCheckMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final checkNotes = [
      if (checkNumber != null) '??? ???: $checkNumber',
      if (bankName != null) '?????: $bankName',
      if (dueDate != null) '????? ?????????: $dueDate',
      notes,
    ].join(' | ');

    final entry = ContactLedgerModel(
      id: 'check_recv_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.checkReceipt,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : '?????? ??? ?? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<void> recordCheckPayment({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? checkNumber,
    String? bankName,
    String? dueDate,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorCheckMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final checkNotes = [
      if (checkNumber != null) '??? ???: $checkNumber',
      if (bankName != null) '?????: $bankName',
      if (dueDate != null) '????? ?????????: $dueDate',
      notes,
    ].join(' | ');

    final entry = ContactLedgerModel(
      id: 'check_pay_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.checkPayment,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : '??? ??? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// ????? ?????? ????????? ?????? - debit ???? ??????? ????
  static Future<void> recordOpeningBalanceDirect({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AccountingStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = ContactLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.openingBalance,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ???????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// ????? ?????? ????????? ????? - credit ???? ???? ??
  static Future<void> recordOpeningBalanceAsCredit({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AccountingStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = ContactLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.openingBalance,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ??????? - ???? ??',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// ?????? ??? ???? ????? ??????? ???? ???? ?????? ?????
  static Future<Map<String, double>> getAllCustomerBalances(String branchId) async {
    return LedgerService.getAllCustomerBalances(branchId);
  }
}






