import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/database/daos/expenses_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/cashier_shifts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/users_dao.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';

enum ExtraReportType {
  inventory,
  inventoryCount,
  popularItems,
  itemMovement,
  taxSummary,
  employeeActivity,
  customerGroups,
  receipts,
  salesRepPerformance,
}

class InventoryRow {
  final String name;
  final String sku;
  final String category;
  final int stock;
  final double buyPrice;
  final double sellPrice;
  final double costValue;
  final double saleValue;
  final double profit;

  const InventoryRow({
    required this.name,
    required this.sku,
    required this.category,
    required this.stock,
    required this.buyPrice,
    required this.sellPrice,
    required this.costValue,
    required this.saleValue,
    required this.profit,
  });
}

class PopularItemRow {
  final String item;
  final String sku;
  final int soldQuantity;
  final double salesTotal;
  final double avgPrice;
  final int invoices;

  const PopularItemRow({
    required this.item,
    required this.sku,
    required this.soldQuantity,
    required this.salesTotal,
    required this.avgPrice,
    required this.invoices,
  });
}

class MovementRow {
  final String item;
  final String sku;
  final String type;
  final String date;
  final String reference;
  final String party;
  final int quantity;
  final double unitPrice;
  final double total;

  const MovementRow({
    required this.item,
    required this.sku,
    required this.type,
    required this.date,
    required this.reference,
    required this.party,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

class TaxSummaryRow {
  final String date;
  final String type;
  final String reference;
  final String contact;
  final String taxNumber;
  final double amount;
  final String paymentMethod;
  final double unitDiscount;
  final double base;

  const TaxSummaryRow({
    required this.date,
    required this.type,
    required this.reference,
    required this.contact,
    required this.taxNumber,
    required this.amount,
    required this.paymentMethod,
    required this.unitDiscount,
    required this.base,
  });
}

class EmployeeActivityRow {
  final String date;
  final String subjectType;
  final String action;
  final String by;
  final String notes;

  const EmployeeActivityRow({
    required this.date,
    required this.subjectType,
    required this.action,
    required this.by,
    required this.notes,
  });
}

class CustomerGroupRow {
  final String groupName;
  final String customerName;
  final String phone;
  final int visits;
  final double totalPurchases;
  final double totalReturns;
  final double netPurchases;

  const CustomerGroupRow({
    required this.groupName,
    required this.customerName,
    required this.phone,
    required this.visits,
    required this.totalPurchases,
    required this.totalReturns,
    required this.netPurchases,
  });
}

class ReceiptRow {
  final String date;
  final String type;
  final String reference;
  final String contact;
  final double amount;
  final String paymentMethod;
  final String notes;

  const ReceiptRow({
    required this.date,
    required this.type,
    required this.reference,
    required this.contact,
    required this.amount,
    required this.paymentMethod,
    required this.notes,
  });
}

class ExtraReportsService {
  static String _formatDate(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y/$m/$d';
  }

  static String _formatDateTime(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y/$m/$d $h:$min';
  }

  static double _money(double v) => (v * 100).roundToDouble() / 100;

  static bool _inside(DateTime value, DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);
    return !value.isBefore(start) && !value.isAfter(end);
  }

  /// Inventory report — current stock value by purchase/sale price
  static List<InventoryRow> getInventoryReport(String branchId) {
    final items = BranchDataService.getMedicines(branchId: branchId);
    return items.where((m) => !m.isDeleted).map((m) {
      final stock = m.quantity;
      final buyPrice = m.buyPrice;
      final sellPrice = m.sellPrice;
      return InventoryRow(
        name: m.name,
        sku: m.barcodes.isNotEmpty ? m.barcodes.first : '—',
        category: m.category ?? '—',
        stock: stock,
        buyPrice: buyPrice,
        sellPrice: sellPrice,
        costValue: _money(stock * buyPrice),
        saleValue: _money(stock * sellPrice),
        profit: _money(stock * (sellPrice - buyPrice).clamp(0, double.infinity)),
      );
    }).toList();
  }

  /// Popular items — aggregated from sales within date range
  static List<PopularItemRow> getPopularItemsReport(
    String branchId,
    DateTime fromDate,
    DateTime toDate,
  ) {
    final sales = BranchDataService.getSales(branchId: branchId).where((s) =>
        !s.isDeleted && _inside(s.createdAt, fromDate, toDate));
    final map = <String, _PopularAccumulator>{};
    for (final sale in sales) {
      for (final line in sale.items) {
        final key = line.medicineId;
        final acc = map.putIfAbsent(key, () => _PopularAccumulator());
        acc.name = line.medicineName;
        acc.quantity += line.quantity;
        acc.total += line.totalPrice;
        acc.invoices += 1;
      }
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.quantity.compareTo(a.value.quantity));
    return sorted.map((e) {
      final acc = e.value;
      final avg = acc.quantity > 0 ? _money(acc.total / acc.quantity) : 0.0;
      return PopularItemRow(
        item: acc.name,
        sku: e.key,
        soldQuantity: acc.quantity,
        salesTotal: _money(acc.total),
        avgPrice: avg,
        invoices: acc.invoices,
      );
    }).toList();
  }

  /// Item movements from purchases, sales, returns
  static List<MovementRow> getItemMovementReport(
    String branchId,
    String medicineId,
  ) {
    final movements = <MovementRow>[];

    final sales = BranchDataService.getSales(branchId: branchId);
    for (final sale in sales.where((s) => !s.isDeleted)) {
      for (final line in sale.items.where((i) => i.medicineId == medicineId)) {
        movements.add(MovementRow(
          item: line.medicineName,
          sku: line.medicineId,
          type: AppStrings.movementTypeSale,
          date: _formatDateTime(sale.createdAt),
          reference: sale.id,
          party: sale.customerName ?? '—',
          quantity: line.quantity,
          unitPrice: line.unitPrice,
          total: line.totalPrice,
        ));
      }
    }

    final purchases = BranchDataService.getPurchases(branchId: branchId);
    for (final purchase in purchases.where((p) => !p.isDeleted)) {
      for (final line in purchase.items.where((i) => i.medicineId == medicineId)) {
        movements.add(MovementRow(
          item: line.medicineName,
          sku: line.medicineId,
          type: AppStrings.movementTypePurchase,
          date: _formatDateTime(purchase.createdAt),
          reference: purchase.id,
          party: purchase.supplierName,
          quantity: line.quantity,
          unitPrice: line.unitPrice,
          total: line.totalPrice,
        ));
      }
    }

    final returns = BranchDataService.getReturns(branchId: branchId);
    for (final ret in returns.where((r) => !r.isDeleted)) {
      for (final line in ret.items.where((i) => i.medicineId == medicineId)) {
        final isSaleReturn = ret.saleId != null;
        movements.add(MovementRow(
          item: line.medicineName,
          sku: line.medicineId,
          type: isSaleReturn ? AppStrings.movementTypeSaleReturn : AppStrings.movementTypePurchaseReturn,
          date: _formatDateTime(ret.createdAt),
          reference: ret.id,
          party: '—',
          quantity: line.quantity,
          unitPrice: line.unitPrice,
          total: line.totalPrice,
        ));
      }
    }

    movements.sort((a, b) => b.date.compareTo(a.date));
    return movements;
  }

  /// Tax summary from sales, purchases, and expenses
  static Future<List<TaxSummaryRow>> getTaxSummaryReport(
    String branchId,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final rows = <TaxSummaryRow>[];

    final sales = BranchDataService.getSales(branchId: branchId)
        .where((s) => !s.isDeleted && _inside(s.createdAt, fromDate, toDate));
    for (final sale in sales) {
      final discount = (sale.discount ?? 0);
      final baseAmount = sale.totalAmount;
      final taxAmount = _money(sale.finalAmount - (baseAmount - discount));
      rows.add(TaxSummaryRow(
        date: _formatDate(sale.createdAt),
        type: AppStrings.taxTypeVatSales,
        reference: sale.id,
        contact: sale.customerName ?? '—',
        taxNumber: '—',
        amount: taxAmount,
        paymentMethod: _paymentLabel(sale.paymentMethod),
        unitDiscount: discount,
        base: baseAmount,
      ));
    }

    final purchases = BranchDataService.getPurchases(branchId: branchId)
        .where((p) => !p.isDeleted && _inside(p.createdAt, fromDate, toDate));
    for (final purchase in purchases) {
      final taxAmount = (purchase.tax ?? 0) + (purchase.invoiceTaxAmount ?? 0);
      rows.add(TaxSummaryRow(
        date: _formatDate(purchase.createdAt),
        type: AppStrings.taxTypeIncomePurchase,
        reference: purchase.id,
        contact: purchase.supplierName,
        taxNumber: '—',
        amount: _money(taxAmount),
        paymentMethod: _paymentLabel(purchase.paymentMethod),
        unitDiscount: (purchase.discount ?? 0) + (purchase.invoiceDiscountAmount ?? 0),
        base: purchase.totalAmount,
      ));
    }

    final expensesDao = sl<ExpensesDao>();
    final expenseRows = await expensesDao.getByBranch(branchId);
    for (final row in expenseRows) {
      if (!_inside(row.expenseDate, fromDate, toDate)) continue;
      rows.add(TaxSummaryRow(
        date: _formatDate(row.expenseDate),
        type: AppStrings.taxTypeExpense,
        reference: row.expenseNumber.toString(),
        contact: row.category,
        taxNumber: '—',
        amount: 0,
        paymentMethod: _paymentLabel(row.paymentMethod),
        unitDiscount: 0,
        base: row.amount,
      ));
    }

    rows.sort((a, b) => b.date.compareTo(a.date));
    return rows;
  }

  /// Employee activity from shifts, users
  static Future<List<EmployeeActivityRow>> getEmployeeActivityReport(
    String branchId,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final rows = <EmployeeActivityRow>[];

    final shiftsDao = sl<CashierShiftsDao>();
    final shiftRows = await shiftsDao.getByBranch(branchId);
    for (final data in shiftRows) {
      if (!_inside(data.openedAt, fromDate, toDate)) continue;
      final statusLabel = data.status == 'open' ? AppStrings.activityShiftOpen : AppStrings.activityShiftClose;
      rows.add(EmployeeActivityRow(
        date: _formatDateTime(data.openedAt),
        subjectType: AppStrings.activitySubjectShift,
        action: statusLabel,
        by: data.cashierName,
        notes: AppStrings.activityNotesShiftFormat.replaceFirst('%s', data.shiftNumber.toString()),
      ));
    }

    final usersDao = sl<UsersDao>();
    final userRows = await usersDao.getAll();
    for (final data in userRows) {
      if (data.isDeleted) continue;
      if (!_inside(data.createdAt, fromDate, toDate)) continue;
      final roleLabel = data.role == 'owner' ? AppStrings.activityRoleOwner : AppStrings.activityRoleEmployee;
      rows.add(EmployeeActivityRow(
        date: _formatDateTime(data.createdAt),
        subjectType: AppStrings.activitySubjectEmployee,
        action: AppStrings.activityActionAddUser,
        by: data.name,
        notes: '$roleLabel — ${data.email}',
      ));
    }

    rows.sort((a, b) => b.date.compareTo(a.date));
    return rows;
  }

  static List<CustomerGroupRow> getCustomerGroupsReport(String branchId) {
    final rows = <CustomerGroupRow>[];
    final customers = BranchDataService.getCustomers(branchId: branchId).where((c) => !c.isDeleted).toList();
    final sales = BranchDataService.getSales(branchId: branchId).where((s) => !s.isDeleted).toList();
    final returns = BranchDataService.getReturns(branchId: branchId).where((r) => !r.isDeleted).toList();

    for (final customer in customers) {
      final groupName = customer.companyName?.isNotEmpty == true ? customer.companyName! : AppStrings.defaultNoGroup;
      final customerSales = sales.where((s) => s.customerId == customer.id).toList();
      final customerReturns = returns.where((r) => r.saleId != null && customer.id == (r.notes ?? '')).toList();
      final totalPurchases = customerSales.fold<double>(0, (s, sale) => s + sale.finalAmount);
      final totalReturns = customerReturns.fold<double>(0, (s, ret) => s + ret.totalAmount);
      rows.add(CustomerGroupRow(
        groupName: groupName,
        customerName: customer.name,
        phone: customer.phone ?? '—',
        visits: customerSales.length,
        totalPurchases: _money(totalPurchases),
        totalReturns: _money(totalReturns),
        netPurchases: _money(totalPurchases - totalReturns),
      ));
    }

    rows.sort((a, b) => b.netPurchases.compareTo(a.netPurchases));
    return rows;
  }

  static List<ReceiptRow> getReceiptsReport(
    String branchId,
    DateTime fromDate,
    DateTime toDate,
  ) {
    final rows = <ReceiptRow>[];

    final sales = BranchDataService.getSales(branchId: branchId)
        .where((s) => !s.isDeleted && _inside(s.createdAt, fromDate, toDate));
    for (final sale in sales) {
      rows.add(ReceiptRow(
        date: _formatDateTime(sale.createdAt),
        type: AppStrings.receiptTypeSaleInvoice,
        reference: sale.id,
        contact: sale.customerName ?? AppStrings.defaultCashCustomer,
        amount: _money(sale.finalAmount),
        paymentMethod: _paymentLabel(sale.paymentMethod),
        notes: sale.notes ?? '',
      ));
    }

    final purchases = BranchDataService.getPurchases(branchId: branchId)
        .where((p) => !p.isDeleted && _inside(p.createdAt, fromDate, toDate));
    for (final purchase in purchases) {
      rows.add(ReceiptRow(
        date: _formatDateTime(purchase.createdAt),
        type: AppStrings.receiptTypePurchaseInvoice,
        reference: purchase.id,
        contact: purchase.supplierName,
        amount: _money(purchase.finalAmount),
        paymentMethod: _paymentLabel(purchase.paymentMethod),
        notes: purchase.notes ?? '',
      ));
    }

    final returns = BranchDataService.getReturns(branchId: branchId)
        .where((r) => !r.isDeleted && _inside(r.createdAt, fromDate, toDate));
    for (final ret in returns) {
      rows.add(ReceiptRow(
        date: _formatDateTime(ret.createdAt),
        type: ret.saleId != null ? AppStrings.movementTypeSaleReturn : AppStrings.movementTypePurchaseReturn,
        reference: ret.id,
        contact: '—',
        amount: _money(ret.totalAmount),
        paymentMethod: '—',
        notes: ret.reason.name,
      ));
    }

    rows.sort((a, b) => b.date.compareTo(a.date));
    return rows;
  }

  static Future<List<SalesRepPerformanceRow>> getSalesRepPerformanceReport(String branchId, DateTime fromDate, DateTime toDate) async {
    final rows = <SalesRepPerformanceRow>[];
    final reps = await BranchDataService.getSalesReps(branchId: branchId);
    final repsFiltered = reps.where((r) => !r.isDeleted).toList();
    final sales = BranchDataService.getSales(branchId: branchId).where((s) => !s.isDeleted).toList();
    final returns = BranchDataService.getReturns(branchId: branchId).where((r) => !r.isDeleted).toList();
    final customers = BranchDataService.getCustomers(branchId: branchId).where((c) => !c.isDeleted).toList();

    for (final rep in repsFiltered) {
      final repSales = sales.where((s) => s.salesRepId == rep.id && _inside(s.createdAt, fromDate, toDate)).toList();
      final repReturns = returns.where((r) => r.saleId != null && _inside(r.createdAt, fromDate, toDate)).toList();
      final repCustomers = customers.where((c) => c.salesRepId == rep.id).toList();
      final totalSales = repSales.fold<double>(0, (s, sale) => s + sale.finalAmount);
      final totalReturns = repReturns.fold<double>(0, (s, ret) => s + ret.totalAmount);

      rows.add(SalesRepPerformanceRow(
        repId: rep.id,
        repName: rep.name,
        customers: repCustomers.length,
        visits: repSales.length,
        totalSales: _money(totalSales),
        totalReturns: _money(totalReturns),
        netSales: _money(totalSales - totalReturns),
      ));
    }

    rows.sort((a, b) => b.netSales.compareTo(a.netSales));
    return rows;
  }

  static String _paymentLabel(String method) {
    switch (method) {
      case 'cash': return AppStrings.paymentCash;
      case 'card': return AppStrings.paymentCard;
      case 'credit': return AppStrings.paymentCredit;
      case 'wallet': return AppStrings.paymentWallet;
      case 'bank-transfer': return AppStrings.paymentBankTransfer;
      default: return method;
    }
  }
}

class SalesRepPerformanceRow {
  final String repId;
  final String repName;
  final int customers;
  final int visits;
  final double totalSales;
  final double totalReturns;
  final double netSales;

  const SalesRepPerformanceRow({
    required this.repId,
    required this.repName,
    required this.customers,
    required this.visits,
    required this.totalSales,
    required this.totalReturns,
    required this.netSales,
  });
}

class _PopularAccumulator {
  String name = '';
  int quantity = 0;
  double total = 0;
  int invoices = 0;
}
