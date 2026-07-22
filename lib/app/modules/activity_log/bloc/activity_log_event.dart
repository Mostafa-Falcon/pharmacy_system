import 'package:equatable/equatable.dart';

abstract class ActivityLogEvent extends Equatable {
  const ActivityLogEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivityLog extends ActivityLogEvent {
  const LoadActivityLog();
}

class RefreshActivityLog extends ActivityLogEvent {
  const RefreshActivityLog();
}
