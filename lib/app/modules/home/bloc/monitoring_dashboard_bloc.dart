import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import '../../../modules/accounting/services/accounting_projection_service.dart';
import 'chart_data_point.dart';
import 'monitoring_dashboard_event.dart';
import 'monitoring_dashboard_state.dart';

class MonitoringDashboardBloc
    extends Bloc<MonitoringDashboardEvent, MonitoringDashboardState> {
  // UTF-8 Force Refresh
  MonitoringDashboardBloc() : super(const MonitoringDashboardState()) {
    on<LoadMonitoringDashboard>(_onLoad);
    on<RefreshMonitoringDashboard>(_onLoad);
    add(const LoadMonitoringDashboard());
  }

  Future<void> _onLoad(
    MonitoringDashboardEvent event,
    Emitter<MonitoringDashboardState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final user = AuthService.currentUser;
    final branch = AuthService.currentBranch;
    final branchId = AuthService.currentBranchId ?? '';

    final sales = BranchDataService.getSales(branchId: branchId);
    final purchases = BranchDataService.getPurchases(branchId: branchId);
    final returns = BranchDataService.getReturns(branchId: branchId);
    final medicines = BranchDataService.getMedicines(branchId: branchId);

    final totalSales = sales.fold<double>(0, (s, e) => s + e.finalAmount);
    final totalPurchases =
        purchases.fold<double>(0, (s, e) => s + e.finalAmount);

    final salesRet = returns.where((r) => r.saleId != null).toList();
    final purchRet = returns.where((r) => r.purchaseId != null).toList();
    final salesReturnsTotal =
        salesRet.fold<double>(0, (s, e) => s + e.totalAmount);
    final purchaseReturnsTotal =
        purchRet.fold<double>(0, (s, e) => s + e.totalAmount);

    double expenses;
    double netIncome;
    try {
      final summary =
          await AccountingProjectionService.getSummary(branchId: branchId);
      expenses = summary.operatingExpenses;
      netIncome = summary.netProfit;
    } catch (_) {
      expenses = 0;
      netIncome = totalSales - totalPurchases;
    }

    final customerDebtRows = _loadCustomerDebts();
    final supplierDebtRows = _loadSupplierDebts();

    final last30DaysSales = _aggregateLast30Days(sales);
    final fiscalYearSales = _aggregateFiscalYear(sales);

    final orderRows = sales.map((s) {
      return {
        'date': _fmtDate(s.createdAt),
        'orderNumber': s.id.substring(0, 8),
        'customer': s.customerName ?? 'نقدي',
        'total': '${s.finalAmount.toStringAsFixed(2)} ج.م',
        'status': s.paymentMethod == 'credit' ? 'آجل' : 'مكتمل',
      };
    }).toList();

    final pendingShipmentRows = sales
        .where((s) => s.paymentMethod == 'credit')
        .map((s) {
          return {
            'date': _fmtDate(s.createdAt),
            'invoice': s.id.substring(0, 8),
            'customer': s.customerName ?? '—',
            'status': 'معلق',
          };
        })
        .toList();

    final lowStockRows = medicines
        .where((m) => m.quantity < m.minStock)
        .map((m) {
          return {
            'item': m.name,
            'stock': '${m.quantity}',
            'minStock': '${m.minStock}',
          };
        })
        .toList();

    emit(state.copyWith(
      loading: false,
      userName: user?.name ?? 'مستخدم',
      branchName: branch?.name ?? 'الصيدلية',
      totalSales: totalSales,
      netIncome: netIncome,
      salesDue: customerDebtRows.fold<double>(0, (s, r) {
        final val = (r['debt'] as String)
            .replaceAll(' ج.م', '')
            .replaceAll(',', '');
        return s + (double.tryParse(val) ?? 0);
      }),
      salesReturnsTotal: salesReturnsTotal,
      totalPurchases: totalPurchases,
      purchasesDue: 0,
      purchaseReturnsTotal: purchaseReturnsTotal,
      expenses: expenses,
      customerDebtRows: customerDebtRows,
      supplierDebtRows: supplierDebtRows,
      lowStockRows: lowStockRows,
      orderRows: orderRows,
      pendingShipmentRows: pendingShipmentRows,
      last30DaysSales: last30DaysSales,
      fiscalYearSales: fiscalYearSales,
    ));
  }

  List<Map<String, dynamic>> _loadCustomerDebts() {
    try {
      final customers = CustomerService.getAll();
      return customers
          .where((c) => c.creditLimit > 0)
          .map((c) => {
                'name': c.name,
                'debt': '${c.creditLimit.toStringAsFixed(2)} ج.م',
              })
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<Map<String, dynamic>> _loadSupplierDebts() {
    try {
      final suppliers = SupplierService.getAll();
      return suppliers
          .map((s) => {'name': s.name, 'debt': '0.00 ج.م'})
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<ChartDataPoint> _aggregateLast30Days(List sales) {
    final now = DateTime.now();
    final map = <String, double>{};
    for (var i = 29; i >= 0; i--) {
      map[DateFormat('MM/dd').format(now.subtract(Duration(days: i)))] = 0;
    }
    for (final s in sales) {
      if (s.createdAt.isAfter(now.subtract(const Duration(days: 30)))) {
        final key = DateFormat('MM/dd').format(s.createdAt);
        map[key] = (map[key] ?? 0) + s.finalAmount;
      }
    }
    return map.entries
        .map((e) => ChartDataPoint(label: e.key, value: e.value))
        .toList();
  }

  List<ChartDataPoint> _aggregateFiscalYear(List sales) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'إبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final map = <int, double>{};
    for (var m = 1; m <= 12; m++) {
      map[m] = 0;
    }
    for (final s in sales) {
      map[s.createdAt.month] = (map[s.createdAt.month] ?? 0) + s.finalAmount;
    }
    return map.entries
        .map((e) => ChartDataPoint(label: months[e.key - 1], value: e.value))
        .toList();
  }

  String _fmtDate(DateTime d) => DateFormat('yyyy/MM/dd').format(d);
}
