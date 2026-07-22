import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_customer_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import 'package:pharmacy_system/app/core/data/services/party_ledger_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import '../../../../core/constants/app_strings.dart';
import '../services/supplier_customer_service.dart';
import 'supplier_customers_event.dart';
import 'supplier_customers_state.dart';

class SupplierCustomersBloc extends Bloc<SupplierCustomersEvent, SupplierCustomersState> {
  SupplierCustomersBloc() : super(const SupplierCustomersState()) {
    on<LoadSupplierCustomers>(_onLoad);
    on<SearchSupplierCustomers>(_onSearch);
    on<SetSupplierCustomersFilter>(_onSetFilter);
    on<AddSupplierCustomer>(_onAdd);
    on<UpdateSupplierCustomer>(_onUpdate);
    on<DeleteSupplierCustomer>(_onDelete);
    on<SelectSupplierCustomer>(_onSelect);
    on<LoadSupplierCustomerLedger>(_onLoadLedger);
    on<RecordCashReceipt>(_onRecordCashReceipt);
    on<RecordCashPayment>(_onRecordCashPayment);
    on<RecordAdditionNotice>(_onRecordAdditionNotice);
    on<RecordDiscountNotice>(_onRecordDiscountNotice);
    on<RecordCheckReceipt>(_onRecordCheckReceipt);
    on<RecordCheckPayment>(_onRecordCheckPayment);
    on<ClearSupplierCustomerSelection>(_onClearSelection);
    on<ExportSupplierCustomerLedger>(_onExportLedger);
    add(const LoadSupplierCustomers());
  }

  Future<void> _onLoad(LoadSupplierCustomers event, Emitter<SupplierCustomersState> emit) async {
    emit(state.copyWith(status: SupplierCustomersStatus.loading));
    try {
      final all = SupplierCustomerService.getAll(activeOnly: false);
      
      // تحسين الأداء: حساب الأرصدة الموحدة بكفاءة
      final balances = await PartyLedgerService.getAllCombinedBalances();
      
      final filtered = _applyFilters(all, state.searchQuery, state.selectedFilter, balances);
      emit(state.copyWith(
        status: SupplierCustomersStatus.loaded,
        allSuppliers: all,
        filteredSuppliers: filtered,
        currentBalances: balances,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: SupplierCustomersStatus.error, error: e.toString()));
    }
  }

  void _onSearch(SearchSupplierCustomers event, Emitter<SupplierCustomersState> emit) {
    final filtered = _applyFilters(state.allSuppliers, event.query, state.selectedFilter, state.currentBalances);
    emit(state.copyWith(searchQuery: event.query, filteredSuppliers: filtered));
  }

  void _onSetFilter(SetSupplierCustomersFilter event, Emitter<SupplierCustomersState> emit) {
    final filtered = _applyFilters(state.allSuppliers, state.searchQuery, event.filter, state.currentBalances);
    emit(state.copyWith(selectedFilter: event.filter, filteredSuppliers: filtered));
  }

  Future<void> _onAdd(AddSupplierCustomer event, Emitter<SupplierCustomersState> emit) async {
    try {
      await SupplierCustomerService.add(
        name: event.name, phone: event.phone, address: event.address,
        email: event.email, companyName: event.companyName, taxId: event.taxId,
        notes: event.notes, customerKindIndex: event.customerKindIndex,
        creditLimit: event.creditLimit, discountPercent: event.discountPercent,
        paymentTermDays: event.paymentTermDays, supplierPartyTypeIndex: event.supplierPartyTypeIndex,
        openingBalance: event.openingBalance, openingBalanceDirection: event.openingBalanceDirection,
      );
      if (!isClosed) add(const LoadSupplierCustomers());
      AppSnackbar.success(AppStrings.msgPartyAdded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgAddFailed}$e');
    }
  }

