import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/ledger_service.dart';

class SupplierLedgerService {
  static Future<void> recordPurchaseInvoice({
    required String supplierId,
    required String branchId,
    required String purchaseId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    if (dueAmount <= 0) return;

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = currentBalance + dueAmount;

    final entry = SupplierLedgerModel(
      id: 'ledger_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.purchaseInvoice,
      debit: dueAmount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: purchaseId,
      referenceNumber: invoiceNumber,
      notes: '???? ???? ????? ?? ?????? ??????? ???? / ?????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<void> recordSupplierPayment({
    required String supplierId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorPaymentMustBePositive);

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = SupplierLedgerModel(
      id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.supplierPayment,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<void> recordPurchaseVoid({
    required String supplierId,
    required String branchId,
    required String purchaseId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    if (dueAmount <= 0) return;

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = (currentBalance - dueAmount).clamp(0.0, double.infinity);

    final entry = SupplierLedgerModel(
      id: 'void_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.purchaseVoid,
      debit: 0,
      credit: dueAmount,
      balanceAfter: newBalance,
      referenceId: purchaseId,
      referenceNumber: invoiceNumber,
      notes: '??? ???? ?????? ??????? ?????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<List<SupplierLedgerModel>> getSupplierLedger(
    String supplierId,
    String branchId,
  ) async {
    return LedgerService.getSupplierEntries(supplierId, branchId);
  }

  static Future<double> getSupplierBalance(
    String supplierId,
    String branchId,
  ) async {
    return LedgerService.getSupplierBalance(supplierId, branchId);
  }

  static Future<void> recordAdditionNotice({
    required String supplierId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorAdditionMustBePositive);

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = SupplierLedgerModel(
      id: 'addition_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.additionNotice,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '????? ????? ????? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<void> recordDiscountNotice({
    required String supplierId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) throw Exception(AccountingStrings.errorDiscountMustBePositive);

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = SupplierLedgerModel(
      id: 'discount_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.discountNotice,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '????? ??? ????? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<void> recordCheckPayment({
    required String supplierId,
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

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final checkNotes = [
      if (checkNumber != null) '??? ???: $checkNumber',
      if (bankName != null) '?????: $bankName',
      if (dueDate != null) '????? ?????????: $dueDate',
      notes ?? '',
    ].join(' | ');

    final entry = SupplierLedgerModel(
      id: 'check_pay_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.checkPayment,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : '??? ??? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  static Future<void> recordCheckReceipt({
    required String supplierId,
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

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final checkNotes = [
      if (checkNumber != null) '??? ???: $checkNumber',
      if (bankName != null) '?????: $bankName',
      if (dueDate != null) '????? ?????????: $dueDate',
      notes ?? '',
    ].join(' | ');

    final entry = SupplierLedgerModel(
      id: 'check_recv_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.checkReceipt,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : '?????? ??? ?? ??????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  /// ????? ?????? ????????? ?????? - debit ???? ??????? ????? (?????? ???? ????)
  static Future<void> recordOpeningBalanceDirect({
    required String supplierId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AccountingStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = SupplierLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.openingBalance,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ???????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }

  /// ????? ?????? ????????? ????? - credit ???? ???? ????? (???? ?????? ???? ???)
  static Future<void> recordOpeningBalanceAsCredit({
    required String supplierId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AccountingStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getSupplierBalance(
      supplierId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = SupplierLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      supplierId: supplierId,
      branchId: branchId,
      type: SupplierLedgerEntryType.openingBalance,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? '???? ??????? - ???? ?????',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertSupplierEntry(entry);
  }
}





