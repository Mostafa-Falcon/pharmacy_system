import 'dart:async';

import 'package:get_it/get_it.dart';
import '../../core/data/services/tasks/task_service.dart';
import 'bloc/tasks_bloc.dart';

final sl = GetIt.instance;

void registerTasksDependencies() {
  sl.allowReassignment = true;
  if (!sl.isRegistered<TaskService>()) {
    final s = TaskService();
    sl.registerSingleton<TaskService>(s);
    unawaited(s.init());
  }
  _fac<TasksBloc>(() => TasksBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
