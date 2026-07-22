import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/quote_model.dart';

enum QuotesStatus { initial, loading, loaded, error }

class QuotesState extends Equatable {
  final QuotesStatus status;
  final List<QuoteModel> quotes;
  final String? error;

  const QuotesState({
    this.status = QuotesStatus.initial,
    this.quotes = const [],
    this.error,
  });

  QuotesState copyWith({
    QuotesStatus? status,
    List<QuoteModel>? quotes,
    String? error,
    bool clearError = false,
  }) {
    return QuotesState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, quotes, error];
}

