import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import 'package:pharmacy_system/app/core/data/database/daos/items_archive_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'items_archive_event.dart';
import 'items_archive_state.dart';

export 'items_archive_event.dart';
export 'items_archive_state.dart';

abstract final class _SearchNormalizer {
  static final _diacritics =
      RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]');
  static final _ws = RegExp(r'\s+');

  static String normalize(String? v) {
    if (v == null || v.isEmpty) return '';
    return v
        .replaceAll('\u0640', '')
        .replaceAll(_diacritics, '')
        .replaceAll(RegExp(r'[????]'), '?')
        .replaceAll('?', '?')
        .replaceAll('?', '?')
        .replaceAll('?', '?')
        .replaceAll('?', '?')
        .toLowerCase()
        .trim()
        .replaceAll(_ws, ' ');
  }

  static String combine(Iterable<String?> vs) =>
      vs.map(normalize).where((v) => v.isNotEmpty).toSet().join(' ');
}

class ItemsArchiveBloc extends Bloc<ItemsArchiveEvent, ItemsArchiveState> {
  List<MedicineModel> _source = [];

  String get _branchId => AuthService.currentBranchId ?? '';
  bool get canManage => AuthService.currentUser?.isOwner ?? false;

  static ItemsArchiveDao get _dao =>
      ItemsArchiveDao(GetIt.instance<AppDatabase>());

  ItemsArchiveBloc() : super(const ItemsArchiveState()) {
    on<LoadItemsArchive>(_onLoad);
    on<SearchItemsArchive>(_onSearch);
    on<ToggleItemSelection>(_onToggleSelection);
    on<ToggleAllSelection>(_onToggleAll);
    on<RestoreItem>(_onRestoreItem);
    on<RestoreSelected>(_onRestoreSelected);
    on<DeleteItem>(_onDeleteItem);
    on<DeleteSelected>(_onDeleteSelected);
  }

  Future<void> _onLoad(LoadItemsArchive event, Emitter<ItemsArchiveState> emit) async {
    if (!canManage) return;
    emit(state.copyWith(status: ItemsArchiveStatus.loading));
    try {
      final records = await _dao.getByBranch(_branchId);
      _source = records.map(_archiveToMedicine).toList(growable: false);
      _applyFilter(emit, '');
    } on Object catch (_) {
      emit(state.copyWith(status: ItemsArchiveStatus.error));
    }
  }

  static MedicineModel _archiveToMedicine(ItemsArchiveTableData d) {
    List<String> barcodes;
    try {
      barcodes = (jsonDecode(d.barcodes) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } catch (_) {
      barcodes = d.barcodes.isNotEmpty ? [d.barcodes] : [];
    }

    return MedicineModel(
      id: d.medicineId,
      name: d.medicineName,
      barcodes: barcodes,
      buyPrice: d.buyPrice,
      sellPrice: d.sellPrice,
      branchId: d.branchId,
      isDeleted: true,
      quantity: 0,
      minStock: 0,
      lastModified: d.archivedAt,
    );
  }

  void _onSearch(SearchItemsArchive event, Emitter<ItemsArchiveState> emit) {
    _applyFilter(emit, event.query);
  }

  void _applyFilter(Emitter<ItemsArchiveState> emit, String query) {
    final normalized = _SearchNormalizer.normalize(query);
    final filtered = _source.where((item) {
      if (normalized.isEmpty) return true;
      final barcodes = [
        ...item.barcodes,
        ...item.units.map((u) => u.barcode),
      ];
      return _SearchNormalizer
          .combine([
            item.name,
            item.nameEn,
            ...barcodes,
            item.category,
            item.manufacturer,
          ])
          .contains(normalized);
    }).toList();
    final validIds =
        state.selectedIds.where((id) => filtered.any((i) => i.id == id)).toSet();
    emit(state.copyWith(
      status: ItemsArchiveStatus.loaded,
      items: filtered,
      selectedIds: validIds,
    ));
  }

  void _onToggleSelection(ToggleItemSelection event, Emitter<ItemsArchiveState> emit) {
    final ids = Set<String>.from(state.selectedIds);
    ids.contains(event.id) ? ids.remove(event.id) : ids.add(event.id);
    emit(state.copyWith(selectedIds: ids));
  }

  void _onToggleAll(ToggleAllSelection event, Emitter<ItemsArchiveState> emit) {
    final allSelected =
        state.items.isNotEmpty && state.items.every((i) => state.selectedIds.contains(i.id));
    emit(state.copyWith(
      selectedIds: allSelected ? const {} : state.items.map((i) => i.id).toSet(),
    ));
  }

  Future<void> _onRestoreItem(RestoreItem event, Emitter<ItemsArchiveState> emit) async {
    final idx = _source.indexWhere((i) => i.id == event.id);
    if (idx == -1) return;
    await _restore([_source[idx]], emit);
  }

  Future<void> _onRestoreSelected(RestoreSelected event, Emitter<ItemsArchiveState> emit) async {
    final items = _source.where((i) => state.selectedIds.contains(i.id)).toList();
    await _restore(items, emit);
  }

  Future<void> _restore(List<MedicineModel> items, Emitter<ItemsArchiveState> emit) async {
    if (!canManage || items.isEmpty || state.isWorking) return;
    emit(state.copyWith(isWorking: true));
    var failed = 0;
    try {
      for (final item in items) {
        try {
          await BranchDataService.updateMedicine(item.copyWith(isDeleted: false));
        } on Object catch (_) {
          failed++;
        }
      }
      emit(state.copyWith(selectedIds: const {}));
      if (failed == 0) {
        AppSnackbar.success(InventoryStrings.itemsRestoredSuccess, title: GeneralStrings.restoreLabel);
      } else {
        AppSnackbar.warning('${InventoryStrings.itemsRestorePartial} ($failed)', title: GeneralStrings.warning);
      }
      add(const LoadItemsArchive());
    } finally {
      emit(state.copyWith(isWorking: false));
    }
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<ItemsArchiveState> emit) async {
    final idx = _source.indexWhere((i) => i.id == event.id);
    if (idx == -1) return;
    await _executeDelete([_source[idx]], emit);
  }

  Future<void> _onDeleteSelected(DeleteSelected event, Emitter<ItemsArchiveState> emit) async {
    final items = _source.where((i) => state.selectedIds.contains(i.id)).toList();
    await _executeDelete(items, emit);
  }

  Future<void> _executeDelete(List<MedicineModel> items, Emitter<ItemsArchiveState> emit) async {
    emit(state.copyWith(isWorking: true));
    var failed = 0;
    try {
      for (final item in items) {
        try {
          await _dao.softDelete(item.id);
          
          unawaited(
            SyncService.queueOperation(
              type: SyncOperationType.delete,
              table: 'items_archive',
              data: {'id': item.id, 'is_deleted': true},
              branchId: _branchId,
            ),
          );
        } on Object catch (_) {
          failed++;
        }
      }
      emit(state.copyWith(selectedIds: const {}));
      if (failed == 0) {
        AppSnackbar.error(InventoryStrings.itemsDeletedPermanently, title: SalesStrings.permanentDelete);
      } else {
        AppSnackbar.warning('${InventoryStrings.itemsDeletePartial} ($failed)', title: GeneralStrings.warning);
      }
      add(const LoadItemsArchive());
    } finally {
      emit(state.copyWith(isWorking: false));
    }
  }
}