  Future<void> _onUpdate(UpdateSupplierCustomer event, Emitter<SupplierCustomersState> emit) async {
    try {
      await SupplierCustomerService.update(event.supplier);
      if (!isClosed) add(const LoadSupplierCustomers());
      AppSnackbar.success(AppStrings.msgUpdatedSuccess);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgUpdateFailed}$e');
    }
  }

  Future<void> _onDelete(DeleteSupplierCustomer event, Emitter<SupplierCustomersState> emit) async {
    try {
      await SupplierCustomerService.delete(event.id);
      if (!isClosed) add(const LoadSupplierCustomers());
      AppSnackbar.success(AppStrings.msgDeletedSuccess);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgDeleteFailedCrm}$e');
    }
  }

  void _onSelect(SelectSupplierCustomer event, Emitter<SupplierCustomersState> emit) {
    if (event.supplier == null) {
      emit(state.copyWith(clearSelected: true, combinedLedger: const [], transactionSummary: const {}));
    } else {
      emit(state.copyWith(selectedParty: event.supplier));
    }
  }

  Future<void> _onLoadLedger(LoadSupplierCustomerLedger event, Emitter<SupplierCustomersState> emit) async {
    emit(state.copyWith(isLoadingLedger: true));
    try {
      final entries = await PartyLedgerService.getCombinedLedger(event.partyId);
      final summary = await PartyLedgerService.getTransactionSummary(event.partyId);
      final party = SupplierCustomerService.getById(event.partyId);
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingLedger: false,
        combinedLedger: entries,
        transactionSummary: summary,
        selectedParty: party,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingLedger: false, error: e.toString()));
    }
  }

  Future<void> _onRecordCashReceipt(RecordCashReceipt event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordCashReceipt(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '', notes: event.notes,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgReceiptRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgReceiptFailed}$e');
    }
  }

  Future<void> _onRecordCashPayment(RecordCashPayment event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordCashPayment(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '', notes: event.notes,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgPaymentRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgPaymentFailedCrm}$e');
    }
  }

  Future<void> _onRecordAdditionNotice(RecordAdditionNotice event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordAdditionNotice(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '', notes: event.notes,
        ledgerTarget: event.ledgerTarget,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgAdditionRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgAdditionFailed}$e');
    }
  }

  Future<void> _onRecordDiscountNotice(RecordDiscountNotice event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordDiscountNotice(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '', notes: event.notes,
        ledgerTarget: event.ledgerTarget,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgDiscountRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgDiscountFailed}$e');
    }
  }

  Future<void> _onRecordCheckReceipt(RecordCheckReceipt event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordCheckReceipt(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        checkNumber: event.checkNumber, bankName: event.bankName,
        dueDate: event.dueDate, notes: event.notes,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgCheckReceiptRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgCheckReceiptFailed}$e');
    }
  }

  Future<void> _onRecordCheckPayment(RecordCheckPayment event, Emitter<SupplierCustomersState> emit) async {
    try {
      await PartyLedgerService.recordCheckPayment(
        partyId: event.partyId, amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        checkNumber: event.checkNumber, bankName: event.bankName,
        dueDate: event.dueDate, notes: event.notes,
      );
      if (!isClosed) add(LoadSupplierCustomerLedger(event.partyId));
      AppSnackbar.success(AppStrings.msgCheckPaymentRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${AppStrings.msgCheckPaymentFailed}$e');
    }
  }

  void _onClearSelection(ClearSupplierCustomerSelection event, Emitter<SupplierCustomersState> emit) {
    emit(state.copyWith(clearSelected: true, combinedLedger: const [], transactionSummary: const {}));
  }

  Future<void> _onExportLedger(ExportSupplierCustomerLedger event, Emitter<SupplierCustomersState> emit) async {
    try {
      final party = state.selectedParty;
      if (party == null) return;
      final entries = state.combinedLedger;
      final isCustomer = party.customerKindIndex >= 0;

      switch (event.format) {
        case 'csv':
          final csv = StringBuffer();
          csv.writeln('Date,Type,Debit,Credit,Balance,Notes');
          for (final e in entries) {
            csv.writeln('${DateFormat('yyyy-MM-dd').format(e['date'] as DateTime)},"${e['type']}",${e['debit']},${e['credit']},${e['runningBalance'] ?? e['balanceAfter'] ?? 0},"${e['notes'] ?? ''}"');
          }
          await ExportService.exportToCsv(
            content: csv.toString(),
            fileName: 'ledger_${party.name}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
          );
          break;
        case 'xlsx':
          if (isCustomer) {
            final models = entries.map((e) => CustomerLedgerModel(
              id: e['id'] as String, customerId: party.id, branchId: '',
              type: CustomerLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => CustomerLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportCustomerLedgerToXlsx(entries: models, customerName: party.name);
          } else {
            final models = entries.map((e) => SupplierLedgerModel(
              id: e['id'] as String, supplierId: party.id, branchId: '',
              type: SupplierLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => SupplierLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportSupplierLedgerToXlsx(entries: models, supplierName: party.name);
          }
          break;
        case 'html':
          if (isCustomer) {
            final models = entries.map((e) => CustomerLedgerModel(
              id: e['id'] as String, customerId: party.id, branchId: '',
              type: CustomerLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => CustomerLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportCustomerLedgerToHtml(entries: models, customerName: party.name);
          } else {
            final models = entries.map((e) => SupplierLedgerModel(
              id: e['id'] as String, supplierId: party.id, branchId: '',
              type: SupplierLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => SupplierLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportSupplierLedgerToHtml(entries: models, supplierName: party.name);
          }
          break;
        case 'xml':
          if (isCustomer) {
            final models = entries.map((e) => CustomerLedgerModel(
              id: e['id'] as String, customerId: party.id, branchId: '',
              type: CustomerLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => CustomerLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportCustomerLedgerToXml(entries: models, customerName: party.name);
          } else {
            final models = entries.map((e) => SupplierLedgerModel(
              id: e['id'] as String, supplierId: party.id, branchId: '',
              type: SupplierLedgerEntryType.values.firstWhere((t) => t.name == (e['entryType'] as String), orElse: () => SupplierLedgerEntryType.openingBalance),
              debit: (e['debit'] as double?) ?? 0, credit: (e['credit'] as double?) ?? 0,
              balanceAfter: (e['runningBalance'] as double?) ?? (e['balanceAfter'] as double?) ?? 0,
              referenceNumber: e['referenceNumber'] as String?, notes: e['notes'] as String?,
              createdBy: e['createdBy'] as String?, entryDate: e['date'] as DateTime,
              syncVersion: 0, lastModified: DateTime.now(), isDeleted: false,
            )).toList();
            await ExportService.exportSupplierLedgerToXml(entries: models, supplierName: party.name);
          }
          break;
        default:
          AppSnackbar.error(AppStrings.msgExportUnsupported);
          return;
      }
      AppSnackbar.success(AppStrings.msgExportSuccessCrm);
    } catch (e) {
      AppSnackbar.error('${AppStrings.msgExportFailedCrm}$e');
    }
  }

  List<SupplierCustomerModel> _applyFilters(
    List<SupplierCustomerModel> all, String query, String filter, Map<String, double> balances,
  ) {
    var list = all.toList();
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        (c.phone?.contains(q) ?? false) ||
        (c.companyName?.toLowerCase().contains(q) ?? false) ||
        (c.email?.toLowerCase().contains(q) ?? false) ||
        (c.taxId?.contains(q) ?? false)
      ).toList();
    }
    switch (filter) {
      case 'active': list = list.where((c) => c.isActive).toList(); break;
      case 'inactive': list = list.where((c) => !c.isActive).toList(); break;
      case 'credit_customer': list = list.where((c) => c.customerKindIndex == 0 && c.isActive).toList(); break;
      case 'cash_customer': list = list.where((c) => c.customerKindIndex == 1 && c.isActive).toList(); break;
      case 'individual': list = list.where((c) => c.supplierPartyTypeIndex == 1 && c.isActive).toList(); break;
      case 'company': list = list.where((c) => c.supplierPartyTypeIndex == 0 && c.isActive).toList(); break;
      case 'with_balance': list = list.where((c) => (balances[c.id] ?? 0) > 0 && c.isActive).toList(); break;
      case 'no_balance': list = list.where((c) => (balances[c.id] ?? 0) <= 0 && c.isActive).toList(); break;
    }
    return list;
  }
}

