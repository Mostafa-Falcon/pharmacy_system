import 'package:equatable/equatable.dart';

enum ReportPeriod { today, thisWeek, thisMonth, thisYear, custom }

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadReport extends ReportsEvent {
  const LoadReport();
}

class SelectReportPeriod extends ReportsEvent {
  final ReportPeriod period;

  const SelectReportPeriod(this.period);

  @override
  List<Object?> get props => [period];
}

class PickCustomRange extends ReportsEvent {
  final DateTime from;
  final DateTime to;

  const PickCustomRange(this.from, this.to);

  @override
  List<Object?> get props => [from, to];
}
