import 'package:get_it/get_it.dart';
import 'bloc/quotes_bloc.dart';

final sl = GetIt.instance;

void registerQuotesDependencies() {
  sl.allowReassignment = true;
  _fac<QuotesBloc>(() => QuotesBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


