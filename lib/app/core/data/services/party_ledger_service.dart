import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';

class PartyLedgerService {
  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> recordSaleInvoice({
    required String partyId,
    required String saleId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    try {
      await CustomerLedgerService.recordSaleInvoice(
        customerId: partyId,
        branchId: _currentBranchId,
        saleId: saleId,
        invoiceNumber: invoiceNumber,
        dueAmount: dueAmount,
        createdBy: createdBy,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordSaleInvoice failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordSaleReturn({
    required String partyId,
    required String returnId,
    required String returnNumber,
    required double refundAmount,
    required String createdBy,
  }) async {
    try {
      if (refundAmount <= 0) return;

      final currentBalance = await LedgerService.getSupplierBalance(partyId, _currentBranchId);
      final newBalance = (currentBalance - refundAmount).clamp(0.0, double.infinity);

      final entry = SupplierLedgerModel(
        id: 'sale_return_${DateTime.now().millisecondsSinceEpoch}',
        supplierId: partyId,
        branchId: _currentBranchId,
        type: SupplierLedgerEntryType.purchaseVoid,
        debit: 0,
        credit: refundAmount,
        balanceAfter: newBalance,
        referenceId: returnId,
        referenceNumber: returnNumber,
        notes: 'مرتجع مبيعات للعميل',
        createdBy: createdBy,
        entryDate: DateTime.now(),
      );

      await LedgerService.insertSupplierEntry(entry);
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordSaleReturn failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordPurchaseInvoice({
    required String partyId,
    required String purchaseId,
    required String invoiceNumber,
    required double dueAmount,
    required String createdBy,
  }) async {
    try {
      await SupplierLedgerService.recordPurchaseInvoice(
        supplierId: partyId,
        branchId: _currentBranchId,
        purchaseId: purchaseId,
        invoiceNumber: invoiceNumber,
        dueAmount: dueAmount,
        createdBy: createdBy,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordPurchaseInvoice failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordPurchaseReturn({
    required String partyId,
    required String returnId,
    required String returnNumber,
    required double refundAmount,
    required String createdBy,
  }) async {
    try {
      if (refundAmount <= 0) return;

      final currentBalance = await LedgerService.getSupplierBalance(partyId, _currentBranchId);
      final newBalance = (currentBalance - refundAmount).clamp(0.0, double.infinity);

      final entry = SupplierLedgerModel(
        id: 'purchase_return_${DateTime.now().millisecondsSinceEpoch}',
        supplierId: partyId,
        branchId: _currentBranchId,
        type: SupplierLedgerEntryType.purchaseVoid,
        debit: 0,
        credit: refundAmount,
        balanceAfter: newBalance,
        referenceId: returnId,
        referenceNumber: returnNumber,
        notes: 'مرتجع مشتريات من المورد',
        createdBy: createdBy,
        entryDate: DateTime.now(),
      );

      await LedgerService.insertSupplierEntry(entry);
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordPurchaseReturn failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordCashReceipt({
    required String partyId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    try {
      await CustomerLedgerService.recordCustomerPayment(
        customerId: partyId,
        branchId: _currentBranchId,
        amount: amount,
        createdBy: createdBy,
        notes: notes,
        referenceId: referenceId,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordCashReceipt failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordCashPayment({
    required String partyId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
  }) async {
    try {
      await SupplierLedgerService.recordSupplierPayment(
        supplierId: partyId,
        branchId: _currentBranchId,
        amount: amount,
        createdBy: createdBy,
        notes: notes,
        referenceId: referenceId,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordCashPayment failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordAdditionNotice({
    required String partyId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
    String ledgerTarget = 'customer',
  }) async {
    try {
      if (ledgerTarget == 'supplier') {
        await SupplierLedgerService.recordAdditionNotice(
          supplierId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
          referenceId: referenceId,
        );
      } else {
        await CustomerLedgerService.recordAdditionNotice(
          customerId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
          referenceId: referenceId,
        );
      }
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordAdditionNotice failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordDiscountNotice({
    required String partyId,
    required double amount,
    required String createdBy,
    String? notes,
    String? referenceId,
    String ledgerTarget = 'customer',
  }) async {
    try {
      if (ledgerTarget == 'supplier') {
        await SupplierLedgerService.recordDiscountNotice(
          supplierId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
          referenceId: referenceId,
        );
      } else {
        await CustomerLedgerService.recordDiscountNotice(
          customerId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
          referenceId: referenceId,
        );
      }
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordDiscountNotice failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordCheckReceipt({
    required String partyId,
    required double amount,
    required String createdBy,
    String? checkNumber,
    String? bankName,
    String? dueDate,
    String? notes,
    String? referenceId,
  }) async {
    try {
      await CustomerLedgerService.recordCheckReceipt(
        customerId: partyId,
        branchId: _currentBranchId,
        amount: amount,
        createdBy: createdBy,
        checkNumber: checkNumber,
        bankName: bankName,
        dueDate: dueDate,
        notes: notes,
        referenceId: referenceId,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordCheckReceipt failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> recordCheckPayment({
    required String partyId,
    required double amount,
    required String createdBy,
    String? checkNumber,
    String? bankName,
    String? dueDate,
    String? notes,
    String? referenceId,
  }) async {
    try {
      await SupplierLedgerService.recordCheckPayment(
        supplierId: partyId,
        branchId: _currentBranchId,
        amount: amount,
        createdBy: createdBy,
        checkNumber: checkNumber,
        bankName: bankName,
        dueDate: dueDate,
        notes: notes,
        referenceId: referenceId,
      );
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordCheckPayment failed: $e\n$s');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getCombinedLedger(
    String partyId,
  ) async {
    try {
      return LedgerService.getCombinedLedger(partyId, branchId: _currentBranchId);
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.getCombinedLedger failed: $e\n$s');
      return [];
    }
  }

  static Future<void> recordOpeningBalance({
    required String partyId,
    required double amount,
    required String createdBy,
    required String direction,
    String? notes,
  }) async {
    try {
      if (direction == 'debit') {
        await CustomerLedgerService.recordOpeningBalanceDirect(
          customerId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
        );
      } else {
        await SupplierLedgerService.recordOpeningBalanceDirect(
          supplierId: partyId,
          branchId: _currentBranchId,
          amount: amount,
          createdBy: createdBy,
          notes: notes,
        );
      }
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.recordOpeningBalance failed: $e\n$s');
      rethrow;
    }
  }

  static Future<double> getCombinedBalance(String partyId) async {
    try {
      return LedgerService.getCombinedBalance(partyId, branchId: _currentBranchId);
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.getCombinedBalance failed: $e\n$s');
      return 0.0;
    }
  }

  static Future<Map<String, double>> getTransactionSummary(
    String partyId,
  ) async {
    try {
      return LedgerService.getTransactionSummary(partyId, branchId: _currentBranchId);
    } catch (e, s) {
      safeDebugPrint('PartyLedgerService.getTransactionSummary failed: $e\n$s');
      return {};
    }
  }

  /// الحصول على كافة الأرصدة الموحدة بكفاءة
  static Future<Map<String, double>> getAllCombinedBalances() async {
    return LedgerService.getAllCombinedBalances();
  }
}

