
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/core/domain/models/base/correction_model.dart';
import '../auth/auth_service.dart';
import '../admin/branch_data_service.dart';
import '../accounting/correction_service.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/account_enums.dart';
import 'package:pharmacy_system/app/modules/accounting/services/journal_entry_service.dart';
import 'package:pharmacy_system/app/modules/accounting/services/accounting_engine_service.dart';
import 'package:get_it/get_it.dart';

class VoidOperationsService {
  static final VoidOperationsService _instance = VoidOperationsService._internal();
  factory VoidOperationsService() => _instance;
  VoidOperationsService._internal();

  static VoidOperationsService get to => GetIt.instance<VoidOperationsService>();

  final _salesEngine = const SalesAccountingService();
  final _purchaseEngine = const PurchaseAccountingService();
  final _purchasePolicy = const PurchaseAccountingPolicy();

  String get _userId => AuthService.currentUser?.id ?? '';
  String get _userName => AuthService.currentUser?.name ?? '';
  String get _branchId => AuthService.currentBranchId ?? '';

  Future<void> voidSale({
    required SaleModel sale,
    required String reason,
  }) async {
    await BranchDataService.voidSale(sale.id);
    await _createSaleVoidEntry(sale);
    await CorrectionService.record(
      referenceType: CorrectionReferenceType.sale,
      referenceId: sale.id,
      action: CorrectionAction.voided,
      details: reason,
    );
  }

  Future<void> voidPurchase({
    required PurchaseModel purchase,
    required String reason,
  }) async {
    await BranchDataService.voidPurchase(purchase.id);
    await _createPurchaseVoidEntry(purchase);
    await CorrectionService.record(
      referenceType: CorrectionReferenceType.purchase,
      referenceId: purchase.id,
      action: CorrectionAction.voided,
      details: reason,
    );
  }

  Future<void> _createSaleVoidEntry(SaleModel sale) async {
    final entry = await _salesEngine.buildEntry(sale: sale, actorId: _userId);

    final reversedLines = entry.lines
        .map(
          (l) => l.copyWith(
            id: const Uuid().v4(),
            debit: l.credit,
            credit: l.debit,
            description: 'إلغاء: ${l.description ?? ''}',
          ),
        )
        .toList();

    final now = DateTime.now();
    final reversed = JournalEntryModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      entryNumber: await JournalEntryService.nextNumber(_branchId),
      entryDate: now,
      entryType: JournalEntryType.salesReturn,
      referenceId: sale.id,
      referenceNumber: sale.id,
      description: 'إلغاء فاتورة بيع: ${sale.id} - ${sale.customerName ?? ''}',
      lines: reversedLines,
      totalDebit: entry.totalCredit,
      totalCredit: entry.totalDebit,
      createdById: _userId,
      createdByName: _userName,
      createdAt: now,
      updatedAt: now,
    );
    await JournalEntryService.create(reversed);
  }

  Future<void> _createPurchaseVoidEntry(PurchaseModel purchase) async {
    final paidAmount = purchase.paidAmount ?? 0;
    final paymentAccount = purchase.paymentMethod == 'cash'
        ? _purchasePolicy.cashAccountId
        : _purchasePolicy.accountsPayableAccountId;
    final entry = await _purchaseEngine.buildEntry(
      purchase: purchase,
      actorId: _userId,
      paidAmount: paidAmount,
      paymentAccountId: paymentAccount,
    );

    final reversedLines = entry.lines
        .map(
          (l) => l.copyWith(
            id: const Uuid().v4(),
            debit: l.credit,
            credit: l.debit,
            description: 'إلغاء: ${l.description ?? ''}',
          ),
        )
        .toList();

    final now = DateTime.now();
    final reversed = JournalEntryModel(
      id: const Uuid().v4(),
      branchId: _branchId,
      entryNumber: await JournalEntryService.nextNumber(_branchId),
      entryDate: now,
      entryType: JournalEntryType.purchaseReturn,
      referenceId: purchase.id,
      referenceNumber: purchase.id,
      description:
          'إلغاء فاتورة مشتريات: ${purchase.id} - ${purchase.supplierName}',
      lines: reversedLines,
      totalDebit: entry.totalCredit,
      totalCredit: entry.totalDebit,
      createdById: _userId,
      createdByName: _userName,
      createdAt: now,
      updatedAt: now,
    );
    await JournalEntryService.create(reversed);
  }

  List<SaleModel> getVoidableSales() {
    return BranchDataService.getSales(
        branchId: _branchId,
      ).where((s) => !s.isDeleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<PurchaseModel> getVoidablePurchases() {
    return BranchDataService.getPurchases(
        branchId: _branchId,
      ).where((p) => !p.isDeleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

