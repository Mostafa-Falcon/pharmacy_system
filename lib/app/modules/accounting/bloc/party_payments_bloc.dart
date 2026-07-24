import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_enums.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_model.dart';
import '../services/party_payment_service.dart';

// -- ????? ????? ????? ?????? --
abstract class PartyPaymentsEvent extends Equatable {
  const PartyPaymentsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPayments extends PartyPaymentsEvent {
  const LoadPayments();
}

class PostCustomerReceipt extends PartyPaymentsEvent {
  final String customerId;
  final String customerName;
  final double amount;
  final String paymentMethod;
  final String? notes;
  const PostCustomerReceipt({
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.paymentMethod,
    this.notes,
  });
  @override
  List<Object?> get props => [customerId, customerName, amount, paymentMethod, notes];
}

class PostSupplierPayment extends PartyPaymentsEvent {
  final String supplierId;
  final String supplierName;
  final double amount;
  final String paymentMethod;
  final String? notes;
  const PostSupplierPayment({
    required this.supplierId,
    required this.supplierName,
    required this.amount,
    required this.paymentMethod,
    this.notes,
  });
  @override
  List<Object?> get props => [supplierId, supplierName, amount, paymentMethod, notes];
}

class DeletePayment extends PartyPaymentsEvent {
  final String id;
  const DeletePayment({required this.id});
  @override
  List<Object?> get props => [id];
}

// -- ???? ????? ????? ?????? --
enum PartyPaymentsStatus { initial, loading, loaded, error }

class PartyPaymentsState extends Equatable {
  final PartyPaymentsStatus status;
  final List<PartyPaymentModel> payments;
  final List<CustomerModel> customers;
  final List<SupplierModel> suppliers;
  final bool isPosting;
  final String? errorMessage;

  const PartyPaymentsState({
    this.status = PartyPaymentsStatus.initial,
    this.payments = const [],
    this.customers = const [],
    this.suppliers = const [],
    this.isPosting = false,
    this.errorMessage,
  });

  List<PartyPaymentModel> get customerReceipts =>
      payments.where((p) => p.kind == PartyPaymentKind.customerReceipt).toList();

  List<PartyPaymentModel> get supplierPayments =>
      payments.where((p) => p.kind == PartyPaymentKind.supplierPayment).toList();

  PartyPaymentsState copyWith({
    PartyPaymentsStatus? status,
    List<PartyPaymentModel>? payments,
    List<CustomerModel>? customers,
    List<SupplierModel>? suppliers,
    bool? isPosting,
    String? errorMessage,
  }) {
    return PartyPaymentsState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      customers: customers ?? this.customers,
      suppliers: suppliers ?? this.suppliers,
      isPosting: isPosting ?? this.isPosting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, payments, customers, suppliers, isPosting, errorMessage];
}

// -- Bloc ????? ????? ?????? --
class PartyPaymentsBloc extends Bloc<PartyPaymentsEvent, PartyPaymentsState> {
  PartyPaymentsBloc() : super(const PartyPaymentsState()) {
    on<LoadPayments>(_onLoadPayments);
    on<PostCustomerReceipt>(_onPostCustomerReceipt);
    on<PostSupplierPayment>(_onPostSupplierPayment);
    on<DeletePayment>(_onDeletePayment);
  }

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? '';
  String get _userName => AuthService.currentUser?.name ?? '';

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<PartyPaymentsState> emit,
  ) async {
    emit(state.copyWith(status: PartyPaymentsStatus.loading));
    try {
      final payments = await PartyPaymentService.getAll(branchId: _branchId);
      final customers = CustomerService.getAll(activeOnly: true);
      final suppliers = SupplierService.getAll(activeOnly: true);
      emit(state.copyWith(
        status: PartyPaymentsStatus.loaded,
        payments: payments,
        customers: customers,
        suppliers: suppliers,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartyPaymentsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPostCustomerReceipt(
    PostCustomerReceipt event,
    Emitter<PartyPaymentsState> emit,
  ) async {
    if (state.isPosting) return;
    emit(state.copyWith(isPosting: true));
    try {
      final now = DateTime.now();
      await PartyPaymentService.create(PartyPaymentModel(
        id: const Uuid().v4(),
        branchId: _branchId,
        number: await PartyPaymentService.nextNumber(_branchId),
        paymentDate: now,
        kind: PartyPaymentKind.customerReceipt,
        partyId: event.customerId,
        partyName: event.customerName,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        notes: event.notes,
        createdById: _userId,
        createdByName: _userName,
        createdAt: now,
        updatedAt: now,
      ));
      AppSnackbar.success('?? ????? ??? ????? ?????');
      add(const LoadPayments());
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      emit(state.copyWith(isPosting: false));
    }
  }

  Future<void> _onPostSupplierPayment(
    PostSupplierPayment event,
    Emitter<PartyPaymentsState> emit,
  ) async {
    if (state.isPosting) return;
    emit(state.copyWith(isPosting: true));
    try {
      final now = DateTime.now();
      await PartyPaymentService.create(PartyPaymentModel(
        id: const Uuid().v4(),
        branchId: _branchId,
        number: await PartyPaymentService.nextNumber(_branchId),
        paymentDate: now,
        kind: PartyPaymentKind.supplierPayment,
        partyId: event.supplierId,
        partyName: event.supplierName,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        notes: event.notes,
        createdById: _userId,
        createdByName: _userName,
        createdAt: now,
        updatedAt: now,
      ));
      AppSnackbar.success('?? ????? ??? ????? ?????');
      add(const LoadPayments());
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      emit(state.copyWith(isPosting: false));
    }
  }

  Future<void> _onDeletePayment(
    DeletePayment event,
    Emitter<PartyPaymentsState> emit,
  ) async {
    try {
      await PartyPaymentService.delete(event.id);
      AppSnackbar.success('?? ??? ?????');
      add(const LoadPayments());
    } catch (e) {
      AppSnackbar.error('??? ?????: $e');
    }
  }
}





