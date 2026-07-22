import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/core/constants/strings/reports_strings.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../services/extra_reports_service.dart';

part 'extra_reports_event.dart';
part 'extra_reports_state.dart';

/// Extra reports Bloc.
class ExtraReportsBloc extends Bloc<ExtraReportsEvent, ExtraReportsState> {
  ExtraReportsBloc() : super(ExtraReportsState()) {
    on<LoadExtraReport>(_onLoad);
    on<SelectExtraReportType>(_onSelectType);
    on<SetExtraReportRange>(_onSetRange);
    on<SelectMovementMedicine>(_onSelectMedicine);
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  String _typeLabelValue(ExtraReportType type) {
    switch (type) {
      case ExtraReportType.inventory:
        return ReportsStrings.reportsInventory;
      case ExtraReportType.inventoryCount:
        return ReportsStrings.reportsStocktake;
      case ExtraReportType.popularItems:
        return ReportsStrings.reportsPopularItems;
      case ExtraReportType.itemMovement:
        return ReportsStrings.reportsItemMovement;
      case ExtraReportType.taxSummary:
        return ReportsStrings.reportsTaxSummary;
      case ExtraReportType.employeeActivity:
        return ReportsStrings.reportsEmployeeActivity;
      case ExtraReportType.customerGroups:
        return ReportsStrings.typeCustomerGroups;
      case ExtraReportType.receipts:
        return ReportsStrings.typeReceipts;
      case ExtraReportType.salesRepPerformance:
        return ReportsStrings.typeSalesRepPerformance;
    }
  }

  Future<void> _reload(Emitter<ExtraReportsState> emit) async {
    emit(state.copyWith(isLoading: true));
    switch (state.selectedType) {
      case ExtraReportType.inventory:
        emit(state.copyWith(inventoryRows: ExtraReportsService.getInventoryReport(_branchId), isLoading: false));
        break;
      case ExtraReportType.inventoryCount:
        emit(state.copyWith(inventoryRows: ExtraReportsService.getInventoryReport(_branchId), isLoading: false));
        break;
      case ExtraReportType.popularItems:
        emit(state.copyWith(
          popularItemRows: ExtraReportsService.getPopularItemsReport(_branchId, state.fromDate, state.toDate),
          isLoading: false,
        ));
        break;
      case ExtraReportType.itemMovement:
        final medId = state.selectedMedicineId;
        emit(state.copyWith(
          movementRows: (medId != null && medId.isNotEmpty)
              ? ExtraReportsService.getItemMovementReport(_branchId, medId)
              : const [],
          isLoading: false,
        ));
        break;
      case ExtraReportType.taxSummary:
        final taxRows = await ExtraReportsService.getTaxSummaryReport(_branchId, state.fromDate, state.toDate);
        emit(state.copyWith(
          taxSummaryRows: taxRows,
          isLoading: false,
        ));
        break;
      case ExtraReportType.employeeActivity:
        final empRows = await ExtraReportsService.getEmployeeActivityReport(_branchId, state.fromDate, state.toDate);
        emit(state.copyWith(
          employeeActivityRows: empRows,
          isLoading: false,
        ));
        break;
      case ExtraReportType.customerGroups:
        emit(state.copyWith(
          customerGroupRows: ExtraReportsService.getCustomerGroupsReport(_branchId),
          isLoading: false,
        ));
        break;
      case ExtraReportType.receipts:
        emit(state.copyWith(
          receiptRows: ExtraReportsService.getReceiptsReport(_branchId, state.fromDate, state.toDate),
          isLoading: false,
        ));
        break;
      case ExtraReportType.salesRepPerformance:
        final repRows = await ExtraReportsService.getSalesRepPerformanceReport(_branchId, state.fromDate, state.toDate);
        emit(state.copyWith(
          salesRepPerformanceRows: repRows,
          isLoading: false,
        ));
        break;
    }
  }

  Future<void> _onLoad(LoadExtraReport event, Emitter<ExtraReportsState> emit) async {
    emit(state.copyWith(
      dateLabel: state._dateLabel,
      typeLabel: _typeLabelValue(state.selectedType),
    ));
    await _reload(emit);
  }

  Future<void> _onSelectType(SelectExtraReportType event, Emitter<ExtraReportsState> emit) async {
    emit(state.copyWith(selectedType: event.type, typeLabel: _typeLabelValue(event.type)));
    await _reload(emit);
  }

  Future<void> _onSetRange(SetExtraReportRange event, Emitter<ExtraReportsState> emit) async {
    emit(state.copyWith(
      fromDate: event.from,
      toDate: event.to,
      dateLabel: '${event.from.year}/${event.from.month.toString().padLeft(2, '0')}/${event.from.day.toString().padLeft(2, '0')} — ${event.to.year}/${event.to.month.toString().padLeft(2, '0')}/${event.to.day.toString().padLeft(2, '0')}',
    ));
    await _reload(emit);
  }

  void _onSelectMedicine(SelectMovementMedicine event, Emitter<ExtraReportsState> emit) {
    emit(state.copyWith(selectedMedicineId: event.medicineId));
    _reload(emit);
  }
}
