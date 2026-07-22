import 'package:get_it/get_it.dart';
import 'bloc/notifications_bloc.dart';

final sl = GetIt.instance;

void registerNotificationsDependencies() {
  sl.allowReassignment = true;
  _reg<NotificationsBloc>(() => NotificationsBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
