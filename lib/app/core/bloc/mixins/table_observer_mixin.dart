import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

mixin TableObserverMixin<E, S> on Bloc<E, S> {
  final List<StreamSubscription> _tableSubscriptions = [];

  void observeTables(List<String> tables, FutureOr<void> Function() onUpdate, {String? branchId}) {
    _tableSubscriptions.add(
      SyncService.tableUpdateStream.listen((update) {
        final table = update.$1;
        final bid = update.$2;
        if (tables.contains(table) && (branchId == null || bid == branchId || bid.isEmpty)) {
          onUpdate();
        }
      }),
    );
  }

  @override
  Future<void> close() async {
    for (final s in _tableSubscriptions) {
      await s.cancel();
    }
    return super.close();
  }
}


