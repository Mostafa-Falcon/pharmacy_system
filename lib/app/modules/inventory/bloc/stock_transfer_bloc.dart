import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/stock_transfers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';

import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/models/inventory/inventory_enums.dart';
import 'package:pharmacy_system/app/core/models/inventory/stock_transfer_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import '../services/inventory_transaction_service.dart';
import '../services/stock_quantity_guard.dart';
import 'stock_transfer_event.dart';
import 'stock_transfer_state.dart';

export 'stock_transfer_event.dart';
export 'stock_transfer_state.dart';

class StockTransferBloc extends Bloc<StockTransferEvent, StockTransferState> {
  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? '';

  static StockTransfersDao get _transfersDao =>
      StockTransfersDao(GetIt.instance<AppDatabase>());
  static BranchesDao get _branchesDao =>
      BranchesDao(GetIt.instance<AppDatabase>());

  List<BranchModel> _branchesCache = [];
  List<StockTransferModel> _transfersCache = [];

  StockTransferBloc() : super(const StockTransferState()) {
    on<LoadStockTransfers>(_onLoad);
    on<SelectTransferTab>(_onSelectTab);
    on<SendTransfer>(_onSendTransfer);
    on<ReceiveTransfer>(_onReceiveTransfer);
    on<CancelTransfer>(_onCancelTransfer);
  }

