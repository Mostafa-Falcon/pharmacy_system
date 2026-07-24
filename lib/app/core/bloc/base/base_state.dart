import 'package:equatable/equatable.dart';

/// تمثيل للأحداث العابرة (Side Effects) مثل عرض Snackbar أو التنقل.
abstract class BaseEffect extends Equatable {
  const BaseEffect();
  @override
  List<Object?> get props => [];
}

class ShowSnackbar extends BaseEffect {
  final String message;
  final bool isError;
  const ShowSnackbar(this.message, {this.isError = false});
  @override
  List<Object?> get props => [message, isError];
}

class PlaySound extends BaseEffect {
  final String soundName;
  const PlaySound(this.soundName);
  @override
  List<Object?> get props => [soundName];
}

class BaseState<T> extends Equatable {
  final bool isLoading;
  final T? data;
  final String? errorMessage;
  final bool isInitial;
  final bool isEmpty;
  final DateTime? fromDate;
  final DateTime? toDate;

  const BaseState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
    this.isInitial = false,
    this.isEmpty = false,
    this.fromDate,
    this.toDate,
  });

  const BaseState.initial() : this(isInitial: true);
  const BaseState.loading() : this(isLoading: true);
  const BaseState.success(T data) : this(data: data);
  const BaseState.error(String message) : this(errorMessage: message);
  const BaseState.empty() : this(isEmpty: true);

  @override
  List<Object?> get props => [isLoading, data, errorMessage, isInitial, isEmpty, fromDate, toDate];

  BaseState<T> copyWith({
    bool? isLoading,
    T? data,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}


