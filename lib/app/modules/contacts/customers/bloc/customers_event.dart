import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';

abstract class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomersEvent {
  const LoadCustomers();
}

class SearchCustomers extends CustomersEvent {
  final String query;
  const SearchCustomers(this.query);

  @override
  List<Object?> get props => [query];
}

class AddCustomer extends CustomersEvent {
  final String name;
  final CustomerKind kind;
  final String? phone;
  final String? address;
  final String? companyName;
  final String? email;
  final String? taxId;
  final double creditLimit;
  final double discountPercent;
  final int paymentTermDays;
  final String? notes;
  final double openingBalance;
  final bool openingBalanceIsDebit;

  const AddCustomer({
    required this.name,
    this.kind = CustomerKind.regular,
    this.phone,
    this.address,
    this.companyName,
    this.email,
    this.taxId,
    this.creditLimit = 0,
    this.discountPercent = 0,
    this.paymentTermDays = 0,
    this.notes,
    this.openingBalance = 0,
    this.openingBalanceIsDebit = true,
  });

  @override
  List<Object?> get props => [name, kind, phone, address, companyName, email, taxId, creditLimit, discountPercent, paymentTermDays, notes, openingBalance, openingBalanceIsDebit];
}

class UpdateCustomer extends CustomersEvent {
  final CustomerModel customer;
  const UpdateCustomer(this.customer);

  @override
  List<Object?> get props => [customer];
}

class ToggleCustomerActive extends CustomersEvent {
  final String id;
  const ToggleCustomerActive(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteCustomer extends CustomersEvent {
  final String id;
  const DeleteCustomer(this.id);

  @override
  List<Object?> get props => [id];
}

class SelectCustomer extends CustomersEvent {
  final CustomerModel? customer;
  const SelectCustomer(this.customer);

  @override
  List<Object?> get props => [customer];
}

class LoadLedger extends CustomersEvent {
  final String customerId;
  const LoadLedger(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class RecordCashReceipt extends CustomersEvent {
  final String customerId;
  final double amount;
  final String? notes;

  const RecordCashReceipt({required this.customerId, required this.amount, this.notes});

  @override
  List<Object?> get props => [customerId, amount, notes];
}

class RecordAdditionNotice extends CustomersEvent {
  final String customerId;
  final double amount;
  final String? notes;

  const RecordAdditionNotice({required this.customerId, required this.amount, this.notes});

  @override
  List<Object?> get props => [customerId, amount, notes];
}

class RecordDiscountNotice extends CustomersEvent {
  final String customerId;
  final double amount;
  final String? notes;

  const RecordDiscountNotice({required this.customerId, required this.amount, this.notes});

  @override
  List<Object?> get props => [customerId, amount, notes];
}

class RecordCheckReceipt extends CustomersEvent {
  final String customerId;
  final double amount;
  final String? checkNumber;
  final String? bankName;
  final String? dueDate;
  final String? notes;

  const RecordCheckReceipt({required this.customerId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});

  @override
  List<Object?> get props => [customerId, amount, checkNumber, bankName, dueDate, notes];
}

class RecordCheckPayment extends CustomersEvent {
  final String customerId;
  final double amount;
  final String? checkNumber;
  final String? bankName;
  final String? dueDate;
  final String? notes;

  const RecordCheckPayment({required this.customerId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});

  @override
  List<Object?> get props => [customerId, amount, checkNumber, bankName, dueDate, notes];
}

class NextPage extends CustomersEvent {
  const NextPage();
}

class PreviousPage extends CustomersEvent {
  const PreviousPage();
}

class ChangePageSize extends CustomersEvent {
  final int pageSize;
  const ChangePageSize(this.pageSize);

  @override
  List<Object?> get props => [pageSize];
}

class UpdateSort extends CustomersEvent {
  final String columnId;
  final bool ascending;

  const UpdateSort(this.columnId, this.ascending);

  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportCustomers extends CustomersEvent {
  const ExportCustomers();
}

class ClearLedger extends CustomersEvent {
  const ClearLedger();
}

class ToggleSelectCustomer extends CustomersEvent {
  final String id;
  const ToggleSelectCustomer(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectAllCustomers extends CustomersEvent {
  final bool select;
  const ToggleSelectAllCustomers(this.select);
  @override
  List<Object?> get props => [select];
}

class BulkDeleteCustomers extends CustomersEvent {
  const BulkDeleteCustomers();
}

class BulkToggleCustomersActive extends CustomersEvent {
  final bool active;
  const BulkToggleCustomersActive(this.active);
  @override
  List<Object?> get props => [active];
}