  Future<void> _onLoad(LoadStockTransfers event, Emitter<StockTransferState> emit) async {
    emit(state.copyWith(status: StockTransferStatus.loading));
    try {
      await _refreshCaches();
      emit(state.copyWith(
        status: StockTransferStatus.loaded,
        branches: _branchesCache,
        transfers: _transfersCache,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StockTransferStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _refreshCaches() async {
    final branches = await _branchesDao.getAll();
    _branchesCache = branches
        .where((b) => b.id != _branchId && b.isActive)
        .map(_branchFromData)
        .toList();

    final transfers = await _transfersDao.getAll();
    _transfersCache = transfers
        .where((t) => t.fromBranchId == _branchId || t.toBranchId == _branchId)
        .map(_transferFromData)
        .toList();
    _transfersCache.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  static BranchModel _branchFromData(BranchesTableData d) {
    return BranchModel(
      id: d.id,
      name: d.name,
      address: d.address,
      phone: d.phone,
      isActive: d.isActive,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static StockTransferModel _transferFromData(StockTransfersTableData d) {
    List<StockTransferItemModel> items;
    try {
      items = (jsonDecode(d.items) as List<dynamic>)
          .map((e) =>
              StockTransferItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      items = [];
    }

    final status = TransferStatus.values.firstWhere(
      (e) => e.name == d.status,
      orElse: () => TransferStatus.draft,
    );

    return StockTransferModel(
      id: d.id,
      branchId: d.branchId,
      fromBranchId: d.fromBranchId,
      toBranchId: d.toBranchId,
      fromBranchName: d.fromBranchName,
      toBranchName: d.toBranchName,
      transferNumber: d.transferNumber,
      items: items,
      status: status,
      notes: d.notes,
      createdBy: d.createdBy,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
      receivedAt: d.receivedAt,
      receivedBy: d.receivedBy,
    );
  }

  static StockTransfersTableCompanion _transferToCompanion(StockTransferModel m) {
    return StockTransfersTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      fromBranchId: Value(m.fromBranchId),
      toBranchId: Value(m.toBranchId),
      fromBranchName: Value(m.fromBranchName),
      toBranchName: Value(m.toBranchName),
      transferNumber: Value(m.transferNumber),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      status: Value(m.status.name),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      createdAt: Value(m.createdAt),
      updatedAt: Value(m.updatedAt),
      receivedAt: Value(m.receivedAt),
      receivedBy: Value(m.receivedBy),
      syncVersion: const Value(1),
    );
  }

  void _onSelectTab(SelectTransferTab event, Emitter<StockTransferState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }

  Future<void> _onSendTransfer(SendTransfer event, Emitter<StockTransferState> emit) async {
    emit(state.copyWith(isProcessing: true));
    try {
      final transfer = event.transfer;
      for (final item in transfer.items) {
        StockQuantityGuard.ensureSufficientStock(
          transfer.fromBranchId,
          item.medicineId,
          item.quantity.toDouble(),
          medicineName: item.medicineName,
        );
      }

      final updated = transfer.copyWith(
        status: TransferStatus.sent,
        updatedAt: DateTime.now(),
      );

      await _transfersDao.upsert(_transferToCompanion(updated));

      unawaited(
        SyncService.queueOperation(
          type: SyncOperationType.update,
          table: 'stock_transfers',
          data: updated.toJson(),
          branchId: updated.fromBranchId,
        ),
      );

      for (final item in updated.items) {
        final medicine = BranchDataService.getMedicine(item.medicineId);
        if (medicine != null && medicine.branchId == updated.fromBranchId) {
          await StockMutationService.adjustStock(
            medicineId: item.medicineId,
            delta: -item.quantity,
            branchId: updated.fromBranchId,
          );
        }
      }

      await InventoryTransactionService.to.transferStock(
        transfer: updated,
        actorId: _userId,
      );

      await _refreshCaches();
      emit(state.copyWith(transfers: _transfersCache, isProcessing: false));
      AppSnackbar.success('?? ????? ??????? ??? ${transfer.transferNumber}');
    } catch (e) {
      AppSnackbar.error('??? ????? ???????: $e');
      emit(state.copyWith(isProcessing: false));
    }
  }

  Future<void> _onReceiveTransfer(ReceiveTransfer event, Emitter<StockTransferState> emit) async {
    emit(state.copyWith(isProcessing: true));
    try {
      final raw = await _transfersDao.getById(event.id);
      if (raw == null) {
        AppSnackbar.error('??????? ??? ?????');
        emit(state.copyWith(isProcessing: false));
        return;
      }
      final transfer = _transferFromData(raw);

      if (transfer.status != TransferStatus.sent) {
        AppSnackbar.error('???? ?????? ????????? ??????? ???');
        emit(state.copyWith(isProcessing: false));
        return;
      }

      for (final item in transfer.items) {
        final medicines = BranchDataService.getMedicines(
          branchId: transfer.toBranchId,
        );
        final existing = medicines.cast<MedicineModel?>().firstWhere(
          (m) => m!.id == item.medicineId,
          orElse: () => null,
        );

        if (existing != null) {
          await StockMutationService.adjustStock(
            medicineId: item.medicineId,
            delta: item.quantity,
            branchId: transfer.toBranchId,
          );
        }
      }

      final updated = transfer.copyWith(
        status: TransferStatus.received,
        receivedAt: DateTime.now(),
        receivedBy: _userId,
        updatedAt: DateTime.now(),
      );
      await _transfersDao.upsert(_transferToCompanion(updated));

      unawaited(
        SyncService.queueOperation(
          type: SyncOperationType.update,
          table: 'stock_transfers',
          data: updated.toJson(),
          branchId: updated.toBranchId,
        ),
      );

      await _refreshCaches();
      emit(state.copyWith(transfers: _transfersCache, isProcessing: false));
      AppSnackbar.success('?? ?????? ??????? ??? ${transfer.transferNumber}');
    } catch (e) {
      AppSnackbar.error('??? ?????? ???????: $e');
      emit(state.copyWith(isProcessing: false));
    }
  }

  Future<void> _onCancelTransfer(CancelTransfer event, Emitter<StockTransferState> emit) async {
    emit(state.copyWith(isProcessing: true));
    try {
      final raw = await _transfersDao.getById(event.id);
      if (raw == null) {
        emit(state.copyWith(isProcessing: false));
        return;
      }

      final transfer = _transferFromData(raw);

      if (transfer.status == TransferStatus.draft) {
        final updated = transfer.copyWith(
          status: TransferStatus.cancelled,
          updatedAt: DateTime.now(),
        );
        await _transfersDao.upsert(_transferToCompanion(updated));
        unawaited(
          SyncService.queueOperation(
            type: SyncOperationType.update,
            table: 'stock_transfers',
            data: updated.toJson(),
            branchId: updated.fromBranchId,
          ),
        );
        await _refreshCaches();
        emit(state.copyWith(transfers: _transfersCache, isProcessing: false));
        AppSnackbar.warning(
          '?? ????? ??????? ??? ${transfer.transferNumber}',
          title: '??',
        );
        return;
      }

      if (transfer.status == TransferStatus.sent) {
        for (final item in transfer.items) {
          final medicines = BranchDataService.getMedicines(
            branchId: transfer.fromBranchId,
          );
          final medicine = medicines.cast<MedicineModel?>().firstWhere(
            (m) => m!.id == item.medicineId,
            orElse: () => null,
          );

          if (medicine != null) {
            await StockMutationService.adjustStock(
              medicineId: item.medicineId,
              delta: item.quantity,
              branchId: transfer.fromBranchId,
            );
          }
        }

        final updated = transfer.copyWith(
          status: TransferStatus.cancelled,
          updatedAt: DateTime.now(),
        );
        await _transfersDao.upsert(_transferToCompanion(updated));
        unawaited(
          SyncService.queueOperation(
            type: SyncOperationType.update,
            table: 'stock_transfers',
            data: updated.toJson(),
            branchId: updated.fromBranchId,
          ),
        );
        await _refreshCaches();
        emit(state.copyWith(transfers: _transfersCache, isProcessing: false));
        AppSnackbar.warning(
          '?? ????? ??????? ??? ${transfer.transferNumber} ?????? ???????',
          title: '??',
        );
      }
    } catch (e) {
      AppSnackbar.error('??? ????? ???????: $e');
      emit(state.copyWith(isProcessing: false));
    }
  }
}







