import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/sales/invoice_return_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/purchases_repository.dart';
import '../auth/auth_service.dart';
import '../customer/customer_ledger_service.dart';
import '../inventory/stock_mutation_service.dart';
import '../inventory/batch_service.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_return_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/models/contacts/sales_agent_model.dart';
import 'package:pharmacy_system/app/core/data/services/crm/sales_rep_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';

/// خدمة بيانات الفرع الموحدة - توفر وصولاً سريعاً للبيانات
class BranchDataService {
  static MedicinesRepository get _medicinesRepo => sl<MedicinesRepository>();
  static CustomersRepository get _customersRepo => sl<CustomersRepository>();
  static SalesRepository get _salesRepo => sl<SalesRepository>();
  static PurchasesRepository get _purchasesRepo => sl<PurchasesRepository>();
  static SalesReturnRepository get _salesReturnRepo => sl<SalesReturnRepository>();

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  // ─── Medicines ───

  static List<MedicineModel> getMedicines({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _medicinesRepo.getMedicinesSync(branchId: bid);
  }

  static Future<List<MedicineModel>> getMedicinesAsync({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _medicinesRepo.getMedicines(branchId: bid);
  }

  static MedicineModel? getMedicine(String id) {
    return _medicinesRepo.getById(id);
  }

  static Future<void> addMedicine(MedicineModel medicine) async {
    await _medicinesRepo.create(medicine, branchId: medicine.branchId);
  }

  static Future<void> batchAddMedicines(List<MedicineModel> medicines, {bool skipSync = false}) async {
    if (medicines.isEmpty) return;
    await _medicinesRepo.batchCreate(medicines, branchId: medicines.first.branchId, skipSync: skipSync);
  }

  static Future<void> updateMedicine(MedicineModel medicine) async {
    await _medicinesRepo.update(medicine, branchId: medicine.branchId);
  }

  static Future<void> batchUpdateMedicines(List<MedicineModel> medicines, {bool skipSync = false}) async {
    if (medicines.isEmpty) return;
    await _medicinesRepo.batchUpdate(medicines, branchId: medicines.first.branchId, skipSync: skipSync);
  }

  static Future<void> deleteMedicine(MedicineModel medicine) async {
    await _medicinesRepo.delete(medicine, branchId: medicine.branchId);
  }

  // ─── Sales ───

  static List<SaleInvoiceModel> getSales({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesRepo.getSalesSync(branchId: bid);
  }

  static Future<List<SaleInvoiceModel>> getSalesAsync({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesRepo.getSales(branchId: bid);
  }

  static SaleInvoiceModel? getSale(String id) {
    return _salesRepo.getById(id);
  }

  static Future<void> addSale(SaleInvoiceModel sale) async {
    await _salesRepo.create(sale);
  }

  static Future<void> updateSale(SaleInvoiceModel sale) async {
    await _salesRepo.update(sale);
  }

  static Future<void> voidSale(String saleId, {String? branchId}) async {
    final bid = branchId ?? _currentBranchId;
    final sale = getSale(saleId);
    if (sale == null) throw StateError('الفاتورة غير موجودة');

    for (final item in sale.items) {
      await StockMutationService.adjustStock(
        medicineId: item.medicineId,
        delta: item.quantity,
        branchId: bid,
      );

      try {
        await BatchService.to.addBatch(
          medicineId: item.medicineId,
          batchNumber: 'VOID-${saleId.substring(0, 8)}',
          quantity: item.quantity,
          purchasePrice: 0.0, // Cost price logic can be added if needed
        );
      } catch (e) {
        safeDebugPrint('BranchDataService.voidSale: addBatch failed: $e');
      }
    }

    final dueAmount = sale.remainingAmount;
    if (sale.customerId != null && dueAmount > 0.0001) {
      await CustomerLedgerService.recordSaleVoid(
        customerId: sale.customerId!,
        branchId: bid,
        saleId: saleId,
        invoiceNumber: sale.invoiceNumber,
        dueAmount: dueAmount,
        createdBy: sale.createdBy,
      );
    }

    await ArchiveService.record(
      entityType: 'sale',
      entityId: sale.id,
      entityName: 'فاتورة #${sale.invoiceNumber}',
      entityData: sale.toJson(),
      branchId: bid,
    );

    final updated = sale.copyWith(
      isDeleted: true,
      lastModified: DateTime.now(),
    );
    await _salesRepo.update(updated);
  }

  // ─── Purchases ───

  static List<PurchaseInvoiceModel> getPurchases({String? branchId}) {
    return _purchasesRepo.getPurchasesSync(
      branchId: branchId ?? _currentBranchId,
    );
  }

  static PurchaseInvoiceModel? getPurchase(String id) {
    return _purchasesRepo.getById(id);
  }

  static Future<void> addPurchase(PurchaseInvoiceModel purchase) async {
    await _purchasesRepo.create(purchase);
  }

  static Future<void> updatePurchase(PurchaseInvoiceModel purchase) async {
    await _purchasesRepo.update(purchase);
  }

  static Future<void> voidPurchase(
    String purchaseId, {
    String? branchId,
  }) async {
    await _purchasesRepo.voidPurchase(
      purchaseId,
      branchId: branchId ?? _currentBranchId,
    );
  }

  // ─── Returns ───

  static List<InvoiceReturnModel> getReturns({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesReturnRepo.getSalesReturnsSync(branchId: bid);
  }

  static Future<void> addReturn(InvoiceReturnModel returnModel) async {
    await _salesReturnRepo.create(returnModel);
  }

  // ─── Customers ───

  static List<CustomerModel> getCustomers({String? branchId}) {
    return _customersRepo.getCustomersSync();
  }

  static Future<List<CustomerModel>> getCustomersAsync({String? branchId}) {
    return _customersRepo.getCustomers();
  }

  static CustomerModel? getCustomer(String id) {
    return _customersRepo.getById(id);
  }

  // ─── Sales Reps ───

  static Future<List<SalesAgentModel>> getSalesReps({String? branchId}) async {
    final bid = branchId ?? _currentBranchId;
    return SalesRepService.getAll(branchId: bid);
  }

  // ─── Branches ───

  static Future<List<dynamic>> getAllBranches() async {
    return SyncService.getPendingItems(); // Placeholder or actual branch data
  }

  // ─── Stats ───

  static Map<String, dynamic> getDashboardStats({String? branchId}) {
    final medicines = getMedicines(branchId: branchId);
    final sales = getSales(branchId: branchId);
    final purchases = getPurchases(branchId: branchId);

    final now = DateTime.now();
    final totalMedicines = medicines.length;
    final lowStockCount = medicines
        .where((m) => m.quantity <= m.minStock)
        .length;

    final totalSalesToday = sales
        .where(
          (s) =>
              s.createdAt.day == now.day &&
              s.createdAt.month == now.month &&
              s.createdAt.year == now.year,
        )
        .fold(0.0, (sum, s) => sum + s.finalAmount);

    final totalPurchasesThisMonth = purchases
        .where(
          (p) => p.createdAt.month == now.month && p.createdAt.year == now.year,
        )
        .fold(0.0, (sum, p) => sum + p.finalAmount);

    return {
      'total_medicines': totalMedicines,
      'low_stock_count': lowStockCount,
      'total_sales_today': totalSalesToday,
      'total_purchases_month': totalPurchasesThisMonth,
    };
  }
}
