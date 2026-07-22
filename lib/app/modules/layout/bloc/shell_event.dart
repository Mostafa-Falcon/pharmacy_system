import 'package:equatable/equatable.dart';

abstract class ShellEvent extends Equatable {
  const ShellEvent();

  @override
  List<Object?> get props => [];
}

class LoadShell extends ShellEvent {
  const LoadShell();
}

class ToggleSidebar extends ShellEvent {
  const ToggleSidebar();
}

class SelectBranch extends ShellEvent {
  final String branchId;
  const SelectBranch(this.branchId);

  @override
  List<Object?> get props => [branchId];
}

class NavigateTo extends ShellEvent {
  final int index;
  const NavigateTo(this.index);

  @override
  List<Object?> get props => [index];
}

class LogoutRequested extends ShellEvent {
  const LogoutRequested();
}
