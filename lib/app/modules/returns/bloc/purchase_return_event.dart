import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';

class PurchaseReturnItem {
  final String medicineId;
  final String medicineName;
  final int returnQuantity;
  final int maxQuantity;
  final double unitPrice;

  PurchaseReturnItem({
    required this.medicineId,
    required this.medicineName,
    required this.returnQuantity,
    required this.maxQuantity,
    required this.unitPrice,
  });

  bool get isValid => returnQuantity > 0 && returnQuantity <= maxQuantity;
}

abstract class PurchaseReturnEvent extends Equatable {
  const PurchaseReturnEvent();

  @override
  List<Object?> get props => [];
}

class LoadPurchaseReturns extends PurchaseReturnEvent {
  const LoadPurchaseReturns();
}

class SearchPurchaseReturns extends PurchaseReturnEvent {
  final String query;
  const SearchPurchaseReturns(this.query);

  @override
  List<Object?> get props => [query];
}

class SetPurchaseReturnFilter extends PurchaseReturnEvent {
  final String filter;
  const SetPurchaseReturnFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class CreatePurchaseReturn extends PurchaseReturnEvent {
  final PurchaseModel originalPurchase;
  final List<PurchaseReturnItem> selectedItems;
  final ReturnReason reason;
  final String? notes;

  const CreatePurchaseReturn({
    required this.originalPurchase,
    required this.selectedItems,
    required this.reason,
    this.notes,
  });

  @override
  List<Object?> get props => [originalPurchase, selectedItems, reason, notes];
}

class ToggleSelectReturn extends PurchaseReturnEvent {
  final String id;
  const ToggleSelectReturn(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectAllReturns extends PurchaseReturnEvent {
  final bool select;
  const ToggleSelectAllReturns(this.select);
  @override
  List<Object?> get props => [select];
}

