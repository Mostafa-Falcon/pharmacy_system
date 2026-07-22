// lib/app/modules/sync/bloc/sync_status_bloc.dart
//
// Bloc خفيف لحالة شاشة المزامنة: بيتابع الـ Streams الحية
// من [SyncService] (status / progress / online) ويجمع تقدّم كل جدول
// لحظيًا عشان الصفحة تعرض "نفس اللحظة" بدون ما المستخدم يعمل ريفريش.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/sync/models/sync_table_meta.dart';

// ... (State and Event classes remain the same)

class SyncStatusState {
  final bool isOnline;
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final String? lastSyncError;
  final List<OutboxTableData> pending;
  final int deadLetterCount;
  final Map<String, String> tableStates; // table -> 'idle'|'pending'|'synced'|'error'
  final Map<String, String?> tableErrors;
  final Map<String, int> tableCounts;
  final String? activeTable;

  const SyncStatusState({
    required this.isOnline,
    required this.isSyncing,
    this.lastSyncTime,
    this.lastSyncError,
    this.pending = const [],
    this.deadLetterCount = 0,
    this.tableStates = const {},
    this.tableErrors = const {},
    this.tableCounts = const {},
    this.activeTable,
  });

  SyncStatusState copyWith({
    bool? isOnline,
    bool? isSyncing,
    DateTime? lastSyncTime,
    String? lastSyncError,
    List<OutboxTableData>? pending,
    int? deadLetterCount,
    Map<String, String>? tableStates,
    Map<String, String?>? tableErrors,
    Map<String, int>? tableCounts,
    String? activeTable,
  }) =>
      SyncStatusState(
        isOnline: isOnline ?? this.isOnline,
        isSyncing: isSyncing ?? this.isSyncing,
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        lastSyncError: lastSyncError ?? this.lastSyncError,
        pending: pending ?? this.pending,
        deadLetterCount: deadLetterCount ?? this.deadLetterCount,
        tableStates: tableStates ?? this.tableStates,
        tableErrors: tableErrors ?? this.tableErrors,
        tableCounts: tableCounts ?? this.tableCounts,
        activeTable: activeTable ?? this.activeTable,
      );
}

abstract class SyncStatusEvent {
  const SyncStatusEvent();
}

class SyncStatusStarted extends SyncStatusEvent {
  const SyncStatusStarted();
}

class SyncStatusTick extends SyncStatusEvent {
  final SyncStatus status;
  const SyncStatusTick(this.status);
}

class SyncStatusProgress extends SyncStatusEvent {
  final SyncProgress progress;
  const SyncStatusProgress(this.progress);
}

class SyncStatusTriggerSync extends SyncStatusEvent {
  const SyncStatusTriggerSync();
}

class SyncStatusTriggerPull extends SyncStatusEvent {
  const SyncStatusTriggerPull();
}

class SyncStatusTriggerPush extends SyncStatusEvent {
  const SyncStatusTriggerPush();
}

class SyncStatusRetryDeadLetter extends SyncStatusEvent {
  const SyncStatusRetryDeadLetter();
}

class SyncStatusRemoveItem extends SyncStatusEvent {
  final String id;
  const SyncStatusRemoveItem(this.id);
}

class SyncStatusClearQueue extends SyncStatusEvent {
  const SyncStatusClearQueue();
}

class SyncStatusRefreshManual extends SyncStatusEvent {
  final List<OutboxTableData> pending;
  final Map<String, int> tableCounts;
  final SyncStatusState state;
  const SyncStatusRefreshManual({
    required this.pending,
    required this.tableCounts,
    required this.state,
  });
}

class SyncStatusBloc extends Bloc<SyncStatusEvent, SyncStatusState> {
  SyncStatusBloc() : super(const SyncStatusState(isOnline: true, isSyncing: false)) {
    on<SyncStatusStarted>(_onStarted);
    on<SyncStatusTick>(_onTick);
    on<SyncStatusProgress>(_onProgress);
    on<SyncStatusTriggerSync>(_onTrigger);
    on<SyncStatusTriggerPull>(_onTriggerPull);
    on<SyncStatusTriggerPush>(_onTriggerPush);
    on<SyncStatusRetryDeadLetter>(_onRetryDeadLetter);
    on<SyncStatusRemoveItem>(_onRemoveItem);
    on<SyncStatusClearQueue>(_onClearQueue);
    on<SyncStatusRefreshManual>(_onRefreshManual);
  }

  StreamSubscription<SyncStatus>? _statusSub;
  StreamSubscription<SyncProgress>? _progressSub;
  Timer? _throttleTimer;
  bool _hasPendingUpdates = false;

  Future<void> _onStarted(
    SyncStatusStarted event,
    Emitter<SyncStatusState> emit,
  ) async {
    await _statusSub?.cancel();
    await _progressSub?.cancel();

    _statusSub = SyncService.statusStream.listen(
      (s) => add(SyncStatusTick(s)),
    );
    _progressSub = SyncService.progressStream.listen(
      (p) => add(SyncStatusProgress(p)),
    );

    final pending = await SyncService.getPendingItems();
    final tableCounts = await _fetchAllCounts();
    final deadCount = await SyncService.deadLetterCount;

    emit(state.copyWith(
      isOnline: SyncService.isOnline,
      isSyncing: SyncService.isSyncing,
      lastSyncTime: SyncService.lastSyncTime,
      lastSyncError: SyncService.lastSyncError,
      pending: pending,
      tableCounts: tableCounts,
      deadLetterCount: deadCount,
    ));
  }

