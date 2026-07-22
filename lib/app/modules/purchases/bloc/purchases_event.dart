import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_unit_model.dart';

abstract class PurchasesEvent extends Equatable {
  const PurchasesEvent();

  @override
  List<Object?> get props => [];
}

class LoadPurchases extends PurchasesEvent {
  const LoadPurchases();
}

class SearchPurchases extends PurchasesEvent {
  final String query;
  const SearchPurchases(this.query);

  @override
  List<Object?> get props => [query];
}

class SetPurchasesFilter extends PurchasesEvent {
  final String filter;
  const SetPurchasesFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SetPurchaseDateFrom extends PurchasesEvent {
  final DateTime? date;
  const SetPurchaseDateFrom(this.date);

  @override
  List<Object?> get props => [date];
}

class SetPurchaseDateTo extends PurchasesEvent {
  final DateTime? date;
  const SetPurchaseDateTo(this.date);

  @override
  List<Object?> get props => [date];
}

class SetPurchaseReferenceNumber extends PurchasesEvent {
  final String? reference;
  const SetPurchaseReferenceNumber(this.reference);

  @override
  List<Object?> get props => [reference];
}

class SetPurchaseStatus extends PurchasesEvent {
  final String status;
  const SetPurchaseStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SetPurchaseDate extends PurchasesEvent {
  final DateTime date;
  const SetPurchaseDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SetPurchasePaymentTerm extends PurchasesEvent {
  final int? term;
  final String? unit;
  const SetPurchasePaymentTerm(this.term, [this.unit]);

  @override
  List<Object?> get props => [term, unit];
}

class AddPurchaseLine extends PurchasesEvent {
  final String medicineId;
  final String medicineName;
  final int quantity;
  final double unitPrice;
  final String? batchNumber;
  final DateTime? expiryDate;
  final double? discount;
  final String? discountType;
  final double? taxAmount;
  final String? taxType;
  final String? unitId;
  final String? unitName;
  final List<MedicineUnitModel> units;

  const AddPurchaseLine({
    required this.medicineId, required this.medicineName,
    this.quantity = 1, this.unitPrice = 0,
    this.batchNumber, this.expiryDate, this.discount, this.discountType,
    this.taxAmount, this.taxType, this.unitId, this.unitName, this.units = const [],
  });

  @override
  List<Object?> get props => [medicineId, medicineName, quantity, unitPrice, batchNumber, expiryDate, discount, discountType, taxAmount, taxType, unitId, unitName, units];
}

class UpdatePurchaseLineQuantity extends PurchasesEvent {
  final int index;
  final int quantity;
  const UpdatePurchaseLineQuantity(this.index, this.quantity);

  @override
  List<Object?> get props => [index, quantity];
}

class UpdatePurchaseLineUnitPrice extends PurchasesEvent {
  final int index;
  final double unitPrice;
  const UpdatePurchaseLineUnitPrice(this.index, this.unitPrice);

  @override
  List<Object?> get props => [index, unitPrice];
}

class UpdatePurchaseLineDiscount extends PurchasesEvent {
  final int index;
  final double? discount;
  final String? discountType;
  const UpdatePurchaseLineDiscount(this.index, this.discount, [this.discountType]);

  @override
  List<Object?> get props => [index, discount, discountType];
}

class UpdatePurchaseLineTax extends PurchasesEvent {
  final int index;
  final double? tax;
  final String? taxType;
  const UpdatePurchaseLineTax(this.index, this.tax, [this.taxType]);

  @override
  List<Object?> get props => [index, tax, taxType];
}

class UpdatePurchaseLineBatch extends PurchasesEvent {
  final int index;
  final String? batch;
  const UpdatePurchaseLineBatch(this.index, this.batch);

  @override
  List<Object?> get props => [index, batch];
}

class UpdatePurchaseLineExpiry extends PurchasesEvent {
  final int index;
  final DateTime? expiry;
  const UpdatePurchaseLineExpiry(this.index, this.expiry);

  @override
  List<Object?> get props => [index, expiry];
}

class UpdatePurchaseLineUnit extends PurchasesEvent {
  final int index;
  final String? unitId;
  final String? unitName;
  const UpdatePurchaseLineUnit(this.index, this.unitId, this.unitName);

  @override
  List<Object?> get props => [index, unitId, unitName];
}

class RemovePurchaseLine extends PurchasesEvent {
  final int index;
  const RemovePurchaseLine(this.index);

  @override
  List<Object?> get props => [index];
}

class SetPurchaseSupplier extends PurchasesEvent {
  final String? id;
  final String? name;
  const SetPurchaseSupplier(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

class SetPurchaseSourceType extends PurchasesEvent {
  final String type;
  const SetPurchaseSourceType(this.type);

  @override
  List<Object?> get props => [type];
}

class SetPurchasePaymentMethod extends PurchasesEvent {
  final String method;
  const SetPurchasePaymentMethod(this.method);

  @override
  List<Object?> get props => [method];
}

class SetPurchaseInvoiceDiscount extends PurchasesEvent {
  final String type;
  final double value;
  const SetPurchaseInvoiceDiscount(this.type, this.value);

  @override
  List<Object?> get props => [type, value];
}

class SetPurchaseInvoiceTax extends PurchasesEvent {
  final String type;
  final double value;
  const SetPurchaseInvoiceTax(this.type, this.value);

  @override
  List<Object?> get props => [type, value];
}

class SetPurchaseShipping extends PurchasesEvent {
  final double amount;
  const SetPurchaseShipping(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SetPurchaseDelivery extends PurchasesEvent {
  final double amount;
  const SetPurchaseDelivery(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SetPurchasePaidAmount extends PurchasesEvent {
  final double amount;
  const SetPurchasePaidAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SetPurchasePaymentAccount extends PurchasesEvent {
  final String? id;
  final String? name;
  const SetPurchasePaymentAccount(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

class SetPurchasePaymentDate extends PurchasesEvent {
  final DateTime date;
  const SetPurchasePaymentDate(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdatePurchaseLineSellPrice extends PurchasesEvent {
  final int index;
  final double sellPrice;
  const UpdatePurchaseLineSellPrice(this.index, this.sellPrice);

  @override
  List<Object?> get props => [index, sellPrice];
}

class PayInFull extends PurchasesEvent {
  const PayInFull();
}

class SetPurchaseNotes extends PurchasesEvent {
  final String notes;
  const SetPurchaseNotes(this.notes);

  @override
  List<Object?> get props => [notes];
}

class SubmitPurchase extends PurchasesEvent {
  const SubmitPurchase();
}

class VoidPurchase extends PurchasesEvent {
  final String purchaseId;
  const VoidPurchase(this.purchaseId);

  @override
  List<Object?> get props => [purchaseId];
}

class ExportPurchasesCsv extends PurchasesEvent {
  const ExportPurchasesCsv();
}

class LoadPurchaseForEdit extends PurchasesEvent {
  final PurchaseModel purchase;
  const LoadPurchaseForEdit(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class ResetPurchaseForm extends PurchasesEvent {
  const ResetPurchaseForm();
}

