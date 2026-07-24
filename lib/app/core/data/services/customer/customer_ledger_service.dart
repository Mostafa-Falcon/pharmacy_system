import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/models/contacts/contact_ledger_model.dart';
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

    final currentBalance = await LedgerService.getContactBalance(customerId, branchId);
    final newBalance = currentBalance + dueAmount;

    final entry = ContactLedgerModel(
      id: 'ledger_${DateTime.now().millisecondsSinceEpoch}',
      contactId: customerId,
      transactionDate: DateTime.now(),
      referenceNumber: invoiceNumber,
      transactionType: LedgerTransactionType.saleInvoice,
      debitAmount: dueAmount,
      creditAmount: 0.0,
      runningBalance: newBalance,
      description: 'فاتورة مبيعات رقم $invoiceNumber بواسطة $createdBy',
      branchId: branchId,
    );

    await LedgerService.insertEntry(entry);
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

    final currentBalance = await LedgerService.getContactBalance(customerId, branchId);
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = ContactLedgerModel(
      id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
      contactId: customerId,
      transactionDate: DateTime.now(),
      referenceNumber: referenceId ?? 'PAY-${DateTime.now().millisecondsSinceEpoch}',
      transactionType: LedgerTransactionType.payment,
      debitAmount: 0.0,
      creditAmount: amount,
      runningBalance: newBalance,
      description: notes ?? 'دفعة سداد من العميل بواسطة $createdBy',
      branchId: branchId,
    );

    await LedgerService.insertEntry(entry);
  }

  static Future<List<ContactLedgerModel>> getCustomerLedger(String customerId, String branchId) {
    return LedgerService.getEntriesForContact(customerId);
  }

  static Future<double> getCustomerBalance(String customerId, String branchId) {
    return LedgerService.getContactBalance(customerId, branchId);
  }
}
