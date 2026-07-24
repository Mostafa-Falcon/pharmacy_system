import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';

enum FreeReturnStatus { initial, loading, success, error }

class FreeReturnState extends Equatable {
  final FreeReturnStatus status;
  final String? error;
  
  final String returnType; // 'sales', 'purchase'
  final String partyType; // 'cash', 'customer', 'supplier'
  final String? selectedPartyId;
  final String? selectedPartyName;
  
  final List<ReturnItemModel> items;
  final double discountPercent;
  final String? safeId;
  final String? notes;
  final ReturnReason reason;

  const FreeReturnState({
    this.status = FreeReturnStatus.initial,
    this.error,
    this.returnType = 'sales',
    this.partyType = 'cash',
    this.selectedPartyId,
    this.selectedPartyName,
    this.items = const [],
    this.discountPercent = 0,
    this.safeId,
    this.notes,
    this.reason = ReturnReason.other,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountAmount => subtotal * (discountPercent / 100);
  double get finalAmount => subtotal - discountAmount;

  FreeReturnState copyWith({
    FreeReturnStatus? status,
    String? error,
    String? returnType,
    String? partyType,
    String? selectedPartyId,
    String? selectedPartyName,
    List<ReturnItemModel>? items,
    double? discountPercent,
    String? safeId,
    String? notes,
    ReturnReason? reason,
    bool clearParty = false,
  }) {
    return FreeReturnState(
      status: status ?? this.status,
      error: error ?? this.error,
      returnType: returnType ?? this.returnType,
      partyType: partyType ?? this.partyType,
      selectedPartyId: clearParty ? null : (selectedPartyId ?? this.selectedPartyId),
      selectedPartyName: clearParty ? null : (selectedPartyName ?? this.selectedPartyName),
      items: items ?? this.items,
      discountPercent: discountPercent ?? this.discountPercent,
      safeId: safeId ?? this.safeId,
      notes: notes ?? this.notes,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        returnType,
        partyType,
        selectedPartyId,
        selectedPartyName,
        items,
        discountPercent,
        safeId,
        notes,
        reason,
      ];
}



