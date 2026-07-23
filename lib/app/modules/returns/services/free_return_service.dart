import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/party_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class FreeReturnService {
  static const _uuid = Uuid();
  static AppDatabase get _db => sl<AppDatabase>();

  static Future<ReturnModel> submitFreeReturn(ReturnModel model) async {
    try {
      final branchId = model.branchId;
      
      // 1. Save to Local Database
      await _db.into(_db.returnsTable).insert(
        ReturnsTableCompanion(
          id: Value(model.id),
          branchId: Value(branchId),
          returnType: Value(model.returnType),
          partyId: Value(model.partyId),
          partyName: Value(model.partyName),
          partyType: Value(model.partyType),
          saleId: Value(model.saleId),
          purchaseId: Value(model.purchaseId),
          items: Value(jsonEncode(model.items.map((e) => e.toJson()).toList())),
          totalAmount: Value(model.totalAmount),
          discountPercent: Value(model.discountPercent),
          finalAmount: Value(model.finalAmount),
          safeId: Value(model.safeId),
          reason: Value(model.reason.name),
          notes: Value(model.notes),
          createdBy: Value(model.createdBy),
          createdAt: Value(model.createdAt),
          syncVersion: Value(model.syncVersion),
          lastModified: Value(DateTime.now()),
          isDeleted: const Value(false),
        ),
      );

      // 2. Queue for Sync
      unawaited(
        SyncService.queueOperation(
          type: SyncOperationType.create,
          table: 'returns',
          data: model.toJson(),
          branchId: branchId,
        ),
      );

      // 3. Update Inventory
      // If Sales Return -> delta is Positive (adds to stock)
      // If Purchase Return -> delta is Negative (subtracts from stock)
      final isSalesReturn = model.returnType == 'sales';
      for (final item in model.items) {
        final delta = isSalesReturn ? item.quantity : -item.quantity;
        await StockMutationService.adjustStock(
          medicineId: item.medicineId,
          delta: delta,
          branchId: branchId,
        );
      }

      // 4. Update Financial Ledger / Safe
      if (model.partyType != 'cash' && model.partyId != null) {
        // Credit Return
        if (isSalesReturn) {
          // Sales Return for Customer -> Decrease debt (Credit them)
          await PartyLedgerService.recordDiscountNotice(
            partyId: model.partyId!,
            amount: model.finalAmount,
            createdBy: model.createdBy,
            notes: 'مرتجع مبيعات حر رقم ${model.id.substring(0, 8)}',
            ledgerTarget: 'customer',
          );
        } else {
          // Purchase Return to Supplier -> Decrease our debt to them (Debit them)
          await PartyLedgerService.recordAdditionNotice(
            partyId: model.partyId!,
            amount: model.finalAmount,
            createdBy: model.createdBy,
            notes: 'مرتجع مشتريات حر رقم ${model.id.substring(0, 8)}',
            ledgerTarget: 'supplier',
          );
        }
      } else {
        // Cash Return
        // Logic for cash return would involve recordCashPayment (for sales return) 
        // or recordCashReceipt (for purchase return) in the safe.
        if (isSalesReturn) {
           await PartyLedgerService.recordCashPayment(
             partyId: model.partyId ?? 'cash', // Fallback to 'cash' if no party selected
             amount: model.finalAmount,
             createdBy: model.createdBy,
             notes: 'صرف نقدي مقابل مرتجع مبيعات حر',
           );
        } else {
           await PartyLedgerService.recordCashReceipt(
             partyId: model.partyId ?? 'cash',
             amount: model.finalAmount,
             createdBy: model.createdBy,
             notes: 'تحصيل نقدي مقابل مرتجع مشتريات حر',
           );
        }
      }

      return model;
    } catch (e, s) {
      safeDebugPrint('FreeReturnService.submitFreeReturn failed: $e\n$s');
      rethrow;
    }
  }
}
