import 'package:equatable/equatable.dart';

import 'reports_event.dart';
import '../services/report_projection_service.dart';

class ReportsState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ProfitReportBundle? bundle;
  final DateTime fromDate;
  final DateTime toDate;
  final ReportPeriod selectedPeriod;
  final String periodLabel;

  ReportsState({
    this.isLoading = false,
    this.errorMessage,
    this.bundle,
    DateTime? fromDate,
    DateTime? toDate,
    this.selectedPeriod = ReportPeriod.thisMonth,
    this.periodLabel = '',
  })  : fromDate = fromDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        toDate = toDate ?? DateTime.now();

  ReportsState copyWith({
    bool? isLoading,
    String? errorMessage,
    ProfitReportBundle? bundle,
    DateTime? fromDate,
    DateTime? toDate,
    ReportPeriod? selectedPeriod,
    String? periodLabel,
    bool clearError = false,
  }) {
    return ReportsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      bundle: bundle ?? this.bundle,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      periodLabel: periodLabel ?? this.periodLabel,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        bundle,
        fromDate,
        toDate,
        selectedPeriod,
        periodLabel,
      ];
}
