import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/purchases_repository.dart';
import '../auth/auth_service.dart';
import '../customer/customer_ledger_service.dart';
import '../inventory/stock_mutation_service.dart';
import '../inventory/batch_service.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_return_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/inventory_repository.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/crm/models/sales_rep_model.dart';
import 'package:pharmacy_system/app/core/data/services/crm/sales_rep_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';

/// الخدمة الرئيسية للوصول للداتا حسب الفرع
/// محسنة لاستخدام الـ Repositories الموحدة عبر حاوي GetIt
class BranchDataService {
  // ─── Repositories Getters from GetIt ────────────────────────────
  static MedicinesRepository get _medicinesRepo => sl<MedicinesRepository>();
  static CustomersRepository get _customersRepo => sl<CustomersRepository>();
  static SalesRepository get _salesRepo => sl<SalesRepository>();
  static PurchasesRepository get _purchasesRepo => sl<PurchasesRepository>();
  static SalesReturnRepository get _salesReturnRepo => sl<SalesReturnRepository>();
  static InventoryRepository get _inventoryRepo => sl<InventoryRepository>();

  // ─── Current Branch ─────────────────────────────────────────────

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  // ─── Medicines - محسنة لاستخدام الـ Repository ──────────────────

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

  // ─── Sales - محسنة لاستخدام الـ Repository ──────────────────────

  static List<SaleModel> getSales({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesRepo.getSalesSync(branchId: bid);
  }

  static Future<List<SaleModel>> getSalesAsync({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesRepo.getSales(branchId: bid);
  }

  static SaleModel? getSale(String id) {
    return _salesRepo.getById(id);
  }

  static Future<void> addSale(SaleModel sale) async {
    await _salesRepo.create(sale);
  }

  static Future<void> updateSale(SaleModel sale) async {
    await _salesRepo.update(sale);
  }

  /// إلغاء فاتورة بيع - يرجع المخزون ويسجل الإلغاء في الكشف الحسابي
  static Future<void> voidSale(String saleId, {String? branchId}) async {
    final bid = branchId ?? _currentBranchId;
    final sale = getSale(saleId);
    if (sale == null) throw StateError('الفاتورة غير موجودة');

    // إرجاع المخزون
    for (final item in sale.items) {
      await StockMutationService.adjustStock(
        medicineId: item.medicineId,
        delta: item.quantity,
        branchId: bid,
      );

      // إرجاع الكمية للتشغيلات (Batches) عند الإلغاء
      try {
        await BatchService.to.addBatch(
          medicineId: item.medicineId,
          batchNumber: 'VOID-${saleId.substring(0, 8)}',
          quantity: item.quantity,
          purchasePrice: item.costPrice,
        );
      } catch (e) {
        safeDebugPrint('BranchDataService.voidSale: addBatch failed for ${item.medicineId}: $e');
      }
    }

    // تسجيل الإلغاء في الكشف الحسابي — نعكس المديونية المستحقة فعلياً
    // (credit = كامل المبلغ، mixed = المبلغ ناقص المدفوع، نقدي/بطاقة = صفر)
    // بدل عكس كامل المبلغ، عشان متعكسش مديونية أكتر من الحقيقي.
    final dueAmount = sale.dueAmount;
    if (sale.customerId != null && dueAmount > 0.0001) {
      await CustomerLedgerService.recordSaleVoid(
        customerId: sale.customerId!,
        branchId: bid,
        saleId: saleId,
        invoiceNumber: saleId,
        dueAmount: double.parse(dueAmount.toStringAsFixed(2)),
        createdBy: sale.createdBy,
      );
    }

    await ArchiveService.record(
      entityType: 'sale',
      entityId: sale.id,
      entityName: 'فاتورة #${sale.id.substring(0, 8)}',
      entityData: sale.toJson(),
      branchId: bid,
    );

    // تعليم الفاتورة كمحذوفة
    final updated = sale.copyWith(
      isDeleted: true,
      lastModified: DateTime.now(),
    );
    await _salesRepo.update(updated);
  }

  // ─── Purchases - محسنة لاستخدام الـ Repository ──────────────────

  static List<PurchaseModel> getPurchases({String? branchId}) {
    return _purchasesRepo.getPurchasesSync(
      branchId: branchId ?? _currentBranchId,
    );
  }

  static PurchaseModel? getPurchase(String id) {
    return _purchasesRepo.getById(id);
  }

  static Future<void> addPurchase(PurchaseModel purchase) async {
    await _purchasesRepo.create(purchase);
  }

  static Future<void> updatePurchase(PurchaseModel purchase) async {
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

  // ─── Inventory - محولة لاستخدام الـ Repository ─────────────────

  static List<InventoryItemModel> getInventory({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _inventoryRepo.getInventorySync(branchId: bid);
  }

  static InventoryItemModel? getInventoryItem(String id) {
    return _inventoryRepo.getById(id);
  }

  static Future<void> addInventory(InventoryItemModel item) async {
    item.lastModified = DateTime.now();
    await _inventoryRepo.upsert(item);
  }

  static Future<void> updateInventory(InventoryItemModel item) async {
    item.lastModified = DateTime.now();
    await _inventoryRepo.upsert(item);
  }

  // ─── Returns - محسنة لاستخدام الـ Repository ────────────────────

  static List<ReturnModel> getReturns({String? branchId}) {
    final bid = branchId ?? _currentBranchId;
    return _salesReturnRepo.getSalesReturnsSync(branchId: bid);
  }

  static Future<void> addReturn(ReturnModel returnModel) async {
    await _salesReturnRepo.create(returnModel);
  }

  // ─── Customers - محسنة لاستخدام الـ Repository ──────────────────

  static List<CustomerModel> getCustomers({String? branchId}) {
    return _customersRepo.getCustomersSync();
  }

  static Future<List<CustomerModel>> getCustomersAsync({String? branchId}) {
    return _customersRepo.getCustomers();
  }

  static CustomerModel? getCustomer(String id) {
    return _customersRepo.getById(id);
  }

  // ─── Sales Reps ────────────────────────────────────────────────

  static Future<List<SalesRepModel>> getSalesReps({String? branchId}) async {
    final bid = branchId ?? _currentBranchId;
    return SalesRepService.getAll(branchId: bid);
  }

  // ─── Branches ──────────────────────────────────────────────────

  static Future<List<dynamic>> getAllBranches() async {
    return SyncService.getAllLocalData(boxName: 'branches');
  }

  // ─── Stats (for dashboard) ────────────────────────────────────

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

