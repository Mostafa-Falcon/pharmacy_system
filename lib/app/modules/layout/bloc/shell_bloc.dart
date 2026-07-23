import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/shareds/sidebar.dart';
import 'package:pharmacy_system/app/modules/auth/bloc/auth_bloc.dart' hide LogoutRequested;
import '../../../core/utils/app_utils.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import '../../../modules/admin/data/admin_sidebar_data.dart';
import '../../../modules/employee/data/employee_sidebar_data.dart';
import 'shell_event.dart';
import 'shell_state.dart';

class ShellBloc extends Bloc<ShellEvent, ShellState> {
  StreamSubscription? _authSubscription;

  ShellBloc() : super(const ShellState()) {
    on<LoadShell>(_onLoad);
    on<ToggleSidebar>(_onToggleSidebar);
    on<SelectBranch>(_onSelectBranch);
    on<NavigateTo>(_onNavigate);
    on<LogoutRequested>(_onLogout);

    // ذكاء مهندسة: مراقبة حالة الـ Auth لضمان تحديث الواجهة فور الدخول
    _authSubscription = sl<AuthBloc>().stream.listen((authState) {
      if (authState.status == AuthStatus.authenticated && authState.user != null) {
        if (!isClosed) add(const LoadShell());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoad(LoadShell event, Emitter<ShellState> emit) async {
    // لو بنحمل واليوزر لسه null، نعطي فرصة بسيطة للـ Cache
    if (AuthService.currentUser == null) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        emit(state.copyWith(status: ShellStatus.error, error: 'لا يوجد مستخدم'));
        return;
      }

      final isOwner = user.isOwner;
      final groups = isOwner ? getAdminSidebarGroups() : getEmployeeSidebarGroups();

      final branchesDao = sl<BranchesDao>();
      final branchRows = await branchesDao.getAll();
      final branches = branchRows
          .where((b) => !b.isDeleted)
          .map((b) => BranchOption(id: b.id, label: b.name))
          .toList();

      final activeBranchId = AuthService.currentBranchId ?? '';
      if (activeBranchId.isNotEmpty && branches.every((b) => b.id != activeBranchId) && branches.isNotEmpty) {
        await AuthService.selectBranch(branches.first.id);
      }
      
      AuthService.refreshCurrentBranch();

      emit(state.copyWith(
        status: ShellStatus.loaded,
        user: user,
        groups: groups,
        branches: branches,
        activeBranchId: activeBranchId.isNotEmpty ? activeBranchId : (branches.isNotEmpty ? branches.first.id : ''),
      ));
    } catch (e, s) {
      safeDebugPrint('ShellBloc._onLoad error: $e\n$s');
      emit(state.copyWith(status: ShellStatus.error, error: 'فشل تهيئة الواجهة: $e'));
    }
  }

  void _onToggleSidebar(ToggleSidebar event, Emitter<ShellState> emit) {
    emit(state.copyWith(sidebarVisible: !state.sidebarVisible));
  }

  void _onSelectBranch(SelectBranch event, Emitter<ShellState> emit) {
    AuthService.selectBranch(event.branchId);
    emit(state.copyWith(activeBranchId: event.branchId));
  }

  void _onNavigate(NavigateTo event, Emitter<ShellState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onLogout(LogoutRequested event, Emitter<ShellState> emit) {
    AuthService.logout();
  }
}
