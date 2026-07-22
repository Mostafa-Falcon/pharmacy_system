import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
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

    final entry = CustomerLedgerModel(
      id: 'ledger_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.saleInvoice,
      debit: dueAmount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: saleId,
      referenceNumber: invoiceNumber,
      notes: 'مديونية ناتجة عن فاتورة بيع آجلة / جزئية',
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
    if (amount <= 0) throw Exception(AppStrings.errorPaymentMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = CustomerLedgerModel(
      id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.customerPayment,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? 'سداد من العميل',
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

    final entry = CustomerLedgerModel(
      id: 'void_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.saleVoid,
      debit: 0,
      credit: dueAmount,
      balanceAfter: newBalance,
      referenceId: saleId,
      referenceNumber: invoiceNumber,
      notes: 'عكس مديونية فاتورة ملغاة',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  static Future<List<CustomerLedgerModel>> getCustomerLedger(
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
    if (amount <= 0) throw Exception(AppStrings.errorAdditionMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = CustomerLedgerModel(
      id: 'addition_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.additionNotice,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? 'إشعار إضافة لحساب العميل',
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
    if (amount <= 0) throw Exception(AppStrings.errorDiscountMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = CustomerLedgerModel(
      id: 'discount_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.discountNotice,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? 'إشعار خصم لحساب العميل',
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
    if (amount <= 0) throw Exception(AppStrings.errorCheckMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final checkNotes = [
      if (checkNumber != null) 'شيك رقم: $checkNumber',
      if (bankName != null) 'البنك: $bankName',
      if (dueDate != null) 'تاريخ الاستحقاق: $dueDate',
      notes,
    ].join(' | ');

    final entry = CustomerLedgerModel(
      id: 'check_recv_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.checkReceipt,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : 'استلام شيك من العميل',
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
    if (amount <= 0) throw Exception(AppStrings.errorCheckMustBePositive);

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final checkNotes = [
      if (checkNumber != null) 'شيك رقم: $checkNumber',
      if (bankName != null) 'البنك: $bankName',
      if (dueDate != null) 'تاريخ الاستحقاق: $dueDate',
      notes,
    ].join(' | ');

    final entry = CustomerLedgerModel(
      id: 'check_pay_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.checkPayment,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: checkNotes.isNotEmpty ? checkNotes : 'دفع شيك للعميل',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// تسجيل الرصيد الافتتاحي مباشرة - debit يعني مديونية عليه
  static Future<void> recordOpeningBalanceDirect({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AppStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = currentBalance + amount;

    final entry = CustomerLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.openingBalance,
      debit: amount,
      credit: 0,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? 'رصيد افتتاحي',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// تسجيل الرصيد الافتتاحي كدائن - credit يعني رصيد له
  static Future<void> recordOpeningBalanceAsCredit({
    required String customerId,
    required String branchId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    if (amount <= 0) {
      throw Exception(AppStrings.errorOpeningMustBePositive);
    }

    final currentBalance = await LedgerService.getCustomerBalance(
      customerId,
      branchId,
    );
    final newBalance = (currentBalance - amount).clamp(0.0, double.infinity);

    final entry = CustomerLedgerModel(
      id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      branchId: branchId,
      type: CustomerLedgerEntryType.openingBalance,
      debit: 0,
      credit: amount,
      balanceAfter: newBalance,
      referenceId: referenceId,
      notes: notes ?? 'رصيد افتتاحي - رصيد له',
      createdBy: createdBy,
      entryDate: DateTime.now(),
    );

    await LedgerService.insertCustomerEntry(entry);
  }

  /// الحصول على كافة أرصدة العملاء لفرع معين بكفاءة عالية
  static Future<Map<String, double>> getAllCustomerBalances(String branchId) async {
    return LedgerService.getAllCustomerBalances(branchId);
  }
}

