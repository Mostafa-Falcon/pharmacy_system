import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/shared/widgets/layouts/sidebar.dart';

enum ShellStatus { initial, loading, loaded, error }

class ShellState extends Equatable {
  final ShellStatus status;
  final String? error;
  final List<SidebarGroup> groups;
  final bool sidebarVisible;
  final List<BranchOption> branches;
  final String activeBranchId;
  final UserModel? user;

  const ShellState({
    this.status = ShellStatus.initial,
    this.error,
    this.groups = const [],
    this.sidebarVisible = true,
    this.branches = const [],
    this.activeBranchId = '',
    this.user,
  });

  ShellState copyWith({
    ShellStatus? status,
    String? error,
    bool clearError = false,
    List<SidebarGroup>? groups,
    bool? sidebarVisible,
    List<BranchOption>? branches,
    String? activeBranchId,
    UserModel? user,
  }) {
    return ShellState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      groups: groups ?? this.groups,
      sidebarVisible: sidebarVisible ?? this.sidebarVisible,
      branches: branches ?? this.branches,
      activeBranchId: activeBranchId ?? this.activeBranchId,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props =>
      [status, error, groups, sidebarVisible, branches, activeBranchId, user];
}
