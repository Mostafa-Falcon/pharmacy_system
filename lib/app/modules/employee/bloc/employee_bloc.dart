import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmployeeSession extends EmployeeEvent {
  const LoadEmployeeSession();
}

class ChangeEmployeeTab extends EmployeeEvent {
  final int index;
  const ChangeEmployeeTab(this.index);
  @override
  List<Object?> get props => [index];
}

class EmployeeLogout extends EmployeeEvent {
  const EmployeeLogout();
}

class EmployeeState extends Equatable {
  final int selectedIndex;
  final String userName;
  final String branchName;
  final bool isLoggingOut;

  const EmployeeState({
    this.selectedIndex = 0,
    this.userName = 'مستخدم',
    this.branchName = 'الصيدلية',
    this.isLoggingOut = false,
  });

  EmployeeState copyWith({
    int? selectedIndex,
    String? userName,
    String? branchName,
    bool? isLoggingOut,
  }) {
    return EmployeeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      userName: userName ?? this.userName,
      branchName: branchName ?? this.branchName,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, userName, branchName, isLoggingOut];
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(const EmployeeState()) {
    on<LoadEmployeeSession>(_onLoad);
    on<ChangeEmployeeTab>(_onChangeTab);
    on<EmployeeLogout>(_onLogout);
    add(const LoadEmployeeSession());
  }

  void _onLoad(LoadEmployeeSession event, Emitter<EmployeeState> emit) {
    final user = AuthService.currentUser;
    final branch = AuthService.currentBranch;
    emit(state.copyWith(
      userName: user?.name ?? 'مستخدم',
      branchName: branch?.name ?? 'الصيدلية',
    ));
  }

  void _onChangeTab(ChangeEmployeeTab event, Emitter<EmployeeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  Future<void> _onLogout(EmployeeLogout event, Emitter<EmployeeState> emit) async {
    emit(state.copyWith(isLoggingOut: true));
    await AuthService.logout();
    emit(state.copyWith(isLoggingOut: false));
  }
}


