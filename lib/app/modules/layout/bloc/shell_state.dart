import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/shareds/sidebar.dart';
import 'package:pharmacy_system/app/modules/auth/models/user_model.dart';

enum ShellStatus { initial, loading, loaded, error }

class ShellState extends Equatable {
  final ShellStatus status;
  final bool sidebarVisible;
  final String activeBranchId;
  final int selectedIndex;
  final List<SidebarGroup> groups;
  final List<BranchOption> branches;
  final UserModel? user;
  final String? error;

  const ShellState({
    this.status = ShellStatus.initial,
    this.sidebarVisible = true,
    this.activeBranchId = '',
    this.selectedIndex = 0,
    this.groups = const [],
    this.branches = const [],
    this.user,
    this.error,
  });

  ShellState copyWith({
    ShellStatus? status,
    bool? sidebarVisible,
    String? activeBranchId,
    int? selectedIndex,
    List<SidebarGroup>? groups,
    List<BranchOption>? branches,
    UserModel? user,
    String? error,
    bool clearError = false,
  }) {
    return ShellState(
      status: status ?? this.status,
      sidebarVisible: sidebarVisible ?? this.sidebarVisible,
      activeBranchId: activeBranchId ?? this.activeBranchId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      groups: groups ?? this.groups,
      branches: branches ?? this.branches,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    status,
    sidebarVisible,
    activeBranchId,
    selectedIndex,
    groups,
    branches,
    user,
    error,
  ];
}




