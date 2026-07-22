import 'package:get_it/get_it.dart';
import 'bloc/accounting_bloc.dart';
import 'bloc/party_payments_bloc.dart';

final sl = GetIt.instance;

void registerAccountingDependencies() {
  sl.allowReassignment = true;
  _fac<AccountingBloc>(() => AccountingBloc());
  _fac<PartyPaymentsBloc>(() => PartyPaymentsBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
