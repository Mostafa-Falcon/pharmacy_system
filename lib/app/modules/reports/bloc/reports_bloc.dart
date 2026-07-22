
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import '../services/report_projection_service.dart';
import 'reports_event.dart';
import 'reports_state.dart';

export 'reports_event.dart';
export 'reports_state.dart';

/// Profit and sales reports Bloc.
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsState()) {
    on<LoadReport>(_onLoad);
    on<SelectReportPeriod>(_onSelectPeriod);
    on<PickCustomRange>(_onPickRange);
  }

  final ReportProjectionService _projection = ReportProjectionService();

  String get _branchId => AuthService.currentBranchId ?? '';

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _labelFor(DateTime from, DateTime to) =>
      '${from.year}/${_pad(from.month)}/${_pad(from.day)} — ${to.year}/${_pad(to.month)}/${_pad(to.day)}';

  void _applyPeriod(ReportPeriod period, Emitter<ReportsState> emit) {
    final now = DateTime.now();
    switch (period) {
      case ReportPeriod.today:
        emit(state.copyWith(fromDate: now, toDate: now));
        break;
      case ReportPeriod.thisWeek:
        emit(state.copyWith(fromDate: now.subtract(Duration(days: now.weekday - 1)), toDate: now));
        break;
      case ReportPeriod.thisMonth:
        emit(state.copyWith(fromDate: DateTime(now.year, now.month, 1), toDate: now));
        break;
      case ReportPeriod.thisYear:
        emit(state.copyWith(fromDate: DateTime(now.year, 1, 1), toDate: now));
        break;
      case ReportPeriod.custom:
        break;
    }
    emit(state.copyWith(periodLabel: _labelFor(state.fromDate, state.toDate)));
  }

  Future<void> _onLoad(LoadReport event, Emitter<ReportsState> emit) async {
    final branchId = _branchId;
    if (branchId.isEmpty) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final bundle = await _projection.build(
        branchId: branchId,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );
      emit(state.copyWith(bundle: bundle, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void _onSelectPeriod(SelectReportPeriod event, Emitter<ReportsState> emit) {
    emit(state.copyWith(selectedPeriod: event.period));
    _applyPeriod(event.period, emit);
    add(const LoadReport());
  }

  void _onPickRange(PickCustomRange event, Emitter<ReportsState> emit) {
    emit(state.copyWith(
      fromDate: event.from,
      toDate: event.to,
      selectedPeriod: ReportPeriod.custom,
      periodLabel: _labelFor(event.from, event.to),
    ));
    add(const LoadReport());
  }

  String getSelectedPeriodLabel() {
    switch (state.selectedPeriod) {
      case ReportPeriod.today:
        return AppStrings.todayLabel;
      case ReportPeriod.thisWeek:
        return AppStrings.reportsThisWeek;
      case ReportPeriod.thisMonth:
        return AppStrings.reportsThisMonth;
      case ReportPeriod.thisYear:
        return AppStrings.reportsThisYear;
      case ReportPeriod.custom:
        return AppStrings.reportsCustom;
    }
  }

  Map<String, dynamic> getSalesReport() {
    final sales = BranchDataService.getSales(branchId: _branchId);
    final now = DateTime.now();
    final today = sales.where((s) =>
        s.createdAt.year == now.year &&
        s.createdAt.month == now.month &&
        s.createdAt.day == now.day).length;
    final month = sales.where((s) =>
        s.createdAt.year == now.year && s.createdAt.month == now.month).length;
    return {
      'total': sales.length,
      'totalAmount': sales.fold<double>(0.0, (sum, s) => sum + s.finalAmount),
      'today': today,
      'month': month,
    };
  }

  Map<String, dynamic> getPurchasesReport() {
    final purchases = BranchDataService.getPurchases(branchId: _branchId);
    final now = DateTime.now();
    final month = purchases.where((p) =>
        p.createdAt.year == now.year && p.createdAt.month == now.month).length;
    return {
      'total': purchases.length,
      'totalAmount': purchases.fold<double>(0.0, (sum, p) => sum + p.totalAmount),
      'month': month,
    };
  }
}
