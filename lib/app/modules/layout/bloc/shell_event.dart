import 'package:equatable/equatable.dart';

sealed class ShellEvent extends Equatable {
  const ShellEvent();

  @override
  List<Object?> get props => [];
}

final class LoadShell extends ShellEvent {
  const LoadShell();
}

final class ToggleSidebar extends ShellEvent {
  const ToggleSidebar();
}

final class SelectBranch extends ShellEvent {
  final String branchId;
  const SelectBranch(this.branchId);

  @override
  List<Object?> get props => [branchId];
}
