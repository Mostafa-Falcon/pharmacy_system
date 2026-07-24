import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'customers_event.dart';
import 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  StreamSubscription? _subscription;

  CustomersBloc() : super(const CustomersState()) {
    on<LoadCustomers>(_onLoadCustomers);
    // remaining events registered in _registerHandlers
    _registerHandlers();

    _subscription = sl<CustomersRepository>().watchCustomers().listen((_) {
      if (!isClosed) add(const LoadCustomers());
    });

    add(const LoadCustomers());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _registerHandlers() {
    on<SearchCustomers>(_onSearchCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<ToggleCustomerActive>(_onToggleActive);
    on<DeleteCustomer>(_onDeleteCustomer);
    on<SelectCustomer>(_onSelectCustomer);
    on<LoadLedger>(_onLoadLedger);
    on<RecordCashReceipt>(_onRecordCashReceipt);
    on<RecordAdditionNotice>(_onRecordAdditionNotice);
    on<RecordDiscountNotice>(_onRecordDiscountNotice);
    on<RecordCheckReceipt>(_onRecordCheckReceipt);
    on<RecordCheckPayment>(_onRecordCheckPayment);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<ChangePageSize>(_onChangePageSize);
    on<UpdateSort>(_onUpdateSort);
    on<ExportCustomers>(_onExportCustomers);
    on<ClearLedger>(_onClearLedger);
    on<ToggleSelectCustomer>(_onToggleSelect);
    on<ToggleSelectAllCustomers>(_onToggleSelectAll);
    on<BulkDeleteCustomers>(_onBulkDelete);
    on<BulkToggleCustomersActive>(_onBulkToggleActive);
  }

  void _onToggleSelect(ToggleSelectCustomer event, Emitter<CustomersState> emit) {
    final newSelected = Set<String>.from(state.selectedIds);
    if (newSelected.contains(event.id)) {
      newSelected.remove(event.id);
    } else {
      newSelected.add(event.id);
    }
    emit(state.copyWith(selectedIds: newSelected));
  }

  void _onToggleSelectAll(ToggleSelectAllCustomers event, Emitter<CustomersState> emit) {
    if (event.select) {
      final allIds = state.pagedCustomers.map((c) => c.id).toSet();
      emit(state.copyWith(selectedIds: allIds));
    } else {
      emit(state.copyWith(selectedIds: {}));
    }
  }

  Future<void> _onBulkDelete(BulkDeleteCustomers event, Emitter<CustomersState> emit) async {
    try {
      for (final id in state.selectedIds) {
        await CustomerService.hardDelete(id);
      }
      if (isClosed) return;
      emit(state.copyWith(selectedIds: {}));
      add(const LoadCustomers());
      AppSnackbar.success(CrmStrings.msgDeletedSuccess);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgDeleteFailed}$e');
    }
  }

  Future<void> _onBulkToggleActive(BulkToggleCustomersActive event, Emitter<CustomersState> emit) async {
    try {
      for (final id in state.selectedIds) {
        if (event.active) {
          await CustomerService.activate(id);
        } else {
          await CustomerService.deactivate(id);
        }
      }
      if (isClosed) return;
      emit(state.copyWith(selectedIds: {}));
      add(const LoadCustomers());
      AppSnackbar.success(CrmStrings.msgUpdatedSuccess);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgUpdateFailed}$e');
    }
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  Future<void> _onLoadCustomers(LoadCustomers event, Emitter<CustomersState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final customers = CustomerService.getAll(activeOnly: false);
      
      // ????? ??????: ???? ???? ??????? ?? ????? ????? ????? ?? ?????
      final balances = await CustomerLedgerService.getAllCustomerBalances(_branchId);
      
      final sorted = _sortCustomers(customers, state.sortColumnId, state.isSortAscending);
      final filtered = _filterCustomers(sorted, state.searchQuery);
      final paged = _paginate(filtered, state.currentPage, state.currentPageSize);
      final totalPages = (filtered.length / state.currentPageSize).ceil().clamp(1, double.maxFinite.toInt());
      emit(state.copyWith(
        data: customers,
        filteredCustomers: filtered,
        pagedCustomers: paged,
        balances: balances,
        totalPages: totalPages,
        isLoading: false,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onSearchCustomers(SearchCustomers event, Emitter<CustomersState> emit) {
    final sorted = _sortCustomers(state.allCustomers, state.sortColumnId, state.isSortAscending);
    final filtered = _filterCustomers(sorted, event.query);
    final totalPages = (filtered.length / state.currentPageSize).ceil().clamp(1, double.maxFinite.toInt());
    emit(state.copyWith(
      searchQuery: event.query,
      filteredCustomers: filtered,
      currentPage: 0,
      totalPages: totalPages,
      pagedCustomers: _paginate(filtered, 0, state.currentPageSize),
    ));
  }

  Future<void> _onAddCustomer(AddCustomer event, Emitter<CustomersState> emit) async {
    try {
      final customer = await CustomerService.add(
        name: event.name,
        kind: event.kind,
        phone: event.phone,
        address: event.address,
        companyName: event.companyName,
        email: event.email,
        taxId: event.taxId,
        creditLimit: event.creditLimit,
        discountPercent: event.discountPercent,
        paymentTermDays: event.paymentTermDays,
        notes: event.notes,
      );
      if (event.openingBalance > 0) {
        if (event.openingBalanceIsDebit) {
          await CustomerLedgerService.recordOpeningBalanceDirect(
            customerId: customer.id,
            branchId: _branchId,
            amount: event.openingBalance,
            createdBy: AuthService.currentUser?.id ?? '',
          );
        } else {
          await CustomerLedgerService.recordOpeningBalanceAsCredit(
            customerId: customer.id,
            branchId: _branchId,
            amount: event.openingBalance,
            createdBy: AuthService.currentUser?.id ?? '',
          );
        }
      }
      if (!isClosed) add(const LoadCustomers());
      emit(state.copyWith(isSuccess: true));
      AppSnackbar.success(CrmStrings.msgPartyAdded);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
      AppSnackbar.error('${CrmStrings.msgAddFailed}$e');
    }
  }

  Future<void> _onUpdateCustomer(UpdateCustomer event, Emitter<CustomersState> emit) async {
    try {
      await CustomerService.update(event.customer);
      if (!isClosed) add(const LoadCustomers());
      emit(state.copyWith(isSuccess: true));
      AppSnackbar.success(CrmStrings.msgUpdatedSuccess);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
      AppSnackbar.error('${CrmStrings.msgUpdateFailed}$e');
    }
  }

  Future<void> _onToggleActive(ToggleCustomerActive event, Emitter<CustomersState> emit) async {
    final customer = CustomerService.getById(event.id);
    if (customer != null) {
      if (customer.isActive) {
        await CustomerService.deactivate(event.id);
      } else {
        await CustomerService.activate(event.id);
      }
      if (!isClosed) add(const LoadCustomers());
    }
  }

  Future<void> _onDeleteCustomer(DeleteCustomer event, Emitter<CustomersState> emit) async {
    try {
      await CustomerService.hardDelete(event.id);
      if (!isClosed) add(const LoadCustomers());
      AppSnackbar.success(CrmStrings.msgDeletedSuccess);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgDeleteFailed}$e');
    }
  }

  void _onSelectCustomer(SelectCustomer event, Emitter<CustomersState> emit) {
    emit(state.copyWith(
      selectedCustomer: event.customer,
      clearSelected: event.customer == null,
    ));
  }

  Future<void> _onLoadLedger(LoadLedger event, Emitter<CustomersState> emit) async {
    emit(state.copyWith(isLoadingLedger: true));
    try {
      final entries = await CustomerLedgerService.getCustomerLedger(event.customerId, _branchId);
      final customer = CustomerService.getById(event.customerId);
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingLedger: false,
        ledgerEntries: entries,
        selectedCustomer: customer,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingLedger: false));
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onRecordCashReceipt(RecordCashReceipt event, Emitter<CustomersState> emit) async {
    try {
      await CustomerLedgerService.recordCustomerPayment(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        notes: event.notes,
      );
      if (!isClosed) add(LoadLedger(event.customerId));
      AppSnackbar.success(CrmStrings.msgReceiptRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgReceiptFailed}$e');
    }
  }

  Future<void> _onRecordAdditionNotice(RecordAdditionNotice event, Emitter<CustomersState> emit) async {
    try {
      await CustomerLedgerService.recordAdditionNotice(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        notes: event.notes,
      );
      if (!isClosed) add(LoadLedger(event.customerId));
      AppSnackbar.success(CrmStrings.msgAdditionRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgAdditionFailed}$e');
    }
  }

  Future<void> _onRecordDiscountNotice(RecordDiscountNotice event, Emitter<CustomersState> emit) async {
    try {
      await CustomerLedgerService.recordDiscountNotice(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        notes: event.notes,
      );
      if (!isClosed) add(LoadLedger(event.customerId));
      AppSnackbar.success(CrmStrings.msgDiscountRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgDiscountFailed}$e');
    }
  }

  Future<void> _onRecordCheckReceipt(RecordCheckReceipt event, Emitter<CustomersState> emit) async {
    try {
      await CustomerLedgerService.recordCheckReceipt(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        checkNumber: event.checkNumber,
        bankName: event.bankName,
        dueDate: event.dueDate,
        notes: event.notes,
      );
      if (!isClosed) add(LoadLedger(event.customerId));
      AppSnackbar.success(CrmStrings.msgCheckReceiptRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgCheckReceiptFailed}$e');
    }
  }

  Future<void> _onRecordCheckPayment(RecordCheckPayment event, Emitter<CustomersState> emit) async {
    try {
      await CustomerLedgerService.recordCheckPayment(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: AuthService.currentUser?.id ?? '',
        checkNumber: event.checkNumber,
        bankName: event.bankName,
        dueDate: event.dueDate,
        notes: event.notes,
      );
      if (!isClosed) add(LoadLedger(event.customerId));
      AppSnackbar.success(CrmStrings.msgCheckPaymentRecorded);
    } catch (e) {
      if (isClosed) return;
      AppSnackbar.error('${CrmStrings.msgCheckPaymentFailed}$e');
    }
  }

  void _onNextPage(NextPage event, Emitter<CustomersState> emit) {
    if (state.currentPage < state.totalPages - 1) {
      final page = state.currentPage + 1;
      emit(state.copyWith(
        currentPage: page,
        pagedCustomers: _paginate(state.filteredCustomers, page, state.currentPageSize),
      ));
    }
  }

  void _onPreviousPage(PreviousPage event, Emitter<CustomersState> emit) {
    if (state.currentPage > 0) {
      final page = state.currentPage - 1;
      emit(state.copyWith(
        currentPage: page,
        pagedCustomers: _paginate(state.filteredCustomers, page, state.currentPageSize),
      ));
    }
  }

  void _onChangePageSize(ChangePageSize event, Emitter<CustomersState> emit) {
    final pageSize = event.pageSize;
    final filtered = state.filteredCustomers;
    final totalPages = (filtered.length / pageSize).ceil().clamp(1, double.maxFinite.toInt());
    emit(state.copyWith(
      currentPageSize: pageSize,
      currentPage: 0,
      totalPages: totalPages,
      pagedCustomers: _paginate(filtered, 0, pageSize),
    ));
  }

  void _onUpdateSort(UpdateSort event, Emitter<CustomersState> emit) {
    final sorted = _sortCustomers(state.allCustomers, event.columnId, event.ascending);
    final filtered = _filterCustomers(sorted, state.searchQuery);
    final totalPages = (filtered.length / state.currentPageSize).ceil().clamp(1, double.maxFinite.toInt());
    emit(state.copyWith(
      sortColumnId: event.columnId,
      isSortAscending: event.ascending,
      filteredCustomers: filtered,
      currentPage: 0,
      totalPages: totalPages,
      pagedCustomers: _paginate(filtered, 0, state.currentPageSize),
    ));
  }

  Future<void> _onExportCustomers(ExportCustomers event, Emitter<CustomersState> emit) async {
    try {
      final entries = state.allCustomers.map((c) => {
        'id': c.id,
        'name': c.name,
        'kind': c.kindName,
        'phone': c.phone ?? '',
        'company': c.companyName ?? '',
        'email': c.email ?? '',
        'taxId': c.taxId ?? '',
        'address': c.address ?? '',
        'creditLimit': c.creditLimit,
        'discountPercent': c.discountPercent,
        'paymentTermDays': c.paymentTermDays,
        'balance': state.balances[c.id] ?? 0,
        'isActive': c.isActive,
      }).toList();
      await ExportService.exportCustomersToXlsx(entries: entries);
      AppSnackbar.success(CrmStrings.msgExportSuccess);
    } catch (e) {
      AppSnackbar.error('${CrmStrings.msgExportFailed}$e');
    }
  }

  void _onClearLedger(ClearLedger event, Emitter<CustomersState> emit) {
    emit(state.copyWith(
      ledgerEntries: const [],
      clearSelected: true,
    ));
  }

  // --- Helpers ---

  List<CustomerModel> _filterCustomers(List<CustomerModel> customers, String query) {
    if (query.isEmpty) return customers;
    final q = query.toLowerCase();
    return customers.where((c) =>
      c.name.toLowerCase().contains(q) ||
      (c.phone?.contains(q) ?? false) ||
      (c.email?.toLowerCase().contains(q) ?? false) ||
      (c.taxId?.contains(q) ?? false) ||
      (c.companyName?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  List<CustomerModel> _sortCustomers(List<CustomerModel> customers, String columnId, bool ascending) {
    final sorted = List<CustomerModel>.from(customers);
    sorted.sort((a, b) {
      int cmp;
      switch (columnId) {
        case 'name':
          cmp = a.name.compareTo(b.name);
        case 'phone':
          cmp = (a.phone ?? '').compareTo(b.phone ?? '');
        case 'company':
          cmp = (a.companyName ?? '').compareTo(b.companyName ?? '');
        case 'balance':
          cmp = (state.balances[a.id] ?? 0).compareTo(state.balances[b.id] ?? 0);
        case 'creditLimit':
          cmp = a.creditLimit.compareTo(b.creditLimit);
        case 'discount':
          cmp = a.discountPercent.compareTo(b.discountPercent);
        case 'paymentDays':
          cmp = a.paymentTermDays.compareTo(b.paymentTermDays);
        case 'status':
          cmp = (a.isActive ? 0 : 1).compareTo(b.isActive ? 0 : 1);
        default:
          cmp = a.name.compareTo(b.name);
      }
      return ascending ? cmp : -cmp;
    });
    return sorted;
  }

  List<CustomerModel> _paginate(List<CustomerModel> customers, int page, int pageSize) {
    final start = page * pageSize;
    final end = start + pageSize;
    return customers.sublist(
      start.clamp(0, customers.length),
      end.clamp(0, customers.length),
    );
  }
}





