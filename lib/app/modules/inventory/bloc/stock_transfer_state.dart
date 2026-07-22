import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/auth/models/branch_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_transfer_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_enums.dart';

enum StockTransferStatus { initial, loading, loaded, error }

class StockTransferState extends Equatable {
  final StockTransferStatus status;
  final List<StockTransferModel> transfers;
  final List<BranchModel> branches;
  final int selectedTab;
  final bool isProcessing;
  final String? error;

  const StockTransferState({
    this.status = StockTransferStatus.initial,
    this.transfers = const [],
    this.branches = const [],
    this.selectedTab = 0,
    this.isProcessing = false,
    this.error,
  });

  List<StockTransferModel> outgoingTransfers(String branchId) =>
      transfers.where((t) => t.fromBranchId == branchId).toList();

  List<StockTransferModel> incomingTransfers(String branchId) =>
      transfers.where((t) => t.toBranchId == branchId).toList();

  List<StockTransferModel> pendingIncoming(String branchId) =>
      incomingTransfers(branchId).where((t) => t.status == TransferStatus.sent).toList();

  StockTransferState copyWith({
    StockTransferStatus? status,
    List<StockTransferModel>? transfers,
    List<BranchModel>? branches,
    int? selectedTab,
    bool? isProcessing,
    String? error,
    bool clearError = false,
  }) {
    return StockTransferState(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      branches: branches ?? this.branches,
      selectedTab: selectedTab ?? this.selectedTab,
      isProcessing: isProcessing ?? this.isProcessing,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        transfers,
        branches,
        selectedTab,
        isProcessing,
        error,
      ];
}

