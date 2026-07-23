import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/domain/models/base/correction_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/services/print_settings_service.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/receipt_number_service.dart';
import '../../../modules/accounting/services/accounting_engine_service.dart';
import '../../../modules/accounting/services/journal_entry_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/batch_service.dart';
import '../models/pos_cart_line.dart';

class SaleEngine {
  static String get branchId => AuthService.currentBranchId ?? '';
  static String get cashierId => AuthService.currentUser?.id ?? '';
  static bool get isPrintEnabled => PrintSettingsService.isPrintEnabled;

  /// Completes a sale: creates SaleModel, decrements stock, records ledger & correction
  static Future<SaleModel> execute({
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

    // مفتاح الجدارة (idempotency): يمنع تسجيل نفس الفاتورة مرتين بسبب
    // الضغط المزدوج على "إتمام البيع". مبنى على محتوى السلة + المبلغ + العميل
    // + رقم الوردية الحالية، فيمنع أي تكرار لوردية كاملة (مش بس نفس الثانية)
    // ونسمح ببيعتين متطابقتين في ورديات مختلفة.
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
    // 1. خَصم المخزون أولاً — لو فشل (مثلاً كمية غير كافية) نوقف العملية تماماً
    // ده بيمنع حدوث "فاتورة مسجلة بدون خصم مخزون" (Ghost Sale)
    await _decrementStock(cart, branchId);

    final sale = SaleModel(
      id: idempotencyKey,
      branchId: branchId,
      customerId: customerId,
      customerName: customerName,
      items: cart.map((l) => SaleItemModel(
        medicineId: l.medicine.id,
        medicineName: l.medicine.name,
        quantity: l.quantity,
        unitPrice: l.unitPrice,
        totalPrice: l.lineTotal,
        costPrice: l.medicine.buyPrice,
      )).toList(),
      totalAmount: subtotal,
      discount: totalDiscount > 0 ? totalDiscount : null,
      finalAmount: grandTotal,
      paidAmount: paidTotal,
      taxAmount: _cartTaxTotal(cart),
      paymentMethod: paymentMethod,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
      createdBy: cashierId,
      createdAt: now,
      receiptNumber: await ReceiptNumberService.nextForBranch(branchId),
    );

    // 2. تسجيل الفاتورة في قاعدة البيانات
    await BranchDataService.addSale(sale);

    // العمليات التالية نلفها في try-catch عشان متبوظش المبيعة لو فشلت (Best effort)
    try {
      // 3. تسجيل مديونية العميل في الحالتين: آجل (credit) أو مختلط فيه مبلغ مستحق.
      final isCreditLike = paymentMethod == 'credit' || paymentMethod == 'mixed';
      final dueAmount = paymentMethod == 'mixed'
          ? (grandTotal - paidTotal).clamp(0.0, double.infinity)
          : grandTotal;
      if (isCreditLike && customerId != null && dueAmount > 0.0001) {
        await CustomerLedgerService.recordSaleInvoice(
          customerId: customerId,
          branchId: branchId,
          saleId: sale.id,
          invoiceNumber: sale.id,
          dueAmount: double.parse(dueAmount.toStringAsFixed(2)),
          createdBy: cashierId,
        );
      }
    } catch (e) {
      safeDebugPrint('SaleEngine: Customer ledger failed: $e');
    }

    // Build accounting entry
    try {
      final entry = await SalesAccountingService().buildEntry(
        sale: sale,
        actorId: cashierId,
        paidTotal: paidTotal,
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
        details: AppStrings.saleSuccessFormat(sale.finalAmount.toStringAsFixed(2)),
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
    // المفتاح مبني على محتوى السلة + المبلغ + العميل + رقم الوردية (مش الوقت)
    // عشان نمنع أي تكرار في نفس الوردية، ونسمح ببيعتين متطابقتين في ورديات مختلفة.
    final input = '$branchId|$customerId|$shiftId|$itemsHash|$grandTotal';
    return Uuid().v5(Namespace.url.value, input);
  }

  static double _cartTaxTotal(List<PosCartLine> cart) {
    return double.parse(
      cart.fold(0.0, (sum, l) => sum + l.taxAmount).toStringAsFixed(2),
    );
  }

  static SaleModel? _findRecentSaleByIdempotencyKey(String idempotencyKey, String branchId) {
    try {
      final sales = BranchDataService.getSales(branchId: branchId);
      // المفتاح deterministic (مبني على محتوى السلة + المبلغ + العميل + الوردية)
      // فأي فاتورة متطابقة في نفس الوردية بتترفض — يمنع الضغط المزدوج والازدواج.
      // نافذة 10 ثواني إضافية تأمين ضد التكرار في نفس اللحظة (بدلاً من 3).
      final cutoff = DateTime.now().subtract(const Duration(seconds: 10));
      return sales.firstWhereOrNull(
        (s) => s.id == idempotencyKey && !s.isDeleted && s.createdAt.isAfter(cutoff),
      );
    } catch (_) {
      return null;
    }
  }

  /// Decrement stock and consume from batches for each item in cart
  static Future<void> _decrementStock(List<PosCartLine> cart, String branchId) async {
    for (final line in cart) {
      // نخصم من فرع الفاتورة الحالي (branchId) مش من فرع الدواء،
      // لأن الدواء ممكن يكون مشترك أو branchId بتاعه قديم/فارغ.
      await StockMutationService.adjustStock(
        medicineId: line.medicine.id,
        delta: -line.totalPieces, // الخصم بإجمالي عدد القطع الصغرى
        branchId: branchId,
      );

      // خصم الكمية من التشغيلات (Batches) بنظام FEFO (الأقرب انتهاءً أولاً)
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

