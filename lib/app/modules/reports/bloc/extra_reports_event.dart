part of 'extra_reports_bloc.dart';

abstract class ExtraReportsEvent extends Equatable {
  const ExtraReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadExtraReport extends ExtraReportsEvent {
  const LoadExtraReport();
}

class SelectExtraReportType extends ExtraReportsEvent {
  final ExtraReportType type;

  const SelectExtraReportType(this.type);

  @override
  List<Object?> get props => [type];
}

class SetExtraReportRange extends ExtraReportsEvent {
  final DateTime from;
  final DateTime to;

  const SetExtraReportRange(this.from, this.to);

  @override
  List<Object?> get props => [from, to];
}

class SelectMovementMedicine extends ExtraReportsEvent {
  final String? medicineId;

  const SelectMovementMedicine(this.medicineId);

  @override
  List<Object?> get props => [medicineId];
}


