import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/constants/strings/sales_strings.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/services/print_settings_service.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/receipt_number_service.dart';
import '../../../modules/accounting/services/accounting_engine_service.dart';
import '../../../modules/accounting/services/journal_entry_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/batch_service.dart';
import 'package:pharmacy_system/app/modules/sales/models/pos_cart_line.dart';

class SaleEngine {
  static String get branchId => AuthService.currentBranchId ?? '';
  static String get cashierId => AuthService.currentUser?.id ?? '';
  static bool get isPrintEnabled => PrintSettingsService.isPrintEnabled;

  /// تنفيذ عملية البيع بالكامل: إنشاء الفاتورة، خصم المخزون، تسجيل الحسابات
  static Future<SaleInvoiceModel> execute({
    required List<PosCartLine> cart,
    required double subtotal,
    required double totalDiscount,
    required double grandTotal,
    required String paymentMethod,
    required String? customerId,
    required String? customerName,
    required String? notes,
    required String cashierId,
    required String branchId,
    required Function(String message) onWarning,
    double paidTotal = 0,
    String? shiftId,
  }) async {
    final now = DateTime.now();

    final idempotencyKey = _generateIdempotencyKey(
      cart: cart,
      grandTotal: grandTotal,
      customerId: customerId,
      branchId: branchId,
      shiftId: shiftId,
    );

    final existing = _findRecentSaleByIdempotencyKey(idempotencyKey, branchId);
    if (existing != null) {
      return existing;
    }

    await _decrementStock(cart, branchId);

    final sale = SaleInvoiceModel(
      id: idempotencyKey,
      invoiceNumber: await ReceiptNumberService.nextForBranch(branchId),
      branchId: branchId,
      customerId: customerId,
      customerName: customerName ?? 'زبون نقدي',
      items: cart.map((l) => SaleItemModel(
        medicineId: l.medicine.id,
        medicineName: l.medicine.name,
        unitLevel: 1, // Placeholder logic
        unitName: 'علبة', // Placeholder
        quantity: l.quantity,
        unitPrice: l.unitPrice,
        totalPrice: l.lineTotal,
      )).toList(),
      subtotalAmount: subtotal,
      discountAmount: totalDiscount,
      finalAmount: grandTotal,
      paidAmount: paidTotal,
      remainingAmount: (grandTotal - paidTotal).clamp(0.0, double.infinity),
      cashRegisterId: shiftId ?? '',
      paymentMethod: paymentMethod,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
      createdBy: cashierId,
      createdAt: now,
      accountId: '', // Should be filled from session
    );

    await BranchDataService.addSale(sale);

    try {
      final isCreditLike = paymentMethod == 'credit' || paymentMethod == 'mixed';
      final dueAmount = sale.remainingAmount;
      if (isCreditLike && customerId != null && dueAmount > 0.0001) {
        await CustomerLedgerService.recordSaleInvoice(
          customerId: customerId,
          branchId: branchId,
          saleId: sale.id,
          invoiceNumber: sale.invoiceNumber,
          dueAmount: dueAmount,
          createdBy: cashierId,
        );
      }
    } catch (e) {
      safeDebugPrint('SaleEngine: Customer ledger failed: $e');
    }

    try {
      final entry = await SalesAccountingService().buildEntry(
        sale: sale,
        actorId: cashierId,
      );
      await JournalEntryService.create(entry);
    } catch (e, s) {
      safeDebugPrint('SaleEngine accounting failed: $e\n$s');
    }

    try {
      CorrectionService.record(
        referenceType: CorrectionReferenceType.sale,
        referenceId: sale.id,
        action: CorrectionAction.created,
        details: SalesStrings.saleSuccessFormat(sale.finalAmount.toStringAsFixed(2)),
      );
    } catch (e) {
      safeDebugPrint('SaleEngine: Correction record failed: $e');
    }

    SoundService.instance.play(SoundEffect.saleComplete);
    return sale;
  }

  static String _generateIdempotencyKey({
    required List<PosCartLine> cart,
    required double grandTotal,
    required String? customerId,
    required String branchId,
    String? shiftId,
  }) {
    final itemsHash = cart.map((l) => '${l.medicine.id}:${l.quantity}:${l.unitPrice}').join('|');
    final input = '$branchId|$customerId|$shiftId|$itemsHash|$grandTotal';
    return Uuid().v5(Namespace.url.value, input);
  }

  static SaleInvoiceModel? _findRecentSaleByIdempotencyKey(String idempotencyKey, String branchId) {
    try {
      final sales = BranchDataService.getSales(branchId: branchId);
      final cutoff = DateTime.now().subtract(const Duration(seconds: 10));
      return sales.firstWhereOrNull(
        (s) => s.id == idempotencyKey && !s.isDeleted && s.createdAt.isAfter(cutoff),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> _decrementStock(List<PosCartLine> cart, String branchId) async {
    for (final line in cart) {
      await StockMutationService.adjustStock(
        medicineId: line.medicine.id,
        delta: -line.totalPieces,
        branchId: branchId,
      );

      try {
        await BatchService.to.consumeFromBatches(
          medicineId: line.medicine.id,
          quantity: line.totalPieces,
        );
      } catch (e) {
        safeDebugPrint('SaleEngine: Batch consumption failed for ${line.medicine.id}: $e');
      }
    }
  }
}

