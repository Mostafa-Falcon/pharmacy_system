import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';

abstract class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object?> get props => [];
}

class LoadSuppliers extends SuppliersEvent {
  const LoadSuppliers();
}

class SearchSuppliers extends SuppliersEvent {
  final String query;
  const SearchSuppliers(this.query);
  @override
  List<Object?> get props => [query];
}

class AddSupplier extends SuppliersEvent {
  final String name;
  final SupplierPartyType partyType;
  final String? phone, address, companyName, email, taxId, notes;
  final double creditLimit, discountPercent, openingBalance;
  final int paymentTermDays;
  final bool openingBalanceIsDebit;

  const AddSupplier({
    required this.name,
    this.partyType = SupplierPartyType.company,
    this.phone, this.address, this.companyName, this.email, this.taxId, this.notes,
    this.creditLimit = 0, this.discountPercent = 0, this.paymentTermDays = 0,
    this.openingBalance = 0, this.openingBalanceIsDebit = true,
  });

  @override
  List<Object?> get props => [name, partyType, phone, address, companyName, email, taxId, creditLimit, discountPercent, paymentTermDays, notes, openingBalance, openingBalanceIsDebit];
}

class UpdateSupplier extends SuppliersEvent {
  final SupplierModel supplier;
  const UpdateSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class ToggleSupplierActive extends SuppliersEvent {
  final String id;
  const ToggleSupplierActive(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleArchivedView extends SuppliersEvent {
  const ToggleArchivedView();
}

class ArchiveSupplier extends SuppliersEvent {
  final String id;
  const ArchiveSupplier(this.id);
  @override
  List<Object?> get props => [id];
}

class RestoreSupplier extends SuppliersEvent {
  final String id;
  const RestoreSupplier(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteSupplier extends SuppliersEvent {
  final String id;
  const DeleteSupplier(this.id);
  @override
  List<Object?> get props => [id];
}

class SelectSupplier extends SuppliersEvent {
  final SupplierModel? supplier;
  const SelectSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class LoadSupplierLedger extends SuppliersEvent {
  final String supplierId;
  const LoadSupplierLedger(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class RecordCashPayment extends SuppliersEvent {
  final String supplierId; final double amount; final String? notes;
  const RecordCashPayment({required this.supplierId, required this.amount, this.notes});
  @override
  List<Object?> get props => [supplierId, amount, notes];
}

class RecordSupplierAdditionNotice extends SuppliersEvent {
  final String supplierId; final double amount; final String? notes;
  const RecordSupplierAdditionNotice({required this.supplierId, required this.amount, this.notes});
  @override
  List<Object?> get props => [supplierId, amount, notes];
}

class RecordSupplierDiscountNotice extends SuppliersEvent {
  final String supplierId; final double amount; final String? notes;
  const RecordSupplierDiscountNotice({required this.supplierId, required this.amount, this.notes});
  @override
  List<Object?> get props => [supplierId, amount, notes];
}

class RecordSupplierCheckPayment extends SuppliersEvent {
  final String supplierId; final double amount;
  final String? checkNumber, bankName, dueDate, notes;
  const RecordSupplierCheckPayment({required this.supplierId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});
  @override
  List<Object?> get props => [supplierId, amount, checkNumber, bankName, dueDate, notes];
}

class RecordSupplierCheckReceipt extends SuppliersEvent {
  final String supplierId; final double amount;
  final String? checkNumber, bankName, dueDate, notes;
  const RecordSupplierCheckReceipt({required this.supplierId, required this.amount, this.checkNumber, this.bankName, this.dueDate, this.notes});
  @override
  List<Object?> get props => [supplierId, amount, checkNumber, bankName, dueDate, notes];
}

class NextSupplierPage extends SuppliersEvent { const NextSupplierPage(); }
class PreviousSupplierPage extends SuppliersEvent { const PreviousSupplierPage(); }

class UpdateSupplierSort extends SuppliersEvent {
  final String columnId; final bool ascending;
  const UpdateSupplierSort(this.columnId, this.ascending);
  @override
  List<Object?> get props => [columnId, ascending];
}

class ExportSuppliers extends SuppliersEvent { const ExportSuppliers(); }
class ClearSupplierLedger extends SuppliersEvent { const ClearSupplierLedger(); }

class ToggleSelectSupplier extends SuppliersEvent {
  final String id;
  const ToggleSelectSupplier(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectAllSuppliers extends SuppliersEvent {
  final bool select;
  const ToggleSelectAllSuppliers(this.select);
  @override
  List<Object?> get props => [select];
}

class BulkDeleteSuppliers extends SuppliersEvent {
  const BulkDeleteSuppliers();
}

class BulkToggleSuppliersActive extends SuppliersEvent {
  final bool active;
  const BulkToggleSuppliersActive(this.active);
  @override
  List<Object?> get props => [active];
}