  Future<void> _onTick(SyncStatusTick event, Emitter<SyncStatusState> emit) async {
    final s = event.status;
    final wasSyncing = state.isSyncing;
    
    final pending = await SyncService.getPendingItems();
    final tableCounts = await _fetchAllCounts();
    final deadCount = await SyncService.deadLetterCount;

    emit(state.copyWith(
      isOnline: s.isOnline,
      isSyncing: s.isSyncing,
      lastSyncTime: s.lastSyncTime,
      lastSyncError: s.lastSyncError,
      pending: pending,
      tableCounts: tableCounts,
      deadLetterCount: deadCount,
      activeTable: s.isSyncing ? state.activeTable : null,
    ));

    // تشغيل صوت النجاح لو المزامنة خلصت مفيش أخطاء
    if (wasSyncing && !s.isSyncing && s.lastSyncError == null) {
      SoundService.instance.play(SoundEffect.syncComplete);
    }
  }

  Future<Map<String, int>> _fetchAllCounts() async {
    final Map<String, int> counts = {};
    for (final table in syncTables) {
      counts[table.table] = await SyncService.getLocalTableCount(table.table);
    }
    return counts;
  }

  /// معالجة تقدّم المزامنة مع "تبريد" (Throttling) لتجنب تهنيج الـ UI
  /// لو فيه 1000 عملية ورا بعض، بنحدث الصفحة كل 400ms بس بدل 1000 مرة.
  Future<void> _onProgress(SyncStatusProgress event, Emitter<SyncStatusState> emit) async {
    final p = event.progress;
    final tableStates = Map<String, String>.from(state.tableStates);
    final tableErrors = Map<String, String?>.from(state.tableErrors);

    if (p.isPending) {
      tableStates[p.table] = 'syncing';
    } else if (p.isSuccess == true) {
      tableStates[p.table] = 'synced';
    } else if (p.isSuccess == false) {
      tableStates[p.table] = 'error';
      if (p.error != null) tableErrors[p.table] = p.error;
    }

    _lastProgressState = state.copyWith(
      tableStates: tableStates,
      tableErrors: tableErrors,
      activeTable: p.isPending ? p.table : null,
    );

    if (_throttleTimer?.isActive ?? false) {
      _hasPendingUpdates = true;
    } else {
      _hasPendingUpdates = false;
      final pending = await SyncService.getPendingItems();
      final counts = await _fetchAllCounts();
      final deadCount = await SyncService.deadLetterCount;
      emit(_lastProgressState!.copyWith(
        pending: pending,
        tableCounts: counts,
        deadLetterCount: deadCount,
      ));
      _startThrottle();
    }
  }

  SyncStatusState? _lastProgressState;

  void _startThrottle() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(milliseconds: 300), () async {
      if (_hasPendingUpdates && !isClosed && _lastProgressState != null) {
        _hasPendingUpdates = false;
        final pending = await SyncService.getPendingItems();
        final counts = await _fetchAllCounts();
        final deadCount = await SyncService.deadLetterCount;
        add(SyncStatusRefreshManual(
          pending: pending,
          tableCounts: counts,
          state: _lastProgressState!.copyWith(deadLetterCount: deadCount),
        ));
      }
    });
  }

  Future<void> _onTrigger(
    SyncStatusTriggerSync event,
    Emitter<SyncStatusState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    SyncService.syncSmart();
  }

  Future<void> _onTriggerPull(
    SyncStatusTriggerPull event,
    Emitter<SyncStatusState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    SyncService.pullOnly();
  }

  Future<void> _onTriggerPush(
    SyncStatusTriggerPush event,
    Emitter<SyncStatusState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    SyncService.pushOnly();
  }

  Future<void> _onRetryDeadLetter(
    SyncStatusRetryDeadLetter event,
    Emitter<SyncStatusState> emit,
  ) async {
    final deadItems = await SyncService.getDeadLetterItems();
    for (final item in deadItems) {
      await SyncService.retryDeadLetterItem(item.id);
    }
    emit(state.copyWith(isSyncing: true));
    SyncService.pushAll();
  }

  Future<void> _onRemoveItem(
    SyncStatusRemoveItem event,
    Emitter<SyncStatusState> emit,
  ) async {
    await SyncService.removePendingItem(event.id);
    final pending = await SyncService.getPendingItems();
    final deadCount = await SyncService.deadLetterCount;
    emit(state.copyWith(pending: pending, deadLetterCount: deadCount));
  }

  Future<void> _onClearQueue(
    SyncStatusClearQueue event,
    Emitter<SyncStatusState> emit,
  ) async {
    await SyncService.clearQueue();
    final pending = await SyncService.getPendingItems();
    final deadCount = await SyncService.deadLetterCount;
    emit(state.copyWith(pending: pending, deadLetterCount: deadCount));
  }

  Future<void> _onRefreshManual(
    SyncStatusRefreshManual event,
    Emitter<SyncStatusState> emit,
  ) async {
    emit(event.state.copyWith(
      pending: event.pending,
      tableCounts: event.tableCounts,
    ));
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    _progressSub?.cancel();
    return super.close();
  }
}
