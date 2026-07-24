import 'package:equatable/equatable.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuotes extends QuotesEvent {
  const LoadQuotes();
}

class CreateQuote extends QuotesEvent {
  final String customerName;
  final String? notes;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double discount;
  final double total;

  const CreateQuote({
    required this.customerName,
    this.notes,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    required this.total,
  });

  @override
  List<Object?> get props => [customerName, notes, items, subtotal, discount, total];
}

class DeleteQuote extends QuotesEvent {
  final String id;
  const DeleteQuote(this.id);

  @override
  List<Object?> get props => [id];
}


