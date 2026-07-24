import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';

class VoidOperationsState extends Equatable {
  final bool isLoading;
  final List<SaleInvoiceModel> voidableSales;
  final List<PurchaseInvoiceModel> voidablePurchases;

  const VoidOperationsState({
    this.isLoading = false,
    this.voidableSales = const [],
    this.voidablePurchases = const [],
  });

  VoidOperationsState copyWith({
    bool? isLoading,
    List<SaleInvoiceModel>? voidableSales,
    List<PurchaseInvoiceModel>? voidablePurchases,
  }) {
    return VoidOperationsState(
      isLoading: isLoading ?? this.isLoading,
      voidableSales: voidableSales ?? this.voidableSales,
      voidablePurchases: voidablePurchases ?? this.voidablePurchases,
    );
  }

  @override
  List<Object?> get props => [isLoading, voidableSales, voidablePurchases];
}




