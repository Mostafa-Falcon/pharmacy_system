import 'package:equatable/equatable.dart';

abstract class BulkPriceUpdateEvent extends Equatable {
  const BulkPriceUpdateEvent();
  @override
  List<Object?> get props => [];
}

class BulkPriceUpdateLoadCategories extends BulkPriceUpdateEvent {
  const BulkPriceUpdateLoadCategories();
}

class BulkPriceUpdateApply extends BulkPriceUpdateEvent {
  final String? category;
  final String field; // 'buyPrice' | 'sellPrice' | 'both'
  final String operation; // 'set' | 'increase' | 'decrease' | 'increasePercent' | 'decreasePercent'
  final double value;

  const BulkPriceUpdateApply({
    this.category,
    required this.field,
    required this.operation,
    required this.value,
  });

  @override
  List<Object?> get props => [category, field, operation, value];
}

class BulkPriceUpdateConfirmApply extends BulkPriceUpdateEvent {
  const BulkPriceUpdateConfirmApply();
}
