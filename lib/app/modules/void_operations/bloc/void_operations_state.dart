import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';

class VoidOperationsState extends Equatable {
  final bool isLoading;
  final List<SaleModel> voidableSales;
  final List<PurchaseModel> voidablePurchases;

  const VoidOperationsState({
    this.isLoading = false,
    this.voidableSales = const [],
    this.voidablePurchases = const [],
  });

  VoidOperationsState copyWith({
    bool? isLoading,
    List<SaleModel>? voidableSales,
    List<PurchaseModel>? voidablePurchases,
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
