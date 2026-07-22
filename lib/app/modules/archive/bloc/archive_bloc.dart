import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/modules/archive/models/archive_record_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../services/archive_service.dart';
import 'archive_event.dart';
import 'archive_state.dart';

export 'archive_event.dart';
export 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  ArchiveBloc() : super(const ArchiveState()) {
    on<LoadArchive>(_onLoad);
    on<ChangeArchiveEntityType>(_onChangeType);
    on<SearchArchive>(_onSearch);
    on<NextArchivePage>(_onNextPage);
    on<PreviousArchivePage>(_onPreviousPage);
    on<RestoreArchiveItem>(_onRestore);
    on<PermanentDeleteArchiveItem>(_onPermanentDelete);
  }

  bool get canManage => AuthService.currentUser?.isOwner ?? false;

  Future<void> _onLoad(LoadArchive event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(status: ArchiveStatus.loading));
    try {
      await _applyFilter(emit);
    } on Object catch (e) {
      emit(state.copyWith(status: ArchiveStatus.error, error: e.toString()));
    }
  }

  Future<void> _onChangeType(ChangeArchiveEntityType event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(
      selectedType: event.entityType,
      currentPage: 1,
      query: '',
    ));
    await _applyFilter(emit);
  }

  Future<void> _onSearch(SearchArchive event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(query: event.query, currentPage: 1));
    await _applyFilter(emit);
  }

  Future<void> _onNextPage(NextArchivePage event, Emitter<ArchiveState> emit) async {
    if (!state.hasNextPage) return;
    emit(state.copyWith(currentPage: state.currentPage + 1));
    await _applyFilter(emit);
  }

  Future<void> _onPreviousPage(PreviousArchivePage event, Emitter<ArchiveState> emit) async {
    if (!state.hasPreviousPage) return;
    emit(state.copyWith(currentPage: state.currentPage - 1));
    await _applyFilter(emit);
  }

  Future<void> _applyFilter(Emitter<ArchiveState> emit) async {
    final query = state.query.trim();
    final type = state.selectedType;
    final page = state.currentPage;
    final pageSize = state.pageSize;

    List<ArchiveRecordModel> records;
    int total;

    if (query.isNotEmpty) {
      records = await ArchiveService.search(
        query: query,
        entityType: type?.value,
        page: page,
        pageSize: pageSize,
      );
      total = await ArchiveService.searchCount(
        query: query,
        entityType: type?.value,
      );
    } else {
      records = await ArchiveService.getAll(
        entityType: type?.value,
        page: page,
        pageSize: pageSize,
      );
      total = await ArchiveService.count(entityType: type?.value);
    }

    emit(state.copyWith(
      status: ArchiveStatus.loaded,
      records: records,
      totalRecords: total,
    ));
  }

  Future<void> _onRestore(RestoreArchiveItem event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isWorking: true));
    try {
      final success = await ArchiveService.restore(event.recordId, modifiedData: event.modifiedData);
      if (success) {
        add(const LoadArchive());
      }
    } finally {
      emit(state.copyWith(isWorking: false));
    }
  }

  Future<void> _onPermanentDelete(PermanentDeleteArchiveItem event, Emitter<ArchiveState> emit) async {
    emit(state.copyWith(isWorking: true));
    try {
      final success = await ArchiveService.permanentDelete(event.recordId);
      if (success) {
        add(const LoadArchive());
      }
    } finally {
      emit(state.copyWith(isWorking: false));
    }
  }
}

