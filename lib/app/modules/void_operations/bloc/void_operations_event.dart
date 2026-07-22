import 'package:equatable/equatable.dart';

abstract class VoidOperationsEvent extends Equatable {
  const VoidOperationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadVoidOperations extends VoidOperationsEvent {}

class VoidSale extends VoidOperationsEvent {
  final String saleId;
  final String reason;
  const VoidSale({required this.saleId, required this.reason});
}

class VoidPurchase extends VoidOperationsEvent {
  final String purchaseId;
  final String reason;
  const VoidPurchase({required this.purchaseId, required this.reason});
}
