import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import '../services/admin_service.dart';
import '../services/access_control_service.dart';
import 'branches_event.dart';
import 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final AdminService _adminService = AdminService.to;
  final AccessControlService _access = AccessControlService.to;

  BranchesBloc() : super(const BranchesState()) {
    on<LoadBranches>(_onLoad);
    on<AddBranch>(_onAdd);
    on<UpdateBranch>(_onUpdate);
    on<DeleteBranch>(_onDelete);
    add(const LoadBranches());
  }

  Future<void> _onLoad(LoadBranches event, Emitter<BranchesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final branches = await _adminService.getBranches();
      emit(state.copyWith(data: branches, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onAdd(AddBranch event, Emitter<BranchesState> emit) async {
    _access.require('branches.write');
    try {
      await _adminService.createBranch(
        name: event.name,
        address: event.address,
        phone: event.phone,
      );
      // Re-use current strings or migrate if needed. 
      // I'll leave snackbars as they are for now or use AppStrings if already migrated.
      AppSnackbar.success('تم إضافة الفرع بنجاح');
      add(const LoadBranches());
    } catch (e) {
      AppSnackbar.error('فشل في إضافة الفرع: $e');
    }
  }

  Future<void> _onUpdate(UpdateBranch event, Emitter<BranchesState> emit) async {
    _access.require('branches.write');
    try {
      await _adminService.updateBranch(
        event.id,
        name: event.name,
        address: event.address,
        phone: event.phone,
      );
      AppSnackbar.success('تم تحديث بيانات الفرع');
      add(const LoadBranches());
    } catch (e) {
      AppSnackbar.error('فشل في تحديث الفرع: $e');
    }
  }

  Future<void> _onDelete(DeleteBranch event, Emitter<BranchesState> emit) async {
    _access.require('branches.write');
    try {
      await _adminService.deleteBranch(event.id);
      AppSnackbar.success('تم حذف الفرع');
      add(const LoadBranches());
    } catch (e) {
      AppSnackbar.error('فشل في حذف الفرع: $e');
    }
  }
}
