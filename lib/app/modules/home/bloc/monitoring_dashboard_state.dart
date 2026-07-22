import 'package:equatable/equatable.dart';

import 'chart_data_point.dart';

class MonitoringDashboardState extends Equatable {
  // UTF-8 Force Refresh
  final bool loading;
  final String userName;
  final String branchName;

  final double totalSales;
  final double netIncome;
  final double salesDue;
  final double salesReturnsTotal;
  final double totalPurchases;
  final double purchasesDue;
  final double purchaseReturnsTotal;
  final double expenses;

  final List<ChartDataPoint> last30DaysSales;
  final List<ChartDataPoint> fiscalYearSales;

  final List<Map<String, dynamic>> customerDebtRows;
  final List<Map<String, dynamic>> supplierDebtRows;
  final List<Map<String, dynamic>> lowStockRows;
  final List<Map<String, dynamic>> orderRows;
  final List<Map<String, dynamic>> pendingShipmentRows;

  const MonitoringDashboardState({
    this.loading = true,
    this.userName = 'مستخدم',
    this.branchName = 'الصيدلية',
    this.totalSales = 0,
    this.netIncome = 0,
    this.salesDue = 0,
    this.salesReturnsTotal = 0,
    this.totalPurchases = 0,
    this.purchasesDue = 0,
    this.purchaseReturnsTotal = 0,
    this.expenses = 0,
    this.last30DaysSales = const [],
    this.fiscalYearSales = const [],
    this.customerDebtRows = const [],
    this.supplierDebtRows = const [],
    this.lowStockRows = const [],
    this.orderRows = const [],
    this.pendingShipmentRows = const [],
  });

  MonitoringDashboardState copyWith({
    bool? loading,
    String? userName,
    String? branchName,
    double? totalSales,
    double? netIncome,
    double? salesDue,
    double? salesReturnsTotal,
    double? totalPurchases,
    double? purchasesDue,
    double? purchaseReturnsTotal,
    double? expenses,
    List<ChartDataPoint>? last30DaysSales,
    List<ChartDataPoint>? fiscalYearSales,
    List<Map<String, dynamic>>? customerDebtRows,
    List<Map<String, dynamic>>? supplierDebtRows,
    List<Map<String, dynamic>>? lowStockRows,
    List<Map<String, dynamic>>? orderRows,
    List<Map<String, dynamic>>? pendingShipmentRows,
  }) {
    return MonitoringDashboardState(
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
      branchName: branchName ?? this.branchName,
      totalSales: totalSales ?? this.totalSales,
      netIncome: netIncome ?? this.netIncome,
      salesDue: salesDue ?? this.salesDue,
      salesReturnsTotal: salesReturnsTotal ?? this.salesReturnsTotal,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      purchasesDue: purchasesDue ?? this.purchasesDue,
      purchaseReturnsTotal: purchaseReturnsTotal ?? this.purchaseReturnsTotal,
      expenses: expenses ?? this.expenses,
      last30DaysSales: last30DaysSales ?? this.last30DaysSales,
      fiscalYearSales: fiscalYearSales ?? this.fiscalYearSales,
      customerDebtRows: customerDebtRows ?? this.customerDebtRows,
      supplierDebtRows: supplierDebtRows ?? this.supplierDebtRows,
      lowStockRows: lowStockRows ?? this.lowStockRows,
      orderRows: orderRows ?? this.orderRows,
      pendingShipmentRows: pendingShipmentRows ?? this.pendingShipmentRows,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        userName,
        branchName,
        totalSales,
        netIncome,
        salesDue,
        salesReturnsTotal,
        totalPurchases,
        purchasesDue,
        purchaseReturnsTotal,
        expenses,
        last30DaysSales,
        fiscalYearSales,
        customerDebtRows,
        supplierDebtRows,
        lowStockRows,
        orderRows,
        pendingShipmentRows,
      ];
}
