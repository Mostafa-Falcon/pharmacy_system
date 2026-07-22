import 'package:equatable/equatable.dart';

abstract class MonitoringDashboardEvent extends Equatable {
  const MonitoringDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadMonitoringDashboard extends MonitoringDashboardEvent {
  const LoadMonitoringDashboard();
}

class RefreshMonitoringDashboard extends MonitoringDashboardEvent {
  const RefreshMonitoringDashboard();
}
