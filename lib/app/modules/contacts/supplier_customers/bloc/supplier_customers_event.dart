import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_customer_model.dart';

abstract class SupplierCustomersEvent extends Equatable {
  const SupplierCustomersEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupplierCustomers extends SupplierCustomersEvent {
  const LoadSupplierCustomers();
}

class SearchSupplierCustomers extends SupplierCustomersEvent {
  final String query;
  const SearchSupplierCustomers(this.query);

  @override
  List<Object?> get props => [query];
}

class SetSupplierCustomersFilter extends SupplierCustomersEvent {
  final String filter;
  const SetSupplierCustomersFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class AddSupplierCustomer extends SupplierCustomersEvent {
  final String name;
  final String? phone;
  final String? address;
  final String? email;
  final String? companyName;
  final String? taxId;
  final String? notes;
  final int customerKindIndex;
  final double creditLimit;
  final double discountPercent;
  final int paymentTermDays;
  final int supplierPartyTypeIndex;
  final double openingBalance;
  final String openingBalanceDirection;

  const AddSupplierCustomer({
    required this.name,
    this.phone,
    this.address,
    this.email,
    this.companyName,
    this.taxId,
    this.notes,
    this.customerKindIndex = 0,
    this.creditLimit = 0,
    this.discountPercent = 0,
    this.paymentTermDays = 0,
    this.supplierPartyTypeIndex = 0,
    this.openingBalance = 0,
    this.openingBalanceDirection = 'debit',
  });

  @override
  List<Object?> get props => [name, phone, address, email, companyName, taxId, notes, customerKindIndex, creditLimit, discountPercent, paymentTermDays, supplierPartyTypeIndex, openingBalance, openingBalanceDirection];
}

class UpdateSupplierCustomer extends SupplierCustomersEvent {
  final SupplierCustomerModel supplier;
  const UpdateSupplierCustomer(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplierCustomer extends SupplierCustomersEvent {
  final String id;
  const DeleteSupplierCustomer(this.id);

  @override
  List<Object?> get props => [id];
}

class SelectSupplierCustomer extends SupplierCustomersEvent {
  final SupplierCustomerModel? supplier;
  const SelectSupplierCustomer(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class LoadSupplierCustomerLedger extends SupplierCustomersEvent {
  final String partyId;
  const LoadSupplierCustomerLedger(this.partyId);

  @override
  List<Object?> get props => [partyId];
}

class RecordCashReceipt extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? notes;

  const RecordCashReceipt({required this.partyId, required this.amount, this.notes});

  @override
  List<Object?> get props => [partyId, amount, notes];
}

class RecordCashPayment extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? notes;

  const RecordCashPayment({required this.partyId, required this.amount, this.notes});

  @override
  List<Object?> get props => [partyId, amount, notes];
}

class RecordAdditionNotice extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? notes;
  final String ledgerTarget;

  const RecordAdditionNotice({required this.partyId, required this.amount, this.notes, this.ledgerTarget = 'customer'});

  @override
  List<Object?> get props => [partyId, amount, notes, ledgerTarget];
}

class RecordDiscountNotice extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? notes;
  final String ledgerTarget;

  const RecordDiscountNotice({required this.partyId, required this.amount, this.notes, this.ledgerTarget = 'customer'});

  @override
  List<Object?> get props => [partyId, amount, notes, ledgerTarget];
}

class RecordCheckReceipt extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? checkNumber;
  final String? bankName;
  final String? dueDate;
  final String? notes;

  const RecordCheckReceipt({required this.partyId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});

  @override
  List<Object?> get props => [partyId, amount, checkNumber, bankName, dueDate, notes];
}

class RecordCheckPayment extends SupplierCustomersEvent {
  final String partyId;
  final double amount;
  final String? checkNumber;
  final String? bankName;
  final String? dueDate;
  final String? notes;

  const RecordCheckPayment({required this.partyId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});

  @override
  List<Object?> get props => [partyId, amount, checkNumber, bankName, dueDate, notes];
}

class ClearSupplierCustomerSelection extends SupplierCustomersEvent {
  const ClearSupplierCustomerSelection();
}

class ExportSupplierCustomerLedger extends SupplierCustomersEvent {
  final String format;
  const ExportSupplierCustomerLedger(this.format);

  @override
  List<Object?> get props => [format];
}




