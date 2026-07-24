import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/core/models/base/correction_model.dart';

class ActivityLogState extends Equatable {
  final bool isLoading;
  final bool isRefreshing;
  final List<CorrectionEntry> entries;
  final String? error;

  const ActivityLogState({
    this.isLoading = true,
    this.isRefreshing = false,
    this.entries = const [],
    this.error,
  });

  ActivityLogState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<CorrectionEntry>? entries,
    String? error,
  }) {
    return ActivityLogState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      entries: entries ?? this.entries,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isRefreshing, entries, error];
}


