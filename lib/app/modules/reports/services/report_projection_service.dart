import '../../accounting/services/accounting_projection_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';

class ProfitReportBundle {
  final double netProfit;
  final double revenue;
  final double costOfGoodsSold;
  final double grossProfit;
  final double operatingExpenses;
  final double netSales;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;

  const ProfitReportBundle({
    required this.netProfit,
    required this.revenue,
    required this.costOfGoodsSold,
    required this.grossProfit,
    required this.operatingExpenses,
    required this.netSales,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });
}

class ReportProjectionService {
  double _money(double value) => (value * 100).roundToDouble() / 100;

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  bool _inside(DateTime value, DateTime from, DateTime to) {
    final local = value.toLocal();
    final start = _startOfDay(from);
    final end = _endOfDay(to);
    return !local.isBefore(start) && !local.isAfter(end);
  }

  Future<ProfitReportBundle> build({
    required String branchId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final sales = _getSales(branchId, fromDate, toDate);
    final salesReturns = _getSalesReturns(branchId, fromDate, toDate);
    final grossSales = sales.fold<double>(0, (sum, s) => sum + s.finalAmount);
    final salesReturnTotal =
        salesReturns.fold<double>(0, (sum, r) => sum + r.totalAmount);
    final netSales = _money(grossSales - salesReturnTotal);

    final summary = await _getAccountingSummary(branchId, fromDate, toDate);

    return ProfitReportBundle(
      netProfit: summary.netProfit,
      revenue: summary.revenue,
      costOfGoodsSold: summary.costOfGoodsSold,
      grossProfit: summary.grossProfit,
      operatingExpenses: summary.operatingExpenses,
      netSales: netSales,
      totalDebit: summary.totalDebit,
      totalCredit: summary.totalCredit,
      isBalanced: summary.balanced,
    );
  }

  List<SaleModel> _getSales(String branchId, DateTime from, DateTime to) {
    return BranchDataService.getSales(branchId: branchId)
        .where((s) => !s.isDeleted && _inside(s.createdAt, from, to))
        .toList();
  }

  List<ReturnModel> _getSalesReturns(
      String branchId, DateTime from, DateTime to) {
    return BranchDataService.getReturns(branchId: branchId)
        .where((r) =>
            r.saleId != null &&
            !r.isDeleted &&
            _inside(r.createdAt, from, to))
        .toList();
  }

  Future<AccountingSummaryProjection> _getAccountingSummary(
      String branchId, DateTime from, DateTime to) async {
    return AccountingProjectionService.getSummary(
      branchId: branchId,
      from: from,
      to: to,
    );
  }
}

