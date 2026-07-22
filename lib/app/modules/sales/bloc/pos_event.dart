import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_unit_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'cart_cubit.dart';

import 'pos_state.dart';

abstract class PosEvent extends Equatable {
  const PosEvent();
  @override
  List<Object?> get props => [];
}

class PosInitialize extends PosEvent {
  const PosInitialize();
}

class PosRefreshData extends PosEvent {
  const PosRefreshData();
}

class PosLoadCatalog extends PosEvent {
  const PosLoadCatalog();
}

class PosSearchChanged extends PosEvent {
  final String query;
  const PosSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class PosCategoryChanged extends PosEvent {
  final String? category;
  const PosCategoryChanged(this.category);
  @override
  List<Object?> get props => [category];
}

class PosAddMedicine extends PosEvent {
  final MedicineModel medicine;
  final MedicineUnitModel? unit;
  const PosAddMedicine(this.medicine, [this.unit]);
  @override
  List<Object?> get props => [medicine, unit];
}

class PosAddByBarcode extends PosEvent {
  final String code;
  const PosAddByBarcode(this.code);
  @override
  List<Object?> get props => [code];
}

class PosIncrementLine extends PosEvent {
  final String id;
  const PosIncrementLine(this.id);
  @override
  List<Object?> get props => [id];
}

class PosDecrementLine extends PosEvent {
  final String id;
  const PosDecrementLine(this.id);
  @override
  List<Object?> get props => [id];
}

class PosUpdateLineQuantity extends PosEvent {
  final String id;
  final int quantity;
  const PosUpdateLineQuantity(this.id, this.quantity);
  @override
  List<Object?> get props => [id, quantity];
}

class PosRemoveLine extends PosEvent {
  final String id;
  const PosRemoveLine(this.id);
  @override
  List<Object?> get props => [id];
}

class PosUpdateLineDiscount extends PosEvent {
  final String id;
  final double percent;
  const PosUpdateLineDiscount(this.id, this.percent);
  @override
  List<Object?> get props => [id, percent];
}

class PosUpdateLinePrice extends PosEvent {
  final String id;
  final double price;
  const PosUpdateLinePrice(this.id, this.price);
  @override
  List<Object?> get props => [id, price];
}

class PosUpdateLineUnit extends PosEvent {
  final String medicineId;
  final String unitName;
  const PosUpdateLineUnit(this.medicineId, this.unitName);
  @override
  List<Object?> get props => [medicineId, unitName];
}

class PosToggleFullScreen extends PosEvent {
  const PosToggleFullScreen();
}

class PosToggleCatalog extends PosEvent {
  const PosToggleCatalog();
}

class PosUpdateCatalogWidth extends PosEvent {
  final double width;
  const PosUpdateCatalogWidth(this.width);
  @override
  List<Object?> get props => [width];
}

class PosClearCart extends PosEvent {
  const PosClearCart();
}

class PosSetInvoiceDiscount extends PosEvent {
  final double value;
  final bool isPercentage;
  const PosSetInvoiceDiscount(this.value, {this.isPercentage = false});
  @override
  List<Object?> get props => [value, isPercentage];
}

class PosSetInvoiceTax extends PosEvent {
  final double value;
  final bool isPercentage;
  const PosSetInvoiceTax(this.value, {this.isPercentage = false});
  @override
  List<Object?> get props => [value, isPercentage];
}

class PosSetPaymentMode extends PosEvent {
  final PaymentMode mode;
  const PosSetPaymentMode(this.mode);
  @override
  List<Object?> get props => [mode];
}

class PosCashChanged extends PosEvent {
  final double value;
  const PosCashChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PosCardChanged extends PosEvent {
  final double value;
  const PosCardChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PosSelectCustomer extends PosEvent {
  final String? customerId;
  const PosSelectCustomer(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class PosSelectSupplier extends PosEvent {
  final String? supplierId;
  const PosSelectSupplier(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class PosNotesChanged extends PosEvent {
  final String notes;
  const PosNotesChanged(this.notes);
  @override
  List<Object?> get props => [notes];
}

class PosOpenShift extends PosEvent {
  final double openingCash;
  const PosOpenShift(this.openingCash);
  @override
  List<Object?> get props => [openingCash];
}

class PosRefreshShift extends PosEvent {
  const PosRefreshShift();
}

class PosCloseShift extends PosEvent {
  final double countedCash;
  final String? notes;
  const PosCloseShift(this.countedCash, {this.notes});
  @override
  List<Object?> get props => [countedCash, notes];
}

class PosCompleteSale extends PosEvent {
  final CartState? cart;
  const PosCompleteSale([this.cart]);
  @override
  List<Object?> get props => [cart];
}

class PosCompleteSaleCash extends PosEvent {
  final CartState? cart;
  const PosCompleteSaleCash([this.cart]);
  @override
  List<Object?> get props => [cart];
}

class PosCompleteSaleCard extends PosEvent {
  final CartState? cart;
  const PosCompleteSaleCard([this.cart]);
  @override
  List<Object?> get props => [cart];
}

class PosCompleteSaleMixed extends PosEvent {
  final CartState? cart;
  const PosCompleteSaleMixed([this.cart]);
  @override
  List<Object?> get props => [cart];
}

class PosCompleteSaleCredit extends PosEvent {
  final CartState? cart;
  const PosCompleteSaleCredit([this.cart]);
  @override
  List<Object?> get props => [cart];
}

class PosPrintLastInvoice extends PosEvent {
  const PosPrintLastInvoice();
}

class PosSuspendSale extends PosEvent {
  const PosSuspendSale();
}

class PosResumeSale extends PosEvent {
  final Map<String, dynamic> suspended;
  final bool deleteAfter;
  const PosResumeSale(this.suspended, {this.deleteAfter = true});
  @override
  List<Object?> get props => [suspended, deleteAfter];
}

class PosDeleteSuspendedSale extends PosEvent {
  final String id;
  const PosDeleteSuspendedSale(this.id);
  @override
  List<Object?> get props => [id];
}

class PosCreateQuoteFromCart extends PosEvent {
  const PosCreateQuoteFromCart();
}

class PosAddExpense extends PosEvent {
  final String description;
  final double amount;
  const PosAddExpense(this.description, this.amount);
  @override
  List<Object?> get props => [description, amount];
}

class PosLoadCustomerBalance extends PosEvent {
  final String customerId;
  const PosLoadCustomerBalance(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class PosRecordCustomerPayment extends PosEvent {
  final String customerId;
  final double amount;
  final String? notes;
  const PosRecordCustomerPayment(this.customerId, this.amount, {this.notes});
  @override
  List<Object?> get props => [customerId, amount, notes];
}

class PosLoadSupplierBalance extends PosEvent {
  final String supplierId;
  const PosLoadSupplierBalance(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class PosRecordSupplierPayment extends PosEvent {
  final String supplierId;
  final double amount;
  final String? notes;
  const PosRecordSupplierPayment(this.supplierId, this.amount, {this.notes});
  @override
  List<Object?> get props => [supplierId, amount, notes];
}

class PosEditSale extends PosEvent {
  final SaleModel sale;
  const PosEditSale(this.sale);
  @override
  List<Object?> get props => [sale];
}

class PosEditQuote extends PosEvent {
  final dynamic quote;
  const PosEditQuote(this.quote);
  @override
  List<Object?> get props => [quote];
}

/// يغير المجموعة السعرية (تجزئة / جملة / نصف جملة)
class PosSetPriceGroup extends PosEvent {
  final String priceGroup;
  const PosSetPriceGroup(this.priceGroup);
  @override
  List<Object?> get props => [priceGroup];
}

/// يحذف السطر المحدد حالياً في السلة (أو آخر سطر لو مفيش محدد).
/// مربوط باختصار Ctrl+D في الكيبورد.
class PosRemoveSelectedLine extends PosEvent {
  const PosRemoveSelectedLine();
}

class PosTogglePrint extends PosEvent {
  const PosTogglePrint();
}

