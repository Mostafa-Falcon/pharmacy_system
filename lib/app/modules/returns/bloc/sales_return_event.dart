import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';

class SelectedItem {
  final String medicineId;
  final String medicineName;
  final double unitPrice;
  final int returnQuantity;
  final int maxQuantity;

  SelectedItem({
    required this.medicineId,
    required this.medicineName,
    required this.unitPrice,
    required this.returnQuantity,
    required this.maxQuantity,
  });

  bool get isValid => returnQuantity > 0 && returnQuantity <= maxQuantity;

  Map<String, dynamic> toMap() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'quantity': returnQuantity,
    'unit_price': unitPrice,
  };
}

abstract class SalesReturnEvent extends Equatable {
  const SalesReturnEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalesReturns extends SalesReturnEvent {
  const LoadSalesReturns();
}

class SearchSalesReturns extends SalesReturnEvent {
  final String query;
  const SearchSalesReturns(this.query);

  @override
  List<Object?> get props => [query];
}

class SetSalesReturnFilter extends SalesReturnEvent {
  final String filter;
  const SetSalesReturnFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class CreateSalesReturn extends SalesReturnEvent {
  final SaleInvoiceModel originalSale;
  final List<SelectedItem> selectedItems;
  final ReturnReason reason;
  final String? notes;

  const CreateSalesReturn({
    required this.originalSale,
    required this.selectedItems,
    required this.reason,
    this.notes,
  });

  @override
  List<Object?> get props => [originalSale, selectedItems, reason, notes];
}





